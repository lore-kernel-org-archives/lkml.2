Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2BHNJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:09:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65248 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2BHNJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:09:43 -0500
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, w.sang@pengutronix.de,
        akpm@linux-foundation.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [RESEND PATCH v2 2/2] rtc: Rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC
Date: Wed,  8 Feb 2012 11:09:30 -0200
Message-Id: <1328706570-1869-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323693187-3466-1-git-send-email-fabio.estevam@freescale.com>
References: <1323693187-3466-1-git-send-email-fabio.estevam@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to keep consistency with other rtc drivers,rename CONFIG_RTC_MXC
to CONFIG_RTC_DRV_MXC.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 arch/arm/configs/imx_v4_v5_defconfig |    2 +-
 arch/arm/configs/mx3_defconfig       |    2 +-
 arch/arm/configs/mx5_defconfig       |    2 +-
 drivers/rtc/Kconfig                  |    2 +-
 drivers/rtc/Makefile                 |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/configs/imx_v4_v5_defconfig b/arch/arm/configs/imx_v4_v5_defconfig
index 11a4192..bb22ead 100644
--- a/arch/arm/configs/imx_v4_v5_defconfig
+++ b/arch/arm/configs/imx_v4_v5_defconfig
@@ -149,7 +149,7 @@ CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PCF8563=y
 CONFIG_RTC_DRV_IMXDI=y
-CONFIG_RTC_MXC=y
+CONFIG_RTC_DRV_MXC=y
 CONFIG_DMADEVICES=y
 CONFIG_IMX_SDMA=y
 CONFIG_IMX_DMA=y
diff --git a/arch/arm/configs/mx3_defconfig b/arch/arm/configs/mx3_defconfig
index cb0717f..b69bd64 100644
--- a/arch/arm/configs/mx3_defconfig
+++ b/arch/arm/configs/mx3_defconfig
@@ -128,7 +128,7 @@ CONFIG_USB_ULPI=y
 CONFIG_MMC=y
 CONFIG_MMC_MXC=y
 CONFIG_RTC_CLASS=y
-CONFIG_RTC_MXC=y
+CONFIG_RTC_DRV_MXC=y
 CONFIG_DMADEVICES=y
 # CONFIG_DNOTIFY is not set
 CONFIG_TMPFS=y
diff --git a/arch/arm/configs/mx5_defconfig b/arch/arm/configs/mx5_defconfig
index d0d8dfe..fb17fd9 100644
--- a/arch/arm/configs/mx5_defconfig
+++ b/arch/arm/configs/mx5_defconfig
@@ -132,7 +132,7 @@ CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_INTF_DEV_UIE_EMUL=y
-CONFIG_RTC_MXC=y
+CONFIG_RTC_DRV_MXC=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_POSIX_ACL=y
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index a5ed7cc..5a8efee 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1059,7 +1059,7 @@ config RTC_DRV_PUV3
 	  This drive can also be built as a module. If so, the module
 	  will be called rtc-puv3.
 
-config RTC_MXC
+config RTC_DRV_MXC
 	tristate "Freescale MXC Real Time Clock"
 	depends on ARCH_MXC
 	depends on RTC_CLASS
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 6e69823..1e1d26e 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -59,7 +59,7 @@ obj-$(CONFIG_RTC_DRV_M41T94)	+= rtc-m41t94.o
 obj-$(CONFIG_RTC_DRV_M48T35)	+= rtc-m48t35.o
 obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
 obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
-obj-$(CONFIG_RTC_MXC)		+= rtc-mxc.o
+obj-$(CONFIG_RTC_DRV_MXC)	+= rtc-mxc.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX8925)	+= rtc-max8925.o
 obj-$(CONFIG_RTC_DRV_MAX8998)	+= rtc-max8998.o
-- 
1.7.1

