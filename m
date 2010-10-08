Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0JHNm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:42:27 -0400
Received: from smtp.nokia.com ([192.100.105.134]:46848 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab0JHNm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:42:26 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        alan@lxorguk.ukuu.org.uk
Subject: [PATCHv2 2/5] misc: update bhsfh driver to Kconfig and Makefile
Date: Fri,  8 Oct 2010 16:42:01 +0300
Message-Id: <1286545324-18506-3-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 08 Oct 2010 13:42:13.0296 (UTC) FILETIME=[9D079300:01CB66EE]
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

