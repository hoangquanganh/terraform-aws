provider "aws" {
  region = "ap-southeast-1"
}

# creating vpc, name, CIDR and tag
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  tags = {
    Name = "demo_vpc"
  }
}

#creating public subnet
resource "aws_subnet" "public-1" {
  vpc_id = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch  = "true"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "public-1"
  }
}

#creating private subnet
resource "aws_subnet" "private-1" {
  vpc_id = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "ap-southeast-1a"
  tags = {
    Name = "private-1"
  }
}


#creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo_vpc.id
  
  tags = {
    Name = "igw"
  }
}

#creating route table for igw
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "public-rt"
  }
}

#creating route association public subnet
resource "aws_route_table_association" "public-1-a" {
  subnet_id = aws_subnet.public-1.id 
  route_table_id = aws_route_table.public_rt.id
}
