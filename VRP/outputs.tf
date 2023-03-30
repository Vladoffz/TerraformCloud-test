output "public_ip" {
  value = aws_eip.for_workspace.public_ip
}