Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab2BYDhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 22:37:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48190 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab2BYDhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 22:37:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.195.71 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330141014.10677.0.camel@phoenix>
Subject: [PATCH 1/2] mfd: include linux/mfd/pcf50633/pmic.h in
 pcf50633-gpio.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Harald Welte <laforge@openmoko.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Sat, 25 Feb 2012 11:36:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/mfd/pcf50633/pmic.h instead of duplicating the same defines.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/pcf50633-gpio.c |   27 +--------------------------
 1 files changed, 1 insertions(+), 26 deletions(-)

diff --git a/drivers/mfd/pcf50633-gpio.c b/drivers/mfd/pcf50633-gpio.c
index 9ab19a8..d02ddf2 100644
--- a/drivers/mfd/pcf50633-gpio.c
+++ b/drivers/mfd/pcf50633-gpio.c
@@ -19,32 +19,7 @@
 
 #include <linux/mfd/pcf50633/core.h>
 #include <linux/mfd/pcf50633/gpio.h>
-
-enum pcf50633_regulator_id {
-	PCF50633_REGULATOR_AUTO,
-	PCF50633_REGULATOR_DOWN1,
-	PCF50633_REGULATOR_DOWN2,
-	PCF50633_REGULATOR_LDO1,
-	PCF50633_REGULATOR_LDO2,
-	PCF50633_REGULATOR_LDO3,
-	PCF50633_REGULATOR_LDO4,
-	PCF50633_REGULATOR_LDO5,
-	PCF50633_REGULATOR_LDO6,
-	PCF50633_REGULATOR_HCLDO,
-	PCF50633_REGULATOR_MEMLDO,
-};
-
-#define PCF50633_REG_AUTOOUT	0x1a
-#define PCF50633_REG_DOWN1OUT	0x1e
-#define PCF50633_REG_DOWN2OUT	0x22
-#define PCF50633_REG_MEMLDOOUT	0x26
-#define PCF50633_REG_LDO1OUT	0x2d
-#define PCF50633_REG_LDO2OUT	0x2f
-#define PCF50633_REG_LDO3OUT	0x31
-#define PCF50633_REG_LDO4OUT	0x33
-#define PCF50633_REG_LDO5OUT	0x35
-#define PCF50633_REG_LDO6OUT	0x37
-#define PCF50633_REG_HCLDOOUT	0x39
+#include <linux/mfd/pcf50633/pmic.h>
 
 static const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
 	[PCF50633_REGULATOR_AUTO]	= PCF50633_REG_AUTOOUT,
-- 
1.7.5.4



