variable "availability_zones" {
  description = "Number of availability zones to use."
  type        = number
  default     = 1
  validation {
    condition     = var.availability_zones >= 1
    error_message = "availability_zones must be >= 1."
  }
}

variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.50.0.0/16"
}

variable "enable_dns_hostnames" {
  description = "Whether DNS hostnames are enabled for the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Whether DNS resolution is enabled for the VPC."
  type        = bool
  default     = true
}

variable "name" {
  description = "Name/tag for the VPC and related resources."
  type        = string
  default     = "aurora-test-vpc-01"
}

variable "nat_gateway" {
  description = "NAT gateway mode. Use \"none\" to create no NAT gateway."
  type        = string
  default     = "none"
  validation {
    condition     = contains(["none"], var.nat_gateway)
    error_message = "For this configuration, nat_gateway must be \"none\"."
  }
}

variable "private_subnet_count" {
  description = "Number of private subnets to create."
  type        = number
  default     = 3
  validation {
    condition     = var.private_subnet_count >= 0
    error_message = "private_subnet_count must be >= 0."
  }
}

variable "public_subnet_count" {
  description = "Number of public subnets to create."
  type        = number
  default     = 0
  validation {
    condition     = var.public_subnet_count == 0
    error_message = "For this configuration, public_subnet_count must be 0."
  }
}

variable "region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}