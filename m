Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2AOMZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 07:25:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39055 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2AOMZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 07:25:33 -0500
Message-ID: <1326630322.3116.0.camel@phoenix>
Subject: [PATCH] regulator: Update tps65217-regulator for DT changes
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: AnilKumar Ch <anilkumar@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 15 Jan 2012 20:25:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65217-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 6665566..28a10ea 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -447,7 +447,7 @@ static int __devinit tps65217_regulator_probe(struct platform_device *pdev)
 	tps->info[pdev->id] = info;
 
 	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
-				  pdev->dev.platform_data, tps);
+				  pdev->dev.platform_data, tps, NULL);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
-- 
1.7.5.4



