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

variable "subnets" {
    type = list(string)
}

variable "security_groups" {
    type = list(string)
}
