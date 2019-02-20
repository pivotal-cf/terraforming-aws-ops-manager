local {
  use_route53 = "${var.region == "us-gov-west-1" ? 0 : 1}"
}

resource "aws_route53_record" "ops_manager" {
  count   = "${local.use_route53 ? var.count : 0}"
  name    = "pcf.${var.env_name}.${var.dns_suffix}"
  zone_id = "${var.zone_id}"
  type    = "A"
  ttl     = 300

  records = ["${aws_eip.ops_manager.public_ip}"]
}

resource "aws_route53_record" "optional_ops_manager" {
  count   = "${local.use_route53 ? var.optional_count : 0}"
  name    = "pcf-optional.${var.env_name}.${var.dns_suffix}"
  zone_id = "${var.zone_id}"
  type    = "A"
  ttl     = 300

  records = ["${aws_eip.optional_ops_manager.public_ip}"]
}
