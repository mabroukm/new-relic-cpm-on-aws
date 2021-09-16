terraform {
  backend "s3" {
    bucket  = "cox-au-sharedservices-dc-tf-state"
    key     = "new-relic-cpm.tfstate"
    region  = "ap-southeast-2"
    profile = "cox-shared-services"
  }
}