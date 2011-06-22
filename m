Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab1FVNyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:54:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41818 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753411Ab1FVNyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:54:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Don't ask about the TPS65912 core driver in Kconfig
Date: Wed, 22 Jun 2011 14:53:58 +0100
Message-Id: <1308750838-26534-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user has to select the I2C and SPI drivers individually and they select
the core driver for the device so there's no point in presenting the user
with an option for the core driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 5494413..c5edb8b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -172,7 +172,7 @@ config MFD_TPS6586X
 	  will be called tps6586x.
 
 config MFD_TPS65912
-	bool "TPS65912 PMIC"
+	bool
 	depends on GPIOLIB
 
 config MFD_TPS65912_I2C
-- 
1.7.5.4

