Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203Ab2KAUL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:11:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934353Ab2KAULR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:11:17 -0400
From: Milan Broz <mbroz@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jaxboe@fusionio.com, kzak@redhat.com, Milan Broz <mbroz@redhat.com>
Subject: [RFC PATCH 2/4] Remove cryptoloop config option.
Date: Thu,  1 Nov 2012 21:11:02 +0100
Message-Id: <ef77e092876542c18d25cf803a26934cc5513269.1351799189.git.mbroz@redhat.com>
In-Reply-To: <cover.1351799189.git.mbroz@redhat.com>
References: <cover.1351799189.git.mbroz@redhat.com>
In-Reply-To: <cover.1351799189.git.mbroz@redhat.com>
References: <cover.1351799189.git.mbroz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove use of CONFIG_BLK_DEV_CRYPTOLOOP across the tree.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 arch/arm/configs/colibri_pxa270_defconfig      |    1 -
 arch/arm/configs/ezx_defconfig                 |    1 -
 arch/arm/configs/imote2_defconfig              |    1 -
 arch/arm/configs/lpc32xx_defconfig             |    1 -
 arch/arm/configs/netx_defconfig                |    1 -
 arch/arm/configs/nhk8815_defconfig             |    1 -
 arch/arm/configs/trizeps4_defconfig            |    1 -
 arch/ia64/configs/bigsur_defconfig             |    1 -
 arch/ia64/configs/generic_defconfig            |    1 -
 arch/ia64/configs/gensparse_defconfig          |    1 -
 arch/ia64/configs/tiger_defconfig              |    1 -
 arch/ia64/configs/xen_domu_defconfig           |    1 -
 arch/m68k/configs/amiga_defconfig              |    1 -
 arch/m68k/configs/apollo_defconfig             |    1 -
 arch/m68k/configs/atari_defconfig              |    1 -
 arch/m68k/configs/bvme6000_defconfig           |    1 -
 arch/m68k/configs/hp300_defconfig              |    1 -
 arch/m68k/configs/mac_defconfig                |    1 -
 arch/m68k/configs/multi_defconfig              |    1 -
 arch/m68k/configs/mvme147_defconfig            |    1 -
 arch/m68k/configs/mvme16x_defconfig            |    1 -
 arch/m68k/configs/q40_defconfig                |    1 -
 arch/m68k/configs/sun3_defconfig               |    1 -
 arch/m68k/configs/sun3x_defconfig              |    1 -
 arch/mips/configs/bcm47xx_defconfig            |    1 -
 arch/mips/configs/bigsur_defconfig             |    1 -
 arch/mips/configs/fuloong2e_defconfig          |    1 -
 arch/mips/configs/ip27_defconfig               |    1 -
 arch/mips/configs/ip32_defconfig               |    1 -
 arch/mips/configs/jazz_defconfig               |    1 -
 arch/mips/configs/lemote2f_defconfig           |    1 -
 arch/mips/configs/malta_defconfig              |    1 -
 arch/mips/configs/markeins_defconfig           |    1 -
 arch/mips/configs/nlm_xlp_defconfig            |    1 -
 arch/mips/configs/nlm_xlr_defconfig            |    1 -
 arch/mips/configs/rm200_defconfig              |    1 -
 arch/mips/configs/sead3_defconfig              |    1 -
 arch/parisc/configs/712_defconfig              |    1 -
 arch/parisc/configs/b180_defconfig             |    1 -
 arch/parisc/configs/c3000_defconfig            |    1 -
 arch/parisc/configs/default_defconfig          |    1 -
 arch/powerpc/configs/85xx/ge_imp3a_defconfig   |    1 -
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig  |    1 -
 arch/powerpc/configs/86xx/gef_sbc310_defconfig |    1 -
 arch/powerpc/configs/86xx/gef_sbc610_defconfig |    1 -
 arch/powerpc/configs/86xx/sbc8641d_defconfig   |    1 -
 arch/powerpc/configs/c2k_defconfig             |    1 -
 arch/powerpc/configs/chroma_defconfig          |    1 -
 arch/powerpc/configs/ppc6xx_defconfig          |    1 -
 arch/score/configs/spct6600_defconfig          |    1 -
 arch/sh/configs/sdk7786_defconfig              |    1 -
 arch/sh/configs/sh7785lcr_32bit_defconfig      |    1 -
 arch/sh/configs/titan_defconfig                |    1 -
 arch/sparc/configs/sparc32_defconfig           |    1 -
 arch/sparc/configs/sparc64_defconfig           |    1 -
 arch/tile/configs/tilegx_defconfig             |    1 -
 arch/tile/configs/tilepro_defconfig            |    1 -
 arch/um/defconfig                              |    1 -
 drivers/block/Kconfig                          |   23 -----------------------
 59 files changed, 81 deletions(-)

diff --git a/arch/arm/configs/colibri_pxa270_defconfig b/arch/arm/configs/colibri_pxa270_defconfig
index 2ef2c5e..5d8530a 100644
--- a/arch/arm/configs/colibri_pxa270_defconfig
+++ b/arch/arm/configs/colibri_pxa270_defconfig
@@ -79,7 +79,6 @@ CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
 CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
 CONFIG_MTD_ONENAND=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=8
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
index d95763d..8c124c0 100644
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -187,7 +187,6 @@ CONFIG_MTD_OTP=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PXA2XX=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 # CONFIG_MISC_DEVICES is not set
diff --git a/arch/arm/configs/imote2_defconfig b/arch/arm/configs/imote2_defconfig
index fd996bb..2866a41 100644
--- a/arch/arm/configs/imote2_defconfig
+++ b/arch/arm/configs/imote2_defconfig
@@ -167,7 +167,6 @@ CONFIG_MTD_OTP=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PXA2XX=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 # CONFIG_MISC_DEVICES is not set
diff --git a/arch/arm/configs/lpc32xx_defconfig b/arch/arm/configs/lpc32xx_defconfig
index 92386b2..b3f923d 100644
--- a/arch/arm/configs/lpc32xx_defconfig
+++ b/arch/arm/configs/lpc32xx_defconfig
@@ -59,7 +59,6 @@ CONFIG_MTD_NAND_MUSEUM_IDS=y
 CONFIG_MTD_NAND_SLC_LPC32XX=y
 CONFIG_MTD_NAND_MLC_LPC32XX=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=1
 CONFIG_BLK_DEV_RAM_SIZE=16384
diff --git a/arch/arm/configs/netx_defconfig b/arch/arm/configs/netx_defconfig
index 9c0ad79..97069ff 100644
--- a/arch/arm/configs/netx_defconfig
+++ b/arch/arm/configs/netx_defconfig
@@ -45,7 +45,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PLATRAM=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_NET_NETX=y
diff --git a/arch/arm/configs/nhk8815_defconfig b/arch/arm/configs/nhk8815_defconfig
index 240b25e..ed2da50 100644
--- a/arch/arm/configs/nhk8815_defconfig
+++ b/arch/arm/configs/nhk8815_defconfig
@@ -62,7 +62,6 @@ CONFIG_MTD_ONENAND=y
 CONFIG_MTD_ONENAND_VERIFY_WRITE=y
 CONFIG_MTD_ONENAND_GENERIC=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/arm/configs/trizeps4_defconfig b/arch/arm/configs/trizeps4_defconfig
index 3162173..e1e24d5 100644
--- a/arch/arm/configs/trizeps4_defconfig
+++ b/arch/arm/configs/trizeps4_defconfig
@@ -90,7 +90,6 @@ CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
 CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
 CONFIG_MTD_ONENAND=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=8
diff --git a/arch/ia64/configs/bigsur_defconfig b/arch/ia64/configs/bigsur_defconfig
index cf5993f..67893f4 100644
--- a/arch/ia64/configs/bigsur_defconfig
+++ b/arch/ia64/configs/bigsur_defconfig
@@ -24,7 +24,6 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 # CONFIG_IPV6 is not set
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
 CONFIG_IDE=m
diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 7913695..0e16eab 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -44,7 +44,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 # CONFIG_PNP_DEBUG_MESSAGES is not set
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SGI_IOC4=y
diff --git a/arch/ia64/configs/gensparse_defconfig b/arch/ia64/configs/gensparse_defconfig
index f8e9133..a7eb788 100644
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@ -35,7 +35,6 @@ CONFIG_ARPD=y
 CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SGI_IOC4=y
diff --git a/arch/ia64/configs/tiger_defconfig b/arch/ia64/configs/tiger_defconfig
index a5a9e02..ae07574 100644
--- a/arch/ia64/configs/tiger_defconfig
+++ b/arch/ia64/configs/tiger_defconfig
@@ -41,7 +41,6 @@ CONFIG_ARPD=y
 CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_IDE=y
diff --git a/arch/ia64/configs/xen_domu_defconfig b/arch/ia64/configs/xen_domu_defconfig
index 37b9b42..4c91d82 100644
--- a/arch/ia64/configs/xen_domu_defconfig
+++ b/arch/ia64/configs/xen_domu_defconfig
@@ -44,7 +44,6 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_IDE=y
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 90d3109..647597d 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -153,7 +153,6 @@ CONFIG_PARPORT_1284=y
 CONFIG_AMIGA_FLOPPY=y
 CONFIG_AMIGA_Z2RAM=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 8f4f657..dcae87c 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -147,7 +147,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 4571d33..fdf0e89 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -149,7 +149,6 @@ CONFIG_PARPORT_ATARI=m
 CONFIG_PARPORT_1284=y
 CONFIG_ATARI_FLOPPY=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 12f2117..e0aedd4 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -145,7 +145,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 215389a..6cd47ff 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -146,7 +146,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index cb9dfb3..e9392a9 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -146,7 +146,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_SWIM=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 8d5def4..586f689 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -173,7 +173,6 @@ CONFIG_ATARI_FLOPPY=y
 CONFIG_BLK_DEV_SWIM=y
 CONFIG_AMIGA_Z2RAM=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index e2af46f..215d8a7 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -144,7 +144,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 7c9402b..5ef6fed 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -145,7 +145,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index 19d23db..96c5b8c 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -141,7 +141,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index ca6c0b4..ecdcc14 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -142,7 +142,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index c80941c..91e0602 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -142,7 +142,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index b6fde2b..4aa0bc1 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -284,7 +284,6 @@ CONFIG_MTD_ROM=y
 CONFIG_MTD_ABSENT=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index 1cdff6b..6e0c44d 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -114,7 +114,6 @@ CONFIG_YAM=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_SGI_IOC4=m
 CONFIG_EEPROM_LEGACY=y
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index e5b73de..8925c7e 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -110,7 +110,6 @@ CONFIG_MTD_CFI_AMDSTD=m
 CONFIG_MTD_CFI_STAA=m
 CONFIG_MTD_PHYSMAP=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_RAM=m
 CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 0e36abc..db4fd2b 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -100,7 +100,6 @@ CONFIG_MAC80211_RC_PID=y
 CONFIG_RFKILL=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_OSD=m
 CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 7bbd521..056a306 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -49,7 +49,6 @@ CONFIG_NETWORK_SECMARK=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_SGI_IOC4=y
 CONFIG_RAID_ATTRS=y
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index 0315ee3..72c1a56 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -201,7 +201,6 @@ CONFIG_PARIDE_KTTI=m
 CONFIG_PARIDE_ON20=m
 CONFIG_PARIDE_ON26=m
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index b6acd2f..08d3d82 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -106,7 +106,6 @@ CONFIG_RFKILL=m
 CONFIG_RFKILL_INPUT=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
 # CONFIG_MISC_DEVICES is not set
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index cd732e5..5b3f85b 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -266,7 +266,6 @@ CONFIG_MTD_UBI_GLUEBI=m
 CONFIG_BLK_DEV_FD=m
 CONFIG_BLK_DEV_UMEM=m
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_CDROM_PKTCDVD=m
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
index 636f82b..ac513e1 100644
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -132,7 +132,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_SGI_IOC4=m
 CONFIG_SCSI=m
 CONFIG_SCSI_TGT=m
diff --git a/arch/mips/configs/nlm_xlp_defconfig b/arch/mips/configs/nlm_xlp_defconfig
index 5468b1c..05145fe 100644
--- a/arch/mips/configs/nlm_xlp_defconfig
+++ b/arch/mips/configs/nlm_xlp_defconfig
@@ -327,7 +327,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_OSD=m
 CONFIG_BLK_DEV_RAM=y
diff --git a/arch/mips/configs/nlm_xlr_defconfig b/arch/mips/configs/nlm_xlr_defconfig
index 44b4734..049ca51 100644
--- a/arch/mips/configs/nlm_xlr_defconfig
+++ b/arch/mips/configs/nlm_xlr_defconfig
@@ -302,7 +302,6 @@ CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_STANDALONE is not set
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_OSD=m
 CONFIG_BLK_DEV_RAM=y
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 59d9d2f..1f5d037 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -211,7 +211,6 @@ CONFIG_PARIDE_KTTI=m
 CONFIG_PARIDE_ON20=m
 CONFIG_PARIDE_ON26=m
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_SX8=m
 CONFIG_BLK_DEV_UB=m
diff --git a/arch/mips/configs/sead3_defconfig b/arch/mips/configs/sead3_defconfig
index e3eec68..d814f2c 100644
--- a/arch/mips/configs/sead3_defconfig
+++ b/arch/mips/configs/sead3_defconfig
@@ -41,7 +41,6 @@ CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_UBI=y
 CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/parisc/configs/712_defconfig b/arch/parisc/configs/712_defconfig
index 0f90569..79cd7a7 100644
--- a/arch/parisc/configs/712_defconfig
+++ b/arch/parisc/configs/712_defconfig
@@ -45,7 +45,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_PARPORT=y
 CONFIG_PARPORT_PC=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=6144
 CONFIG_ATA_OVER_ETH=m
diff --git a/arch/parisc/configs/b180_defconfig b/arch/parisc/configs/b180_defconfig
index e289f5b..cd9fc80 100644
--- a/arch/parisc/configs/b180_defconfig
+++ b/arch/parisc/configs/b180_defconfig
@@ -31,7 +31,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_PARPORT=y
 CONFIG_PARPORT_PC=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=y
 CONFIG_SCSI=y
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
index 311ca36..c7a1902 100644
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -43,7 +43,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_BLK_DEV_UMEM=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_NS87415=y
diff --git a/arch/parisc/configs/default_defconfig b/arch/parisc/configs/default_defconfig
index dfe88f6..42a0211 100644
--- a/arch/parisc/configs/default_defconfig
+++ b/arch/parisc/configs/default_defconfig
@@ -56,7 +56,6 @@ CONFIG_PARPORT_PC=m
 CONFIG_PARPORT_PC_PCMCIA=m
 CONFIG_PARPORT_1284=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=6144
 CONFIG_IDE=y
diff --git a/arch/powerpc/configs/85xx/ge_imp3a_defconfig b/arch/powerpc/configs/85xx/ge_imp3a_defconfig
index f8c51a4..95aa2e6 100644
--- a/arch/powerpc/configs/85xx/ge_imp3a_defconfig
+++ b/arch/powerpc/configs/85xx/ge_imp3a_defconfig
@@ -84,7 +84,6 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_FSL_ELBC=y
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=131072
diff --git a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
index da731c2..693366a 100644
--- a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
+++ b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
@@ -81,7 +81,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=131072
diff --git a/arch/powerpc/configs/86xx/gef_sbc310_defconfig b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
index 2149360..c9c25b9 100644
--- a/arch/powerpc/configs/86xx/gef_sbc310_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
@@ -81,7 +81,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=131072
diff --git a/arch/powerpc/configs/86xx/gef_sbc610_defconfig b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
index af2e8e1..4d60455 100644
--- a/arch/powerpc/configs/86xx/gef_sbc610_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
@@ -134,7 +134,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=131072
diff --git a/arch/powerpc/configs/86xx/sbc8641d_defconfig b/arch/powerpc/configs/86xx/sbc8641d_defconfig
index 0a92ca0..1a7fa04 100644
--- a/arch/powerpc/configs/86xx/sbc8641d_defconfig
+++ b/arch/powerpc/configs/86xx/sbc8641d_defconfig
@@ -130,7 +130,6 @@ CONFIG_MTD_CFI_LE_BYTE_SWAP=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_MD=y
diff --git a/arch/powerpc/configs/c2k_defconfig b/arch/powerpc/configs/c2k_defconfig
index 2a84fd7..91c86cd 100644
--- a/arch/powerpc/configs/c2k_defconfig
+++ b/arch/powerpc/configs/c2k_defconfig
@@ -158,7 +158,6 @@ CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
diff --git a/arch/powerpc/configs/chroma_defconfig b/arch/powerpc/configs/chroma_defconfig
index 29bb11e..35de505 100644
--- a/arch/powerpc/configs/chroma_defconfig
+++ b/arch/powerpc/configs/chroma_defconfig
@@ -174,7 +174,6 @@ CONFIG_MTD_CFI_STAA=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=65536
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index be1cb6e..d01bcc9 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -389,7 +389,6 @@ CONFIG_PNP=y
 CONFIG_ISAPNP=y
 CONFIG_MAC_FLOPPY=m
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
diff --git a/arch/score/configs/spct6600_defconfig b/arch/score/configs/spct6600_defconfig
index df1edbf..67d1a38 100644
--- a/arch/score/configs/spct6600_defconfig
+++ b/arch/score/configs/spct6600_defconfig
@@ -30,7 +30,6 @@ CONFIG_ARPD=y
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=1
 # CONFIG_MISC_DEVICES is not set
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index 76a76a2..586ee41 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -118,7 +118,6 @@ CONFIG_MTD_NAND_SH_FLCTL=m
 CONFIG_MTD_UBI=y
 CONFIG_MTD_UBI_GLUEBI=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 # CONFIG_MISC_DEVICES is not set
 CONFIG_IDE=y
diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
index 9bdcf72..b51c58a 100644
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig
+++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -56,7 +56,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_RAM=y
 # CONFIG_MISC_DEVICES is not set
 # CONFIG_SCSI_PROC_FS is not set
diff --git a/arch/sh/configs/titan_defconfig b/arch/sh/configs/titan_defconfig
index e2cbd92..53b966e 100644
--- a/arch/sh/configs/titan_defconfig
+++ b/arch/sh/configs/titan_defconfig
@@ -164,7 +164,6 @@ CONFIG_MTD_CFI=m
 CONFIG_MTD_JEDECPROBE=m
 CONFIG_MTD_NAND=m
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_ATA_OVER_ETH=m
 CONFIG_SCSI=y
diff --git a/arch/sparc/configs/sparc32_defconfig b/arch/sparc/configs/sparc32_defconfig
index fb23fd6..1cbed02 100644
--- a/arch/sparc/configs/sparc32_defconfig
+++ b/arch/sparc/configs/sparc32_defconfig
@@ -32,7 +32,6 @@ CONFIG_IPV6_TUNNEL=m
 CONFIG_NET_PKTGEN=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 9d8521b..0cfe44fa 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -62,7 +62,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_CDROM_PKTCDVD=m
 CONFIG_CDROM_PKTCDVD_WCACHE=y
diff --git a/arch/tile/configs/tilegx_defconfig b/arch/tile/configs/tilegx_defconfig
index 8c5eff6..a493064 100644
--- a/arch/tile/configs/tilegx_defconfig
+++ b/arch/tile/configs/tilegx_defconfig
@@ -306,7 +306,6 @@ CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_SX8=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
diff --git a/arch/tile/configs/tilepro_defconfig b/arch/tile/configs/tilepro_defconfig
index e7a3dfc..e688990 100644
--- a/arch/tile/configs/tilepro_defconfig
+++ b/arch/tile/configs/tilepro_defconfig
@@ -304,7 +304,6 @@ CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_SX8=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
diff --git a/arch/um/defconfig b/arch/um/defconfig
index 08107a7..5f24b2b 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -324,7 +324,6 @@ CONFIG_BLK_DEV_UBD=y
 CONFIG_BLK_DEV_COW_COMMON=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
-# CONFIG_BLK_DEV_CRYPTOLOOP is not set
 
 #
 # DRBD disabled because PROC_FS, INET or CONNECTOR not selected
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 824e09c..d07ab5f 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -243,14 +243,6 @@ config BLK_DEV_LOOP
 	  bits of, say, a sound file). This is also safe if the file resides
 	  on a remote file server.
 
-	  There are several ways of encrypting disks. Some of these require
-	  kernel patches. The vanilla kernel offers the cryptoloop option
-	  and a Device Mapper target (which is superior, as it supports all
-	  file systems). If you want to use the cryptoloop, say Y to both
-	  LOOP and CRYPTOLOOP, and make sure you have a recent (version 2.12
-	  or later) version of util-linux. Additionally, be aware that
-	  the cryptoloop is not safe for storing journaled filesystems.
-
 	  Note that this loop device has nothing to do with the loopback
 	  device used for network connections from the machine to itself.
 
@@ -274,21 +266,6 @@ config BLK_DEV_LOOP_MIN_COUNT
 	  is used, it can be set to 0, since needed loop devices can be
 	  dynamically allocated with the /dev/loop-control interface.
 
-config BLK_DEV_CRYPTOLOOP
-	tristate "Cryptoloop Support"
-	select CRYPTO
-	select CRYPTO_CBC
-	depends on BLK_DEV_LOOP
-	---help---
-	  Say Y here if you want to be able to use the ciphers that are 
-	  provided by the CryptoAPI as loop transformation. This might be
-	  used as hard disk encryption.
-
-	  WARNING: This device is not safe for journaled file systems like
-	  ext3 or Reiserfs. Please use the Device Mapper crypto module
-	  instead, which can be configured to be on-disk compatible with the
-	  cryptoloop device.
-
 source "drivers/block/drbd/Kconfig"
 
 config BLK_DEV_NBD
-- 
1.7.10.4

