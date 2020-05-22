provider "aws" {
  profile = "default"
  region = "sa-east-1"
}

resource "aws_default_vpc" "default" {}
