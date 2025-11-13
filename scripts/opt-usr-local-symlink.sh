#!/usr/bin/env bash

# Make `/opt and `/usr/local` symlinks.
# This is the historical default and what FCOS currently ships. fedora-bootc
# uses the new `root` value, but migrating FCOS is not that simple...
# https://coreos.github.io/rpm-ostree/treefile/#experimental-options
# We can nuke `opt-usrlocal: var` above once this is the only path we support.

set -xeuo pipefail

if [ -f /run/.containerenv ]; then
	  rm -vrf /opt;
    ln -vs var/opt /opt
    rm -vrf /usr/local
    ln -vs ../var/usrlocal /usr/local
fi
