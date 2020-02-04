# General variables

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "environment" {
  description = "Environment for wich this module will be created. E.g. Development"
  type        = string
  default     = "Development"
}

variable "custom_tags" {
  description = "Optional tags to be applied on top of the base tags on all resources"
  type        = map(string)
  default     = {}
}

# EFS variables
variable "name" {
  description = <<EOF
A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System to ensure
idempotent file system creation.
EOF
  type        = string
  default     = ""
}

variable "performance_mode" {
  description = "The file system performance mode. Can be either \"generalPurpose\" or \"maxIO\"."
  type        = string
  default     = "generalPurpose"
}

variable "throughput_mode" {
  type        = string
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps`"
  default     = "bursting"
}

variable "provisioned_throughput_in_mibps" {
  description = <<EOF
The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned.
EOF
  type        = number
  default     = 0
}

variable "encrypted" {
  description = "If true, the disk will be encrypted. "
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = <<EOF
The ARN for the KMS key to use for encrypting the disk. If specified, `encrypted` must be set to \"true\"`. If left
blank and `encrypted` is set to \"true\", Terraform will use the default `aws/elasticfilesystem` KMS key.
EOF

  type    = string
  default = ""
}

# EFS Mount target  options
variable "subnets" {
  description = "Subnets in which the EFS mount target will be created."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}


# DNS
variable "create_internal_dns_record" {
  description = <<EOF
Whether or not to create a custom, internal DNS record for the EFS endpoint's generated DNS name. If \"true\", the
`internal_zone_id` MUST be provided, and a specific `internal_record_name` MAY be provided. Default is \"false\".
EOF

  type    = bool
  default = false
}

variable "internal_zone_id" {
  description = <<EOF
A Route 53 Internal Hosted Zone ID.
EOF

  type    = "string"
  default = ""
}

variable "internal_record_name" {
  description = <<EOF
DNS record name subdomain. If `internal_record_name` is provided, the convention \"efs-<name>-<environment>\" will be used.
EOF
  type        = "string"
  default     = ""
}
