terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "tuvo-s3-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
  }
}