Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab2E3EuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 00:50:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43184 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2E3Esy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 00:48:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 18/22] mfd: Remove redundant Kconfig entry
Date: Wed, 30 May 2012 12:47:36 +0800
Message-Id: <1338353260-10097-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During ab8500-core clean-up the Kconfig entry for AB8500_I2C_CORE
was left remnant. This patch simply removes it.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/Kconfig |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 11a1b65..b697136 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -660,16 +660,6 @@ config AB8500_CORE
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

