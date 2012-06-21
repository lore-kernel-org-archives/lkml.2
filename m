Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab2FUJ5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:57:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35943 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759240Ab2FUJ5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:57:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>, Milo.Kim@ti.com
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: lp872x: Depend on I2C=y
Date: Thu, 21 Jun 2012 10:56:22 +0100
Message-Id: <1340272582-14617-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig doesn't do the right thing for us here.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index e056c09..27fe52f 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -234,7 +234,7 @@ config REGULATOR_LP3972
 
 config REGULATOR_LP872X
 	bool "TI/National Semiconductor LP8720/LP8725 voltage regulators"
-	depends on I2C
+	depends on I2C=y
 	select REGMAP_I2C
 	help
 	  This driver supports LP8720/LP8725 PMIC
-- 
1.7.10

