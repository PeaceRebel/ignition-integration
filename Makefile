SRCDIR ?= .
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
	install -m 0644 dracut/dracut.conf.d/60-omit-nfs.conf "$(DESTDIR)$(DRACUT_DIR)/dracut.conf.d/60-omit-nfs.conf"

	# dracut modules: 01ignition-scsi-rules
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/01ignition-scsi-rules"
	install -m 0755 dracut/modules.d/01ignition-scsi-rules/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/01ignition-scsi-rules/module-setup.sh"

	# dracut modules: 40ignition-ostree
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree"
	install -m 0755 dracut/modules.d/40ignition-ostree/ignition-relabel "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-relabel"
	install -m 0644 dracut/modules.d/40ignition-ostree/ignition-ostree-mount-var.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-mount-var.service"
	install -m 0755 dracut/modules.d/40ignition-ostree/ignition-ostree-mount-var.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-mount-var.sh"
	install -m 0644 dracut/modules.d/40ignition-ostree/ignition-ostree-populate-var.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-populate-var.service"
	install -m 0755 dracut/modules.d/40ignition-ostree/ignition-ostree-populate-var.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-populate-var.sh"
	install -m 0644 dracut/modules.d/40ignition-ostree/ignition-ostree-transposefs-detect.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-transposefs-detect.service"
	install -m 0644 dracut/modules.d/40ignition-ostree/ignition-ostree-transposefs-restore.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-transposefs-restore.service"
	install -m 0644 dracut/modules.d/40ignition-ostree/ignition-ostree-transposefs-save.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-transposefs-save.service"
	install -m 0755 dracut/modules.d/40ignition-ostree/ignition-ostree-transposefs.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/ignition-ostree-transposefs.sh"
	install -m 0755 dracut/modules.d/40ignition-ostree/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/40ignition-ostree/module-setup.sh"

	# dracut modules: 41ignition-network
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/41ignition-network"
	install -m 0755 dracut/modules.d/41ignition-network/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/41ignition-network/module-setup.sh"
	install -m 0644 dracut/modules.d/41ignition-network/ignition-enable-network.service "$(DESTDIR)$(DRACUT_DIR)/modules.d/41ignition-network/ignition-enable-network.service"
	install -m 0755 dracut/modules.d/41ignition-network/ignition-enable-network.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/41ignition-network/ignition-enable-network.sh"

	# dracut modules: 99ignition-log-kmsg
	install -d "$(DESTDIR)$(DRACUT_DIR)/modules.d/99ignition-log-kmsg"
	install -m 0755 dracut/modules.d/99ignition-log-kmsg/module-setup.sh "$(DESTDIR)$(DRACUT_DIR)/modules.d/99ignition-log-kmsg/module-setup.sh"
	install -m 0644 dracut/modules.d/99ignition-log-kmsg/00-journal-log-level-kmsg.conf "$(DESTDIR)$(DRACUT_DIR)/modules.d/99ignition-log-kmsg/00-journal-log-level-kmsg.conf"
	install -m 0644 dracut/modules.d/99ignition-log-kmsg/10-stdout-kmsg.conf "$(DESTDIR)$(DRACUT_DIR)/modules.d/99ignition-log-kmsg/10-stdout-kmsg.conf"

	# systemd: presets
	install -d "$(DESTDIR)$(SYSTEMD_DIR)/system-preset"
	install -m 0644 systemd/system-preset/40-ignition.preset "$(DESTDIR)$(SYSTEMD_DIR)/system-preset/40-ignition.preset"

	# systemd: units and drop-ins
	install -d "$(DESTDIR)$(SYSTEMD_DIR)/system"
	install -m 0644 systemd/ignition-write-issues.service "$(DESTDIR)$(SYSTEMD_DIR)/system/ignition-write-issues.service"

	# libexec helpers
	install -d "$(DESTDIR)$(EXEC_DIR)"
	install -m 0755 scripts/libexec/ignition-write-issues "$(DESTDIR)$(EXEC_DIR)/ignition-write-issues"

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
