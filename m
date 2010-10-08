Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0JHNma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:42:30 -0400
Received: from smtp.nokia.com ([192.100.105.134]:46854 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab0JHNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:42:27 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        alan@lxorguk.ukuu.org.uk
Subject: [PATCHv2 4/5] misc: update apds990x driver to Kconfig and Makefile
Date: Fri,  8 Oct 2010 16:42:03 +0300
Message-Id: <1286545324-18506-5-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 08 Oct 2010 13:42:16.0625 (UTC) FILETIME=[9F038A10:01CB66EE]
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
index f2e8065..cc7c363 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -324,6 +324,17 @@ config SENSORS_BHSFH
            To compile this driver as a module, choose M here: the
            module will be called bhsfh. If unsure, say N here.
 
+config SENSORS_APDS990X
+	 tristate "APDS990X combined als and proximity sensors"
+	 depends on I2C
+	 default n
+	 ---help---
+	   Say Y here if you want to build a driver for Avago APDS990x
+	   combined ambient light and proximity sensor chip
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called apds990x. If unsure, say N here.
+
 config HMC6352
 	tristate "Honeywell HMC6352 compass"
 	depends on I2C
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index fd5a4b7..b90cea7 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_PHANTOM)		+= phantom.o
 obj-$(CONFIG_SENSORS_BH1780)	+= bh1780gli.o
 obj-$(CONFIG_SENSORS_BHSFH)	+= bhsfh.o
+obj-$(CONFIG_SENSORS_APDS990X)	+= apds990x.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
-- 
1.6.0.4

