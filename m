Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1LXPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 10:09:28 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:34940 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1LXPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 10:09:25 -0500
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH v2 5/5] regulator: Add S5M8767 configuration
Date: Fri, 23 Dec 2011 17:28:12 +0900
Message-Id: <1324628892-12170-6-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1324628892-12170-1-git-send-email-sbkim73@samsung.com>
References: <1324628892-12170-1-git-send-email-sbkim73@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Samsung S5M8767 pmic configuration.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/Kconfig  |    8 ++++++++
 drivers/regulator/Makefile |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 9713b1b..a047185 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -135,6 +135,14 @@ config REGULATOR_MAX8998
 	  via I2C bus. The provided regulator is suitable for S3C6410
 	  and S5PC1XX chips to control VCC_CORE and VCC_USIM voltages.
 
+config REGULATOR_S5M8767
+	tristate "Samsung S5M8767 voltage regulator"
+	depends on MFD_S5M_CORE
+	help
+	 This driver supports a Samsung S5M8767 voltage output regulator
+	 via I2C bus. S5M8767 have 9 Bucks and 28 LDOs output and
+	 supports 8 DVS modes ranging from 0.65V to 2.225V.
+
 config REGULATOR_TWL4030
 	bool "TI TWL4030/TWL5030/TWL6030/TPS659x0 PMIC"
 	depends on TWL4030_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 93a6318..efcbc36 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -46,5 +46,6 @@ obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
+obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
-- 
1.7.1

