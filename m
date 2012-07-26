Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab2GZOLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:11:54 -0400
Received: from mail2.matrix-vision.com ([85.214.244.251]:45561 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2GZOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:11:53 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2012 10:11:53 EDT
From: Michael Jones <michael.jones@matrix-vision.de>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] regulator: whitespace
Date: Thu, 26 Jul 2012 16:07:23 +0200
Message-Id: <1343311644-19739-2-git-send-email-michael.jones@matrix-vision.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1343311644-19739-1-git-send-email-michael.jones@matrix-vision.de>
References: <1343311644-19739-1-git-send-email-michael.jones@matrix-vision.de>
X-MV-Disclaimer: true (erinome)
X-AV-Checked: ClamAV using ClamSMTP (erinome)
X-AV-Checked: ClamAV using ClamSMTP (mail2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 drivers/regulator/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index c86b886..403503f 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -49,11 +49,11 @@ config REGULATOR_VIRTUAL_CONSUMER
 	tristate "Virtual regulator consumer support"
 	help
 	  This driver provides a virtual consumer for the voltage and
-          current regulator API which provides sysfs controls for
-          configuring the supplies requested.  This is mainly useful
-          for test purposes.
+	  current regulator API which provides sysfs controls for
+	  configuring the supplies requested.  This is mainly useful
+	  for test purposes.
 
-          If unsure, say no.
+	  If unsure, say no.
 
 config REGULATOR_USERSPACE_CONSUMER
 	tristate "Userspace regulator consumer support"
@@ -62,7 +62,7 @@ config REGULATOR_USERSPACE_CONSUMER
 	  from user space. Userspace consumer driver provides ability to
 	  control power supplies for such devices.
 
-          If unsure, say no.
+	  If unsure, say no.
 
 config REGULATOR_GPIO
 	tristate "GPIO regulator support"
@@ -218,7 +218,7 @@ config REGULATOR_LP3972
 
 config REGULATOR_PCF50633
 	tristate "NXP PCF50633 regulator driver"
-        depends on MFD_PCF50633
+	depends on MFD_PCF50633
 	help
 	 Say Y here to support the voltage regulators and convertors
 	 on PCF50633
@@ -379,7 +379,7 @@ config REGULATOR_WM8350
 	depends on MFD_WM8350
 	help
 	  This driver provides support for the voltage and current regulators
-          of the WM8350 AudioPlus PMIC.
+	  of the WM8350 AudioPlus PMIC.
 
 config REGULATOR_WM8400
 	tristate "Wolfson Microelectronics WM8400 AudioPlus PMIC"
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
