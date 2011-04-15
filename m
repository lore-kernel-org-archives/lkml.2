Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1DOA6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 20:58:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39593 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab1DOA6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 20:58:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dP5GHHIRvHeYKeY/RIPuJM2c5Cx2LgEHTilyPer8TsAEqrYNmiaZxMVa58tLKzZUKr
         8n7CHIjkFMQgEc6vtukVAeAyCuy9GY2hvZGSQI8RR1p56ebsD3mD2WoKOrd9QMrIBpNk
         XQT1h4T5MsPm71eVkyDH+PipLr4dMmRTutYfs=
Subject: [PATCH] regulator: Group TI TPSxxxxx regulators together
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Cyril Chemparathy <cyril@ti.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 08:57:58 +0800
Message-ID: <1302829078.2752.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group TI TPSxxxxx regulators together and sort in alphabetical order.
This change make it easier for users to find the config options.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/Kconfig |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index b9f29e0..44528f6 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -248,6 +248,22 @@ config REGULATOR_TPS6507X
 	  three step-down converters and two general-purpose LDO voltage regulators.
 	  It supports TI's software based Class-2 SmartReflex implementation.
 
+config REGULATOR_TPS6524X
+	tristate "TI TPS6524X Power regulators"
+	depends on SPI
+	help
+	  This driver supports TPS6524X voltage regulator chips. TPS6524X
+	  provides three step-down converters and two general-purpose LDO
+	  voltage regulators.  This device is interfaced using a customized
+	  serial interface currently supported on the sequencer serial
+	  port controller.
+
+config REGULATOR_TPS6586X
+	tristate "TI TPS6586X Power regulators"
+	depends on MFD_TPS6586X
+	help
+	  This driver supports TPS6586X voltage regulator chips.
+
 config REGULATOR_88PM8607
 	bool "Marvell 88PM8607 Power regulators"
 	depends on MFD_88PM860X=y
@@ -274,21 +290,5 @@ config REGULATOR_AB8500
 	  This driver supports the regulators found on the ST-Ericsson mixed
 	  signal AB8500 PMIC
 
-config REGULATOR_TPS6586X
-	tristate "TI TPS6586X Power regulators"
-	depends on MFD_TPS6586X
-	help
-	  This driver supports TPS6586X voltage regulator chips.
-
-config REGULATOR_TPS6524X
-	tristate "TI TPS6524X Power regulators"
-	depends on SPI
-	help
-	  This driver supports TPS6524X voltage regulator chips. TPS6524X
-	  provides three step-down converters and two general-purpose LDO
-	  voltage regulators.  This device is interfaced using a customized
-	  serial interface currently supported on the sequencer serial
-	  port controller.
-
 endif
 
-- 
1.7.1



