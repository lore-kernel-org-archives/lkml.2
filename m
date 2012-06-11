Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2FKPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:25:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34353 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2FKPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 04/14] mfd: Remove redundant Kconfig entry
Date: Mon, 11 Jun 2012 16:24:57 +0100
Message-Id: <1339428307-3850-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During ab8500-core clean-up the Kconfig entry for AB8500_I2C_CORE
was left remnant. This patch simply removes it.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
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

