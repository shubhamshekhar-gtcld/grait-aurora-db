output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "ARN of the VPC."
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = [for s in aws_subnet.private : s.id]
}

output "private_subnet_cidr_blocks" {
  description = "CIDR blocks of the private subnets."
  value       = [for s in aws_subnet.private : s.cidr_block]
}

output "private_route_table_id" {
  description = "ID of the private route table."
  value       = aws_route_table.private.id
}

output "availability_zones_used" {
  description = "Availability zone names used by this configuration."
  value       = local.azs
}

output "private_id" {
  description = "ID of aws_route_table_association.private (auto-added by GRAIT)"
  value       = aws_route_table_association.private[*].id
}


# ============================================================
# Added by GRAIT (merged with existing code)
# ============================================================

output "aurora_pg_db_security_group_id" {
  description = "ID of the Aurora PostgreSQL DB security group."
  value       = aws_security_group.aurora_pg_db.id
}

output "aurora_pg_db_security_group_arn" {
  description = "ARN of the Aurora PostgreSQL DB security group."
  value       = aws_security_group.aurora_pg_db.arn
}

output "aurora_pg_db_security_group_name" {
  description = "Name of the Aurora PostgreSQL DB security group."
  value       = aws_security_group.aurora_pg_db.name
}

