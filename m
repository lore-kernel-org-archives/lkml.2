Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab2GTEas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 00:30:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36241 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2GTEaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 00:30:46 -0400
Message-ID: <1342758634.6777.1.camel@phoenix>
Subject: [PATCH] regulator: mc13xxx: Remove extern function declaration for
 mc13xxx_sw_regulator
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Jul 2012 12:30:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function does not exist, remove the extern function declaration.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13xxx.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/mc13xxx.h b/drivers/regulator/mc13xxx.h
index 8343a25..eaff551 100644
--- a/drivers/regulator/mc13xxx.h
+++ b/drivers/regulator/mc13xxx.h
@@ -32,7 +32,6 @@ struct mc13xxx_regulator_priv {
 	struct regulator_dev *regulators[];
 };
 
-extern int mc13xxx_sw_regulator(struct regulator_dev *rdev);
 extern int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector);
 extern int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev);
-- 
1.7.9.5



