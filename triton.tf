provider "triton" {
  account      = "${var.account}"
  key_id       = "${var.key_id}"
  key_material = "${file(var.key_path)}"
}

resource "triton_machine" "dcos-bootstrap" {
  name    = "dcos-bootstrap"
  image   = "d8e65ea2-1f3e-11e5-8557-6b43e0a88b38"
  package = "g3-standard-2-kvm"

  tags {
    role = "bootstrap"
  }

  connection {
    host        = "${self.primaryip}"
    private_key = "${file(var.key_path)}"
  }

  provisioner "remote-exec" {
    inline = ["/bin/true"]
  }
}

resource "triton_machine" "dcos-master" {
  count   = 1
  name    = "${format(\"dcos-master-%03d\", count.index + 1)}"
  image   = "d8e65ea2-1f3e-11e5-8557-6b43e0a88b38"
  package = "g3-standard-15-kvm"

  tags {
    role = "master"
  }

  connection {
    host        = "${self.primaryip}"
    private_key = "${file(var.key_path)}"
  }

  provisioner "remote-exec" {
    inline = ["/bin/true"]
  }
}

resource "triton_machine" "dcos-agent" {
  count   = 3
  name    = "${format(\"dcos-agent-%03d\", count.index + 1)}"
  image   = "d8e65ea2-1f3e-11e5-8557-6b43e0a88b38"
  package = "g3-standard-15-kvm"

  tags {
    role = "agent"
  }

  connection {
    host = "${self.primaryip}"
    private_key = "${file(var.key_path)}"
  }

  provisioner "remote-exec" {
    inline = ["/bin/true"]
  }
}
