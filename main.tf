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
