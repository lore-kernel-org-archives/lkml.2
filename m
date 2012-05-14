Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2ENJNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:13:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50919 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194Ab2ENJNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:13:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: wm8400: Don't support non-modular build
Date: Mon, 14 May 2012 10:13:15 +0100
Message-Id: <1336986796-31491-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's relying on non-exported symbols.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 8a767a6..0ff6d54 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -468,7 +468,7 @@ config MFD_S5M_CORE
 	 of the device
 
 config MFD_WM8400
-	tristate "Support Wolfson Microelectronics WM8400"
+	bool "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
 	depends on I2C
 	select REGMAP_I2C
-- 
1.7.10

