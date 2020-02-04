output "arn" {
  value       = join("", aws_efs_file_system.fs.*.arn)
  description = "EFS ARN"
}

output "id" {
  value       = join("", aws_efs_file_system.fs.*.id)
  description = "EFS ID"
}

output "dns_name" {
  value       = aws_efs_file_system.fs.*.dns_name
  description = "The DNS name for the filesystem"
}

output "dns_name_internal_r53_record" {
  value       = aws_route53_record.efs.*.fqdn
  description = "Internal Route 53 record FQDN for the file system."
}

output "mount_target_dns_names" {
  value       = coalescelist(aws_efs_mount_target.mount.*.dns_name, [""])
  description = "List of EFS mount target DNS names"
}

output "mount_target_ids" {
  value       = coalescelist(aws_efs_mount_target.mount.*.id, [""])
  description = "List of EFS mount target IDs (one per Availability Zone)"
}

output "mount_target_ips" {
  value       = coalescelist(aws_efs_mount_target.mount.*.ip_address, [""])
  description = "List of EFS mount target IPs (one per Availability Zone)"
}

output "network_interface_ids" {
  value       = coalescelist(aws_efs_mount_target.mount.*.network_interface_id, [""])
  description = "List of mount target network interface IDs"
}

output "security_group_id" {
  value       = join("", aws_security_group.efs.*.id)
  description = "EFS Security Group ID"
}

output "security_group_arn" {
  value       = join("", aws_security_group.efs.*.arn)
  description = "EFS Security Group ARN"
}

output "security_group_name" {
  value       = join("", aws_security_group.efs.*.name)
  description = "EFS Security Group name"
}
