#----

data "template_file" "ec2_start_large" {
  count = length(local.source_files)

  template = file(element(local.source_files, count.index))
}

data "archive_file" "ec2_start_large_events" {
  type        = "zip"
  output_path = "start.zip"

  source {
    content  = data.template_file.ec2_start_large.0.rendered
    filename = basename(local.source_files[0])
  }


}

resource "aws_lambda_function" "ec2_start_large_lambda" {
  description = " EC2 large EC2"
  function_name    = "start-ec2-large"
  handler          = "start.handler"
  filename         = "${data.archive_file.ec2_start_large_events.output_path}"
  source_code_hash = "${data.archive_file.ec2_start_large_events.output_base64sha256}"
  role             =  aws_iam_role.lambda_role.arn
  memory_size      = 128
  runtime          = "python3.9"
  timeout          = 3
  publish  = true
  depends_on = [
    aws_iam_role_policy_attachment.role_policy_login_attch
]

  tracing_config {
    mode = "PassThrough"
  }

   tags = {
    Project = "large_ec2"
  }
}