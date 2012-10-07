Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2JGHiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 03:38:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52099 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2JGHiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 03:38:02 -0400
Message-ID: <1349595470.15349.1.camel@phoenix>
Subject: [PATCH] mfd: Remove incorrect Kconfig help text for MFD_TPS6586X,
 MFD_SMSC and MFD_DA9055
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mike Rapoport <mike@compulab.co.il>, Sourav Poddar <sourav.poddar@ti.com>,
        David Dajun Chen <dchen@diasemi.com>, linux-kernel@vger.kernel.org
Date: Sun, 07 Oct 2012 15:37:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For MFD_TPS6586X, MFD_SMSC and MFD_DA9055, these drivers can only be built as
built-in, thus remove incorrect help text in Kconfig entries.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/Kconfig |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index acab3ef..35a1877 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -209,9 +209,6 @@ config MFD_TPS6586X
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
-	  This driver can also be built as a module.  If so, the module
-	  will be called tps6586x.
-
 config MFD_TPS65910
 	bool "TPS65910 Power Management chip"
 	depends on I2C=y && GPIOLIB
@@ -384,9 +381,6 @@ config MFD_SMSC
         If you say yes here you get support for the
         ece1099 chips from SMSC.
 
-        To compile this driver as a module, choose M here: the
-        module will be called smsc.
-
 config MFD_TC6387XB
 	bool "Support Toshiba TC6387XB"
 	depends on ARM && HAVE_CLK
@@ -457,9 +451,6 @@ config MFD_DA9055
 	  Additional drivers must be enabled in order to use the functionality
 	  of the device.
 
-	  This driver can be built as a module. If built as a module it will be
-	  called "da9055"
-
 config PMIC_ADP5520
 	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
 	depends on I2C=y
-- 
1.7.9.5



