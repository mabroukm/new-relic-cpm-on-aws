resource "aws_security_group" "ec2" {
  name        = "${local.application}-ec2-security-group"
  description = "EC2 security group for ${local.application}"
  vpc_id      = local.vpc_id

  ingress = [
  ]
  egress = [
    {
      description      = "Allow all outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    }
  ]
  tags = {
    Name = "${local.application}-ec2-security-group"
  }
}

