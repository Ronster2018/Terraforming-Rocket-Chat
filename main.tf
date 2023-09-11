terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16"
    }
  }
  required_version = ">=1.2.0"
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "rocket_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Rocket Chat VPC"
  }
}


resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.rocket_vpc.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = var.availability_zone
  tags = {
    Name = "Public Subnet"
  }
}
#TODO: Create a private subnet for the DB


resource "aws_internet_gateway" "rocket_igw" {
  vpc_id = aws_vpc.rocket_vpc.id
  tags = {
    Name = "Rocket VPC - Internet Gateway"
  }
}

resource "aws_route_table" "rocket_vpc_us_east_1_public" {
  vpc_id = aws_vpc.rocket_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rocket_igw.id
  }
}

resource "aws_route_table_association" "rocket_vpc_us_east_public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rocket_vpc_us_east_1_public.id
}

resource "aws_security_group" "rocket_sg" {
  name        = "rocket_chat_sg"
  description = "Allow ssh and http/s inbound traffic"
  vpc_id      = aws_vpc.rocket_vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ping
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Rocket Chat Security Group"
  }
}


#deploying an Ec2 instance
resource "aws_instance" "rocket_ubuntu_22_04" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.rocket_sg.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  user_data                   = <<-EOF
    #! /bin/bash
    "sudo snap install rocketchat-server",
    "sudo rocketchat-server.initcaddy",
    "sudo snap set rocketchat-server port=80",
  EOF

  tags = {
    Name = "Rocket Chat Ubuntu20.04"
  }
}
output "public_dns" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = ["${aws_instance.rocket_ubuntu_22_04.public_dns}"]
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = ["${aws_instance.rocket_ubuntu_22_04.public_ip}"]
}
