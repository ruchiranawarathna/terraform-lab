provider "aws" {
  access_key = "xxx"
  secret_key = "xxx"
  region     = "ap-south-1"
}

resource "aws_sns_topic" "order" {
  name = "order"
}

resource "aws_sqs_queue" "order_queue" {
  name = "order-queue"
  delay_seconds = 60
  max_message_size = 1024
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

resource "aws_sns_topic_subscription" "order_topic_sqs_target" {
  topic_arn = aws_sns_topic.order.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.order_queue.arn
}

resource "aws_sqs_queue_policy" "order_topic_to_sns_policy" {
  queue_url = aws_sqs_queue.order_queue.id
  policy    = data.aws_iam_policy_document.order_queue_policy.json
}

data "aws_iam_policy_document" "order_queue_policy" {
#  policy_id = "arn:aws:sqs:ap-south-1:${var.sqs["account-id"]}:${var.sqs["name"]}/SQSDefaultPolicy"

  statement {
#    sid    = "example-sns-topic"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "SQS:SendMessage",
    ]

    resources = [
      aws_sqs_queue.order_queue.arn,
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"

      values = [
        aws_sns_topic.order.arn,
      ]
    }
  }
}