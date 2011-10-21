Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab1JXPRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:17:04 -0400
Received: from [213.95.27.120] ([213.95.27.120]:39642 "EHLO
	ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932904Ab1JXPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:17:01 -0400
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH 3/3] mfd: Add S5M series configuration
Date: Fri, 21 Oct 2011 19:28:14 +0900
Message-Id: <1319192894-19292-4-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319192894-19292-1-git-send-email-sbkim73@samsung.com>
References: <1319192894-19292-1-git-send-email-sbkim73@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add S5M series configuration.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/Kconfig  |   12 ++++++++++++
 drivers/mfd/Makefile |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 21574bd..e280d2a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -386,6 +386,18 @@ config MFD_MAX8998
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
 
+config MFD_S5M_CORE
+	bool "SAMSUNG S5M Series Support"
+	depends on I2C=y && GENERIC_HARDIRQS
+	select MFD_CORE
+	select REGMAP_I2C
+	help
+	  Say yes here to support for SAMSUNG S5M series.
+	  This is a Power Management IC.
+	  This driver provies common support for accessing the device,
+	  additional drivers must be enabled in order to use the functionality
+	  of the device
+
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index c580203..dfd05a2 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -102,3 +102,4 @@ obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
 obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
+obj-$(CONFIG_MFD_S5M_CORE)	+= s5m-core.o s5m-irq.o
-- 
1.7.1

