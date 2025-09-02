terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

#terraform {
#  backend "s3" {
#    bucket         = "kumar-s3-backend-us-east-2"
#    key            = "main-statefile/terraform.tfstate"
#    dynamodb_table = "kumar-tf-dynamodb-lock-table"
#    region         = "us-east-2"
#    encrypt        = true
#  }
#}