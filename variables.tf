variable "network_id" {
  type        = string
  default     = null
  description = "Existing network where resources will be created"
}

variable "description" {
  type        = string
  default     = "Managed by Terraform"
  description = "Description of the security group"
}

variable "name" {
  type        = string
  description = "Security group name"
}

variable "folder_id" {
  type        = string
  default     = null
  description = "Folder ID where the resources will be created"
}

variable "labels" {
  description = "Set of key/value label pairs to assign."
  type        = map(string)
  default     = null
}

variable "ingress_rules_with_cidrs" {
  type = list(object({
    description    = optional(string, "")
    protocol       = optional(string, "ANY")
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
    v4_cidr_blocks = optional(list(string), [])
  }))
  default = []
  validation {
    condition = alltrue([
      for rule in var.ingress_rules_with_cidrs : (
        rule.port == null
        ? ((rule.from_port == null && rule.to_port == null) || (rule.from_port != null && rule.to_port != null && try(rule.from_port <= rule.to_port, false)))
        : rule.from_port == null && rule.to_port == null
      ) && contains(["ANY", "TCP", "UDP", "ICMP", "IPV6_ICMP", "AH", "ESP", "GRE"], rule.protocol)
    ])
    error_message = "Each ingress CIDR rule must use either port or a complete, ordered from_port/to_port range, and its protocol must be ANY, TCP, UDP, ICMP, IPV6_ICMP, AH, ESP, or GRE."
  }
  description = <<-EOT
  List of ingress rules with CIDR blocks as sources.
  
  Each rule can include:
  - description: (Optional) Description of the rule
  - protocol: (Optional) Protocol. Allowed values: TCP, UDP, ICMP, IPV6_ICMP, AH, ESP, GRE, ANY. Default: ANY
  - port: (Optional) Single port number
  - from_port: (Optional) Start of port range. Used with to_port
  - to_port: (Optional) End of port range. Used with from_port
  - v4_cidr_blocks: (Optional) List of IPv4 CIDR blocks
  
  Note: Either use 'port' OR 'from_port'/'to_port' pair, not both.
  
  Example:
  ```
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
  EOT
}

variable "ingress_rules_with_sg_ids" {
  type = list(object({
    description       = optional(string, "")
    protocol          = optional(string, "ANY")
    port              = optional(number)
    from_port         = optional(number)
    to_port           = optional(number)
    security_group_id = string
  }))
  default = []
  validation {
    condition = alltrue([
      for rule in var.ingress_rules_with_sg_ids : (
        rule.port == null
        ? ((rule.from_port == null && rule.to_port == null) || (rule.from_port != null && rule.to_port != null && try(rule.from_port <= rule.to_port, false)))
        : rule.from_port == null && rule.to_port == null
      ) && contains(["ANY", "TCP", "UDP", "ICMP", "IPV6_ICMP", "AH", "ESP", "GRE"], rule.protocol)
    ])
    error_message = "Each ingress security-group rule must use either port or a complete, ordered from_port/to_port range, and its protocol must be ANY, TCP, UDP, ICMP, IPV6_ICMP, AH, ESP, or GRE."
  }
  description = <<-EOT
  List of ingress rules with other security groups as sources.
  
  Each rule can include:
  - description: (Optional) Description of the rule
  - protocol: (Optional) Protocol. Allowed values: TCP, UDP, ICMP, IPV6_ICMP, AH, ESP, GRE, ANY. Default: ANY
  - port: (Optional) Single port number
  - from_port: (Optional) Start of port range. Used with to_port
  - to_port: (Optional) End of port range. Used with from_port
  - security_group_id: (Required) ID of the source security group
  
  Note: Either use 'port' OR 'from_port'/'to_port' pair, not both.
  
  Example:
  ```
  ingress_rules_with_sg_ids = [
    {
      protocol          = "ANY"
      description       = "Communication with web SG"
      security_group_id = "12345678"
    },
  ]
  ```
  EOT
}

variable "self" {
  type        = bool
  description = "Allow to communicate inside security group"
  default     = true
}

variable "nlb_hc" {
  type        = bool
  description = "Allow to communicate with NLB health check servers"
  default     = false
}

variable "self_port" {
  type        = number
  description = "Allow to communicate within security group with port"
  default     = null
}

variable "self_from_port" {
  type        = number
  description = "Allow to communicate within security group with port from"
  default     = null
}

variable "self_to_port" {
  type        = number
  description = "Allow to communicate within security group with port to"
  default     = null
}

variable "self_protocol" {
  type        = string
  description = "Allow to communicate within security group with protocol"
  default     = "ANY"
}

variable "egress_rules" {
  type = list(object({
    description    = optional(string, "")
    protocol       = optional(string, "ANY")
    port           = optional(number)
    from_port      = optional(number, 0)
    to_port        = optional(number, 65535)
    v4_cidr_blocks = optional(list(string), ["0.0.0.0/0"])
  }))
  default = []
  validation {
    condition = alltrue([
      for rule in var.egress_rules : (
        rule.port == null
        ? ((rule.from_port == null && rule.to_port == null) || (rule.from_port != null && rule.to_port != null && try(rule.from_port <= rule.to_port, false)))
        : rule.from_port == 0 && rule.to_port == 65535
      ) && contains(["ANY", "TCP", "UDP", "ICMP", "IPV6_ICMP", "AH", "ESP", "GRE"], rule.protocol)
    ])
    error_message = "Each egress rule must use either port or a complete, ordered from_port/to_port range; port cannot be combined with a custom range. Its protocol must be ANY, TCP, UDP, ICMP, IPV6_ICMP, AH, ESP, or GRE."
  }
  description = <<-EOT
  List of egress rules with CIDR blocks as destinations.
  
  Each rule can include:
  - description: (Optional) Description of the rule
  - protocol: (Optional) Protocol. Allowed values: TCP, UDP, ICMP, IPV6_ICMP, AH, ESP, GRE, ANY. Default: ANY
  - port: (Optional) Single port number
  - from_port: (Optional) Start of port range. Default: 0
  - to_port: (Optional) End of port range. Default: 65535
  - v4_cidr_blocks: (Optional) List of IPv4 CIDR blocks. Default: ["0.0.0.0/0"]
  
  Note: Either use 'port' OR 'from_port'/'to_port' pair, not both.
  
  Example:
  ```
  egress_rules = [
    {
      protocol       = "ANY"
      description    = "To the internet"
      v4_cidr_blocks = ["0.0.0.0/0"]
    },
  ]
  ```
  EOT
}
