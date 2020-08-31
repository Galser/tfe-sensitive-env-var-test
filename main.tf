resource "null_resource" "get_aws_cred" {
  provisioner "local-exec" {
    command = "echo $AWS_SECRET_ACCESS_KEY > awskey"
  }
}

data "local_file" "awscred" {
  filename = "awskey"
  depends_on = [
    null_resource.get_aws_cred
  ]
}

output "AWS_SECRET_ACCESS_KEY" {
  value = data.local_file.awscred.content
}
