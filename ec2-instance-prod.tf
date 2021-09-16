resource "aws_instance" "app_prod_instance" {
  provider                = aws
  ami                     = local.ec2_image
  instance_type           = local.ec2_instance_type
  subnet_id               = local.private_b
  private_ip              = "100.76.64.7"
  key_name                = local.ec2_keyname
  vpc_security_group_ids  = [aws_security_group.ec2.id]
  iam_instance_profile    = alks_iamrole.ec2_prod_iam_role.name
  disable_api_termination = false
  tags = {
    Name                                              = "${local.application}-prod-instance"
    "Environment"                                     = "prod"
  }
  root_block_device {
    volume_size           = 40
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    encrypted             = true
    kms_key_id            = "arn:aws:kms:ap-southeast-2:487785357174:key/606f42f3-eeef-431f-9ccf-29f6ef3287e0"
    delete_on_termination = true
    tags = {
      Name = "${local.application}-prod-root"
    }
  }
}


# CREATE IAM ROLE -- Secondary Provider
resource "alks_iamrole" "ec2_prod_iam_role" {
  provider                 = alks
  name                     = "${local.application}-ec2-prod-role"
  type                     = "Amazon EC2"
  include_default_policies = true
  enable_alks_access       = false
}

# ATTACH POLICY
resource "aws_iam_role_policy" "ec2_prod_s3_custom_policy" {
  name   = "${local.application}-prod-s3-ec2-policy"
  role   = alks_iamrole.ec2_prod_iam_role.name
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ssm:GetParameter"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:ssm:ap-southeast-2:${local.account_id}:parameter/cloudwatch-agent-config-*"
      },
      {
        "Action": [
          "logs:Put*",
          "logs:Describe*",
          "logs:Create*",
          "cloudwatch:PutMetricData"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

# ATTACH POLICY
resource "aws_iam_role_policy" "ec2_prod_sm_custom_policy" {
  name   = "${local.application}-prod-sm-ec2-policy"
  role   = alks_iamrole.ec2_prod_iam_role.name
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": [
                "arn:aws:secretsmanager:ap-southeast-2:487785357174:secret:newrelic/prod/privatelocation-waGMFB"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "secretsmanager:ListSecrets",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "arn:aws:kms:ap-southeast-2:487785357174:key/606f42f3-eeef-431f-9ccf-29f6ef3287e0"
        }
    ]
  }
  EOF
}

# ATTACH POLICY
resource "aws_iam_role_policy" "ec2_prod_metadata_policy" {
  name   = "${local.application}-ec2-prod-metadata-policy"
  role   = alks_iamrole.ec2_prod_iam_role.name
  policy = <<-EOF
  {
   "Version": "2012-10-17",
   "Statement": [{
      "Effect": "Allow",
      "Action": [
         "ec2:DescribeTags"
      ],
      "Resource": "*"
   }
   ]
  }
  EOF
}


