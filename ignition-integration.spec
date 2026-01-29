%define dracutlibdir %{_prefix}/lib/dracut
%global forgeurl https://github.com/PeaceRebel/ignition-integration
%global debug_package %{nil}

Version:        0.1.0

%forgemeta -v -i

Name:           ignition-integration
Release:        1%{?dist}
Summary:        Ignition integration files and dracut modules for bootc images

License:        MIT
URL:            %{forgeurl}

Source0:        %{forgesource}

BuildRequires:  systemd-rpm-macros
BuildRequires:  make
Requires:       dracut
Requires:       ignition
Requires:       ignition-grub
Requires:       bsdtar
Requires:       afterburn
Requires:       afterburn-dracut
Requires:       NetworkManager-team
Requires:       teamd
Requires:       nmstate
Requires:       iscsi-initiator-utils
Requires:       sg3_utils
Requires:       clevis
Requires:       clevis-luks
Requires:       clevis-dracut
Requires:       clevis-systemd
Requires:       cryptsetup
Requires:       device-mapper-multipath

%description
Installs CoreOS ignition-related dracut modules, systemd units, and helper
scripts used to build bootc-based images.

%prep
%{forgeautosetup}

%build
# Nothing to build

%install
%make_install

%post
# No post actions

%preun
# No preun actions

%postun
# No postun actions

%files
%config(noreplace) %{dracutlibdir}/dracut.conf.d/*
%{dracutlibdir}/modules.d/01scsi-rules
%{dracutlibdir}/modules.d/40ignition-ostree
%{dracutlibdir}/modules.d/50rdcore
%{dracutlibdir}/modules.d/35coreos-ignition
%{dracutlibdir}/modules.d/35coreos-multipath
%{dracutlibdir}/modules.d/35coreos-network
%{dracutlibdir}/modules.d/40ignition-conf
%{dracutlibdir}/modules.d/50remove-systemd-gpt-auto-generator
%{dracutlibdir}/modules.d/99emergency-shell-setup
%{dracutlibdir}/modules.d/99journal-conf

%{_systemdgeneratordir}/coreos-boot-mount-generator
%{_systemdgeneratordir}/coreos-sulogin-force-generator

%{_presetdir}/40-coreos-systemd.preset
%{_presetdir}/40-coreos.preset
%{_presetdir}/45-coreos-populate-lvmdevices.preset

%{_unitdir}/coreos-ignition-delete-config.service
%{_unitdir}/coreos-ignition-firstboot-complete.service
%{_unitdir}/coreos-ignition-write-issues.service
%{_unitdir}/coreos-populate-lvmdevices.service
%{_unitdir}/coreos-printk-quiet.service
%{_unitdir}/coreos-update-ca-trust.service
%dir %{_unitdir}/ignition-delete-config.service.d
%{_unitdir}/ignition-delete-config.service.d/10-flag-file.conf
%dir %{_unitdir}/systemd-backlight@.service.d
%{_unitdir}/systemd-backlight@.service.d/45-after-ostree-remount.conf
%dir %{_unitdir}/systemd-firstboot.service.d
%{_unitdir}/systemd-firstboot.service.d/fcos-disable.conf

%{_libexecdir}/coreos-ignition-delete-config
%{_libexecdir}/coreos-ignition-firstboot-complete
%{_libexecdir}/coreos-ignition-write-issues
%{_libexecdir}/coreos-populate-lvmdevices

/usr/lib/coreos/generator-lib.sh

%{_udevrulesdir}/90-coreos-device-mapper.rules

%config(noreplace) /etc/lvm/devices/system.devices
%config(noreplace) /etc/tmpfiles.d/root-bash.conf
%config(noreplace) /etc/ssh/sshd_config.d/40-authorized-keys-file.conf

%changelog
* Tue Dec 09 2025 Bipin B Narayan <bbnaraya@redhat.com> - 0.1.0-1
- Initial package
