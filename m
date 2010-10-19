Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702Ab0JSHKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:10:31 -0400
Received: from smtp.nokia.com ([147.243.1.47]:25482 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758078Ab0JSHK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:10:29 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: akpm@linux-foundation.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv4 4/5] misc: update apds990x driver to Kconfig and Makefile
Date: Tue, 19 Oct 2010 10:09:47 +0300
Message-Id: <1287472188-10101-5-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation support for apds990x driver

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/misc/Kconfig  |   11 +++++++++++
 drivers/misc/Makefile |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a0ada25..11fd137 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -324,6 +324,17 @@ config SENSORS_BH1770
            To compile this driver as a module, choose M here: the
            module will be called bh1770glc. If unsure, say N here.
 
+config SENSORS_APDS990X
+	 tristate "APDS990X combined als and proximity sensors"
+	 depends on I2C
+	 default n
+	 ---help---
+	   Say Y here if you want to build a driver for Avago APDS990x
+	   combined ambient light and proximity sensor chip.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called apds990x. If unsure, say N here.
+
 config HMC6352
 	tristate "Honeywell HMC6352 compass"
 	depends on I2C
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index f0567e0..7dbc3d0 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_PHANTOM)		+= phantom.o
 obj-$(CONFIG_SENSORS_BH1780)	+= bh1780gli.o
 obj-$(CONFIG_SENSORS_BH1770)	+= bh1770glc.o
+obj-$(CONFIG_SENSORS_APDS990X)	+= apds990x.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
-- 
1.6.0.4

