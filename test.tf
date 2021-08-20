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
# aasdf asdf

resource "aws_vpc" "terraform_vpc_1" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "terraform_vpc_1" {
  cidr_block = "10.0.0.0/24"
}