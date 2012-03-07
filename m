Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031137Ab2CGCCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:02:23 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49006 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965269Ab2CGCCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:02:22 -0500
Message-ID: <1331085732.7432.1.camel@phoenix>
Subject: [PATCH] regulator: Remove unused i2c variable in s5m8767_pmic_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 07 Mar 2012 10:02:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s5m8767.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 9b97aa3..e369d9e 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -542,7 +542,6 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 	struct s5m_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct regulator_dev **rdev;
 	struct s5m8767_info *s5m8767;
-	struct i2c_client *i2c;
 	int i, ret, size;
 
 	if (!pdata) {
@@ -565,7 +564,6 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 	s5m8767->iodev = iodev;
 	s5m8767->num_regulators = S5M8767_REG_MAX - 2;
 	platform_set_drvdata(pdev, s5m8767);
-	i2c = s5m8767->iodev->i2c;
 
 	s5m8767->buck_gpioindex = pdata->buck_default_idx;
 	s5m8767->buck2_gpiodvs = pdata->buck2_gpiodvs;
-- 
1.7.5.4



