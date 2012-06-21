Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2FUIDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:03:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34201 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2FUIDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:03:49 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: [PATCH 1/3] regulator: enable module build config for lp872x
Thread-Topic: [PATCH 1/3] regulator: enable module build config for lp872x
Thread-Index: Ac1PhFvA0/m3a5lnTy66b9wsZ8BKMw==
Date: Thu, 21 Jun 2012 08:03:36 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FC04A@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 26a4440..870f730 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -225,7 +225,7 @@ config REGULATOR_LP3972
 	 on National Semiconductors LP3972 PMIC
 
 config REGULATOR_LP872X
-	bool "TI/National Semiconductor LP8720/LP8725 voltage regulators"
+	tristate "TI/National Semiconductor LP8720/LP8725 voltage regulators"
 	depends on I2C
 	select REGMAP_I2C
 	help
-- 
1.7.2.5


Best Regards,
Milo (Woogyom) Kim


