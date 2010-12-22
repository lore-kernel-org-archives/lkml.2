Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0LVGYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 01:24:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40604 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0LVGYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 01:24:13 -0500
Date: Wed, 22 Dec 2010 15:23:08 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 3/6] MFD MAX8998/LP3974 Bugfix: incorrect variable name
 (typo)
In-reply-to: <20101221155004.GA21871@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1292998991-26968-4-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
X-OriginalArrivalTime: 22 Dec 2010 06:23:11.0796 (UTC)
 FILETIME=[B540E740:01CBA1A0]
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
index 65e23d3..7c1478b 100644
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

