output "prometheus_ip" {
  value = aws_instance.prometheus.public_ip
}

output "infra_ip" {
  value = aws_instance.infra.public_ip
}

output "app_ip" {
  value = aws_instance.app.public_ip
}
