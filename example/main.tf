module "sg" {
  source     = "../"
  name       = "Example_SG"
  network_id = "enp5v4es0f4vgdbou270"
  nlb_hc     = true
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
  ingress_rules_with_sg_ids = [
    {
      protocol          = "ANY"
      description       = "Communication with other SG"
      security_group_id = "enpkhpih5kr3pnj2ngof"
      from_port         = 1
      to_port           = 65535
    },
  ]
  self = true
  egress_rules = [
    {
      protocol       = "ANY"
      description    = "To the internet"
      v4_cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}
