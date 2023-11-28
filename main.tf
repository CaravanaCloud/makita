provider "aws" {
  region = var.aws_region
}

data "aws_ssm_parameter" "latest_amazon_linux_ami" {
  name = var.ami_parameter_name
}

resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.ip_range
  enable_dns_hostnames = true

  tags = {
    Name = "dev_vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_vpc_gw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_subnet" "dev_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = cidrsubnet(var.ip_range, 8, 1)
  map_public_ip_on_launch = true

  tags = {
    Name = "dev_subnet"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "dev_secgrp" {
  name        = "dev_secgrp"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev_secgrp"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "dev_instance" {
  ami                    = data.aws_ssm_parameter.latest_amazon_linux_ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.dev_secgrp.id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "dev_instance"
  }
}
