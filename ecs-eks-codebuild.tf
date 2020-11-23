# resource "aws_s3_bucket" "artifacts-store-bucket" {
#   bucket = "xxxxx-artifacts-xxxxx"
#   acl    = "private"
# }

resource "aws_iam_role" "aws_codebuild" {
  name = "aws_codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "aws_codebuild_policy" {
  role = aws_iam_role.aws_codebuild.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "ssm:*" 
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::xxxxxxx-artifacts-xxxx",
        "arn:aws:s3:::xxxxxxx-artifacts-xxx/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "configuration-service" {
  name          = "abc-service"
  description   = "abc service build"
  build_timeout = "5"
  service_role  = aws_iam_role.aws_codebuild.arn

  artifacts {
      type ="S3"
      location= "xxxxx-artifacts-xxxxx" # as bucket alredy created not using aws_s3_bucket.nocnoc-artifacts-store.bucket
      path =""
      namespace_type="NONE"
      name= ""
      packaging= "NONE"
      override_artifact_name= true
      encryption_disabled= false
  }

  cache {
    type     = "S3"
    location = "xxxxxx-artifacts-xxxx"  # as bucket alredy created not using aws_s3_bucket.nocnoc-artifacts-store.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode= true

    environment_variable {
      name  = "dummy_key"
      value = "SOME_VALUE1"
    }

    environment_variable {
      name  = "SOME_KEY2"
      value  = "/xxxxxx/github/token"
      type = "PARAMETER_STORE"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "abc-service"
      stream_name = "build"
    }

    s3_logs {
      status   = "DISABLED"  # not using s3 for build logs
      # location = "${aws_s3_bucket.example.id}/build-log"
      encryption_disabled= true
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/xxxxxxxx/xxxxxxxxx-service.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
    buildspec= "buildspec.yml"
  }

  source_version = "development"

  vpc_config {
    vpc_id = "${var.dev-vpc-id}"

    subnets = [
      "${element("${var.subnet_ids}", 0)}",
      "${element("${var.subnet_ids}", 1)}"
    ]

    security_group_ids = [
      "${var.dev-vpc-all-local}"
    ]
  }

  tags = {
    Environment = "${var.environment}"
    Team = "${var.team}"
    Service = "${var.service}"
    CreatedBy = "amar.khan"
  }
}
