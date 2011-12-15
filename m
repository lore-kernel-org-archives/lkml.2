Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab1LOHEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:04:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59603 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932268Ab1LOHEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:04:04 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>, Liam girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Update da9052-regulator for DT changes
Date: Thu, 15 Dec 2011 15:03:59 +0800
Message-Id: <1323932639-5640-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/da9052-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 30c647f..bdb4375 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -547,7 +547,7 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 	regulator->rdev = regulator_register(&regulator->info->reg_desc,
 					     &pdev->dev,
 					     pdata->regulators[pdev->id],
-					     regulator);
+					     regulator, NULL);
 	if (IS_ERR(regulator->rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			regulator->info->reg_desc.name);
-- 
1.7.7.3

