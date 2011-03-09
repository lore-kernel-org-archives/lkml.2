Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab1CIOs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:48:58 -0500
Received: from smtp.nokia.com ([147.243.128.26]:41698 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666Ab1CIOsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:48:53 -0500
From: aliaksei.katovich@nokia.com
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>
Subject: [PATCH 2/2] mfd: bq2415x compilation enablers
Date: Wed,  9 Mar 2011 16:48:04 +0200
Message-Id: <e80110d2051e61d1214bfc4150392793ece110d3.1299679848.git.aliaksei.katovich@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <"cover.1299679848.git.aliaksei.katovich@nokia.com">
In-Reply-To: <cover.1299679848.git.aliaksei.katovich@nokia.com>
References: <"cover.1299679848.git.aliaksei.katovich@nokia.com">
References: <cover.1299679848.git.aliaksei.katovich@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aliaksei Katovich <aliaksei.katovich@nokia.com>

Enable compilation of bq2415x charger driver

Signed-off-by: Aliaksei Katovich <aliaksei.katovich@nokia.com>
---
 drivers/mfd/Kconfig  |    7 +++++++
 drivers/mfd/Makefile |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fd01836..d0ab44a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -624,6 +624,13 @@ config MFD_WL1273_CORE
 	  driver connects the radio-wl1273 V4L2 module and the wl1273
 	  audio codec.
 
+config MFD_BQ2415X
+	tristate "TI bq24153/6 one-cell Li-Ion charger IC"
+	depends on I2C && REGULATOR
+	help
+	  This driver supports TI bq24153/6 integrated switch-mode chargers
+	  attached to i2c.
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index a54e2c7..a0df0db 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -83,3 +83,4 @@ obj-$(CONFIG_MFD_TPS6586X)	+= tps6586x.o
 obj-$(CONFIG_MFD_VX855)		+= vx855.o
 obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
+obj-$(CONFIG_MFD_BQ2415X)	+= bq2415x.o
-- 
1.7.0.4

