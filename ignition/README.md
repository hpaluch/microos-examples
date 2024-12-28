# MicroOS setup using Ignition

This sample uses Ignition config file (introduced by Fedora CoreOS).

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


