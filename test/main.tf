module "efs_test" {
  source  = "../"
  name    = "EFSTest-minimal-options"
  vpc_id  = var.vpc_id
  subnets = var.subnets

  custom_tags = {
    Company = "ACME Inc"
    Project = "EFS"
  }
}

