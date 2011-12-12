Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab1LLMdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:33:40 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:52079
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752274Ab1LLMdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:33:21 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <rtc-linux@googlegroups.com>
CC: <a.zummo@towertech.it>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 2/2] rtc: Rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC
Date: Mon, 12 Dec 2011 10:33:07 -0200
Message-ID: <1323693187-3466-2-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323548042-25432-1-git-send-email-festevam@gmail.com>
References: <1323548042-25432-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to keep consistency with other rtc drivers,rename CONFIG_RTC_MXC
to CONFIG_RTC_DRV_MXC.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
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


