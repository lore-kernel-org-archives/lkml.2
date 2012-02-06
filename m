Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2BFMiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:38:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38561 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2BFMiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:38:03 -0500
Message-ID: <1328531866.4535.1.camel@phoenix>
Subject: [PATCH] regulator: Show correct chip id for max8649
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 06 Feb 2012 20:37:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8649.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index b06a239..636dfd4 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -270,7 +270,7 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 			ret);
 		goto out;
 	}
-	dev_info(info->dev, "Detected MAX8649 (ID:%x)\n", ret);
+	dev_info(info->dev, "Detected MAX8649 (ID:%x)\n", val);
 
 	/* enable VID0 & VID1 */
 	regmap_update_bits(info->regmap, MAX8649_CONTROL, MAX8649_VID_MASK, 0);
-- 
1.7.5.4



