provider "aws" {
  profile = "default"
  region = "sa-east-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prd" {
    name = "prd_server"
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


resource "aws_instance" "prd" {
    count = 2

    ami = "ami-03c8adc67e56c7f1d"
    instance_type = "t2.nano"

    vpc_security_group_ids = [
        aws_security_group.prd.id
    ]

    tags = {
        "Terraform": "true"
    }
}

resource "aws_eip_association" "prd" {
    instance_id = aws_instance.prd[0].id
    allocation_id = aws_eip.prd.id
}

resource "aws_eip" "prd" {
    instance = aws_instance.prd[0].id

    tags = {
        "Terraform": "true"
    }
}
