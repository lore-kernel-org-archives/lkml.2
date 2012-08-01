Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2HARuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:50:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39570 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab2HARu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:50:27 -0400
From: Matt Sealey <matt@genesi-usa.com>
To: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Sealey <matt@genesi-usa.com>
Subject: [PATCH 1/4] efikamx: remove support for Genesi Efika MX from the build
Date: Wed,  1 Aug 2012 12:49:28 -0500
Message-Id: <1343843371-14143-2-git-send-email-matt@genesi-usa.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343843371-14143-1-git-send-email-matt@genesi-usa.com>
References: <1343843371-14143-1-git-send-email-matt@genesi-usa.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable building for Efika MX boards by not having any configuration or
object file definitions.

Signed-off-by: Matt Sealey <matt@genesi-usa.com>
---
 arch/arm/mach-imx/Kconfig  |   26 --------------------------
 arch/arm/mach-imx/Makefile |    3 ---
 2 files changed, 29 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index eff4db5..a8051fe 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -728,32 +728,6 @@ config MACH_EUKREA_MBIMXSD51_BASEBOARD
 
 endchoice
 
-config MX51_EFIKA_COMMON
-	bool
-	select SOC_IMX51
-	select IMX_HAVE_PLATFORM_IMX_UART
-	select IMX_HAVE_PLATFORM_MXC_EHCI
-	select IMX_HAVE_PLATFORM_PATA_IMX
-	select IMX_HAVE_PLATFORM_SDHCI_ESDHC_IMX
-	select IMX_HAVE_PLATFORM_SPI_IMX
-	select MXC_ULPI if USB_ULPI
-
-config MACH_MX51_EFIKAMX
-	bool "Support MX51 Genesi Efika MX nettop"
-	select LEDS_GPIO_REGISTER
-	select MX51_EFIKA_COMMON
-	help
-	  Include support for Genesi Efika MX nettop. This includes specific
-	  configurations for the board and its peripherals.
-
-config MACH_MX51_EFIKASB
-	bool "Support MX51 Genesi Efika Smartbook"
-	select LEDS_GPIO_REGISTER
-	select MX51_EFIKA_COMMON
-	help
-	  Include support for Genesi Efika Smartbook. This includes specific
-	  configurations for the board and its peripherals.
-
 comment "i.MX53 machines:"
 
 config MACH_IMX53_DT
diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index ff29421..ff6725d 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -88,9 +88,6 @@ obj-$(CONFIG_MACH_MX53_LOCO) += mach-mx53_loco.o
 obj-$(CONFIG_MACH_MX53_ARD) += mach-mx53_ard.o
 obj-$(CONFIG_MACH_EUKREA_CPUIMX51SD) += mach-cpuimx51sd.o
 obj-$(CONFIG_MACH_EUKREA_MBIMXSD51_BASEBOARD) += eukrea_mbimxsd51-baseboard.o
-obj-$(CONFIG_MX51_EFIKA_COMMON) += mx51_efika.o
-obj-$(CONFIG_MACH_MX51_EFIKAMX) += mach-mx51_efikamx.o
-obj-$(CONFIG_MACH_MX51_EFIKASB) += mach-mx51_efikasb.o
 obj-$(CONFIG_MACH_MX50_RDP) += mach-mx50_rdp.o
 
 obj-$(CONFIG_MACH_IMX51_DT) += imx51-dt.o
-- 
1.7.9.5

