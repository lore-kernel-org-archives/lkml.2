Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab2CVCMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:12:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53959 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab2CVCMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:12:08 -0400
Message-ID: <1332382320.13011.1.camel@phoenix>
Subject: [PATCH] mfd: Move MFD_TPS65090 and TPS65911_COMPARATOR Kconfig
 entries to proper location
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 22 Mar 2012 10:12:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group all TPSxxxx drivers together and sort by alphabetical order.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/Kconfig |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 29f463c..f9e0353 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -143,6 +143,18 @@ config TPS6507X
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps6507x.
 
+config MFD_TPS65090
+	bool "TPS65090 Power Management chips"
+	depends on I2C=y && GENERIC_HARDIRQS
+	select MFD_CORE
+	select REGMAP_I2C
+	help
+	  If you say yes here you get support for the TPS65090 series of
+	  Power Management chips.
+	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device.
+
 config MFD_TPS65217
 	tristate "TPS65217 Power Management / White LED chips"
 	depends on I2C
@@ -182,6 +194,9 @@ config MFD_TPS65910
 	  if you say yes here you get support for the TPS65910 series of
 	  Power Management chips.
 
+config TPS65911_COMPARATOR
+	tristate
+
 config MFD_TPS65912
 	bool
 	depends on GPIOLIB
@@ -825,21 +840,6 @@ config MFD_PM8XXX_IRQ
 	  This is required to use certain other PM 8xxx features, such as GPIO
 	  and MPP.
 
-config TPS65911_COMPARATOR
-	tristate
-
-config MFD_TPS65090
-	bool "TPS65090 Power Management chips"
-	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
-	select REGMAP_I2C
-	help
-	  If you say yes here you get support for the TPS65090 series of
-	  Power Management chips.
-	  This driver provides common support for accessing the device,
-	  additional drivers must be enabled in order to use the
-	  functionality of the device.
-
 config MFD_AAT2870_CORE
 	bool "Support for the AnalogicTech AAT2870"
 	select MFD_CORE
-- 
1.7.5.4



