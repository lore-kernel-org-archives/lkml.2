Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1DOMEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 08:04:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50856 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1DOMEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 08:04:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VlitXVWQMpuFt4z7jQsMyaT0AcBgdjbisv2LGV7zOGdb0XIH+ufDlI4AMIRSp1h13E
         5w3rzyhLfvPNqIH3GsRaU/DsXf/NNmqHK2XuMRv+wlDL/++AHcZ8fHgdWF6N1tpBopDf
         3IV4e6oYxWDA0rmZY6CXypXfed6WvA6+qqrGs=
Subject: [PATCH 1/2] mfd: Group TPSxxxxx power management chips together
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 20:04:45 +0800
Message-ID: <1302869085.7230.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group TPSxxxxx power management chips together and sort in alphabetical order.
This change makes it easier for users to find config options.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/Kconfig |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3ed3ff0..8ffd146 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -157,6 +157,20 @@ config TPS6507X
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps6507x.
 
+config MFD_TPS6586X
+	bool "TPS6586x Power Management chips"
+	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
+	select MFD_CORE
+	help
+	  If you say yes here you get support for the TPS6586X series of
+	  Power Management chips.
+	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called tps6586x.
+
 config MENELAUS
 	bool "Texas Instruments TWL92330/Menelaus PM chip"
 	depends on I2C=y && ARCH_OMAP2
@@ -629,20 +643,6 @@ config MFD_JZ4740_ADC
 	  Say yes here if you want support for the ADC unit in the JZ4740 SoC.
 	  This driver is necessary for jz4740-battery and jz4740-hwmon driver.
 
-config MFD_TPS6586X
-	bool "TPS6586x Power Management chips"
-	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
-	select MFD_CORE
-	help
-	  If you say yes here you get support for the TPS6586X series of
-	  Power Management chips.
-	  This driver provides common support for accessing the device,
-	  additional drivers must be enabled in order to use the
-	  functionality of the device.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called tps6586x.
-
 config MFD_VX855
 	tristate "Support for VIA VX855/VX875 integrated south bridge"
 	depends on PCI
-- 
1.7.1



