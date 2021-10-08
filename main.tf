resource "random_id" "hash" {
  byte_length = 8
}

resource "alicloud_instance" "instance"{
    count = 1
    instance_name = "myinstance"
    image_id = "ubuntu_140405_64_40G_cloudinit_20161115.vhd"
    instance_type = "ecs.sn1ne.small"
    security_groups = ["sg-abc12345"]
    vswitch_id = "vsw-abc12345"

    tags = {
      from = "terraform"
    }
}

resource "alicloud_vpc" "vpc" {
  cidr_block = "10.86.0.0/16"

  tags = {
    Name = "TF-Ansible-VPC-${random_id.hash.hex}"
  }
}

resource "alicloud_subnet" "subnet" {
  vpc_id                  = alicloud_vpc.vpc.id
  cidr_block              = "10.86.100.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az
}

resource "alicloud_instance" "this" {
  ami                    = data.alicloud_ami.ubuntu.id
  instance_type          = "t3.small"
  key_name               = "ansible"
  subnet_id              = alicloud_subnet.subnet.id
  vpc_security_group_ids = [alicloud_security_group.sg.id]
  tags = {
    Name = "ansible-${random_id.hash.hex}"
  }
}

resource "ansible_host" "web" {
  inventory_hostname = alicloud_instance.this.public_ip
  groups             = ["web"]
  vars = {
    port         = 80
    ansible_user = "ubuntu"
  }
}
