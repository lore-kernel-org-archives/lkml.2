Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1LTAno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:43:44 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717Ab1LTAni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:43:38 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Tony Lindgren <tony@atomide.com> (maintainer:OMAP SUPPORT),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-omap@vger.kernel.org (open list:OMAP SUPPORT),
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT)
Subject: [PATCH 04/10] arm: omap2: fix regulator warnings
Date: Tue, 20 Dec 2011 02:42:21 +0200
Message-Id: <1324341747-5922-5-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3 && MACH_OMAP_4430SDP && MACH_OMAP4_PANDA && TPS6105X) selects REGULATOR_FIXED_VOLTAGE which has unmet direct dependencies (REGULATOR)

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/arm/mach-omap2/Kconfig |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index dbecb9a..04734b5 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -205,7 +205,7 @@ config MACH_OMAP3_PANDORA
 	depends on ARCH_OMAP3
 	default y
 	select OMAP_PACKAGE_CBB
-	select REGULATOR_FIXED_VOLTAGE
+	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
 config MACH_OMAP3_TOUCHBOOK
 	bool "OMAP3 Touch Book"
@@ -256,7 +256,7 @@ config MACH_OMAP_ZOOM2
 	select SERIAL_8250
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_8250_CONSOLE
-	select REGULATOR_FIXED_VOLTAGE
+	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
 config MACH_OMAP_ZOOM3
 	bool "OMAP3630 Zoom3 board"
@@ -266,7 +266,7 @@ config MACH_OMAP_ZOOM3
 	select SERIAL_8250
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_8250_CONSOLE
-	select REGULATOR_FIXED_VOLTAGE
+	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
 config MACH_CM_T35
 	bool "CompuLab CM-T35/CM-T3730 modules"
@@ -320,7 +320,7 @@ config MACH_OMAP_4430SDP
 	depends on ARCH_OMAP4
 	select OMAP_PACKAGE_CBL
 	select OMAP_PACKAGE_CBS
-	select REGULATOR_FIXED_VOLTAGE
+	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
 config MACH_OMAP4_PANDA
 	bool "OMAP4 Panda Board"
@@ -328,7 +328,7 @@ config MACH_OMAP4_PANDA
 	depends on ARCH_OMAP4
 	select OMAP_PACKAGE_CBL
 	select OMAP_PACKAGE_CBS
-	select REGULATOR_FIXED_VOLTAGE
+	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
 config OMAP3_EMU
 	bool "OMAP3 debugging peripherals"
-- 
1.7.8.rc1.14.g248db

