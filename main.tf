provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

terraform {
  cloud {
    organization = "ricardo-terraform"

    workspaces {
      name = "portfolio-iac"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_instance" "our_vm" {
  instance_type = "t3.micro"
  ami = data.aws_ami.ubuntu.id

  tags = {
    Name = "Example"
  }
}

resource "aws_route53_zone" "my_domain" {
  name = "ricardotrevizo.com"
}

resource "aws_route53_record" "vps" {
  zone_id = aws_route53_zone.my_domain.zone_id
  name = "ricardotrevizo.com"
  type = "A"
  ttl = 300
  records = [aws_instance.our_vm.public_ip]
}
