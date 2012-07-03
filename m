Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab2GCBTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:19:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41321 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2GCBTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:19:04 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: enable module build for lp872x driver
Thread-Topic: [PATCH] regulator: enable module build for lp872x driver
Thread-Index: Ac1Yuc6q72LFCC6IR025YHgmWoxgJA==
Date: Tue, 3 Jul 2012 01:18:53 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FCCCF@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.177.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 27fe52f..7abe31a 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -233,8 +233,8 @@ config REGULATOR_LP3972
 	 on National Semiconductors LP3972 PMIC
 
 config REGULATOR_LP872X
-	bool "TI/National Semiconductor LP8720/LP8725 voltage regulators"
-	depends on I2C=y
+	tristate "TI/National Semiconductor LP8720/LP8725 voltage regulators"
+	depends on I2C
 	select REGMAP_I2C
 	help
 	  This driver supports LP8720/LP8725 PMIC
-- 
1.7.2.5


Best Regards,
Milo

