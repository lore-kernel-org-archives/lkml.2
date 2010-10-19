Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab0JSHKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:10:33 -0400
Received: from smtp.nokia.com ([147.243.1.47]:25478 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077Ab0JSHK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:10:29 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: akpm@linux-foundation.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv4 2/5] misc: update bh1770glc driver to Kconfig and Makefile
Date: Tue, 19 Oct 2010 10:09:45 +0300
Message-Id: <1287472188-10101-3-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation support for bh1770glc driver

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/misc/Kconfig  |   10 ++++++++++
 drivers/misc/Makefile |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b743312..a0ada25 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -314,6 +314,16 @@ config SENSORS_BH1780
 	  This driver can also be built as a module.  If so, the module
 	  will be called bh1780gli.
 
+config SENSORS_BH1770
+         tristate "BH1770GLC / SFH7770 combined ALS - Proximity sensor"
+         depends on I2C
+         ---help---
+           Say Y here if you want to build a driver for BH1770GLC (ROHM) or
+	   SFH7770 (Osram) combined ambient light and proximity sensor chip.
+
+           To compile this driver as a module, choose M here: the
+           module will be called bh1770glc. If unsure, say N here.
+
 config HMC6352
 	tristate "Honeywell HMC6352 compass"
 	depends on I2C
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 42eab95..f0567e0 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
 obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_PHANTOM)		+= phantom.o
 obj-$(CONFIG_SENSORS_BH1780)	+= bh1780gli.o
+obj-$(CONFIG_SENSORS_BH1770)	+= bh1770glc.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
-- 
1.6.0.4

