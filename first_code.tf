provider "aws" {
    profile = "default"
    region = "eu-central-1"
}

resource "aws_s3_bucket" "test_terraform" {
    bucket = "test_terraform_vetsmart_20052020"
    acl = "private"
}
