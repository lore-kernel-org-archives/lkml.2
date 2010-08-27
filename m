Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab0H0Lzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:55:32 -0400
Received: from smtp.nokia.com ([192.100.105.134]:55757 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab0H0Lz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:55:29 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: [PATCH 2/3] drivers: misc: ak8974 support to Kconfig and Makefile
Date: Fri, 27 Aug 2010 14:54:42 +0300
Message-Id: <1282910083-8629-3-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 27 Aug 2010 11:54:51.0592 (UTC) FILETIME=[A8200C80:01CB45DE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/misc/Kconfig  |   11 +++++++++++
 drivers/misc/Makefile |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0b591b6..65615a8 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -314,6 +314,17 @@ config SENSORS_BH1780
 	  This driver can also be built as a module.  If so, the module
 	  will be called bh1780gli.
 
+config AK8974
+         tristate "AK8974 / AMI305 magnetometer chip";
+         depends on I2C
+         default n
+         ---help---
+           Say Y here if you want to build a driver for AK8974 / AMI305
+           magnetometer chip.
+
+           To compile this driver as a module, choose M here: the
+           module will be called ak8974. If unsure, say N here.
+
 config HMC6352
 	tristate "Honeywell HMC6352 compass"
 	depends on I2C
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 255a80d..4abc4b1 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
 obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_PHANTOM)		+= phantom.o
 obj-$(CONFIG_SENSORS_BH1780)	+= bh1780gli.o
+obj-$(CONFIG_AK8974)            += ak8974.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
-- 
1.6.3.3

