Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2HRQYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 12:24:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56166 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2HRQYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 12:24:12 -0400
From: Fabio Estevam <festevam@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 01/11] ARM: defconfig: Remove CONFIG_MISC_DEVICES
Date: Sat, 18 Aug 2012 13:23:45 -0300
Message-Id: <1345307035-3545-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 7c5763 (drivers:misc: Remove MISC_DEVICES config option) removed 
CONFIG_MISC_DEVICES option, so remove the occurrences from the config files 
as well.

Cc: <linux-arm-kernel@lists.infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/arm/configs/acs5k_tiny_defconfig     |    1 -
 arch/arm/configs/ap4evb_defconfig         |    1 -
 arch/arm/configs/at91sam9261_defconfig    |    1 -
 arch/arm/configs/at91sam9263_defconfig    |    1 -
 arch/arm/configs/at91sam9g45_defconfig    |    1 -
 arch/arm/configs/bcmring_defconfig        |    1 -
 arch/arm/configs/cam60_defconfig          |    1 -
 arch/arm/configs/cm_x2xx_defconfig        |    1 -
 arch/arm/configs/cns3420vb_defconfig      |    1 -
 arch/arm/configs/colibri_pxa300_defconfig |    1 -
 arch/arm/configs/cpu9260_defconfig        |    1 -
 arch/arm/configs/cpu9g20_defconfig        |    1 -
 arch/arm/configs/em_x270_defconfig        |    1 -
 arch/arm/configs/ezx_defconfig            |    1 -
 arch/arm/configs/g3evm_defconfig          |    1 -
 arch/arm/configs/g4evm_defconfig          |    1 -
 arch/arm/configs/h3600_defconfig          |    1 -
 arch/arm/configs/imote2_defconfig         |    1 -
 arch/arm/configs/kirkwood_defconfig       |    1 -
 arch/arm/configs/magician_defconfig       |    1 -
 arch/arm/configs/mmp2_defconfig           |    1 -
 arch/arm/configs/nuc910_defconfig         |    1 -
 arch/arm/configs/nuc950_defconfig         |    1 -
 arch/arm/configs/nuc960_defconfig         |    1 -
 arch/arm/configs/palmz72_defconfig        |    1 -
 arch/arm/configs/pcm027_defconfig         |    1 -
 arch/arm/configs/pxa168_defconfig         |    1 -
 arch/arm/configs/pxa3xx_defconfig         |    1 -
 arch/arm/configs/pxa910_defconfig         |    1 -
 arch/arm/configs/qil-a9260_defconfig      |    1 -
 arch/arm/configs/s5p64x0_defconfig        |    1 -
 arch/arm/configs/s5pv210_defconfig        |    1 -
 arch/arm/configs/sam9_l9260_defconfig     |    1 -
 arch/arm/configs/stamp9g20_defconfig      |    1 -
 arch/arm/configs/tct_hammer_defconfig     |    1 -
 arch/arm/configs/usb-a9260_defconfig      |    1 -
 arch/arm/configs/vexpress_defconfig       |    1 -
 arch/arm/configs/xcep_defconfig           |    1 -
 38 files changed, 38 deletions(-)

diff --git a/arch/arm/configs/acs5k_tiny_defconfig b/arch/arm/configs/acs5k_tiny_defconfig
index 2a27a14..ae52a07 100644
--- a/arch/arm/configs/acs5k_tiny_defconfig
+++ b/arch/arm/configs/acs5k_tiny_defconfig
@@ -40,7 +40,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 # CONFIG_BLK_DEV is not set
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_ARM_KS8695_ETHER=y
diff --git a/arch/arm/configs/ap4evb_defconfig b/arch/arm/configs/ap4evb_defconfig
index 2eef85e..ba3455d 100644
--- a/arch/arm/configs/ap4evb_defconfig
+++ b/arch/arm/configs/ap4evb_defconfig
@@ -31,7 +31,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_NAND=y
 # CONFIG_BLK_DEV is not set
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
diff --git a/arch/arm/configs/at91sam9261_defconfig b/arch/arm/configs/at91sam9261_defconfig
index 1e8712e..c2005df 100644
--- a/arch/arm/configs/at91sam9261_defconfig
+++ b/arch/arm/configs/at91sam9261_defconfig
@@ -51,7 +51,6 @@ CONFIG_MTD_UBI=y
 CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=y
 CONFIG_SCSI=y
diff --git a/arch/arm/configs/at91sam9263_defconfig b/arch/arm/configs/at91sam9263_defconfig
index d2050ca..b89306e 100644
--- a/arch/arm/configs/at91sam9263_defconfig
+++ b/arch/arm/configs/at91sam9263_defconfig
@@ -66,7 +66,6 @@ CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_PWM=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_SCSI=y
diff --git a/arch/arm/configs/at91sam9g45_defconfig b/arch/arm/configs/at91sam9g45_defconfig
index 606d48f..a3cb69e 100644
--- a/arch/arm/configs/at91sam9g45_defconfig
+++ b/arch/arm/configs/at91sam9g45_defconfig
@@ -65,7 +65,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=4
 CONFIG_BLK_DEV_RAM_SIZE=8192
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_PWM=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_SCSI=y
diff --git a/arch/arm/configs/bcmring_defconfig b/arch/arm/configs/bcmring_defconfig
index 9e6a8fe..e67e755 100644
--- a/arch/arm/configs/bcmring_defconfig
+++ b/arch/arm/configs/bcmring_defconfig
@@ -47,7 +47,6 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_BCM_UMI=y
 CONFIG_MTD_NAND_BCM_UMI_HWCS=y
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
diff --git a/arch/arm/configs/cam60_defconfig b/arch/arm/configs/cam60_defconfig
index cedc92e..04a4edf 100644
--- a/arch/arm/configs/cam60_defconfig
+++ b/arch/arm/configs/cam60_defconfig
@@ -53,7 +53,6 @@ CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_ATMEL=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/arm/configs/cm_x2xx_defconfig b/arch/arm/configs/cm_x2xx_defconfig
index a93ff8d..a443065 100644
--- a/arch/arm/configs/cm_x2xx_defconfig
+++ b/arch/arm/configs/cm_x2xx_defconfig
@@ -69,7 +69,6 @@ CONFIG_MTD_NAND_CM_X270=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_ATA=m
diff --git a/arch/arm/configs/cns3420vb_defconfig b/arch/arm/configs/cns3420vb_defconfig
index 313627a..366e834 100644
--- a/arch/arm/configs/cns3420vb_defconfig
+++ b/arch/arm/configs/cns3420vb_defconfig
@@ -38,7 +38,6 @@ CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=20000
-# CONFIG_MISC_DEVICES is not set
 CONFIG_BLK_DEV_SD=y
 CONFIG_ATA=y
 # CONFIG_SATA_PMP is not set
diff --git a/arch/arm/configs/colibri_pxa300_defconfig b/arch/arm/configs/colibri_pxa300_defconfig
index b985334..76c4866 100644
--- a/arch/arm/configs/colibri_pxa300_defconfig
+++ b/arch/arm/configs/colibri_pxa300_defconfig
@@ -17,7 +17,6 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_INET_LRO is not set
 CONFIG_IPV6=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
diff --git a/arch/arm/configs/cpu9260_defconfig b/arch/arm/configs/cpu9260_defconfig
index 921480c..4a50e2a 100644
--- a/arch/arm/configs/cpu9260_defconfig
+++ b/arch/arm/configs/cpu9260_defconfig
@@ -40,7 +40,6 @@ CONFIG_MTD_NAND_ATMEL=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_MULTI_LUN=y
diff --git a/arch/arm/configs/cpu9g20_defconfig b/arch/arm/configs/cpu9g20_defconfig
index ea116cb..10d5991 100644
--- a/arch/arm/configs/cpu9g20_defconfig
+++ b/arch/arm/configs/cpu9g20_defconfig
@@ -40,7 +40,6 @@ CONFIG_MTD_NAND_ATMEL=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_MULTI_LUN=y
diff --git a/arch/arm/configs/em_x270_defconfig b/arch/arm/configs/em_x270_defconfig
index 60a21e0..1f409cd 100644
--- a/arch/arm/configs/em_x270_defconfig
+++ b/arch/arm/configs/em_x270_defconfig
@@ -63,7 +63,6 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
index d95763d..90f8ba4 100644
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -190,7 +190,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_DUMMY=y
 # CONFIG_NETDEV_1000 is not set
diff --git a/arch/arm/configs/g3evm_defconfig b/arch/arm/configs/g3evm_defconfig
index 4a336ab..52d9235 100644
--- a/arch/arm/configs/g3evm_defconfig
+++ b/arch/arm/configs/g3evm_defconfig
@@ -31,7 +31,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_NAND=y
 # CONFIG_BLK_DEV is not set
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
diff --git a/arch/arm/configs/g4evm_defconfig b/arch/arm/configs/g4evm_defconfig
index 21c6d03..2f20f40 100644
--- a/arch/arm/configs/g4evm_defconfig
+++ b/arch/arm/configs/g4evm_defconfig
@@ -31,7 +31,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_NAND=y
 # CONFIG_BLK_DEV is not set
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
diff --git a/arch/arm/configs/h3600_defconfig b/arch/arm/configs/h3600_defconfig
index 317960f..ea97960 100644
--- a/arch/arm/configs/h3600_defconfig
+++ b/arch/arm/configs/h3600_defconfig
@@ -41,7 +41,6 @@ CONFIG_MTD_SA1100=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
-# CONFIG_MISC_DEVICES is not set
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDECS=y
 CONFIG_NETDEVICES=y
diff --git a/arch/arm/configs/imote2_defconfig b/arch/arm/configs/imote2_defconfig
index fd996bb..84195c8 100644
--- a/arch/arm/configs/imote2_defconfig
+++ b/arch/arm/configs/imote2_defconfig
@@ -170,7 +170,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_DUMMY=y
 # CONFIG_NETDEV_1000 is not set
diff --git a/arch/arm/configs/kirkwood_defconfig b/arch/arm/configs/kirkwood_defconfig
index aeb3af5..87df04a 100644
--- a/arch/arm/configs/kirkwood_defconfig
+++ b/arch/arm/configs/kirkwood_defconfig
@@ -69,7 +69,6 @@ CONFIG_MTD_M25P80=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ORION=y
 CONFIG_BLK_DEV_LOOP=y
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index a691ef4..1790e2b 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -67,7 +67,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PHYSMAP=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 # CONFIG_NETDEV_1000 is not set
 # CONFIG_NETDEV_10000 is not set
diff --git a/arch/arm/configs/mmp2_defconfig b/arch/arm/configs/mmp2_defconfig
index 5a58452..7da3dab 100644
--- a/arch/arm/configs/mmp2_defconfig
+++ b/arch/arm/configs/mmp2_defconfig
@@ -34,7 +34,6 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_ONENAND=y
 CONFIG_MTD_ONENAND_GENERIC=y
 # CONFIG_BLK_DEV is not set
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
diff --git a/arch/arm/configs/nuc910_defconfig b/arch/arm/configs/nuc910_defconfig
index 10180cf..c1cd29f 100644
--- a/arch/arm/configs/nuc910_defconfig
+++ b/arch/arm/configs/nuc910_defconfig
@@ -25,7 +25,6 @@ CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/arm/configs/nuc950_defconfig b/arch/arm/configs/nuc950_defconfig
index 27aa873..923254b 100644
--- a/arch/arm/configs/nuc950_defconfig
+++ b/arch/arm/configs/nuc950_defconfig
@@ -31,7 +31,6 @@ CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/arm/configs/nuc960_defconfig b/arch/arm/configs/nuc960_defconfig
index 56fd7ad..14dc661 100644
--- a/arch/arm/configs/nuc960_defconfig
+++ b/arch/arm/configs/nuc960_defconfig
@@ -31,7 +31,6 @@ CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/arm/configs/palmz72_defconfig b/arch/arm/configs/palmz72_defconfig
index 4baa83c..3d7a8dd 100644
--- a/arch/arm/configs/palmz72_defconfig
+++ b/arch/arm/configs/palmz72_defconfig
@@ -34,7 +34,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_LOOP=y
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y
 # CONFIG_KEYBOARD_ATKBD is not set
diff --git a/arch/arm/configs/pcm027_defconfig b/arch/arm/configs/pcm027_defconfig
index 2f136c3..fa85865 100644
--- a/arch/arm/configs/pcm027_defconfig
+++ b/arch/arm/configs/pcm027_defconfig
@@ -47,7 +47,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PHYSMAP=y
 # CONFIG_BLK_DEV is not set
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
diff --git a/arch/arm/configs/pxa168_defconfig b/arch/arm/configs/pxa168_defconfig
index 74d7e01..bbb9843 100644
--- a/arch/arm/configs/pxa168_defconfig
+++ b/arch/arm/configs/pxa168_defconfig
@@ -30,7 +30,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_BLK_DEV is not set
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
diff --git a/arch/arm/configs/pxa3xx_defconfig b/arch/arm/configs/pxa3xx_defconfig
index 1677a06..62f5e46 100644
--- a/arch/arm/configs/pxa3xx_defconfig
+++ b/arch/arm/configs/pxa3xx_defconfig
@@ -44,7 +44,6 @@ CONFIG_MTD_ONENAND_VERIFY_WRITE=y
 CONFIG_MTD_ONENAND_GENERIC=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
diff --git a/arch/arm/configs/pxa910_defconfig b/arch/arm/configs/pxa910_defconfig
index 1cd381e..985fb89 100644
--- a/arch/arm/configs/pxa910_defconfig
+++ b/arch/arm/configs/pxa910_defconfig
@@ -30,7 +30,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_BLK_DEV is not set
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_SMC91X=y
diff --git a/arch/arm/configs/qil-a9260_defconfig b/arch/arm/configs/qil-a9260_defconfig
index 42d5db1..ed1de4f 100644
--- a/arch/arm/configs/qil-a9260_defconfig
+++ b/arch/arm/configs/qil-a9260_defconfig
@@ -51,7 +51,6 @@ CONFIG_MTD_DATAFLASH=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
 CONFIG_BLK_DEV_LOOP=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_MULTI_LUN=y
diff --git a/arch/arm/configs/s5p64x0_defconfig b/arch/arm/configs/s5p64x0_defconfig
index ad6b61b..5a3d76f 100644
--- a/arch/arm/configs/s5p64x0_defconfig
+++ b/arch/arm/configs/s5p64x0_defconfig
@@ -20,7 +20,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
diff --git a/arch/arm/configs/s5pv210_defconfig b/arch/arm/configs/s5pv210_defconfig
index fa98990..ecc7f44 100644
--- a/arch/arm/configs/s5pv210_defconfig
+++ b/arch/arm/configs/s5pv210_defconfig
@@ -25,7 +25,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index da276f9..78355b1 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -44,7 +44,6 @@ CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
-# CONFIG_MISC_DEVICES is not set
 CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/arm/configs/stamp9g20_defconfig b/arch/arm/configs/stamp9g20_defconfig
index 52f1488..0d32d73 100644
--- a/arch/arm/configs/stamp9g20_defconfig
+++ b/arch/arm/configs/stamp9g20_defconfig
@@ -51,7 +51,6 @@ CONFIG_MTD_NAND_ATMEL=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_MULTI_LUN=y
diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
index 71277a1..0aaf23f 100644
--- a/arch/arm/configs/tct_hammer_defconfig
+++ b/arch/arm/configs/tct_hammer_defconfig
@@ -36,7 +36,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=10240
-# CONFIG_MISC_DEVICES is not set
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
diff --git a/arch/arm/configs/usb-a9260_defconfig b/arch/arm/configs/usb-a9260_defconfig
index a1501e1..e2a124d 100644
--- a/arch/arm/configs/usb-a9260_defconfig
+++ b/arch/arm/configs/usb-a9260_defconfig
@@ -50,7 +50,6 @@ CONFIG_MTD_DATAFLASH=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
 CONFIG_BLK_DEV_LOOP=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_MULTI_LUN=y
diff --git a/arch/arm/configs/vexpress_defconfig b/arch/arm/configs/vexpress_defconfig
index f2de51f..a1c0541 100644
--- a/arch/arm/configs/vexpress_defconfig
+++ b/arch/arm/configs/vexpress_defconfig
@@ -55,7 +55,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_ARM_INTEGRATOR=y
-CONFIG_MISC_DEVICES=y
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
diff --git a/arch/arm/configs/xcep_defconfig b/arch/arm/configs/xcep_defconfig
index 721832f..d718e51 100644
--- a/arch/arm/configs/xcep_defconfig
+++ b/arch/arm/configs/xcep_defconfig
@@ -50,7 +50,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD_CONCAT=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_PXA2XX=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 # CONFIG_NETDEV_1000 is not set
-- 
1.7.9.5

