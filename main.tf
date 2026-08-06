provider "aws" {
  {{block_to_replace_cred}}
  region = var.region
}

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

  availability_zone       = local.azs[count.index % length(local.azs)]
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
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