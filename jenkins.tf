resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.jenkins_instance_type
  subnet_id     = aws_subnet.public[0].id

  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name              = aws_key_pair.jenkins.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y openjdk-11-jdk
              wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
              sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              apt-get update
              apt-get install -y jenkins
              systemctl start jenkins
              EOF

  tags = {
    Name = "${var.cluster_name}-jenkins"
  }
}