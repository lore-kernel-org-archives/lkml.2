Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2BFLfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 06:35:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44704 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589Ab2BFLfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 06:35:30 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: s5m8767: Fix unused variable warning in probe()
Date: Mon,  6 Feb 2012 11:35:27 +0000
Message-Id: <1328528127-20771-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/s5m8767.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 5b00e5a..2fb2add 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -569,7 +569,7 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 	struct regulator_dev **rdev;
 	struct s5m8767_info *s5m8767;
 	struct i2c_client *i2c;
-	int i, ret, size, reg;
+	int i, ret, size;
 
 	if (!pdata) {
 		dev_err(pdev->dev.parent, "Platform data not supplied\n");
-- 
1.7.9.rc1

