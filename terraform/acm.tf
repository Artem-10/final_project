data "aws_route53_zone" "zone" {
  name         = var.zone_name
  private_zone = false
}

locals {
  domain_name = "${var.zone_name}"
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = local.domain_name
  zone_id     = data.aws_route53_zone.zone.zone_id

  subject_alternative_names = [
    "*.${local.domain_name}",
  ]

  wait_for_validation = true

  tags = merge(
    var.tags,
    { Name = "${var.name}-acm-certificate" }
  )
}

resource "aws_route53_record" "app_dns" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name = local.domain_name
  type = "A"
  allow_overwrite = true

  alias {
    name = data.aws_lb.ingress_controller.dns_name
    zone_id = data.aws_lb.ingress_controller.zone_id
    evaluate_target_health = true
  }
}