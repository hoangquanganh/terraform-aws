# creating security groups
resource "aws_security_group" "sg" {
  description = "Allow limieted inbound external traffic"
  vpc_id = "${aws_vpc.demo_vpc.id}"
  name = "terraform_ec2_private_sg"

  ingress  {
      description      = "TLS from VPC"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      #ipv6_cidr_blocks = ["::/0"]
      #prefix_list_ids = [""]
      #security_groups = [""]
      #self = true
      from_port = 8080
      to_port = 8080
  }

  egress {
    protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 0
      to_port = 0
  }

  tags = {
    Name = "ec2-private-sg"
  }
}

output "aws_security_gr_id" {
      value = ["${aws_security_group.sg.id}"]
}

# creating EC2 in public subnet
resource "aws_instance" "public_ec2" {
  ami = "ami-0d058fe428540cd89"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.sg.id}" ]
  subnet_id = "${aws_subnet.public-1.id}"
  key_name = "demo ec2 key"
  count = 1
  associate_public_ip_address = true
  tags = {
    name = "public_ec2"
  }
}

# creating EC2 in private subnet
resource "aws_instance" "private_ec2" {
  ami = "ami-0d058fe428540cd89"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.sg.id}" ]
  subnet_id = "${aws_subnet.private-1.id}"
  key_name = "demo ec2 key"
  count = 1
  associate_public_ip_address = false
  tags = {
    name = "private_ec2"
  }
}