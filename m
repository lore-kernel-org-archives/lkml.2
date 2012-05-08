Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab2EHRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:16:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33780 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757689Ab2EHRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:16:24 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: dummy: Specify a struct device
Date: Tue,  8 May 2012 18:16:19 +0100
Message-Id: <1336497380-8341-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be becoming mandatory.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/dummy.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/dummy.c b/drivers/regulator/dummy.c
index 1571bee..86f655c 100644
--- a/drivers/regulator/dummy.c
+++ b/drivers/regulator/dummy.c
@@ -42,6 +42,7 @@ static int __devinit dummy_regulator_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 	int ret;
 
+	config.dev = &pdev->dev;
 	config.init_data = &dummy_initdata;
 
 	dummy_regulator_rdev = regulator_register(&dummy_desc, &config);
-- 
1.7.10

