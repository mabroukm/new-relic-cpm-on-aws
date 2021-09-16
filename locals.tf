locals {

  # shared-services Global Vars
  profile        = "shared-services"
  account_id     = "487785357174"
  account_alias  = "shared-services"
  application    = "new-relic-cpm"
  default_region = "ap-southeast-2"

  vpc_id         = "Please your VPC id here"
  private_b      = "Please your subnet id here"

  # Application/workload specific vars

  # EC2 App Vars
  ec2_image          = "ami-0310d0e01c1e033c0"
  ec2_instance_type = "t2.large"
  ec2_keyname       = "${local.account_alias}-keypair"
  ec2_managed_policies = toset([
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ])
}
