# MicroOS setup using Ignition

This sample uses Ignition config file (introduced by Fedora CoreOS). It does:

- creates `core` user with `sudo` rights to get root access (to mimic Fedora
  CoreOS default account). This user can log remotely with ssh key
  `../microos_id_ed25519`
- setup password (`Admin123`) and SSH access with above key
  `../microos_id_ed25519`

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

When ready invoke `./create-libvirt-vm.sh` from GUI and watch console...
