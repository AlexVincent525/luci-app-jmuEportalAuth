OpenWrt/LEDE LuCI for jmuEportalAuth
===

简介
---

本软件包是 jmuEportalAuth 的 LuCI 控制界面，修改自 [luci-app-jmuSupplicant](https://github.com/LGiki/luci-app-jmuSupplicant) 
目前支持到 openwrt 18.06.4

软件包文件结构:
```
/
├── etc/
│   ├── config/
│   │   └── jmuEportalAuth                              // UCI 配置文件
│   └── init.d/
│       └── jmuEportalAuth                              // init 脚本
└── usr/
    └── lib/
        └── lua/
            └── luci/                                   // LuCI 部分
                ├── controller/
                │   └── jmuEportalAuth.lua              // LuCI 菜单配置
                ├── i18n/                               // LuCI 语言文件目录
                │   └── jmuEportalAuth.zh-cn.lmo        // 简体中文
                └── model/
                    └── cbi/
                        └── jmuEportalAuth.lua          // LuCI 基本设置
```

依赖
---

软件包需在 `jmuEportalAuth` 安装后方可安装.
可通过编译 [jmuEportalAuth](https://github.com/openjmu/jmuEportalAuth) 获得.  
只有当文件存在时, 相应的功能才可被使用, 并显示相应的 LuCI 设置界面.   

 可执行文件  | 可选 | 功能        
 ------------|------|-------------
 `jmuEportalAuth` | 否   | 进行Web认证

注: 可执行文件需要在 `/bin/` 路径中, 可被正常调用，否则不会出现LUCI界面.

可执行文件必须命名为 `jmuEportalAuth`.

配置
---

软件包的配置文件路径: `/etc/config/jmuEportalAuth`  
此文件为 UCI 配置文件, 配置方式可参考 [OpenWrt Wiki][uci]  

编译
---

从 OpenWrt/LEDE 的 [SDK][openwrt-sdk] 编译  
```bash
# 解压下载好的 SDK
wget https://mirrors.tuna.tsinghua.edu.cn/lede/releases/17.01.6/targets/ar71xx/generic/lede-sdk-17.01.6-ar71xx-generic_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar.xz
tar xJf lede-sdk-17.01.6-ar71xx-generic_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar.xz
cd lede-sdk-17.01.6-ar71xx-generic_gcc-5.4.0_musl-1.1.16.Linux-x86_64
# Clone 项目
git clone https://github.com/openjmu/luci-app-jmuEportalAuth package/luci-app-jmuEportalAuth
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-jmuEportalAuth/tools/po2lmo
make && sudo make install
popd
# 选择要编译的包 LuCI -> 3. Applications -> [M]luci-app-jmuEportalAuth
make menuconfig
# 开始编译
make package/luci-app-jmuEportalAuth/compile V=99
```

[openwrt-sdk]: https://openwrt.org/docs/guide-developer/using_the_sdk
[uci]: https://openwrt.org/docs/guide-user/base-system/uci
