# Copyright (C) 2018-2019 Lienol
# Copyright (C) 2024 Kingwong55
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI app for adguardhome
LUCI_DEPENDS:=+wget
LUCI_PKGARCH:=all

PKG_VERSION:=1.8
PKG_RELEASE:=23

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

define Package/luci-app-adguardhome/postinst
#!/bin/sh
	/etc/init.d/AdGuardHome enable >/dev/null 2>&1
	enable=$(uci get AdGuardHome.AdGuardHome.enabled 2>/dev/null)
	if [ "$enable" == "1" ]; then
		/etc/init.d/AdGuardHome reload
	fi
	rm -f /tmp/luci-indexcache
	rm -f /tmp/luci-modulecache/*
exit 0
endef

define Package/luci-app-adguardhome/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
     /etc/init.d/AdGuardHome disable
     /etc/init.d/AdGuardHome stop
uci -q batch <<-EOF >/dev/null 2>&1
	delete ucitrack.@AdGuardHome[-1]
	commit ucitrack
EOF
fi
exit 0
endef
