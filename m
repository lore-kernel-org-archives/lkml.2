Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab1FAQaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:30:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64100 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758513Ab1FAQaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=f6tDEFUz8fJnPr5rqzJPhwtPJjU2O8eQAhk1BEYxusUHe3bcRQJGa/Lv/v0uBXxHVA
         EWlpiXtYuv/whqah1kU0D7g/OQZ5BK1tiyHgINuqh1die0uqZgGQZXvOl5Ir0SaSfMIw
         CVFHiiF8QlJNah4i6YemaCrc58qusuFt8Q+oA=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
Cc: linux@arm.linux.org.uk, hans-christian.egtvedt@atmel.com,
        vapier@gentoo.org, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, lethal@linux-sh.org, gxt@mprc.pku.edu.cn,
        david.woodhouse@intel.com, akpm@linux-foundation.org,
        u.kleine-koenig@pengutronix.de, mingo@elte.hu, rientjes@google.com,
        w.sang@pengutronix.de, sam@ravnborg.org, manuel.lauss@googlemail.com,
        anton@samba.org, arnd@arndb.de, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] Fix build warning of the defconfigs
Date: Thu,  2 Jun 2011 00:29:23 +0800
Message-Id: <1306945763-6583-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RTC_CLASS is changed to bool.
So value 'm' is invalid.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/arm/configs/davinci_all_defconfig     |    2 +-
 arch/arm/configs/mxs_defconfig             |    2 +-
 arch/arm/configs/netx_defconfig            |    2 +-
 arch/arm/configs/viper_defconfig           |    2 +-
 arch/arm/configs/xcep_defconfig            |    2 +-
 arch/arm/configs/zeus_defconfig            |    2 +-
 arch/avr32/configs/atngw100_mrmt_defconfig |    2 +-
 arch/blackfin/configs/CM-BF548_defconfig   |    2 +-
 arch/mips/configs/mtx1_defconfig           |    2 +-
 arch/powerpc/configs/52xx/pcm030_defconfig |    2 +-
 arch/powerpc/configs/ps3_defconfig         |    2 +-
 arch/sh/configs/titan_defconfig            |    2 +-
 arch/unicore32/configs/debug_defconfig     |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
index 889922a..67b5abb6 100644
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -157,7 +157,7 @@ CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
 CONFIG_LEDS_TRIGGER_HEARTBEAT=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_XFS_FS=m
diff --git a/arch/arm/configs/mxs_defconfig b/arch/arm/configs/mxs_defconfig
index 2bf2243..5a6ff7c 100644
--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -89,7 +89,7 @@ CONFIG_DISPLAY_SUPPORT=m
 # CONFIG_USB_SUPPORT is not set
 CONFIG_MMC=y
 CONFIG_MMC_MXS=y
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_DS1307=m
 CONFIG_DMADEVICES=y
 CONFIG_MXS_DMA=y
diff --git a/arch/arm/configs/netx_defconfig b/arch/arm/configs/netx_defconfig
index 316af54..9c0ad79 100644
--- a/arch/arm/configs/netx_defconfig
+++ b/arch/arm/configs/netx_defconfig
@@ -60,7 +60,7 @@ CONFIG_FB_ARMCLCD=y
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_LOGO=y
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_INOTIFY=y
 CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
diff --git a/arch/arm/configs/viper_defconfig b/arch/arm/configs/viper_defconfig
index 8b0c717..1d01ddd 100644
--- a/arch/arm/configs/viper_defconfig
+++ b/arch/arm/configs/viper_defconfig
@@ -142,7 +142,7 @@ CONFIG_USB_GADGETFS=m
 CONFIG_USB_FILE_STORAGE=m
 CONFIG_USB_G_SERIAL=m
 CONFIG_USB_G_PRINTER=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_DS1307=m
 CONFIG_RTC_DRV_SA1100=m
 CONFIG_EXT2_FS=m
diff --git a/arch/arm/configs/xcep_defconfig b/arch/arm/configs/xcep_defconfig
index 5b55041..721832f 100644
--- a/arch/arm/configs/xcep_defconfig
+++ b/arch/arm/configs/xcep_defconfig
@@ -73,7 +73,7 @@ CONFIG_SENSORS_MAX6650=m
 # CONFIG_VGA_CONSOLE is not set
 # CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_SA1100=m
 CONFIG_DMADEVICES=y
 # CONFIG_DNOTIFY is not set
diff --git a/arch/arm/configs/zeus_defconfig b/arch/arm/configs/zeus_defconfig
index 960f655..59577ad 100644
--- a/arch/arm/configs/zeus_defconfig
+++ b/arch/arm/configs/zeus_defconfig
@@ -158,7 +158,7 @@ CONFIG_LEDS_TRIGGER_HEARTBEAT=m
 CONFIG_LEDS_TRIGGER_BACKLIGHT=m
 CONFIG_LEDS_TRIGGER_GPIO=m
 CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_ISL1208=m
 CONFIG_RTC_DRV_PXA=m
 CONFIG_EXT2_FS=y
diff --git a/arch/avr32/configs/atngw100_mrmt_defconfig b/arch/avr32/configs/atngw100_mrmt_defconfig
index 19f6cee..fb6dab8 100644
--- a/arch/avr32/configs/atngw100_mrmt_defconfig
+++ b/arch/avr32/configs/atngw100_mrmt_defconfig
@@ -109,7 +109,7 @@ CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_S35390A=m
 CONFIG_RTC_DRV_AT32AP700X=m
 CONFIG_DMADEVICES=y
diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
index 31d9542..9f1d084 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -112,7 +112,7 @@ CONFIG_USB_G_SERIAL=m
 CONFIG_USB_G_PRINTER=m
 CONFIG_MMC=m
 CONFIG_SDH_BFIN=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_BFIN=m
 CONFIG_EXT2_FS=m
 # CONFIG_DNOTIFY is not set
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 37862b2..807c97e 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -678,7 +678,7 @@ CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_INTF_DEV_UIE_EMUL=y
 CONFIG_RTC_DRV_TEST=m
 CONFIG_RTC_DRV_DS1307=m
diff --git a/arch/powerpc/configs/52xx/pcm030_defconfig b/arch/powerpc/configs/52xx/pcm030_defconfig
index 7f7e4a8..22e7195 100644
--- a/arch/powerpc/configs/52xx/pcm030_defconfig
+++ b/arch/powerpc/configs/52xx/pcm030_defconfig
@@ -85,7 +85,7 @@ CONFIG_USB_OHCI_HCD=m
 CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
 # CONFIG_USB_OHCI_HCD_PCI is not set
 CONFIG_USB_STORAGE=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PCF8563=m
 CONFIG_EXT2_FS=m
 CONFIG_EXT3_FS=m
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index 6472322..185c292 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -141,7 +141,7 @@ CONFIG_USB_EHCI_TT_NEWSCHED=y
 # CONFIG_USB_EHCI_HCD_PPC_OF is not set
 CONFIG_USB_OHCI_HCD=m
 CONFIG_USB_STORAGE=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PS3=m
 CONFIG_EXT2_FS=m
 CONFIG_EXT3_FS=m
diff --git a/arch/sh/configs/titan_defconfig b/arch/sh/configs/titan_defconfig
index 0f55891..e2cbd92 100644
--- a/arch/sh/configs/titan_defconfig
+++ b/arch/sh/configs/titan_defconfig
@@ -227,7 +227,7 @@ CONFIG_USB_SERIAL=m
 CONFIG_USB_SERIAL_GENERIC=y
 CONFIG_USB_SERIAL_ARK3116=m
 CONFIG_USB_SERIAL_PL2303=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_SH=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
diff --git a/arch/unicore32/configs/debug_defconfig b/arch/unicore32/configs/debug_defconfig
index b5fbde9..1c367f0 100644
--- a/arch/unicore32/configs/debug_defconfig
+++ b/arch/unicore32/configs/debug_defconfig
@@ -168,7 +168,7 @@ CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 
 #	Real Time Clock
 CONFIG_RTC_LIB=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 
 ### File systems
 CONFIG_EXT2_FS=m
-- 
1.7.4.1

