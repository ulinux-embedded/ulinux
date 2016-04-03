################################################################################
#
# ulinux-device-daemon
#
################################################################################

ULINUX_DEVICE_DAEMON_VERSION = master
ULINUX_DEVICE_DAEMON_SITE = https://github.com/ulinux-embedded/ulinux-device-daemon.git
ULINUX_DEVICE_DAEMON_SITE_METHOD = git

ULINUX_DEVICE_DAEMON_LICENSE = MIT (core code)
ULINUX_DEVICE_DAEMON_LICENSE_FILES = LICENSE

ULINUX_DEVICE_DAEMON_DEPENDENCIES = nodejs

ULINUX_DEVICE_DAEMON_INSTALLDIR = $(TARGET_DIR)/opt/ulinux-device-daemon

define ULINUX_DEVICE_DAEMON_INSTALL_TARGET_CMDS
		mkdir -p $(ULINUX_DEVICE_DAEMON_INSTALLDIR)
		$(INSTALL) -D -m 0755 $(@D)/* $(ULINUX_DEVICE_DAEMON_INSTALLDIR)
		# Install package node_modules
		(cd $(ULINUX_DEVICE_DAEMON_INSTALLDIR); $(NPM) install)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
