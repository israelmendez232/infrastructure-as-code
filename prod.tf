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

resource "aws_elb" "prd_web" {
    name = "prd-web"
    instances = aws_instance.prd.*.id
    subnets = ["aws_default_subnet.default_az1.id", "aws_default_subnet.default_az2"]
    security_groups = [aws_security_group.prd.id]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
}

resource "aws_launch_template" "prd" {
    name_prefix = "prd-web"
    image_id = "ami-03c8adc67e56c7f1d"
    instance_type = "t2.micro"
    tags = {
        "Terraform": "true"
    }
}

resource "aws_autoscaling_group" "prd" {
    availability_zones = ["us-east-1a", "us-east-2b"]
    vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
    desired_capacity = 1
    max_size = 1
    min_size = 1

    launch_template {
        id = aws_launch_template.prd.id
        version = "$latest"
    }

    tag {
        key = "Terraform"
        value = "true"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_attachment" "prd" {
    autoscaling_group_name = aws_autoscaling_group.prd.id
    elb = aws_elb.prd_web.id
}
