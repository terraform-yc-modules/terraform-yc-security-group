# Security Groups Terraform module for Yandex.Cloud

## Features

* Create Security Group and rules in your VPC
* Output Security Group ID for referencing

## Usage

Use `ingress_rules_with_cidrs` to add rules with IP address ranges:

```hcl
ingress_rules_with_cidrs = [
  {
    description    = "ssh"
    port           = 22
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description    = "ICMP"
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  },
]
```

Use `ingress_rules_with_sg_ids` to add rules with other SGs as a traffic source:

```hcl
ingress_rules_with_sg_ids = [
  {
    protocol          = "ANY"
    description       = "Communication with web SG"
    security_group_id = "12345678"
  },
]
```

Use `self` to add rule "self_security_group" for communication within a SG:

```hcl
self = true
```



### How to configure Terraform for Yandex.Cloud 

- Install [YC CLI](https://cloud.yandex.com/docs/cli/quickstart)
- Add environment variables for terraform auth in Yandex Cloud:
  
```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
``` 

### Type

The *type* should always be lowercase as shown below.

#### Allowed `<type>` values:

* **breaking: msg** (a commit that has the text BREAKING CHANGE: at the beginning of its optional body or footer section introduces a breaking API change)
* **chore: msg** (updating build/env/packages, etc; no production code change)
* **ci: msg** (changes to our CI configuration files and scripts )
* **docs: msg** (changes to documentation)
* **feat: msg** (new feature for the user)
* **fix: msg** (bug fix for the user, not a fix to build scripts)
* **refactor: msg** (refactoring production code, eg. renaming a variable)
* **security: msg** (fix security vulnerabilities)
* **style: msg** (formatting, missing semi colons, etc; no functional code change)
* **test: msg** (adding missing tests, refactoring tests; no production code change)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.100 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.139.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_security_group.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group_rule.egress_rules](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group_rule.ingress_nlb_hc_rule](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group_rule.ingress_rules_with_cidrs](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group_rule.ingress_rules_with_sg_ids](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group_rule.ingress_self_rule](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the security group | `string` | `"Managed by Terraform"` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | List of egress rules with CIDR blocks as destinations.<br/><br/>Each rule can include:<br/>- description: (Optional) Description of the rule<br/>- protocol: (Optional) Protocol. Allowed values: TCP, UDP, ICMP, ANY. Default: ANY<br/>- port: (Optional) Single port number<br/>- from\_port: (Optional) Start of port range. Default: 0<br/>- to\_port: (Optional) End of port range. Default: 65535<br/>- v4\_cidr\_blocks: (Optional) List of IPv4 CIDR blocks. Default: ["0.0.0.0/0"]<br/><br/>Note: Either use 'port' OR 'from\_port'/'to\_port' pair, not both.<br/><br/>Example:<pre>egress_rules = [<br/>  {<br/>    protocol       = "ANY"<br/>    description    = "To the internet"<br/>    v4_cidr_blocks = ["0.0.0.0/0"]<br/>  },<br/>]</pre> | <pre>list(object({<br/>    description    = optional(string, "")<br/>    protocol       = optional(string, "ANY")<br/>    port           = optional(number)<br/>    from_port      = optional(number, 0)<br/>    to_port        = optional(number, 65535)<br/>    v4_cidr_blocks = optional(list(string), ["0.0.0.0/0"])<br/>  }))</pre> | `[]` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Folder ID where the resources will be created | `string` | `null` | no |
| <a name="input_ingress_rules_with_cidrs"></a> [ingress\_rules\_with\_cidrs](#input\_ingress\_rules\_with\_cidrs) | List of ingress rules with CIDR blocks as sources.<br/><br/>Each rule can include:<br/>- description: (Optional) Description of the rule<br/>- protocol: (Optional) Protocol. Allowed values: TCP, UDP, ICMP, ANY. Default: ANY<br/>- port: (Optional) Single port number<br/>- from\_port: (Optional) Start of port range. Used with to\_port<br/>- to\_port: (Optional) End of port range. Used with from\_port<br/>- v4\_cidr\_blocks: (Optional) List of IPv4 CIDR blocks<br/><br/>Note: Either use 'port' OR 'from\_port'/'to\_port' pair, not both.<br/><br/>Example:<pre>ingress_rules_with_cidrs = [<br/>  {<br/>    description    = "ssh"<br/>    port           = 22<br/>    protocol       = "TCP"<br/>    v4_cidr_blocks = ["0.0.0.0/0"]<br/>  },<br/>  {<br/>    description    = "ICMP"<br/>    protocol       = "ICMP"<br/>    v4_cidr_blocks = ["0.0.0.0/0"]<br/>    from_port      = 0<br/>    to_port        = 65535<br/>  },<br/>]</pre> | <pre>list(object({<br/>    description    = optional(string, "")<br/>    protocol       = optional(string, "ANY")<br/>    port           = optional(number)<br/>    from_port      = optional(number)<br/>    to_port        = optional(number)<br/>    v4_cidr_blocks = optional(list(string), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_ingress_rules_with_sg_ids"></a> [ingress\_rules\_with\_sg\_ids](#input\_ingress\_rules\_with\_sg\_ids) | List of ingress rules with other security groups as sources.<br/><br/>Each rule can include:<br/>- description: (Optional) Description of the rule<br/>- protocol: (Optional) Protocol. Allowed values: TCP, UDP, ICMP, ANY. Default: ANY<br/>- port: (Optional) Single port number<br/>- from\_port: (Optional) Start of port range. Used with to\_port<br/>- to\_port: (Optional) End of port range. Used with from\_port<br/>- security\_group\_id: (Required) ID of the source security group<br/><br/>Note: Either use 'port' OR 'from\_port'/'to\_port' pair, not both.<br/><br/>Example:<pre>ingress_rules_with_sg_ids = [<br/>  {<br/>    protocol          = "ANY"<br/>    description       = "Communication with web SG"<br/>    security_group_id = "12345678"<br/>  },<br/>]</pre> | <pre>list(object({<br/>    description       = optional(string, "")<br/>    protocol          = optional(string, "ANY")<br/>    port              = optional(number)<br/>    from_port         = optional(number)<br/>    to_port           = optional(number)<br/>    security_group_id = string<br/>  }))</pre> | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Set of key/value label pairs to assign. | `map(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Security group name | `string` | n/a | yes |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | Existing network where resources will be created | `string` | `null` | no |
| <a name="input_nlb_hc"></a> [nlb\_hc](#input\_nlb\_hc) | Allow to communicate with NLB health check servers | `bool` | `false` | no |
| <a name="input_self"></a> [self](#input\_self) | Allow to communicate inside security group | `bool` | `true` | no |
| <a name="input_self_from_port"></a> [self\_from\_port](#input\_self\_from\_port) | Allow to communicate within security group with port from | `number` | `null` | no |
| <a name="input_self_port"></a> [self\_port](#input\_self\_port) | Allow to communicate within security group with port | `number` | `null` | no |
| <a name="input_self_protocol"></a> [self\_protocol](#input\_self\_protocol) | Allow to communicate within security group with protocol | `string` | `"ANY"` | no |
| <a name="input_self_to_port"></a> [self\_to\_port](#input\_self\_to\_port) | Allow to communicate within security group with port to | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Security group ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
