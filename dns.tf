locals {
  use_route53 = "${var.region == "us-gov-west-1" ? 0 : 1}"
}

resource "aws_route53_zone" "pcf_zone" {
  count  = "${local.use_route53 ? 1 : 0}"
  name   = "${var.env_name}.${var.dns_suffix}"

  tags {
    Name = "${var.env_name}-hosted-zone"
  }
}

resource "aws_route53_record" "wildcard_sys_dns" {
  count   = "${local.use_route53 ? 1 : 0}"
  zone_id = "${aws_route53_zone.pcf_zone.id}"
  name    = "*.sys.${var.env_name}.${var.dns_suffix}"
  type    = "CNAME"
  ttl     = 300

  records = ["${aws_elb.web_elb.dns_name}"]
}

resource "aws_route53_record" "wildcard_apps_dns" {
  count   = "${local.use_route53 ? 1 : 0}"
  zone_id = "${aws_route53_zone.pcf_zone.id}"
  name    = "*.apps.${var.env_name}.${var.dns_suffix}"
  type    = "CNAME"
  ttl     = 300

  records = ["${aws_elb.web_elb.dns_name}"]
}

resource "aws_route53_record" "ssh" {
  count   = "${local.use_route53 ? 1 : 0}"
  zone_id = "${aws_route53_zone.pcf_zone.id}"
  name    = "ssh.sys.${var.env_name}.${var.dns_suffix}"
  type    = "CNAME"
  ttl     = 300

  records = ["${aws_elb.ssh_elb.dns_name}"]
}

resource "aws_route53_record" "tcp" {
  count   = "${local.use_route53 ? 1 : 0}"
  zone_id = "${aws_route53_zone.pcf_zone.id}"
  name    = "tcp.${var.env_name}.${var.dns_suffix}"
  type    = "CNAME"
  ttl     = 300

  records = ["${aws_elb.tcp_elb.dns_name}"]
}

resource "aws_route53_record" "wildcard_iso_dns" {
  count   = "${local.use_route53 ? min(var.create_isoseg_resources, 1) : 0}"
  zone_id = "${aws_route53_zone.pcf_zone.id}"
  name    = "*.iso.${var.env_name}.${var.dns_suffix}"
  type    = "CNAME"
  ttl     = 300

  records = ["${aws_elb.isoseg.dns_name}"]
}
