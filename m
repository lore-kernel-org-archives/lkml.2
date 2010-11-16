Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504Ab0KPNLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:11:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59174 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934482Ab0KPNLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:11:21 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Fix prototype for MAX8998 buck set_voltage()
Date: Tue, 16 Nov 2010 13:11:18 +0000
Message-Id: <1289913078-1266-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/max8998.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index cb28cf8..7568df6 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -354,7 +354,7 @@ static inline void buck2_gpio_set(int gpio, int v)
 }
 
 static int max8998_set_voltage_buck(struct regulator_dev *rdev,
-				    int min_uV, int max_uV, int *selector)
+				    int min_uV, int max_uV, unsigned *selector)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
 	struct max8998_platform_data *pdata =
-- 
1.7.1

