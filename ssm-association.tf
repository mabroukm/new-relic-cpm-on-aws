resource "aws_ssm_document" "install_nr_cpm" {
  name            = "install_nr_cpm_document"
  document_type   = "Command"
  content         = file("${path.module}/cpm.yaml")
  document_format = "YAML"
}

resource "aws_ssm_association" "install_nr_cpm_association" {
  association_name = "cai-ssm-Install-NR-CPM"
  name             = aws_ssm_document.install_nr_cpm.name
  targets {
    key    = "tag:Application"
    values = ["${local.application}"]
  }
}


