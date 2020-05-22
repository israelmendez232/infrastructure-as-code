provider "aws" {
  profile = "default"
  region = "sa-east-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod" {
    name = "prod_server"
    description = "Allow the API requests for the server."

    ingress {
        from_port = 80
        to_port = 80 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        "Terraform" = "true"
    }
}


resource "aws_instance" "prod" {
    ami = "ami-03c8adc67e56c7f1d"
    instance_type = "t2.nano"

    vpc_security_group_ids = [
        aws_security_group.prod.id
    ]

    tags = {
        "Terraform": "true"
    }
}

resource "aws_eip" "prod_web" {
    instance = aws_instance.prod.id

    tags = {
        "Terraform": "true"
    }
}
