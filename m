Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2KAGCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:02:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60193 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2KAGCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:02:47 -0400
Message-ID: <1351749756.3695.2.camel@phoenix>
Subject: [PATCH] regulator: Fix trivial typo for TPS51632 Kconfig help text
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Nov 2012 14:02:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 7b920c7..cbc685d 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -341,7 +341,7 @@ config REGULATOR_TPS51632
 	select REGMAP_I2C
 	help
 	  This driver supports TPS51632 voltage regulator chip.
-	  The TPS52632 is 3-2-1 Phase D-Cap+ Step Down Driverless Controller
+	  The TPS51632 is 3-2-1 Phase D-Cap+ Step Down Driverless Controller
 	  with Serial VID control and DVFS.
 	  The voltage output can be configure through I2C interface or PWM
 	  interface.
-- 
1.7.9.5



