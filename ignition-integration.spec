%define dracutlibdir %{_prefix}/lib/dracut
%global forgeurl https://github.com/PeaceRebel/ignition-integration
%global debug_package %{nil}

Version:        0.5.0

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
Requires:       iscsi-initiator-utils
Requires:       sg3_utils
Requires:       clevis
Requires:       clevis-luks
Requires:       clevis-dracut
Requires:       clevis-systemd
Requires:       cryptsetup

%description
Installs ignition-related dracut modules, systemd units, and helper
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
%{dracutlibdir}/modules.d/01ignition-scsi-rules
%{dracutlibdir}/modules.d/40ignition-ostree
%{dracutlibdir}/modules.d/35ignition-network
%{dracutlibdir}/modules.d/50remove-systemd-gpt-auto-generator
%{dracutlibdir}/modules.d/99ignition-journal-conf

%{_systemdgeneratordir}/ignition-sulogin-force-generator

%{_presetdir}/40-ignition-systemd.preset
%{_presetdir}/40-ignition.preset
%{_presetdir}/45-ignition-populate-lvmdevices.preset

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

%{_udevrulesdir}/90-ignition-device-mapper.rules

%config(noreplace) /etc/lvm/devices/system.devices
%config(noreplace) /etc/tmpfiles.d/root-bash.conf

%changelog
* Thu Mar 26 2026 Bipin B Narayan <bbnaraya@redhat.com> - 0.5.0-1
- Remove rdcore and other distro/coreos-specific dependencies and references
- Remove rdcore usage from scripts
- Drop rdcore dependency from the 40ignition-ostree dracut module
- Remove ignition-helpers dracut module as distro-specific content
* Tue Mar 17 2026 Bipin B Narayan <bbnaraya@redhat.com> - 0.4.0-1
- Rename modules with prefix ignition
- Remove sshd config as it's part of ignition main package now
- Remove dracut module for base config
- Include rdcore only if it's not installed by coreos-installer
- Fix script name in 35ignition-network
- Omit 01ignition-scsi-rules and 99ignition-journal-conf from kdump
* Fri Mar 06 2026 Bipin B Narayan <bbnaraya@redhat.com> - 0.3.0-1
- Remove 99emergency-shell-setup dracut module
* Wed Feb 04 2026 Bipin B Narayan <bbnaraya@redhat.com> - 0.2.0-1
- Remove coreos specific modules, scripts and files
- Add script to link /opt and /usr/local inline instead of file
- Remove unnecessary dependencies
- Add helpers for kargs
* Tue Dec 09 2025 Bipin B Narayan <bbnaraya@redhat.com> - 0.1.0-1
- Initial package
