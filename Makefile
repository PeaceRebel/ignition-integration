COMMIT = $(shell (cd "$(SRCDIR)" && git rev-parse HEAD))

.PHONY: all
all: 
	@echo "Usage: make install"
	@exit 1

PREFIX        ?= /usr
LIBDIR        ?= $(PREFIX)/lib
SYSTEMD_DIR   ?= $(LIBDIR)/systemd
DRACUT_DIR    ?= $(LIBDIR)/dracut
UDEV_RULES    ?= $(LIBDIR)/udev/rules.d
EXEC_DIR      ?= /usr/libexec

install:
	# dracut config
	install -d "$(DESTDIR)$(DRACUT_DIR)/dracut.conf.d"
	install -m 0644 dracut/dracut.conf.d/60-coreos-nostrip.conf "$(DESTDIR)$(DRACUT_DIR)/dracut.conf.d/60-coreos-nostrip.conf"
	install -m 0644 dracut/dracut.conf.d/60-coreos-omits.conf "$(DESTDIR)$(DRACUT_DIR)/dracut.conf.d/60-coreos-omits.conf"

	# dracut modules: 01scsi-rules
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/01scsi-rules"
	install -m 0755 dracut/01scsi-rules/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/01scsi-rules/module-setup.sh"

	# dracut modules: 40ignition-ostree
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree"
	install -m 0755 dracut/40ignition-ostree/coreos-check-rootfs-size "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/coreos-check-rootfs-size"
	install -m 0755 dracut/40ignition-ostree/coreos-relabel "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/coreos-relabel"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-check-rootfs-size.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-check-rootfs-size.service"
	install -m 0755 dracut/40ignition-ostree/ignition-ostree-firstboot-uuid "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-firstboot-uuid"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-growfs.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-growfs.service"
	install -m 0755 dracut/40ignition-ostree/ignition-ostree-growfs.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-growfs.sh"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-mount-state-overlays.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-mount-state-overlays.service"
	install -m 0755 dracut/40ignition-ostree/ignition-ostree-mount-state-overlays.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-mount-state-overlays.sh"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-mount-var.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-mount-var.service"
	install -m 0755 dracut/40ignition-ostree/ignition-ostree-mount-var.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-mount-var.sh"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-populate-var.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-populate-var.service"
	install -m 0755 dracut/40ignition-ostree/ignition-ostree-populate-var.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-populate-var.sh"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-transposefs-autosave-xfs.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-transposefs-autosave-xfs.service"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-transposefs-detect.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-transposefs-detect.service"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-transposefs-restore.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-transposefs-restore.service"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-transposefs-save.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-transposefs-save.service"
	install -m 0755 dracut/40ignition-ostree/ignition-ostree-transposefs.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-transposefs.sh"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-uuid-boot.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-uuid-boot.service"
	install -m 0644 dracut/40ignition-ostree/ignition-ostree-uuid-root.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-uuid-root.service"
	install -m 0755 dracut/40ignition-ostree/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/module-setup.sh"

	# dracut modules: 35ignition-helpers
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/35ignition-helpers"
	install -m 0755 dracut/35ignition-helpers/coreos-kargs.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/35ignition-helpers/coreos-kargs.sh"
	install -m 0644 dracut/35ignition-helpers/coreos-kargs-reboot.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/35ignition-helpers/coreos-kargs-reboot.service"
	install -m 0755 dracut/35ignition-helpers/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/35ignition-helpers/module-setup.sh"

	# dracut modules: 50rdcore
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/50rdcore"
	install -m 0755 dracut/50rdcore/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/50rdcore/module-setup.sh"
	install -m 0755 dracut/50rdcore/rdcore "$(DESTDIR)$(DRACUT_DIR)/modules.d/50rdcore/rdcore"

	# dracut modules: 35coreos-network
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/35coreos-network"
	install -m 0755 dracut/35coreos-network/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/35coreos-network/module-setup.sh"
	install -m 0644 dracut/35coreos-network/50-afterburn-network-kargs-default.conf "$(DESTDIR)$(DRACUT_DIR)/modules.d/35coreos-network/50-afterburn-network-kargs-default.conf"
	install -m 0644 dracut/35coreos-network/coreos-enable-network.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/35coreos-network/coreos-enable-network.service"
	install -m 0755 dracut/35coreos-network/coreos-enable-network.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/35coreos-network/coreos-enable-network.sh"

	# dracut modules: 40ignition-conf
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-conf"
	install -m 0644 dracut/40ignition-conf/00-core.ign "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-conf/00-core.ign"
	install -m 0755 dracut/40ignition-conf/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-conf/module-setup.sh"
	install -m 0644 dracut/40ignition-conf/README.md "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-conf/README.md"

	# dracut modules: 50remove-systemd-gpt-auto-generator
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/50remove-systemd-gpt-auto-generator"
	install -m 0755 dracut/50remove-systemd-gpt-auto-generator/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/50remove-systemd-gpt-auto-generator/module-setup.sh"

	# dracut modules: 99emergency-shell-setup
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/99emergency-shell-setup"
	install -m 0755 dracut/99emergency-shell-setup/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/99emergency-shell-setup/module-setup.sh"
	install -m 0755 dracut/99emergency-shell-setup/emergency-shell.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/99emergency-shell-setup/emergency-shell.sh"
	install -m 0644 dracut/99emergency-shell-setup/ignition-virtio-dump-journal.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/99emergency-shell-setup/ignition-virtio-dump-journal.service"
	install -m 0755 dracut/99emergency-shell-setup/ignition-virtio-dump-journal.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/99emergency-shell-setup/ignition-virtio-dump-journal.sh"

	# dracut modules: 99journal-conf
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/99journal-conf"
	install -m 0755 dracut/99journal-conf/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/99journal-conf/module-setup.sh"
	install -m 0644 dracut/99journal-conf/00-journal-log-forwarding.conf "$(DESTDIR)$(DRACUT_DIR)/modules.d/99journal-conf/00-journal-log-forwarding.conf"

	# systemd: generators
	install -d "$(DESTDIR)$(SYSTEMD_DIR)/system-generators"
	install -m 0755 systemd/system-generators/coreos-sulogin-force-generator "$(DESTDIR)$(SYSTEMD_DIR)/system-generators/coreos-sulogin-force-generator"

	# systemd: presets
	install -d "$(DESTDIR)$(SYSTEMD_DIR)/system-preset"
	install -m 0644 systemd/system-preset/40-coreos-systemd.preset "$(DESTDIR)$(SYSTEMD_DIR)/system-preset/40-coreos-systemd.preset"
	install -m 0644 systemd/system-preset/40-coreos.preset "$(DESTDIR)$(SYSTEMD_DIR)/system-preset/40-coreos.preset"
	install -m 0644 systemd/system-preset/45-coreos-populate-lvmdevices.preset "$(DESTDIR)$(SYSTEMD_DIR)/system-preset/45-coreos-populate-lvmdevices.preset"

	# systemd: units and drop-ins
	install -d "$(DESTDIR)$(SYSTEMD_DIR)/system"
	install -m 0644 systemd/system/coreos-ignition-delete-config.service "$(DESTDIR)$(SYSTEMD_DIR)/system/coreos-ignition-delete-config.service"
	install -m 0644 systemd/system/coreos-ignition-firstboot-complete.service "$(DESTDIR)$(SYSTEMD_DIR)/system/coreos-ignition-firstboot-complete.service"
	install -m 0644 systemd/system/coreos-ignition-write-issues.service "$(DESTDIR)$(SYSTEMD_DIR)/system/coreos-ignition-write-issues.service"
	install -m 0644 systemd/system/coreos-populate-lvmdevices.service "$(DESTDIR)$(SYSTEMD_DIR)/system/coreos-populate-lvmdevices.service"
	install -m 0644 systemd/system/coreos-printk-quiet.service "$(DESTDIR)$(SYSTEMD_DIR)/system/coreos-printk-quiet.service"
	install -m 0644 systemd/system/coreos-update-ca-trust.service "$(DESTDIR)$(SYSTEMD_DIR)/system/coreos-update-ca-trust.service"
	install -d "$(DESTDIR)$(SYSTEMD_DIR)/system/ignition-delete-config.service.d"
	install -m 0644 systemd/system/ignition-delete-config.service.d/10-flag-file.conf "$(DESTDIR)$(SYSTEMD_DIR)/system/ignition-delete-config.service.d/10-flag-file.conf"
	install -d "$(DESTDIR)$(SYSTEMD_DIR)/system/systemd-backlight@.service.d"
	install -m 0644 systemd/system/systemd-backlight@.service.d/45-after-ostree-remount.conf "$(DESTDIR)$(SYSTEMD_DIR)/system/systemd-backlight@.service.d/45-after-ostree-remount.conf"
	install -d "$(DESTDIR)$(SYSTEMD_DIR)/system/systemd-firstboot.service.d"
	install -m 0644 systemd/system/systemd-firstboot.service.d/fcos-disable.conf "$(DESTDIR)$(SYSTEMD_DIR)/system/systemd-firstboot.service.d/fcos-disable.conf"

	# libexec helpers
	install -d "$(DESTDIR)$(EXEC_DIR)"
	install -m 0755 scripts/libexec/coreos-ignition-delete-config "$(DESTDIR)$(EXEC_DIR)/coreos-ignition-delete-config"
	install -m 0755 scripts/libexec/coreos-ignition-firstboot-complete "$(DESTDIR)$(EXEC_DIR)/coreos-ignition-firstboot-complete"
	install -m 0755 scripts/libexec/coreos-ignition-write-issues "$(DESTDIR)$(EXEC_DIR)/coreos-ignition-write-issues"
	install -m 0755 scripts/libexec/coreos-populate-lvmdevices "$(DESTDIR)$(EXEC_DIR)/coreos-populate-lvmdevices"

	# coreos helpers
	install -d "$(DESTDIR)$(LIBDIR)/coreos"
	install -m 0644 coreos/generator-lib.sh "$(DESTDIR)$(LIBDIR)/coreos/generator-lib.sh"

	# udev rules
	install -d "$(DESTDIR)$(UDEV_RULES)"
	install -m 0644 conf/udev/rules.d/90-coreos-device-mapper.rules "$(DESTDIR)$(UDEV_RULES)/90-coreos-device-mapper.rules"

	# lvm devices
	install -d "$(DESTDIR)/etc/lvm/devices"
	install -m 0644 conf/lvm/devices/system.devices "$(DESTDIR)/etc/lvm/devices/system.devices"

	# tmpfiles
	install -d "$(DESTDIR)/etc/tmpfiles.d"
	install -m 0644 conf/tmpfiles.d/root-bash.conf "$(DESTDIR)/etc/tmpfiles.d/root-bash.conf"

	# sshd config
	install -d "$(DESTDIR)/etc/ssh/sshd_config.d"
	install -m 0644 conf/sshd/40-authorized-keys-file.conf "$(DESTDIR)/etc/ssh/sshd_config.d/40-authorized-keys-file.conf"


RPM_SPECFILE=rpmbuild/SPECS/ignition-integration-$(COMMIT).spec
RPM_TARBALL=rpmbuild/SOURCES/ignition-integration-$(COMMIT).tar.gz

$(RPM_SPECFILE):
	mkdir -p $(CURDIR)/rpmbuild/SPECS
	(echo "%global commit $(COMMIT)"; git show HEAD:ignition-integration.spec) > $(RPM_SPECFILE)

$(RPM_TARBALL):
	mkdir -p $(CURDIR)/rpmbuild/SOURCES
	git archive --prefix=ignition-integration-$(COMMIT)/ --format=tar.gz HEAD > $(RPM_TARBALL)

.PHONY: srpm
srpm: $(RPM_SPECFILE) $(RPM_TARBALL)
	rpmbuild -bs \
		--define "_topdir $(CURDIR)/rpmbuild" \
		$(RPM_SPECFILE)

.PHONY: rpm
rpm: $(RPM_SPECFILE) $(RPM_TARBALL)
	rpmbuild -bb \
		--define "_topdir $(CURDIR)/rpmbuild" \
		$(RPM_SPECFILE)
