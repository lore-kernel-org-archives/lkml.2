Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1BJGqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:46:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17350 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1BJGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:44:04 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 14/15] ARM: tegra: add tegra_defconfig
Date: Wed,  9 Feb 2011 22:43:23 -0800
Message-Id: <1297320204-31882-15-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

Adding one single defconfig for the tegra family of boards, to over time
cover the superset of supported platform and drivers.

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/configs/tegra_defconfig |  123 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 123 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/configs/tegra_defconfig

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
new file mode 100644
index 0000000..7a9267e
--- /dev/null
+++ b/arch/arm/configs/tegra_defconfig
@@ -0,0 +1,123 @@
+CONFIG_EXPERIMENTAL=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_CGROUPS=y
+CONFIG_CGROUP_DEBUG=y
+CONFIG_CGROUP_FREEZER=y
+CONFIG_CGROUP_CPUACCT=y
+CONFIG_RESOURCE_COUNTERS=y
+CONFIG_CGROUP_SCHED=y
+CONFIG_RT_GROUP_SCHED=y
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_EMBEDDED=y
+# CONFIG_SYSCTL_SYSCALL is not set
+# CONFIG_ELF_CORE is not set
+CONFIG_SLAB=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODULE_FORCE_UNLOAD=y
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+# CONFIG_IOSCHED_CFQ is not set
+CONFIG_ARCH_TEGRA=y
+CONFIG_MACH_HARMONY=y
+CONFIG_TEGRA_DEBUG_UARTD=y
+CONFIG_ARM_ERRATA_742230=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_SMP=y
+CONFIG_NR_CPUS=2
+CONFIG_PREEMPT=y
+CONFIG_AEABI=y
+# CONFIG_OABI_COMPAT is not set
+CONFIG_HIGHMEM=y
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_VFP=y
+CONFIG_PM=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_NET_KEY=y
+CONFIG_INET=y
+CONFIG_INET_ESP=y
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_INET_DIAG is not set
+CONFIG_IPV6=y
+CONFIG_IPV6_PRIVACY=y
+CONFIG_IPV6_ROUTER_PREF=y
+CONFIG_IPV6_OPTIMISTIC_DAD=y
+CONFIG_INET6_AH=y
+CONFIG_INET6_ESP=y
+CONFIG_INET6_IPCOMP=y
+CONFIG_IPV6_MIP6=y
+CONFIG_IPV6_TUNNEL=y
+CONFIG_IPV6_MULTIPLE_TABLES=y
+# CONFIG_WIRELESS is not set
+# CONFIG_FIRMWARE_IN_KERNEL is not set
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_MISC_DEVICES=y
+CONFIG_AD525X_DPOT=y
+CONFIG_AD525X_DPOT_I2C=y
+CONFIG_ICS932S401=y
+CONFIG_APDS9802ALS=y
+CONFIG_ISL29003=y
+CONFIG_NETDEVICES=y
+CONFIG_DUMMY=y
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+# CONFIG_WLAN is not set
+# CONFIG_INPUT is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_HW_RANDOM is not set
+CONFIG_I2C=y
+# CONFIG_HWMON is not set
+# CONFIG_MFD_SUPPORT is not set
+# CONFIG_USB_SUPPORT is not set
+CONFIG_MMC=y
+CONFIG_MMC_SDHCI=y
+CONFIG_MMC_SDHCI_PLTFM=y
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+CONFIG_EXT2_FS_POSIX_ACL=y
+CONFIG_EXT2_FS_SECURITY=y
+CONFIG_EXT3_FS=y
+# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
+CONFIG_EXT3_FS_POSIX_ACL=y
+CONFIG_EXT3_FS_SECURITY=y
+# CONFIG_DNOTIFY is not set
+CONFIG_VFAT_FS=y
+CONFIG_TMPFS=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_PRINTK_TIME=y
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_FS=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DETECT_HUNG_TASK=y
+CONFIG_SCHEDSTATS=y
+CONFIG_TIMER_STATS=y
+CONFIG_DEBUG_SLAB=y
+# CONFIG_DEBUG_PREEMPT is not set
+CONFIG_DEBUG_MUTEXES=y
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_VM=y
+CONFIG_DEBUG_SG=y
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+CONFIG_DEBUG_LL=y
+CONFIG_EARLY_PRINTK=y
+CONFIG_CRYPTO_ECB=y
+CONFIG_CRYPTO_AES=y
+CONFIG_CRYPTO_ARC4=y
+CONFIG_CRYPTO_TWOFISH=y
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
+CONFIG_CRC_CCITT=y
+CONFIG_CRC16=y
-- 
1.7.3.1

