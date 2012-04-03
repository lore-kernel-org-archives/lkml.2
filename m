Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2DCXCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:02:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53199 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755687Ab2DCXBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:01:45 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: max8649: Remove contentless announcement log message
Date: Wed,  4 Apr 2012 00:01:41 +0100
Message-Id: <1333494101-22472-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core already logs the regulator constraints as it is registered and
we're not adding any extra content about the device such as the chip
revision.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/max8649.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 824c650..2e9ffbe 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -306,7 +306,6 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 		goto out;
 	}
 
-	dev_info(info->dev, "Max8649 regulator device is detected.\n");
 	return 0;
 out:
 	regmap_exit(info->regmap);
-- 
1.7.9.1

