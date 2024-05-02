resource "aws_route53_record" "rabbitmqdb" {
  zone_id = "Z0547409165EGAKUG3EH3"
  name    = "rabbitmqdb-${var.ENV}.roboshopshopping"
  type    = "CNAME"
  ttl     = 10
  records = [aws_spot_instance_request.rabbitmqdb.private_ip]
}