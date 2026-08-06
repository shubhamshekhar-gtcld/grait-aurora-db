provider "aws" {
  {{block_to_replace_cred}}
  region = var.region
}

# Kept to avoid introducing breaking refactors; still valid even though we now pin subnets to us-east-1a.
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.availability_zones)
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count

  # Keep existing behavior for subnets [0] and [1], and add the requested subnet as [2].
  availability_zone = count.index == 2 ? "us-east-1b" : "us-east-1a"

  # keep existing CIDR behavior exactly as-is
  cidr_block = (
    count.index == 1 ? "10.50.1.0/24" :
    count.index == 2 ? "10.50.2.0/24" :
    cidrsubnet(var.cidr_block, 8, count.index)
  )

  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-${format("%02d", count.index + 1)}"
      Tier = "private"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-rtb-private"
      Tier = "private"
    }
  )
}

resource "aws_route_table_association" "private" {
  count = var.private_subnet_count

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}

# NEW: Security group for Aurora PostgreSQL database
resource "aws_security_group" "aurora_pg_db" {
  name        = "aurora-pg-db-sg"
  description = "Security group for Aurora PostgreSQL database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["106.220.60.242/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "aurora-pg-db-sg"
    ManagedBy = "terraform"
  }
}