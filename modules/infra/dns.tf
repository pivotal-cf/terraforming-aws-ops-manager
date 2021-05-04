locals {
  data_zone_id     = element(concat(data.aws_route53_zone.pcf_zone.*.zone_id, [""]), 0)
  resource_zone_id = element(concat(aws_route53_zone.pcf_zone.*.zone_id, [""]), 0)
  zone_id          = var.hosted_zone == "" ? local.resource_zone_id : local.data_zone_id

  data_dns_name_servers = join(
    ",",
    flatten(
      concat(data.aws_route53_zone.pcf_zone.*.name_servers, [[""]]),
    ),
  )
  resource_dns_name_servers = join(
    ",",
    flatten(concat(aws_route53_zone.pcf_zone.*.name_servers, [[""]])),
  )
  name_servers      = var.hosted_zone == "" ? local.resource_dns_name_servers : local.data_dns_name_servers
  hosted_zone_count = var.hosted_zone == "" ? 0 : 1

  use_route53 = false #var.region != "us-gov-west-1"
}

data "aws_route53_zone" "pcf_zone" {
  count = local.use_route53 ? local.hosted_zone_count : 0

  name = var.hosted_zone
}

resource "aws_route53_zone" "pcf_zone" {
  count = local.use_route53 ? 1 - local.hosted_zone_count : 0

  name = "${var.env_name}.${var.dns_suffix}"

  tags = merge(
    var.tags,
    {
      "Name" = "${var.env_name}-hosted-zone"
    },
  )
}

resource "aws_route53_record" "name_servers" {
  count = local.use_route53 ? 1 - local.hosted_zone_count : 0

  zone_id = local.zone_id
  name    = "${var.env_name}.${var.dns_suffix}"

  type = "NS"
  ttl  = 300

  records = [local.name_servers]
}

