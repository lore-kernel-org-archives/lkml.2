Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab0JEJnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:43:53 -0400
Received: from smtp.nokia.com ([192.100.122.233]:61960 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab0JEJnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:43:50 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] misc: update bhsfh driver to Kconfig and Makefile
Date: Tue,  5 Oct 2010 12:42:56 +0300
Message-Id: <1286271779-19819-3-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 05 Oct 2010 09:43:05.0152 (UTC) FILETIME=[B5A14C00:01CB6471]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation support for bhsfh driver

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/misc/Kconfig  |   10 ++++++++++
 drivers/misc/Makefile |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b743312..f2e8065 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -314,6 +314,16 @@ config SENSORS_BH1780
 	  This driver can also be built as a module.  If so, the module
 	  will be called bh1780gli.
 
+config SENSORS_BHSFH
+         tristate "BH1770GLC / SFH7770 combined ALS / Proximity sensor";
+         depends on I2C
+         ---help---
+           Say Y here if you want to build a driver for BH1770GLC / SFH7770
+           combined ambient light and proximity sensor chip
+
+           To compile this driver as a module, choose M here: the
+           module will be called bhsfh. If unsure, say N here.
+
 config HMC6352
 	tristate "Honeywell HMC6352 compass"
 	depends on I2C
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 42eab95..fd5a4b7 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
 obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_PHANTOM)		+= phantom.o
 obj-$(CONFIG_SENSORS_BH1780)	+= bh1780gli.o
+obj-$(CONFIG_SENSORS_BHSFH)	+= bhsfh.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
-- 
1.6.0.4

