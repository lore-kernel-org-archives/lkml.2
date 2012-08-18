Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2HRQZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 12:25:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56166 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2HRQYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 12:24:31 -0400
From: Fabio Estevam <festevam@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 10/11] sh: defconfig: Remove CONFIG_MISC_DEVICES
Date: Sat, 18 Aug 2012 13:23:54 -0300
Message-Id: <1345307035-3545-10-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345307035-3545-1-git-send-email-festevam@gmail.com>
References: <1345307035-3545-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 7c5763 (drivers:misc: Remove MISC_DEVICES config option) removed 
CONFIG_MISC_DEVICES option, so remove the occurrences from the config files 
as well

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/sh/configs/ecovec24-romimage_defconfig |    1 -
 arch/sh/configs/edosk7705_defconfig         |    1 -
 arch/sh/configs/edosk7760_defconfig         |    1 -
 arch/sh/configs/espt_defconfig              |    1 -
 arch/sh/configs/kfr2r09-romimage_defconfig  |    1 -
 arch/sh/configs/kfr2r09_defconfig           |    1 -
 arch/sh/configs/sdk7780_defconfig           |    1 -
 arch/sh/configs/sdk7786_defconfig           |    1 -
 arch/sh/configs/se7343_defconfig            |    1 -
 arch/sh/configs/secureedge5410_defconfig    |    1 -
 arch/sh/configs/sh2007_defconfig            |    1 -
 arch/sh/configs/sh7724_generic_defconfig    |    1 -
 arch/sh/configs/sh7763rdp_defconfig         |    1 -
 arch/sh/configs/sh7770_generic_defconfig    |    1 -
 arch/sh/configs/sh7785lcr_32bit_defconfig   |    1 -
 arch/sh/configs/sh7785lcr_defconfig         |    1 -
 arch/sh/configs/urquell_defconfig           |    1 -
 17 files changed, 17 deletions(-)

diff --git a/arch/sh/configs/ecovec24-romimage_defconfig b/arch/sh/configs/ecovec24-romimage_defconfig
index 5fcb17b..3f4f8d6 100644
--- a/arch/sh/configs/ecovec24-romimage_defconfig
+++ b/arch/sh/configs/ecovec24-romimage_defconfig
@@ -30,7 +30,6 @@ CONFIG_INET=y
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
diff --git a/arch/sh/configs/edosk7705_defconfig b/arch/sh/configs/edosk7705_defconfig
index 41fa3a7..d8d240c5 100644
--- a/arch/sh/configs/edosk7705_defconfig
+++ b/arch/sh/configs/edosk7705_defconfig
@@ -20,7 +20,6 @@ CONFIG_CPU_SUBTYPE_SH7705=y
 CONFIG_SH_EDOSK7705=y
 CONFIG_SH_PCLK_FREQ=31250000
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
diff --git a/arch/sh/configs/edosk7760_defconfig b/arch/sh/configs/edosk7760_defconfig
index e1077a0..52e8af8 100644
--- a/arch/sh/configs/edosk7760_defconfig
+++ b/arch/sh/configs/edosk7760_defconfig
@@ -62,7 +62,6 @@ CONFIG_MTD_ABSENT=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=26000
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
diff --git a/arch/sh/configs/espt_defconfig b/arch/sh/configs/espt_defconfig
index 67cb109..c1d6e36 100644
--- a/arch/sh/configs/espt_defconfig
+++ b/arch/sh/configs/espt_defconfig
@@ -43,7 +43,6 @@ CONFIG_MTD_CFI_GEOMETRY=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_PHYSMAP=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_NETDEVICES=y
diff --git a/arch/sh/configs/kfr2r09-romimage_defconfig b/arch/sh/configs/kfr2r09-romimage_defconfig
index 029a506..d6932ea 100644
--- a/arch/sh/configs/kfr2r09-romimage_defconfig
+++ b/arch/sh/configs/kfr2r09-romimage_defconfig
@@ -31,7 +31,6 @@ CONFIG_INET=y
 # CONFIG_IPV6 is not set
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
diff --git a/arch/sh/configs/kfr2r09_defconfig b/arch/sh/configs/kfr2r09_defconfig
index fac13de..eaaf8da 100644
--- a/arch/sh/configs/kfr2r09_defconfig
+++ b/arch/sh/configs/kfr2r09_defconfig
@@ -49,7 +49,6 @@ CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_ONENAND=y
 CONFIG_MTD_ONENAND_GENERIC=y
 CONFIG_MTD_UBI=y
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 CONFIG_INPUT_EVDEV=y
 # CONFIG_KEYBOARD_ATKBD is not set
diff --git a/arch/sh/configs/sdk7780_defconfig b/arch/sh/configs/sdk7780_defconfig
index ae11158..7d28cc5 100644
--- a/arch/sh/configs/sdk7780_defconfig
+++ b/arch/sh/configs/sdk7780_defconfig
@@ -46,7 +46,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_PARPORT=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_PLATFORM=y
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index 76a76a2..eec1215 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -120,7 +120,6 @@ CONFIG_MTD_UBI_GLUEBI=m
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_PLATFORM=y
diff --git a/arch/sh/configs/se7343_defconfig b/arch/sh/configs/se7343_defconfig
index be9c474..1e181ad 100644
--- a/arch/sh/configs/se7343_defconfig
+++ b/arch/sh/configs/se7343_defconfig
@@ -40,7 +40,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_PHYSMAP=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOWLEVEL is not set
diff --git a/arch/sh/configs/secureedge5410_defconfig b/arch/sh/configs/secureedge5410_defconfig
index 7eae4e5..b738b13 100644
--- a/arch/sh/configs/secureedge5410_defconfig
+++ b/arch/sh/configs/secureedge5410_defconfig
@@ -34,7 +34,6 @@ CONFIG_MTD_CFI_GEOMETRY=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PLATRAM=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_NET_PCI=y
diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index 0d2f414..a117a1f 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -49,7 +49,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
 CONFIG_SCSI_TGT=y
diff --git a/arch/sh/configs/sh7724_generic_defconfig b/arch/sh/configs/sh7724_generic_defconfig
index f83ac7b..3d8c89f 100644
--- a/arch/sh/configs/sh7724_generic_defconfig
+++ b/arch/sh/configs/sh7724_generic_defconfig
@@ -18,7 +18,6 @@ CONFIG_HIBERNATION=y
 CONFIG_CPU_IDLE=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
diff --git a/arch/sh/configs/sh7763rdp_defconfig b/arch/sh/configs/sh7763rdp_defconfig
index 4795364..80d0144 100644
--- a/arch/sh/configs/sh7763rdp_defconfig
+++ b/arch/sh/configs/sh7763rdp_defconfig
@@ -43,7 +43,6 @@ CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_CFI_STAA=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_PHYSMAP=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_NETDEVICES=y
diff --git a/arch/sh/configs/sh7770_generic_defconfig b/arch/sh/configs/sh7770_generic_defconfig
index 025bd3a..f8eb5d8 100644
--- a/arch/sh/configs/sh7770_generic_defconfig
+++ b/arch/sh/configs/sh7770_generic_defconfig
@@ -20,7 +20,6 @@ CONFIG_HIBERNATION=y
 CONFIG_CPU_IDLE=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
index 9bdcf72..41eca2e 100644
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig
+++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -58,7 +58,6 @@ CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
diff --git a/arch/sh/configs/sh7785lcr_defconfig b/arch/sh/configs/sh7785lcr_defconfig
index 51561f5..807704a 100644
--- a/arch/sh/configs/sh7785lcr_defconfig
+++ b/arch/sh/configs/sh7785lcr_defconfig
@@ -39,7 +39,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_ATA=y
diff --git a/arch/sh/configs/urquell_defconfig b/arch/sh/configs/urquell_defconfig
index d7f89be..b61e1cb 100644
--- a/arch/sh/configs/urquell_defconfig
+++ b/arch/sh/configs/urquell_defconfig
@@ -60,7 +60,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_ATA=y
-- 
1.7.9.5

