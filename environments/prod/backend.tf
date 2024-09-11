terraform {
  backend "s3" {
    bucket         = "milan-training-tfstate-prod"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "milan-training-tflock-prod"
  }
}