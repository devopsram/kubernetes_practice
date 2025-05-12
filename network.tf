# This is for creating Basic network infrastructure

resource "aws_vpc" "kub_test" {
  cidr_block   = var.vpc_cidr
}

resource "aws_subnet" "pubsubnet1" {
  vpc_id = aws_vpc.kub_test.id
  availability_zone = "us-east-1a"
  cidr_block = "192.168.1.0/24"
  tags = {
    name = "pubsubnet1"
  }
}

resource "aws_subnet" "pubsubnet2" {
  vpc_id = aws_vpc.kub_test.id
  availability_zone = "us-east-1b"
  cidr_block = "192.168.2.0/24"
  tags = {
    name = "pubsubnet2"
  }
}

resource "aws_subnet" "privatesubnet1" {
  vpc_id = aws_vpc.kub_test.id
  availability_zone = "us-east-1a"
  cidr_block = "192.168.3.0/24"
  tags = {
    name = "privatesubnet1"
  }
}

resource "aws_subnet" "privatesubnet2" {
  vpc_id = aws_vpc.kub_test.id
  availability_zone = "us-east-1b"
  cidr_block = "192.168.4.0/24"
  tags = {
    name = "privatesubnet2"
  }
}

resource "aws_security_group" "web-sg" {
  vpc_id = aws_vpc.kub_test.id
  ingress {
    description = "To allow ssh form anywhere"
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }

  ingress {
    description = "To allow http from anywhere"
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }

  ingress {
    description = "To allow https from anywhere"
    from_port = "443"
    to_port = "443"
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }

  egress {
    description = "To access outside"
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = "0.0.0.0/0"
    ipv6_cidr_blocks = "::/0"
  }
  tags = {
    name = "web-sg"
  }
}

resource "aws_security_group" "db-sg" {
  vpc_id = aws_vpc.kub_test.id
  ingress {
    description = "allow 5432 port with in vpc range"
    from_port = "5432"
    to_port = "5432"
    protocol = "tcp"
    cidr_blocks = [aws_vpc.kub_test.cidr_block]
  }
 
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = "0.0.0.0/0"
    ipv6_cidr_blocks = "::/0"
  }
  tags = {
    name = "db-sg"
  }
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.kub_test.id
  tags = {
    name = "Main-IGW"
  }
}

#public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.kub_test.id
  tags = {
    name = "public"
  }

  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw.id
  }
}

#private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.kub_test.id
  tags = {
    name = "private"
  }
}

#route table association to publicsubnet1
resource "aws_route_table_association" "public_rt_publicsubnet1" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.pubsubnet1.id
}

#route table association to publicsubnet2
resource "aws_route_table_association" "public_rt_publicsubnet2" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.pubsubnet2.id
}




