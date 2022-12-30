provider "aws" {
  access_key = "xxx"
  secret_key = "xxx"
  region     = "ap-south-1"
}

resource "aws_sqs_queue" "order_queue" {
  name = "order-queue"
  delay_seconds = 60
  max_message_size = 1024
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}
