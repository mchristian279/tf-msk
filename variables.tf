#AWS Region
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

#VPC configuration
variable "cidr_block_vpc" {
  type    = string
  default = "172.31.0.0/16"
}

variable "cidr_block_subnet_public_a" {
  type    = string
  default = "172.31.0.0/20"
}

variable "cidr_block_subnet_public_b" {
  type    = string
  default = "172.31.80.0/20"
}

variable "availability_zone_subnet_public_a" {
  type    = string
  default = "us-east-1a"
}

variable "availability_zone_subnet_public_b" {
  type    = string
  default = "us-east-1b"
}

variable "cidr_aws_route_table_public_route" {
  type    = string
  default = "0.0.0.0/0"
}