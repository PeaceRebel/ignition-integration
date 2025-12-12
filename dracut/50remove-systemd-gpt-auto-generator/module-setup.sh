check() { return 0; }

install() {
    # XXX SUPER HACK to stamp out the systemd-gpt-auto-generator in the
    # initramfs. The rm of the file in a postprocess we do runs after
    # the initramfs is generated so we need something like this
    # delivered via a dracut module that gets into an overlay in the
    # original rpm-ostree compose.

    rm -v $initdir/usr/lib/systemd/system-generators/systemd-gpt-auto-generator
}