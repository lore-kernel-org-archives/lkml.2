Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0INHbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:31:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39216 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0INHbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:31:03 -0400
Date: Tue, 14 Sep 2010 16:30:53 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] I2C-GPIO: Don't include the asm/gpio.h directly
To: Haavard Skinnemoen <hskinnemoen@atmel.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Tejun Heo <tj@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-id: <20100914073053.GA15611@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 14 Sep 2010 07:30:59.0721 (UTC)
 FILETIME=[C707BF90:01CB53DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't include asm/gpio.h directly. Use the linux/gpio.h.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index d9aa9a6..0c1cc37 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -15,7 +15,7 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 
 /* Toggle SDA by changing the direction of the pin */
 static void i2c_gpio_setsda_dir(void *data, int state)
