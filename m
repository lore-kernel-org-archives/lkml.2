Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2BUCPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:15:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50588 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab2BUCPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:15:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.225.231 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1329790495.5422.1.camel@phoenix>
Subject: [PATCH] regulator: Fix module desciption for tps65910 regulator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 21 Feb 2012 10:14:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the module desciption and also update Kconfig to include supporting
tps65911 chip.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/Kconfig              |    4 ++--
 drivers/regulator/tps65910-regulator.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 376824b..edcd9e2 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -344,10 +344,10 @@ config REGULATOR_TPS6524X
 	  port controller.
 
 config REGULATOR_TPS65910
-	tristate "TI TPS65910 Power Regulator"
+	tristate "TI TPS65910/TPS65911 Power Regulators"
 	depends on MFD_TPS65910
 	help
-	  This driver supports TPS65910 voltage regulator chips.
+	  This driver supports TPS65910/TPS65911 voltage regulator chips.
 
 config REGULATOR_TPS62360
 	tristate "TI TPS62360 Power Regulator"
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index a9bb6d4..15b5f1e 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1235,6 +1235,6 @@ static void __exit tps65910_cleanup(void)
 module_exit(tps65910_cleanup);
 
 MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
-MODULE_DESCRIPTION("TPS6507x voltage regulator driver");
+MODULE_DESCRIPTION("TPS65910/TPS65911 voltage regulator driver");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:tps65910-pmic");
-- 
1.7.5.4



