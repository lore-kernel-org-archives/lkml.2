Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab0JAL7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:59:45 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49663 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932238Ab0JAL7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:59:43 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Ryan Mallon <ryan@bluewatersys.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 61/69] SPEAr3xx: Replace defconfigs with single unified defconfig
Date: Fri,  1 Oct 2010 17:26:21 +0530
Message-Id: <753e3ba7b912827f53554165d8a7d6e6c3c30610.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Mallon <ryan@bluewatersys.com>

We only need one defconfig for SPEAr3xx now since we can build all
three boards into one kernel.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/configs/spear310_defconfig                |   52 --------------------
 arch/arm/configs/spear320_defconfig                |   52 --------------------
 .../{spear300_defconfig => spear3xx_defconfig}     |    4 +-
 3 files changed, 3 insertions(+), 105 deletions(-)
 delete mode 100644 arch/arm/configs/spear310_defconfig
 delete mode 100644 arch/arm/configs/spear320_defconfig
 rename arch/arm/configs/{spear300_defconfig => spear3xx_defconfig} (93%)

diff --git a/arch/arm/configs/spear310_defconfig b/arch/arm/configs/spear310_defconfig
deleted file mode 100644
index 824e444..0000000
--- a/arch/arm/configs/spear310_defconfig
+++ /dev/null
@@ -1,52 +0,0 @@
-CONFIG_EXPERIMENTAL=y
-CONFIG_SYSVIPC=y
-CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_BLK_DEV_INITRD=y
-CONFIG_KALLSYMS_EXTRA_PASS=y
-CONFIG_MODULES=y
-CONFIG_MODULE_UNLOAD=y
-CONFIG_MODVERSIONS=y
-CONFIG_PLAT_SPEAR=y
-CONFIG_MACH_SPEAR310=y
-CONFIG_BINFMT_MISC=y
-CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=16384
-CONFIG_INPUT_FF_MEMLESS=y
-# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
-# CONFIG_INPUT_KEYBOARD is not set
-# CONFIG_INPUT_MOUSE is not set
-CONFIG_SERIAL_AMBA_PL011=y
-CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
-# CONFIG_LEGACY_PTYS is not set
-# CONFIG_HW_RANDOM is not set
-CONFIG_RAW_DRIVER=y
-CONFIG_MAX_RAW_DEVS=8192
-CONFIG_GPIO_SYSFS=y
-CONFIG_GPIO_PL061=y
-# CONFIG_HWMON is not set
-# CONFIG_VGA_CONSOLE is not set
-# CONFIG_HID_SUPPORT is not set
-# CONFIG_USB_SUPPORT is not set
-CONFIG_EXT2_FS=y
-CONFIG_EXT2_FS_XATTR=y
-CONFIG_EXT2_FS_SECURITY=y
-CONFIG_EXT3_FS=y
-CONFIG_EXT3_FS_SECURITY=y
-CONFIG_AUTOFS4_FS=m
-CONFIG_MSDOS_FS=m
-CONFIG_VFAT_FS=m
-CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
-CONFIG_TMPFS=y
-CONFIG_PARTITION_ADVANCED=y
-CONFIG_NLS=y
-CONFIG_NLS_DEFAULT="utf8"
-CONFIG_NLS_CODEPAGE_437=y
-CONFIG_NLS_ASCII=m
-CONFIG_MAGIC_SYSRQ=y
-CONFIG_DEBUG_FS=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_SPINLOCK=y
-CONFIG_DEBUG_SPINLOCK_SLEEP=y
-CONFIG_DEBUG_INFO=y
-# CONFIG_CRC32 is not set
diff --git a/arch/arm/configs/spear320_defconfig b/arch/arm/configs/spear320_defconfig
deleted file mode 100644
index 842f7f3..0000000
--- a/arch/arm/configs/spear320_defconfig
+++ /dev/null
@@ -1,52 +0,0 @@
-CONFIG_EXPERIMENTAL=y
-CONFIG_SYSVIPC=y
-CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_BLK_DEV_INITRD=y
-CONFIG_KALLSYMS_EXTRA_PASS=y
-CONFIG_MODULES=y
-CONFIG_MODULE_UNLOAD=y
-CONFIG_MODVERSIONS=y
-CONFIG_PLAT_SPEAR=y
-CONFIG_MACH_SPEAR320=y
-CONFIG_BINFMT_MISC=y
-CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=16384
-CONFIG_INPUT_FF_MEMLESS=y
-# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
-# CONFIG_INPUT_KEYBOARD is not set
-# CONFIG_INPUT_MOUSE is not set
-CONFIG_SERIAL_AMBA_PL011=y
-CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
-# CONFIG_LEGACY_PTYS is not set
-# CONFIG_HW_RANDOM is not set
-CONFIG_RAW_DRIVER=y
-CONFIG_MAX_RAW_DEVS=8192
-CONFIG_GPIO_SYSFS=y
-CONFIG_GPIO_PL061=y
-# CONFIG_HWMON is not set
-# CONFIG_VGA_CONSOLE is not set
-# CONFIG_HID_SUPPORT is not set
-# CONFIG_USB_SUPPORT is not set
-CONFIG_EXT2_FS=y
-CONFIG_EXT2_FS_XATTR=y
-CONFIG_EXT2_FS_SECURITY=y
-CONFIG_EXT3_FS=y
-CONFIG_EXT3_FS_SECURITY=y
-CONFIG_AUTOFS4_FS=m
-CONFIG_MSDOS_FS=m
-CONFIG_VFAT_FS=m
-CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
-CONFIG_TMPFS=y
-CONFIG_PARTITION_ADVANCED=y
-CONFIG_NLS=y
-CONFIG_NLS_DEFAULT="utf8"
-CONFIG_NLS_CODEPAGE_437=y
-CONFIG_NLS_ASCII=m
-CONFIG_MAGIC_SYSRQ=y
-CONFIG_DEBUG_FS=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_SPINLOCK=y
-CONFIG_DEBUG_SPINLOCK_SLEEP=y
-CONFIG_DEBUG_INFO=y
-# CONFIG_CRC32 is not set
diff --git a/arch/arm/configs/spear300_defconfig b/arch/arm/configs/spear3xx_defconfig
similarity index 93%
rename from arch/arm/configs/spear300_defconfig
rename to arch/arm/configs/spear3xx_defconfig
index cf29f3e..fea7e1f 100644
--- a/arch/arm/configs/spear300_defconfig
+++ b/arch/arm/configs/spear3xx_defconfig
@@ -7,6 +7,9 @@ CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODVERSIONS=y
 CONFIG_PLAT_SPEAR=y
+CONFIG_BOARD_SPEAR300_EVB=y
+CONFIG_BOARD_SPEAR310_EVB=y
+CONFIG_BOARD_SPEAR320_EVB=y
 CONFIG_BINFMT_MISC=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_RAM=y
@@ -24,7 +27,6 @@ CONFIG_MAX_RAW_DEVS=8192
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_PL061=y
 # CONFIG_HWMON is not set
-# CONFIG_VGA_CONSOLE is not set
 # CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_EXT2_FS=y
-- 
1.7.2.2

