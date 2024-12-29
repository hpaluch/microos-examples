# MicroOS WordPress setup using Ignition

This sample uses Ignition config file (introduced by Fedora CoreOS). It does:

- creates `core` user with `sudo` rights to get root access (to mimic Fedora
  CoreOS default account). This user can log remotely with ssh key
  `../microos_id_ed25519`
- setup password (`Admin123`) and SSH access with above key
  `../microos_id_ed25519`
- setup full WordPress using SystemD Quadlets and Podman for containers - from
  adapted example from https://github.com/major/quadlets-wordpress

Usage:
- run `create-libvirt-vm.sh` and follow instructions on both VM login and script.
- at the end you have to reboot your VM to trigger startup of Podman containers
  (or login as `core` user should also trigger it)
- next point your browser to `http://IP_OF_VM` to setup WordPress installation
- NOTE: `create-libvirt-vm.sh` script finishes only when VM execution is
  finished (you can use `sudo poweroff` inside VM to shutdown it)

How Butane/Ignition works?

It has following flow:

1. input source: [config.bu.yaml](config.bu.yaml) - Butane config,
   see https://coreos.github.io/butane/config-fcos-v1_5/ - this file is YAML
   compatible
2. generated `config.ign`: Butane input is converted to Ingition file - which
   is JSON which must have inlined all external files. This file is generated
   with `butane` utility.
3. Then special ISO that must have label `ignition` and specific file path is
   created with  `mkiso`, see https://en.opensuse.org/Portal:MicroOS/Ignition#Create_an_ISO-Image
   for details.

So in summary:
- you will specify all required configuration in YAML file [config.bu.yaml](config.bu.yaml)

To run this example you need to fulfill requirements from parent [../README.md](../README.md)
and additionally install:

1. `butane` binary - download latest from https://github.com/coreos/butane/tags
2. `mkisofs` (on openSUSE LEAP host using `sudo zypper in mkisofs` command)

When ready invoke `./create-libvirt-vm.sh` from GUI and watch console for instructions.
