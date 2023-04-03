module "sg" {
  source     = "../"
  name       = "Example SG"
  network_id = "enp5v4es0f4vgdbou270"
  nlb_hc     = true
  ingress_rules_with_cidrs = [
    {
      description    = "ssh"
      port           = 22
      protocol       = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description    = "ICMP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65535
    },
  ]
  ingress_rules_with_sg_ids = [
    {
      protocol          = "ANY"
      description       = "Communication with other SG"
      security_group_id = "enpbr4hmdn785jdqdXXX"
      from_port         = 1
      to_port           = 65535
    },
  ]
  egress_rules = [
    {
      protocol       = "ANY"
      description    = "To the internet"
      v4_cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}
