terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "terraform_vpc_1" {
  cidr_block = "10.0.0.0/24"
  
}

resource "aws_security_group" "terraform_SG" {
  name = "Terraform_security"
  description = "SG created by terraform"
  vpc_id = aws_vpc.terraform_vpc_1.id


  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [aws_vpc.terraform_vpc_1.cidr_block]
  } 
  

}

resource "aws_subnet" "terraform_subnet" {
  vpc_id = aws_vpc.terraform_vpc_1.id
  cidr_block = "10.0.0.96/28"

  tags = { 
    name = "terraform_subnet"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0aeeebd8d2ab47354"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.terraform_SG.id}"]
  subnet_id = aws_subnet.terraform_subnet.id
 
  user_data = <<-EOF
                #!/bin/bash
                sudo su
                yum update -y
                yum install -y httpd.x86_64
                systemctl start httpd.service
                systemctl enable httpd.service
                echo “Hello World from $(hostname -f)” > /var/www/html/index.html
                EOF

 
  tags = {
    Name = "TerraformPlayGround"
  }
}