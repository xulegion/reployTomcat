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
