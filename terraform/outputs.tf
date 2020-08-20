output "aws_lb_dns" {
  value = aws_alb.ecs_alb.dns_name
}