locals {
  use_route53 = false # var.region != "us-gov-west-1"
}

resource "aws_route53_record" "ops_manager_attached_eip" {
  name    = "pcf.${var.env_name}.${var.dns_suffix}"
  zone_id = var.zone_id
  type    = "A"
  ttl     = 300
  count   = local.use_route53 ? var.vm_count : 0

  records = [coalesce(
    join("", aws_eip.ops_manager_attached.*.public_ip),
    aws_instance.ops_manager[0].private_ip,
  )]
}

resource "aws_route53_record" "ops_manager_unattached_eip" {
  name    = "pcf.${var.env_name}.${var.dns_suffix}"
  zone_id = var.zone_id
  type    = "A"
  ttl     = 300
  count   = local.use_route53 && var.vm_count < 1 ? 1 : 0

  records = aws_eip.ops_manager_unattached.*.public_ip
}

resource "aws_route53_record" "optional_ops_manager" {
  name    = "pcf-optional.${var.env_name}.${var.dns_suffix}"
  zone_id = var.zone_id
  type    = "A"
  ttl     = 300
  count   = local.use_route53 ? var.optional_count : 0

  records = [coalesce(
    join("", aws_eip.optional_ops_manager.*.public_ip),
    aws_instance.optional_ops_manager[0].private_ip,
  )]
}

