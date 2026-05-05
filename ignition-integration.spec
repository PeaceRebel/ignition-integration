%define dracutlibdir %{_prefix}/lib/dracut
%global forgeurl https://github.com/PeaceRebel/ignition-integration
%global debug_package %{nil}

Version:        0.6.0

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
%{dracutlibdir}/modules.d/41ignition-network
%{dracutlibdir}/modules.d/99ignition-log-kmsg

%{_presetdir}/40-ignition.preset

%{_unitdir}/ignition-write-issues.service

%{_libexecdir}/ignition-write-issues

%changelog
* Tue May 05 2026 Bipin B Narayan <bbnaraya@redhat.com> - 0.6.0-1
- Update file as per the selected ones from PeaceRebel/ignition repo
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
