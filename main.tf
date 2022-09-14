provider "aws" {
    access_key = "AKIA2QEFLENWCZ57K3KB"
    secret_key = "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"
    region = "us-east-1"
}

data "aws_ami" "my_ami" {
     most_recent      = true
     #name_regex       = "^mavrick"
     owners           = ["721834156908"]
}


resource "aws_instance" "web-1" {
    ami = "${data.aws_ami.my_ami.id}"
    #ami = "ami-0d857ff0f5fc4e03b"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "LaptopKey"
    subnet_id = "subnet-01f9c2774277f4015"
	private_ip = "10.1.1.111"
    vpc_security_group_ids = ["sg-09c2fc6ae1a93c80e"]
    associate_public_ip_address = true	
    tags = {
        Name = "Server-1"
        Env = "Prod"
        Owner = "Sree"
    }
}
