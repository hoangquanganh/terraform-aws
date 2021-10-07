# creating Elastic IP for NAt
resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "Nat EIP"
  }
}

# creating NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public-1.id

  tags = {
    Name = "NAT gateway"
  }
}

# creating private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private_rt"
  }
}

#creating association between private subnet and private route table
resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private-1.id
  route_table_id = aws_route_table.private_rt.id
}