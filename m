Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2A0UKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:10:21 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38382 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2A0UKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:10:20 -0500
From: Fabio Estevam <festevam@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: gxt@mprc.pku.edu.cn, khilman@ti.com, nsekhar@ti.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] davinci/unicore: Remove MISC_DEVICES selection
Date: Fri, 27 Jan 2012 18:10:09 -0200
Message-Id: <1327695009-20525-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 7c5763b8 (drivers: misc: Remove MISC_DEVICES config option)
MISC_DEVICES symbol is no longer present, so remove its selection

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/arm/mach-davinci/Kconfig |    6 ------
 arch/unicore32/Kconfig        |    1 -
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index 32d837d..0e5f0a1 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -61,7 +61,6 @@ config MACH_DAVINCI_EVM
 	bool "TI DM644x EVM"
 	default ARCH_DAVINCI_DM644x
 	depends on ARCH_DAVINCI_DM644x
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
@@ -71,7 +70,6 @@ config MACH_DAVINCI_EVM
 config MACH_SFFSDR
 	bool "Lyrtech SFFSDR"
 	depends on ARCH_DAVINCI_DM644x
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
@@ -105,7 +103,6 @@ config MACH_DAVINCI_DM6467_EVM
 	default ARCH_DAVINCI_DM646x
 	depends on ARCH_DAVINCI_DM646x
 	select MACH_DAVINCI_DM6467TEVM
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
@@ -119,7 +116,6 @@ config MACH_DAVINCI_DM365_EVM
 	bool "TI DM365 EVM"
 	default ARCH_DAVINCI_DM365
 	depends on ARCH_DAVINCI_DM365
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
@@ -131,7 +127,6 @@ config MACH_DAVINCI_DA830_EVM
 	default ARCH_DAVINCI_DA830
 	depends on ARCH_DAVINCI_DA830
 	select GPIO_PCF857X
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
@@ -218,7 +213,6 @@ config MACH_TNETV107X
 config MACH_MITYOMAPL138
 	bool "Critical Link MityDSP-L138/MityARM-1808 SoM"
 	depends on ARCH_DAVINCI_DA850
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index eeb8054..7c4224a 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -242,7 +242,6 @@ config I2C_BATTERY_BQ27200
 config I2C_EEPROM_AT24
 	tristate "I2C EEPROMs AT24 support"
 	select I2C_PUV3
-	select MISC_DEVICES
 	select EEPROM_AT24
 
 config LCD_BACKLIGHT
-- 
1.7.1

