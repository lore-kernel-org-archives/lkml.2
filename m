Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0CWXF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:05:26 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36932 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab0CWXFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:05:25 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] arm: Remove GENERIC_TIME cruft
Date: Tue, 23 Mar 2010 16:05:22 -0700
Message-Id: <1269385522-2525-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1269385522-2525-1-git-send-email-johnstul@us.ibm.com>
References: <1269385522-2525-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Against linux-next next-20100323)

This patch will likely collide, but tries to remove the select GENERIC_TIME
cruft left over from the conversion to ARCH_USES_GETTIMEOFFSET.

This split was done to ease merging of the prior patch, and this
change is not critical. Just simple cleanup.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/Kconfig           |   26 --------------------------
 arch/arm/mach-at91/Kconfig |   10 ----------
 2 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d77f934..c4c3e1d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -247,7 +247,6 @@ config ARCH_INTEGRATOR
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_VERSATILE
 	help
@@ -259,7 +258,6 @@ config ARCH_REALVIEW
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PLAT_VERSATILE
@@ -274,7 +272,6 @@ config ARCH_VERSATILE
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PLAT_VERSATILE
@@ -289,7 +286,6 @@ config ARCH_VEXPRESS
 	select ARM_TIMER_SP804
 	select COMMON_CLKDEV
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 	select HAVE_CLK
 	select ICST
 	select PLAT_VERSATILE
@@ -312,7 +308,6 @@ config ARCH_BCMRING
 	select CPU_V6
 	select ARM_AMBA
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
@@ -371,7 +366,6 @@ config ARCH_FOOTBRIDGE
 
 config ARCH_MXC
 	bool "Freescale MXC/iMX-based"
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
@@ -385,7 +379,6 @@ config ARCH_STMP3XXX
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select USB_ARCH_HAS_EHCI
@@ -397,7 +390,6 @@ config ARCH_NETX
 	select CPU_ARM926T
 	select ARM_VIC
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 	help
 	  This enables support for systems based on the Hilscher NetX Soc
 
@@ -469,7 +461,6 @@ config ARCH_IXP4XX
 	depends on MMU
 	select CPU_XSCALE
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select DMABOUNCE if PCI
 	help
@@ -495,7 +486,6 @@ config ARCH_DOVE
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -507,7 +497,6 @@ config ARCH_KIRKWOOD
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -517,7 +506,6 @@ config ARCH_KIRKWOOD
 config ARCH_LOKI
 	bool "Marvell Loki (88RC8480)"
 	select CPU_FEROCEON
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -529,7 +517,6 @@ config ARCH_MV78XX0
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -543,7 +530,6 @@ config ARCH_ORION5X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -558,7 +544,6 @@ config ARCH_MMP
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	select PLAT_PXA
@@ -579,7 +564,6 @@ config ARCH_NS9XXX
 	bool "NetSilicon NS9xxx"
 	select CPU_ARM926T
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	help
@@ -595,7 +579,6 @@ config ARCH_W90X900
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Nuvoton (Winbond logic dept.) ARM9 processor,
@@ -633,7 +616,6 @@ config ARCH_PXA
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	select PLAT_PXA
@@ -643,7 +625,6 @@ config ARCH_PXA
 config ARCH_MSM
 	bool "Qualcomm MSM"
 	select CPU_V6
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Qualcomm MSM7K based systems.  This runs on the ARM11
@@ -680,7 +661,6 @@ config ARCH_SA1100
 	select ARCH_HAS_CPUFREQ
 	select CPU_FREQ
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select TICK_ONESHOT
@@ -788,7 +768,6 @@ config ARCH_U300
 	select HAVE_TCM
 	select ARM_AMBA
 	select ARM_VIC
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select COMMON_CLKDEV
@@ -800,7 +779,6 @@ config ARCH_U8500
 	bool "ST-Ericsson U8500 Series"
 	select CPU_V7
 	select ARM_AMBA
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select COMMON_CLKDEV
 	help
@@ -813,7 +791,6 @@ config ARCH_NOMADIK
 	select CPU_ARM926T
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
@@ -823,7 +800,6 @@ config ARCH_NOMADIK
 config ARCH_DAVINCI
 	bool "TI DaVinci"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
@@ -842,7 +818,6 @@ config ARCH_OMAP
 	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_CPUFREQ
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	help
@@ -977,7 +952,6 @@ config ARCH_ACORN
 config PLAT_IOP
 	bool
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 
 config PLAT_ORION
 	bool
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 8a5e8e9..2d040a4 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -23,14 +23,12 @@ choice
 config ARCH_AT91RM9200
 	bool "AT91RM9200"
 	select CPU_ARM920T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 
 config ARCH_AT91SAM9260
 	bool "AT91SAM9260 or AT91SAM9XE"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_AT91_USART4
@@ -39,28 +37,24 @@ config ARCH_AT91SAM9260
 config ARCH_AT91SAM9261
 	bool "AT91SAM9261"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9G10
 	bool "AT91SAM9G10"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9263
 	bool "AT91SAM9263"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9RL
 	bool "AT91SAM9RL"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_FB_ATMEL
@@ -68,7 +62,6 @@ config ARCH_AT91SAM9RL
 config ARCH_AT91SAM9G20
 	bool "AT91SAM9G20"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_AT91_USART4
@@ -77,7 +70,6 @@ config ARCH_AT91SAM9G20
 config ARCH_AT91SAM9G45
 	bool "AT91SAM9G45"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_FB_ATMEL
@@ -85,14 +77,12 @@ config ARCH_AT91SAM9G45
 config ARCH_AT91CAP9
 	bool "AT91CAP9"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT572D940HF
 	bool "AT572D940HF"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91X40
-- 
1.6.0.4

