variable "prd_whitelist" {
    type = list(string)
}

variable "prd_image_id" {
    type = string
}

variable "prd_instance_type" {
    type = string
}

variable "prd_desired_capacity" {
    type = number
}

variable "prd_max_size" {
    type = number
}

variable "prd_min_size" {
    type = number
}

provider "aws" {
  profile = "default"
  region = "sa-east-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
    availability_zone = "us-west-2a"
}

resource "aws_default_subnet" "default_az2" {
    availability_zone = "us-west-2b"
}

resource "aws_security_group" "prd" {
    name = "prd_server"
    description = "Allow the API requests for the server."

    ingress {
        from_port = 80
        to_port = 80 
        protocol = "tcp"
        cidr_blocks = var.prd_whitelist
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = var.prd_whitelist
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.prd_whitelist
    }

    tags = {
        "Terraform" = "true"
    }
}

module "web" {
  source = "./modules/web"
  
}
