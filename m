Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2AZRNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:13:07 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:55293 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2AZRNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:13:05 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/6] ARM: at91/at91sam9x5: Configuration and Makefile
Date: Thu, 26 Jan 2012 18:12:35 +0100
Message-Id: <7c887e9f8d137c834b2f2bbbe8c59d536b15c766.1327596859.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327597957-32662-1-git-send-email-nicolas.ferre@atmel.com>
References: <1327597957-32662-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <15809998b6ca8f1bf69546bfcac18301a70625ef.1327596859.git.nicolas.ferre@atmel.com>
References: <15809998b6ca8f1bf69546bfcac18301a70625ef.1327596859.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig and Makefile entries for SAM9x5 family.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig  |    9 +++++++++
 arch/arm/mach-at91/Makefile |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 0284e66..e55cdcb 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -102,6 +102,15 @@ config ARCH_AT91SAM9G45
 	select HAVE_AT91_DBGU1
 	select AT91_SAM9G45_RESET
 
+config ARCH_AT91SAM9X5
+	bool "AT91SAM9x5 family"
+	select CPU_ARM926T
+	select GENERIC_CLOCKEVENTS
+	select HAVE_FB_ATMEL
+	select HAVE_NET_MACB
+	select HAVE_AT91_DBGU0
+	select AT91_SAM9G45_RESET
+
 config ARCH_AT91X40
 	bool "AT91x40"
 	select ARCH_USES_GETTIMEOFFSET
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index aeb76f1..1b65185 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_ARCH_AT91SAM9263)	+= at91sam9263.o at91sam926x_time.o at91sam9263_d
 obj-$(CONFIG_ARCH_AT91SAM9RL)	+= at91sam9rl.o at91sam926x_time.o at91sam9rl_devices.o sam9_smc.o
 obj-$(CONFIG_ARCH_AT91SAM9G20)	+= at91sam9260.o at91sam926x_time.o at91sam9260_devices.o sam9_smc.o
 obj-$(CONFIG_ARCH_AT91SAM9G45)	+= at91sam9g45.o at91sam926x_time.o at91sam9g45_devices.o sam9_smc.o
+obj-$(CONFIG_ARCH_AT91SAM9X5)	+= at91sam9x5.o at91sam926x_time.o
 obj-$(CONFIG_ARCH_AT91X40)	+= at91x40.o at91x40_time.o
 
 # AT91RM9200 board-specific support
-- 
1.7.5.4

