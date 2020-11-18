provider "aws" {
  region = "eu-west-1"
}

variable "function_name" {
  default = "http-monitor"
}

variable "handler" {
  default = "http-monitor.handler"
}

variable "runtime" {
  default = "python3.6"
}

resource "aws_lambda_function" "lambda_function" {
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = "build/distributions/http-monitor.zip"
  function_name    = var.function_name
  source_code_hash = filebase64sha256("build/distributions/http-monitor.zip")
}

resource "aws_iam_role" "lambda_exec_role" {
  name        = "lambda_exec"
  path        = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name        = "schedule-rule"
  schedule_expression = "rate(1 minute)" # every hour, 5 mns passed the hour
}

resource "aws_cloudwatch_event_target" "cleansing_coding_target" {
  rule      = aws_cloudwatch_event_rule.schedule_rule.name
  arn       = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_rule.arn
}
