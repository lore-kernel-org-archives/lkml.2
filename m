Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0IPKOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 06:14:03 -0400
Received: from smtp.nokia.com ([192.100.122.230]:20238 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0IPKOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 06:14:00 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: rpurdie@linux.intel.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] leds: Update LP552x support Kconfig and Makefile
Date: Thu, 16 Sep 2010 13:12:25 +0300
Message-Id: <1284631946-5350-4-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1284631946-5350-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1284631946-5350-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 16 Sep 2010 10:12:35.0676 (UTC) FILETIME=[AF1891C0:01CB5587]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide configuration and compilation support for LP5521 and LP5523

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/leds/Kconfig  |   18 ++++++++++++++++++
 drivers/leds/Makefile |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index e411262..c789087 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -176,6 +176,24 @@ config LEDS_LP3944
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-lp3944.
 
+config LEDS_LP5521
+	tristate "LED Support for N.S. LP5521 LED driver chip"
+	depends on LEDS_CLASS && I2C
+	help
+	  If you say yes here you get support for the National Semiconductor
+	  LP5521 LED driver. It is 3 channel chip with programmable engines.
+	  Driver provides direct control via LED class and interface for
+	  programming the engines.
+
+config LEDS_LP5523
+	tristate "LED Support for N.S. LP5523 LED driver chip"
+	depends on LEDS_CLASS && I2C
+	help
+	  If you say yes here you get support for the National Semiconductor
+	  LP5523 LED driver. It is 9 channel chip with programmable engines.
+	  Driver provides direct control via LED class and interface for
+	  programming the engines.
+
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook"
 	depends on X86 && SERIO_I8042 && DMI
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 7d6b958..2ba98f6 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -23,6 +23,8 @@ obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunfire.o
 obj-$(CONFIG_LEDS_PCA9532)		+= leds-pca9532.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
+obj-$(CONFIG_LEDS_LP5521)		+= leds-lp5521.o
+obj-$(CONFIG_LEDS_LP5523)		+= leds-lp5523.o
 obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
-- 
1.6.0.4

