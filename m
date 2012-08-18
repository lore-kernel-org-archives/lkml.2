Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2HRQZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 12:25:20 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62696 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2HRQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 12:24:14 -0400
From: Fabio Estevam <festevam@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: [PATCH 02/11] AVR32: deconfig: Remove CONFIG_MISC_DEVICES
Date: Sat, 18 Aug 2012 13:23:46 -0300
Message-Id: <1345307035-3545-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345307035-3545-1-git-send-email-festevam@gmail.com>
References: <1345307035-3545-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 7c5763 (drivers:misc: Remove MISC_DEVICES config option) removed 
CONFIG_MISC_DEVICES option, so remove the occurrences from the config files 
as well.

Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/avr32/configs/atngw100_defconfig              |    1 -
 arch/avr32/configs/atngw100_evklcd100_defconfig    |    1 -
 arch/avr32/configs/atngw100_evklcd101_defconfig    |    1 -
 arch/avr32/configs/atngw100mkii_defconfig          |    1 -
 .../avr32/configs/atngw100mkii_evklcd100_defconfig |    1 -
 .../avr32/configs/atngw100mkii_evklcd101_defconfig |    1 -
 arch/avr32/configs/atstk1002_defconfig             |    1 -
 arch/avr32/configs/atstk1003_defconfig             |    1 -
 arch/avr32/configs/atstk1004_defconfig             |    1 -
 arch/avr32/configs/atstk1006_defconfig             |    1 -
 10 files changed, 10 deletions(-)

diff --git a/arch/avr32/configs/atngw100_defconfig b/arch/avr32/configs/atngw100_defconfig
index a06bfcc..8c5e2f4 100644
--- a/arch/avr32/configs/atngw100_defconfig
+++ b/arch/avr32/configs/atngw100_defconfig
@@ -71,7 +71,6 @@ CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_NETDEVICES=y
 CONFIG_TUN=m
diff --git a/arch/avr32/configs/atngw100_evklcd100_defconfig b/arch/avr32/configs/atngw100_evklcd100_defconfig
index d8f1fe8..2c3fb38 100644
--- a/arch/avr32/configs/atngw100_evklcd100_defconfig
+++ b/arch/avr32/configs/atngw100_evklcd100_defconfig
@@ -73,7 +73,6 @@ CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_NETDEVICES=y
 CONFIG_TUN=m
diff --git a/arch/avr32/configs/atngw100_evklcd101_defconfig b/arch/avr32/configs/atngw100_evklcd101_defconfig
index d4c5b19..4128b17 100644
--- a/arch/avr32/configs/atngw100_evklcd101_defconfig
+++ b/arch/avr32/configs/atngw100_evklcd101_defconfig
@@ -72,7 +72,6 @@ CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_NETDEVICES=y
 CONFIG_TUN=m
diff --git a/arch/avr32/configs/atngw100mkii_defconfig b/arch/avr32/configs/atngw100mkii_defconfig
index 6e0dca4..5df9467 100644
--- a/arch/avr32/configs/atngw100mkii_defconfig
+++ b/arch/avr32/configs/atngw100mkii_defconfig
@@ -73,7 +73,6 @@ CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_NETDEVICES=y
 CONFIG_TUN=m
diff --git a/arch/avr32/configs/atngw100mkii_evklcd100_defconfig b/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
index 7f2a344..d4448d1 100644
--- a/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
+++ b/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
@@ -76,7 +76,6 @@ CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_NETDEVICES=y
 CONFIG_TUN=m
diff --git a/arch/avr32/configs/atngw100mkii_evklcd101_defconfig b/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
index 085eeba..871ba06 100644
--- a/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
+++ b/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
@@ -75,7 +75,6 @@ CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_NETDEVICES=y
 CONFIG_TUN=m
diff --git a/arch/avr32/configs/atstk1002_defconfig b/arch/avr32/configs/atstk1002_defconfig
index d1a887e..6c60c25 100644
--- a/arch/avr32/configs/atstk1002_defconfig
+++ b/arch/avr32/configs/atstk1002_defconfig
@@ -64,7 +64,6 @@ CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_PWM=m
 CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=m
diff --git a/arch/avr32/configs/atstk1003_defconfig b/arch/avr32/configs/atstk1003_defconfig
index 956f281..f792302 100644
--- a/arch/avr32/configs/atstk1003_defconfig
+++ b/arch/avr32/configs/atstk1003_defconfig
@@ -53,7 +53,6 @@ CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_PWM=m
 CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=m
diff --git a/arch/avr32/configs/atstk1004_defconfig b/arch/avr32/configs/atstk1004_defconfig
index 40c69f3..39d1224 100644
--- a/arch/avr32/configs/atstk1004_defconfig
+++ b/arch/avr32/configs/atstk1004_defconfig
@@ -53,7 +53,6 @@ CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_PWM=m
 CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=m
diff --git a/arch/avr32/configs/atstk1006_defconfig b/arch/avr32/configs/atstk1006_defconfig
index 511eb8a..704c696 100644
--- a/arch/avr32/configs/atstk1006_defconfig
+++ b/arch/avr32/configs/atstk1006_defconfig
@@ -67,7 +67,6 @@ CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_MISC_DEVICES=y
 CONFIG_ATMEL_PWM=m
 CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=m
-- 
1.7.9.5

