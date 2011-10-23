Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab1JWIHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:07:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33537 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1JWIH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:07:29 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-94-4ea3cb4033fc
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Sangbeom Kim'" <sbkim73@samsung.com>
Subject: [PATCH 3/3] mfd: Add S5M series configuration
Date: Sun, 23 Oct 2011 17:07:28 +0900
Message-id: <009401cc915a$ce92e7c0$6bb8b740$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyRWs50Bli0Yw+eSuWRq6icARZIwA==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Samsung S5M series configuration.

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
 	  additional drivers must be enabled in order to use the
functionality
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
+	  additional drivers must be enabled in order to use the
functionality
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


