Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2KUElV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:41:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42489 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2KUElT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:41:19 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 2/2] extcon: max77693: Fix coding style
Date: Wed, 21 Nov 2012 10:04:58 +0530
Message-Id: <1353472498-5793-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353472498-5793-1-git-send-email-sachin.kamat@linaro.org>
References: <1353472498-5793-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per kernel coding style, if one branch of conditional statement has braces,
the other one should have too.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max77693.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 1da4ad4..8bf5e48 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -665,9 +665,9 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 	}
 	info->dev = &pdev->dev;
 	info->max77693 = max77693;
-	if (info->max77693->regmap_muic)
+	if (info->max77693->regmap_muic) {
 		dev_dbg(&pdev->dev, "allocate register map\n");
-	else {
+	} else {
 		info->max77693->regmap_muic = devm_regmap_init_i2c(
 						info->max77693->muic,
 						&max77693_muic_regmap_config);
-- 
1.7.4.1

