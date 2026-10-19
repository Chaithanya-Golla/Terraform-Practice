resource "aws_instance" "myec2" {
  ami = "ami-0567589d25e06853e"
  instance_type = "t2.medium"  
  tags = {
    Name = "madhan-server"
  }
}