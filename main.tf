data "aws_vpc" "selected" {
  id = var.vpc_id
}

locals {
  base_tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_efs_file_system" "fs" {
  count                           = var.enabled ? 1 : 0
  creation_token                  = var.name
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_arn

  tags = "${merge(local.base_tags, map("Name", var.name), var.custom_tags)}"
}

resource "aws_efs_mount_target" "mount" {
  count           = var.enabled && length(var.subnets) > 0 ? length(var.subnets) : 0
  file_system_id  = join("", aws_efs_file_system.fs.*.id)
  subnet_id       = var.subnets[count.index]
  security_groups = [join("", aws_security_group.efs.*.id)]

}
resource "aws_security_group" "efs" {
  count       = var.enabled ? 1 : 0
  name        = format("%s-efs-SG", var.environment)
  description = "EFS Security Group"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(local.base_tags, var.custom_tags)}"
}

resource "aws_security_group_rule" "ingress" {
  count             = var.enabled ? 1 : 0
  type              = "ingress"
  from_port         = "2049" # NFS
  to_port           = "2049"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = join("", aws_security_group.efs.*.id)
}

resource "aws_security_group_rule" "egress" {
  count             = var.enabled ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.efs.*.id)
}


resource "aws_route53_record" "efs" {
  count = var.enabled && var.create_internal_dns_record ? 1 : 0

  zone_id = var.internal_zone_id
  name    = "${var.internal_record_name != "" ? var.internal_record_name : "efs-${var.name}-${var.environment}"}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_efs_file_system.fs.*.dns_name]
}

