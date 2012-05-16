Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab2EPIGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:06:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754Ab2EPIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:05:58 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8400 needs to depend on I2C=y
Date: Wed, 16 May 2012 09:05:54 +0100
Message-Id: <1337155554-7115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 0ff6d54..ffb7c05 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -470,7 +470,7 @@ config MFD_S5M_CORE
 config MFD_WM8400
 	bool "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
-	depends on I2C
+	depends on I2C=y
 	select REGMAP_I2C
 	help
 	  Support for the Wolfson Microelecronics WM8400 PMIC and audio
-- 
1.7.10

