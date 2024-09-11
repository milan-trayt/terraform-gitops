data "aws_iam_openid_connect_provider" "github_oidc" {
  url = "https://token.actions.githubusercontent.com"
}

module "github_actions_terraform" {
  source            = "../../modules/workflows/terraform"
  stage             = var.stage
  project           = var.project
  module            = var.module
  oidc_provider_arn = data.aws_iam_openid_connect_provider.github_oidc.arn
}

module "waf" {
  source  = "../../modules/services/waf/cloudfront"
  stage   = var.stage
  project = var.project
  module  = var.module
}

module "cloudfront_logs_bucket" {
  source                    = "../../modules/services/s3/bucket"
  acl_enabled               = true
  force_destroy             = var.logs_bucket_force_destroy
  replication_configuration = var.logs_bucket_replication_configuration
  versioning                = var.logs_bucket_versioning
  bucket_name               = var.logs_bucket_name
  lifecycle_rules = [
    {
      days          = 90,
      storage_class = "STANDARD_IA"
    },
    {
      days          = 180,
      storage_class = "GLACIER"
    }
  ]

  tags = {
    Name        = "milan-cloudfront-logs-s3"
    Exposure    = "Private"
    Description = "Bucket for storing aws cloudfront logs"
  }
}
module "web_portal" {
  source = "../../modules/workflows/web_portal"

  stage              = var.stage
  project            = var.project
  module             = var.module
  portal_name        = var.portal_name
  portal_bucket_name = var.portal_bucket_name

  oidc_provider_arn             = data.aws_iam_openid_connect_provider.github_oidc.arn
  waf_arn                       = module.waf.arn
  portal_access_log_bucket_name = module.cloudfront_logs_bucket.bucket_name

  portal_bucket_replication = var.portal_bucket_replication
  geo_restriction_type      = var.geo_restriction_type
  geo_restriction_location  = var.geo_restriction_location

  enforce_csp             = var.enforce_csp
  content_security_policy = var.content_security_policy
}