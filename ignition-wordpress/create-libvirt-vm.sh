#!/bin/bash
# script to install openSUSE MicroOS using virt-install - adapted from Fedora CoreOS example
# see https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-libvirt/
set -euo pipefail
set -x

DIR=`dirname $0`
BUTANE_CONFIG="$(readlink -f $DIR/config.bu.yaml)"
IGNITION_CONFIG="$(readlink -f $DIR/config.ign)"
# Download with: curl -fLO https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-ContainerHost-kvm-and-xen.qcow2
IMAGE="/opt/iso/openSUSE-MicroOS.x86_64-ContainerHost-kvm-and-xen.qcow2"
# 'u' is like greek 'micro' symbol for MicroOS
VM_NAME="uos-wp"
VCPUS="2"
RAM_MB="4096"
# 20GB is minimum!
# check minimum with: qemu-img info /opt/iso/openSUSE-MicroOS.x86_64-ContainerHost-kvm-and-xen.qcow2 | grep 'virtual size:'
DISK_GB="20"

[ -r "$BUTANE_CONFIG" ] || {
	echo "ERROR: '$BUTANE_CONFIG' not readable"'!' >&2
	exit 1
}

[ -r "$IMAGE" ] || {
	cat >&2 <<EOF
ERROR: Image '$IMAGE' not readable.
Download it with: ( cd /opt/iso && curl -fLO https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-ContainerHost-kvm-and-xen.qcow2 )
and run this script again.
EOF
	exit 1
}

butane -d $DIR/.. -cs $BUTANE_CONFIG || {
	echo "ERROR: butane validatieon of $BUTANE_CONFIG failed" >&2
	exit 1
}

butane -d $DIR/.. -o $IGNITION_CONFIG -ps $BUTANE_CONFIG  || {
	echo "ERROR: Butane failed to generate $IGNITION_CONFIG from $BUTANE_CONFIG" >&2
	exit 1
}

# firmware tricks below do not work - using ISO volume
#IGNITION_DEVICE_ARG=(--qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${IGNITION_CONFIG}")
#IGNITION_DEVICE_ARG=(--sysinfo type=fwcfg,entry0.name="opt/com.coreos/config",entry0.file="$IGNITION_CONFIG")

# So we use ISO configuration disk as described on: https://en.opensuse.org/Portal:MicroOS/Ignition#Create_an_ISO-Image
( cd $DIR
  rm -f ignition.iso
  mkdir -p disk/ignition
  cp $IGNITION_CONFIG disk/ignition/config.ign
  mkisofs -o ignition.iso -V ignition disk
)

ISO="$(readlink -f $DIR/ignition.iso)"
[ -r "$ISO" ] || {
	echo "ERROR: $ISO not readable" >&2
	exit 1
}
IGNITION_DEVICE_ARG=(--cdrom "$ISO")

# NOTE: has to manually shutdown/reboot at the end...
set -x
virt-install --connect="qemu:///system" --name="${VM_NAME}" --vcpus="${VCPUS}" --memory="${RAM_MB}" \
        --os-variant=opensusetumbleweed --import \
        --disk="size=${DISK_GB},backing_store=${IMAGE}" \
        --network bridge=virbr0 "${IGNITION_DEVICE_ARG[@]}" --install no_install=yes
set +x
cat <<EOF
If installation finished without error you can
1. reboot your VM to ensure automatic startup of Podman containers
2. setup WordPress by pointing your browser to http://IP_OF_MICROOS

Or login to system with:
a) ssh -i ../microos_id_ed25519 root@MICRO_OS_IP_ADDRESS
b) ssh -i ../microos_id_ed25519 core@MICRO_OS_IP_ADDRESS (to mimic Fedora CoreOS user)
c) login on local console as 'root' password 'Admin123'
EOF
exit 0
