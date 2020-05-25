resource "aws_elb" "this" {
    name = "${web-app}-web"
    instances = aws_instance.this.*.id
    subnets = var.subnets
    security_groups = var.security_groups

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
}

resource "aws_launch_template" "tis" {
    name_prefix = "${web=app}-web"
    image_id = var.this_image_id
    instance_type = var.this_instance_type
    tags = {
        "Terraform": "true"
    }
}

resource "aws_autoscaling_group" "this" {
    availability_zones = ["us-east-1a", "us-east-2b"]
    vpc_zone_identifier = var.subnets
    desired_capacity = var.this_desired_capacity
    max_size = var.this_max_size
    min_size = var.this_min_size
    
    launch_template {
        id = aws_launch_template.thius.id
        version = "$latest"
    }

    tag {
        key = "Terraform"
        value = "true"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_attachment" "this" {
    autoscaling_group_name = aws_autoscaling_group.this.id
    elb = aws_elb.this.id
}
