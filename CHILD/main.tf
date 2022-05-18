resource "aws_vpc" "leyla" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "${var.tag}-VPC"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.leyla.id
  cidr_block = var.pub_cidr
  tags = {
    "Name" = "${var.tag} Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.leyla.id
  cidr_block = var.prv_cidr
  tags = {
    "Name" = "${var.tag} Private Subnet"
  }
}
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.leyla.id
  tags = {
    Name = "Internet-${var.tag}"
  }
}
# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_subnet.id
  tags = {
    Name = "NAT-${var.tag}"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.leyla.id

  route {
    cidr_block = var.prv_cidr
    gateway_id = aws_internet_gateway.internet_gateway.id
  }


  tags = {
    Name = "private_rt"
  }
}
# Creating Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.leyla.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public-${var.tag}-Table"
  }
}
resource "aws_eip" "lb" {
  vpc      = true
}