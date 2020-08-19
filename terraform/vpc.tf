data "aws_availability_zones" "available" {}

# The VPC
resource "aws_vpc" "ecs_vpc" {
  cidr_block           = "172.18.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "ECS_VPC"
  }
}

# 2 Public subnets
resource "aws_subnet" "ecs_vpc_public-1" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "172.18.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "ECS_VPC_public-1"
  }
}

resource "aws_subnet" "ecs_vpc_public-2" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "172.18.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "ECS_VPC_public-2"
  }
}

# 1 Internet GW
resource "aws_internet_gateway" "ecs_vpc-gw" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ECS_VPC-main_gw"
  }
}

# Public RTB for outbound traffic through the IGW
resource "aws_route_table" "ecs_vpc-public_rtb" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_vpc-gw.id
  }

  tags = {
    Name = "ECS_VPC_public-rtb"
  }
}

# RTB associations
resource "aws_route_table_association" "ecs_vpc-public1-a" {
  subnet_id      = aws_subnet.ecs_vpc_public-1.id
  route_table_id = aws_route_table.ecs_vpc-public_rtb.id
}

resource "aws_route_table_association" "ecs_vpc-public2-b" {
  subnet_id      = aws_subnet.ecs_vpc_public-2.id
  route_table_id = aws_route_table.ecs_vpc-public_rtb.id
}