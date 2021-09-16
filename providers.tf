provider "aws" {
  region  = local.default_region
  profile = local.profile
  default_tags {
    tags = {
      Application = local.application
      AccountName = local.account_alias
      AccountID   = local.account_id
    }
  }
}

terraform {
  required_providers {
    alks = {
      source  = "cox-automotive/alks"
      version = "2.0.2"
    }
#    newrelic = {
#      source = "newrelic/newrelic"
#      version = "2.25.0"
#    }
  }
}

provider "alks" {
  url     = "https://alks.coxautoinc.com/rest"
  account = local.account_id
  profile = local.profile
}

#provider "newrelic" {
#  region = "US"
#}