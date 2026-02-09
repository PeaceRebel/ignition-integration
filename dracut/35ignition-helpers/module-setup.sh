#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

check() {
    if [[ $IN_KDUMP == 1 ]]; then
        return 1
    fi
}

depends() {
    echo systemd network ignition
}

install_ignition_unit() {
    local unit="$1"; shift
    local target="${1:-ignition-complete.target}"; shift
    local instantiated="${1:-$unit}"; shift
    inst_simple "$moddir/$unit" "$systemdsystemunitdir/$unit"
    # note we `|| exit 1` here so we error out if e.g. the units are missing
    # see https://github.com/coreos/fedora-coreos-config/issues/799
    systemctl -q --root="$initdir" add-requires "$target" "$instantiated" || exit 1
}

install() {
    inst_multiple \
        basename \
        diff \
        lsblk \
        sed \
        grep \
        uname


    # In some cases we had to vendor gdisk in Ignition.
    # If this is the case here use that one.
    # See https://issues.redhat.com/browse/RHEL-56080
    if [ -f /usr/libexec/ignition-sgdisk ]; then
        inst /usr/libexec/ignition-sgdisk /usr/sbin/sgdisk
    else
        inst sgdisk
    fi
    
    # dracut inst_script doesn't allow overwrites and we are replacing
    # the default script placed by Ignition
    binpath="/usr/sbin/ignition-kargs-helper"
    cp "$moddir/coreos-kargs.sh" "$initdir$binpath"
    install_ignition_unit coreos-kargs-reboot.service
}
