resource "aws_iam_role" "lambda_role" {
  name = "admin-role"

  assume_role_policy   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
  tags = {
    Project = "SACO"
  }
}

resource "aws_iam_policy" "role_policy" {
  name        = "ec2-large-policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "*"
    }
  ]
}

EOF

tags = {
    Project = "large_ec2"
  }
}

resource "aws_iam_policy" "role_policy_loging" {
  name        = "cloudwatch-logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF

tags = {
    Project = "large_ec2"
  }
}

resource "aws_iam_role_policy_attachment" "role_policy_attch" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.role_policy.arn
}

resource "aws_iam_role_policy_attachment" "role_policy_login_attch" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.role_policy_loging.arn
}

#---instance profile role ---

resource "aws_iam_instance_profile" "resources_iam_profile" {
  name = "ec2-profile"
  role = aws_iam_role.resources_iam_role.name
}

resource "aws_iam_role" "resources_iam_role" {
  name        = "ssm-role"
  description = "The role for the bim deloper resources EC2"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
  {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
EOF
}