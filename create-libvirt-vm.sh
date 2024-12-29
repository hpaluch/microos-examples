#!/bin/bash
# script to install openSUSE MicroOS using virt-install - adapted from Fedora CoreOS example
# see https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-libvirt/
set -euo pipefail

DIR=`dirname $0`
COMBUSTION_CONFIG="$(readlink -f $DIR/combustion-script)"
# Download with: curl -fLO https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-kvm-and-xen.qcow2
IMAGE="/opt/iso/openSUSE-MicroOS.x86_64-kvm-and-xen.qcow2"
# 'u' is like greek 'micro' symbol
VM_NAME="uos-hello"
VCPUS="2"
RAM_MB="2048"
# 20GB is minimum!
DISK_GB="20"

[ -r "$COMBUSTION_CONFIG" ] || {
	echo "ERROR: '$COMBUSTION_CONFIG' not readable - should not happen"'!' >&2
	exit 1
}

[ -r "$IMAGE" ] || {
	cat >&2 <<EOF
ERROR: Image '$IMAGE' not readable.
Download it with: ( cd /opt/iso && curl -fLO https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-kvm-and-xen.qcow2 )
and run this script again.
EOF
	exit 1
}

COMBUSTION_DEVICE_ARG=(--qemu-commandline="-fw_cfg name=opt/org.opensuse.combustion/script,file=${COMBUSTION_CONFIG}")

# NOTE: has to manually shutdown/reboot at the end...
set -x
virt-install --connect="qemu:///system" --name="${VM_NAME}" --vcpus="${VCPUS}" --memory="${RAM_MB}" \
        --os-variant=opensusetumbleweed --import \
        --disk="size=${DISK_GB},backing_store=${IMAGE}" \
        --network bridge=virbr0 "${COMBUSTION_DEVICE_ARG[@]}"
set +x
cat <<EOF
If installation finished without error you can login with:
a) ssh -i microos_id_ed25519 root@MICRO_OS_IP_ADDRESS
b) ssh -i microos_id_ed25519 core@MICRO_OS_IP_ADDRESS and 'sudo'
c) login on local console as 'root' password 'Admin123'
See header of 'combustion-script' for details.
EOF
exit 0
