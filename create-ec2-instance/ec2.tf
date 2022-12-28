provider "aws" {
  access_key = "xxx"
  secret_key = "xxx"
  region     = "ap-south-1"
}

resource "aws_instance" "terraform-example" {
  ami           = "ami-03d3eec31be6ef6f9"
  instance_type = "t2.micro"
}
