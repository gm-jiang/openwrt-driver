#
# Copyright (C) 2008-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=usb-wifi
PKG_RELEASE:=3
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define KernelPackage/usb-wifi
  SUBMENU:=USB Support
  TITLE:=USB Wi-Fi Driver
  FILES:=$(PKG_BUILD_DIR)/usb-wifi.ko
  AUTOLOAD:=$(call AutoLoad,30,usb-wifi,1)
  DEPENDS:=+kmod-usb-core
  KCONFIG:=
endef

define KernelPackage/usb-wifi/description
  Kernel module to generate usb-wifi driver
endef

EXTRA_KCONFIG:= \
	CONFIG_USB_WIFI=m

EXTRA_CFLAGS:= \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=m,%,$(filter %=m,$(EXTRA_KCONFIG)))) \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=y,%,$(filter %=y,$(EXTRA_KCONFIG)))) \

MAKE_OPTS:= \
	$(KERNEL_MAKE_FLAGS) \
	M="$(PKG_BUILD_DIR)" \
	EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
	$(EXTRA_KCONFIG)

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

$(eval $(call KernelPackage,usb-wifi))
