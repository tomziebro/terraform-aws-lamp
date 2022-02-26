#Create the VPC
resource "aws_vpc" "lampvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "lampvpc"
  }
}

#Create a Public Subnet
resource "aws_subnet" "lampvpc_public_subnet" {
  vpc_id                  = aws_vpc.lampvpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "lampvpc_public_subnet"
  }
}

#Create a Private Subnet
resource "aws_subnet" "lampvpc_private_subnet" {
  vpc_id            = aws_vpc.lampvpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "lampvpc_private_subnet"
  }
}

#Create a Private Subnet
resource "aws_subnet" "lampvpc_private_subnet1" {
  vpc_id            = aws_vpc.lampvpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = "us-east-1c"

  tags = {
    Name = "lampvpc_private_subnet1"
  }
}

#Create an Internet Gateway
resource "aws_internet_gateway" "lampvpc_internet_gateway" {
  vpc_id = aws_vpc.lampvpc.id

  tags = {
    Name = "lampvpc_internet_gateway"
  }
}

#Create a Public Route table (Associated with IGW)
resource "aws_route_table" "lampvpc_public_subnet_route_table" {
  vpc_id = aws_vpc.lampvpc.id

  route {
    cidr_block = var.zero_addr_cidr
    gateway_id = aws_internet_gateway.lampvpc_internet_gateway.id
  }

  tags = {
    Name = "lampvpc_public_subnet_route_table"
  }

}
#Create a Private Subnet Route Table
resource "aws_route_table" "lampvpc_private_subnet_route_table" {
  vpc_id = aws_vpc.lampvpc.id

  tags = {
    Name = "lampvpc_private_subnet_route_table"
  }

}
#Create a Default Route Table
resource "aws_default_route_table" "lampvpc_main_route_table" {
  default_route_table_id = aws_vpc.lampvpc.default_route_table_id

  tags = {
    Name = "lampvpc_main_route_table"
  }

}
#Associate the Public Subnet with the Public Route Table
resource "aws_route_table_association" "lampvpc_public_subnet_route_table" {
  subnet_id      = aws_subnet.lampvpc_public_subnet.id
  route_table_id = aws_route_table.lampvpc_public_subnet_route_table.id
}

#Associate the Private Subnet with the Private Route Table
resource "aws_route_table_association" "lampvpc_private_subnet_route_table_association" {
  subnet_id      = aws_subnet.lampvpc_private_subnet.id
  route_table_id = aws_route_table.lampvpc_private_subnet_route_table.id
}

#Associate the Private Subnet with the Private Route Table
resource "aws_route_table_association" "lampvpc_private_subnet_route_table_association1" {
  subnet_id      = aws_subnet.lampvpc_private_subnet1.id
  route_table_id = aws_route_table.lampvpc_private_subnet_route_table.id
}
