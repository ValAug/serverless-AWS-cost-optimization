#--eventbriged/main--

resource "aws_cloudwatch_event_rule" "start_event_rule" {
    name = "start-bim-large-ec2"
    schedule_expression = "cron(0 12 * * ? *)"

    tags = {
    Project = "large_ec2"
  }
}

resource "aws_cloudwatch_event_target" "start_event_lambda_target" {
    rule = aws_cloudwatch_event_rule.start_event_rule.name
    arn = aws_lambda_function.ec2_start_large_lambda.arn
}

resource "aws_lambda_permission" "allow_start_event_rule_schedule" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_start_large_lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.start_event_rule.arn
}

#---stop---

resource "aws_cloudwatch_event_rule" "stop_event_rule" {
    name = "stop-bim-large-ec2"
    schedule_expression = "cron(0 18 * * ? *)"
    tags = {
    Project = "large_ec2"
  }
}

resource "aws_cloudwatch_event_target" "stop_event_lambda_target" {
    rule = aws_cloudwatch_event_rule.stop_event_rule.name
    arn = aws_lambda_function.ec2_stop_large_lambda.arn
}

resource "aws_lambda_permission" "allow_stop_event_rule_schedule" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_stop_large_lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.stop_event_rule.arn
}