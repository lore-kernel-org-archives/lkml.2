Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2E2GTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:19:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62532 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2E2GTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:19:11 -0400
Message-ID: <1338272340.3127.1.camel@phoenix>
Subject: [PATCH] mfd: Remove config AB8500_I2C_CORE Kconfig entry
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 29 May 2012 14:19:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config AB8500_I2C_CORE is not used after commit d28f1db
"mfd: Remove confusing ab8500-i2c file and merge into ab8500-core".
Thus remove it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/Kconfig |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e129c82..170072e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -703,16 +703,6 @@ config AB8500_CORE
 	  the irq_chip parts for handling the Mixed Signal chip events.
 	  This chip embeds various other multimedia funtionalities as well.
 
-config AB8500_I2C_CORE
-	bool "AB8500 register access via PRCMU I2C"
-	depends on AB8500_CORE && MFD_DB8500_PRCMU
-	default y
-	help
-	  This enables register access to the AB8500 chip via PRCMU I2C.
-	  The AB8500 chip can be accessed via SPI or I2C. On DB8500 hardware
-	  the I2C bus is connected to the Power Reset
-	  and Mangagement Unit, PRCMU.
-
 config AB8500_DEBUG
        bool "Enable debug info via debugfs"
        depends on AB8500_CORE && DEBUG_FS
-- 
1.7.9.5



