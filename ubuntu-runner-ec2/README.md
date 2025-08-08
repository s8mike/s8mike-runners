
## Ubuntu EC2 Terraform Setup

This module creates an Ubuntu EC2 instance on AWS with:
- An 8GiB root volume
- A security group allowing all inbound and outbound traffic
- An SSH key pair

### Usage

1. Ensure you have [Terraform](https://www.terraform.io/downloads.html) and AWS credentials configured.
2. Place your public SSH key at `~/.ssh/id_rsa.pub` or update the path in `main.tf`.
3. Initialize and apply the configuration:

```sh
terraform init
terraform apply
```

4. Confirm the apply when prompted. Terraform will output the instance details.

### Notes
- The default AWS region is `us-east-1`. Change it in `main.tf` if needed.
- The security group allows all traffic. Restrict as needed for production.
- The instance type is `t2.micro` by default.

### Clean Up
To destroy the resources:

```sh
terraform destroy
```
