# openSUSE MicroOS examples

Here are example(s) using openSUSE MicroOS from https://get.opensuse.org/microos/

We will use LibVirt's `virt-install` to setup MicroOS VM and set root password and root SSH key.

> [!WARNING]
> This project contains private SSH key for `root` login! Never use this key in production
> or in reachable public systems !!!

# Requirements

Host OS with installed LibVirt `virt-manager` and `virt-install` command, NAT network `default`.

NOTE: I use system (global) namespace - so your user needs to be member of `libvirt` group
and there should be enabled legacy `libvirtd` service.

# Setup

Download suitable MicroOS disk image using:

```shell
( cd /opt/iso &&
  curl -fLO https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-kvm-and-xen.qcow2 )
```

Review Combustion (configuration) script [./combustion-script](./combustion-script)

Review script [./create-libvirt-vm.sh](./create-libvirt-vm.sh) and run it.

Watch on GUI console installation progress - once there appear Login prompt you can:
- login locally as `root` with password `Admin123`
- login remotely as `root` with provided private key `microos_id_ed25519` using command like:

```shell
ssh -i microos_id_ed25519 root@IP_OF_VM
```

> [!WARNING]
> Again - please never use that private SSH key `microos_id_ed25519*` in production!

# Bugs

You need to run `virt-install` in GUI - I was not able to setup properly serial
console although inside VM it looks correct. Although basically same setup
works properly on Fedora CoreOS 41.

# Resources

* My detailed wiki on MicroOS: https://github.com/hpaluch/hpaluch.github.io/wiki/MicroOS
* https://get.opensuse.org/microos/
* https://en.opensuse.org/Portal:MicroOS/Combustion