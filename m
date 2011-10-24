Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab1JXNNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:13:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38050 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932478Ab1JXNNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:13:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Fix word wrap in Makefile
Date: Mon, 24 Oct 2011 15:12:57 +0200
Message-Id: <1319461978-17413-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

80 columns FTW.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 0573c8a..f331a90 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,4 +1,5 @@
-obj-$(CONFIG_REGMAP) += regmap.o regcache.o regcache-indexed.o regcache-rbtree.o regcache-lzo.o
+obj-$(CONFIG_REGMAP) += regmap.o regcache.o regcache-indexed.o
+obj-$(CONFIG_REGMAP) += regcache-rbtree.o regcache-lzo.o
 obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
 obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
-- 
1.7.6.3

