include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-jmuEportalAuth
PKG_VERSION=0.1.1
PKG_RELEASE:=0

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-jmuEportalAuth
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=jmuEportalAuth
	DEPENDS:=+jmuEportalAuth
	PKGARCH:=all
endef

define Package/luci-app-jmuEportalAuth/description
	This package contains LuCI configuration pages for jmuEportalAuth.
endef

define Package/luci-app-jmuEportalAuth/conffiles
/etc/config/jmuEportalAuth
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/files/luci/i18n/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-jmuEportalAuth/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/jmuEportalAuth.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_CONF) ./files/root/etc/config/jmuEportalAuth $(1)/etc/config/jmuEportalAuth
	$(INSTALL_BIN) ./files/root/etc/init.d/jmuEportalAuth $(1)/etc/init.d/jmuEportalAuth
	$(INSTALL_DATA) ./files/luci/controller/jmuEportalAuth.lua $(1)/usr/lib/lua/luci/controller/jmuEportalAuth.lua
	$(INSTALL_DATA) ./files/luci/model/cbi/jmuEportalAuth.lua $(1)/usr/lib/lua/luci/model/cbi/jmuEportalAuth.lua
endef

define Package/jmuEportalAuth/preinst
	#!/bin/sh
	crontab_file="/etc/crontabs/root"
	[ -f $crontab_file ] && sed -i "/jmuEportalAuth/d" $crontab_file
	/sbin/uci set system.@system[0].zonename="Asia/Shanghai"
	/sbin/uci set system.@system[0].timezone="CST-8"
	service system restart
	exit 0
endef

define Package/jmuEportalAuth/prerm
	#!/bin/sh
	crontab_file="/etc/crontabs/root"
	[ -f $crontab_file ] && sed -i "/jmuEportalAuth/d" $crontab_file
	rm -rf /etc/config/jmuEportalAuth
	exit 0
endef

$(eval $(call BuildPackage,luci-app-jmuEportalAuth))
