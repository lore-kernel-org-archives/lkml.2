Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2JEREf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:04:35 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39054 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab2JERE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:04:26 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: [PATCH v4 6/7] ARM: davinci: clean up DA850 EVM include ordering
Date: Fri,  5 Oct 2012 13:04:45 -0400
Message-Id: <1349456686-22736-7-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349456686-22736-1-git-send-email-mporter@ti.com>
References: <1349456686-22736-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder includes so they are grouped by linux/mach/asm

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 1295e61..7359375 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -11,39 +11,39 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/console.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/i2c/at24.h>
 #include <linux/i2c/pca953x.h>
 #include <linux/input.h>
+#include <linux/input/tps6507x-ts.h>
 #include <linux/mfd/tps6507x.h>
-#include <linux/gpio.h>
-#include <linux/gpio_keys.h>
-#include <linux/platform_device.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_data/spi-davinci.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/tps6507x.h>
-#include <linux/input/tps6507x-ts.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
-#include <linux/delay.h>
 #include <linux/wl12xx.h>
 
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/system_info.h>
-
 #include <mach/cp_intc.h>
 #include <mach/da8xx.h>
-#include <linux/platform_data/mtd-davinci.h>
 #include <mach/mux.h>
-#include <linux/platform_data/mtd-davinci-aemif.h>
-#include <linux/platform_data/spi-davinci.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/system_info.h>
 
 #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
 #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
-- 
1.7.9.5

