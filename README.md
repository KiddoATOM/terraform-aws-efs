# aws-terraform-efs

This module sets up a basic Elastic File System on AWS for an account in a specific region.

## Usage

```HCL
module "efs" {
  source = "/module_path/
  name    = "EFSTest-minimal-options"
  vpc_id  = var.vpc_id
  subnets = var.subnets_ids

  custom_tags = {
    Company = "ACME Inc"
    Project = "EFS"
  }
}
```



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enabled | Set to false to prevent the module from creating any resources Default is \"true\". | bool | `true` | no |
| environment | Environment for wich this module will be created. E.g. Development | string | `"Development"` | no |
| custom\_tags | Optional tags to be applied on top of the base tags on all resources | map | `<map>` | no |
| name | A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System to ensure idempotent file system creation. | string | `""` | no |
|performance\_mode | The file system performance mode. Can be either \"generalPurpose\" or \"maxIO\". | string | `"generalPurpose"` | no |
| encrypted | If true, the disk will be encrypted. | bool | `false` | no |
|throughput\_mode | Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps`| string | `"bursting"` | no |
|provisioned\_throughput\_in\_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned. | number | `0` | no |
| encrypted | If true, the disk will be encrypted. | bool | `false` | no |
| kms\_key\_arn | The ARN for the KMS key to use for encrypting the disk. If specified, `encrypted` must be set to \"true\"`. If left blank and `encrypted` is set to \"true\", Terraform will use the default `aws/elasticfilesystem` KMS key. | string | `""` | no |
| subnets | Subnets in which the EFS mount target will be created. | list |  | yes |
| vpc_id | The VPC ID. | string |  | yes |
| create_internal_dns_record | Whether or not to create a custom, internal DNS record for the EFS endpoint's generated DNS name. If \"true\", the `internal_zone_id` MUST be provided, and a specific `internal_record_name` MAY be provided. Default is \"false\". | bool | `false` | no |
| internal_zone_id |A Route 53 Internal Hosted Zone ID. | string | `""` | no |
| internal_record_name |DNS record name subdomain. If `internal_record_name` is provided, the convention \"efs-<name>-<environment>\" will be used. | string | `""` | no |


## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| id | EFS ID |
| dns\_name\ | The DNS name for the filesystem |
| dns\_name\_internal\_r53\_record | Internal Route 53 record FQDN for the file system. |
| mount_target_dns_names | List of EFS mount target DNS names |
| mount\_target\_ids | List of EFS mount target IDs (one per Availability Zone) |
| mount\_target\_ips | List of EFS mount target IPs (one per Availability Zone) |
| network\_interface\_ids | List of mount target network interface IDs |
| security\_group\_id | EFS Security Group ID |
| security\_group\_arn | EFS Security Group ARN |
| security\_group\_name | EFS Security Group name |

## NFS Client configuration

You can use fstab to automatically mount your Amazon EFS file system using the mount helper whenever the Amazon EC2 instance it is mounted on reboots. 

This is the procedure to mount EFS to an Ubuntu instance. As an example the "/home/ubuntu/test-dir" folder is used, you can set the path that you want.
 
```bash
sudo apt-get update
git clone https://github.com/aws/efs-utils
sudo apt-get -y install binutils
cd efs-utils/
./build-deb.sh
sudo apt-get -y install ./build/amazon-efs-utils*deb
mkdir -p /home/ubuntu/test-dir
sudo echo "fs-503a88fa:/ /home/ubuntu/test-dir efs defaults,_netdev 0 0" >> /etc/fstab
sudo mount -fav
```
If all is OK you will see a message like this:
```
/                        : ignored
/home/ubuntu/test-efs-dir: successfully mounted
```

Please verify that both DNS Resolution and DNS Hostnames are enabled for your VPC and your VPC is configured to use the DNS server provided by Amazon.

For more information refer to AWS official documentation:
[Link1](https://docs.aws.amazon.com/efs/latest/ug/mount-fs-auto-mount-onreboot.html)
[Link2](https://docs.aws.amazon.com/efs/latest/ug/using-amazon-efs-utils.html#installing-other-distro)
