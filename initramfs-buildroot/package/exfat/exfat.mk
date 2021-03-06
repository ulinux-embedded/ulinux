################################################################################
#
# exfat
#
################################################################################

EXFAT_VERSION = 1.2.1
EXFAT_SITE = https://github.com/relan/exfat/releases/download/v$(EXFAT_VERSION)
EXFAT_SOURCE = fuse-exfat-$(EXFAT_VERSION).tar.gz
EXFAT_DEPENDENCIES = libfuse host-pkgconf
EXFAT_LICENSE = GPLv3+
EXFAT_LICENSE_FILES = COPYING
EXFAT_CFLAGS = $(TARGET_CFLAGS) -std=c99

$(eval $(autotools-package))
