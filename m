Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2ANUL3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:11:29 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:43957 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab2ANUKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:10:43 -0500
From: Sangbeom Kim <sbkim73@samsung.com>
To: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lrg@ti.com
Cc: Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH] regulator: Add S5M8767 configuration
Date: Fri, 13 Jan 2012 10:13:13 +0900
Message-Id: <1326417193-13509-1-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Samsung S5M8767A pmic configuration.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
MFD_S5M_CORE is merged with for-next branch on Samuel's MFD tree
---
 drivers/regulator/Kconfig  |    8 ++++++++
 drivers/regulator/Makefile |    2 ++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 5451ba6..3d4d4de 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -135,6 +135,14 @@ config REGULATOR_MAX8998
 	  via I2C bus. The provided regulator is suitable for S3C6410
 	  and S5PC1XX chips to control VCC_CORE and VCC_USIM voltages.
 
+config REGULATOR_S5M8767
+	tristate "Samsung S5M8767A voltage regulator"
+	depends on MFD_S5M_CORE
+	help
+	 This driver supports a Samsung S5M8767A voltage output regulator
+	 via I2C bus. S5M8767A have 9 Bucks and 28 LDOs output and
+	 supports DVS mode with 8bits of output voltage control.
+
 config REGULATOR_TWL4030
 	bool "TI TWL4030/TWL5030/TWL6030/TPS659x0 PMIC"
 	depends on TWL4030_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 0a4f7ad..1c4a0e3 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -47,5 +47,7 @@ obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_TPS62360) += tps62360-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
+obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
+
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
-- 
1.7.1

