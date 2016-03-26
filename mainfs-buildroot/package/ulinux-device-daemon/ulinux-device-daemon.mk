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

define ULINUX_DEVICE_DAEMON_INSTALL_TARGET_CMDS
     $(INSTALL) -D -m 0755 $(@D)/* $(TARGET_DIR)/opt/ulinux-device-daemon
     # Install package node_modules
	 (cd $(TARGET_DIR)/opt/ulinux-device-daemon; $(NPM) install)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
