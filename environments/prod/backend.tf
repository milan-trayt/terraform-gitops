terraform {
  backend "s3" {
    bucket         = "milan-devops-training-tfstate-prod"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "milan-devops-training-tflock-prod"
  }
}