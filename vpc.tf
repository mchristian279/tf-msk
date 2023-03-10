resource "aws_vpc" "us_east_1" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw_us_east_1" {
  vpc_id = aws_vpc.us_east_1.id

}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.us_east_1.id
  cidr_block        = var.cidr_block_subnet_public_a
  availability_zone = var.availability_zone_subnet_public_a

}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.us_east_1.id
  cidr_block        = var.cidr_block_subnet_public_b
  availability_zone = var.availability_zone_subnet_public_b

}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.us_east_1.id

  route {
    cidr_block = var.cidr_aws_route_table_public_route
    gateway_id = aws_internet_gateway.igw_us_east_1.id
  }
}

resource "aws_route_table_association" "subnet_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_route.id

}

resource "aws_route_table_association" "subnet_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_route.id

}