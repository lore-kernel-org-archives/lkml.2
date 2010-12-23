Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0LWIoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:44:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:18146 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0LWIoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:44:02 -0500
Date: Thu, 23 Dec 2010 17:43:59 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] regulator MAX8998/LP3974 Bugfix: incorrect variable name (typo)
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1293093839-23994-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 23 Dec 2010 08:43:59.0789 (UTC)
 FILETIME=[8B1015D0:01CBA27D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trivial error. (buck1_idx->buck2_idx in the context of buck2 control)

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max8998.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 5c20756..6413e80 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -448,10 +448,10 @@ buck1_exit:
 			, i, max8998->buck2_vol[0], max8998->buck2_vol[1]);
 		if (gpio_is_valid(pdata->buck2_set3)) {
 			if (max8998->buck2_vol[0] == i) {
-				max8998->buck1_idx = 0;
+				max8998->buck2_idx = 0;
 				buck2_gpio_set(pdata->buck2_set3, 0);
 			} else {
-				max8998->buck1_idx = 1;
+				max8998->buck2_idx = 1;
 				ret = max8998_get_voltage_register(rdev, &reg,
 								   &shift,
 								   &mask);
-- 
1.7.1

