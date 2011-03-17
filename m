Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1CQQdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:33:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42877 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751572Ab1CQQdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:33:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Staticise WM8994 PM ops
Date: Thu, 17 Mar 2011 16:33:49 +0000
Message-Id: <1300379629-8434-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're not exported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 3890e45..7f5c149 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -644,7 +644,8 @@ static const struct i2c_device_id wm8994_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, wm8994_i2c_id);
 
-UNIVERSAL_DEV_PM_OPS(wm8994_pm_ops, wm8994_suspend, wm8994_resume, NULL);
+static UNIVERSAL_DEV_PM_OPS(wm8994_pm_ops, wm8994_suspend, wm8994_resume,
+			    NULL);
 
 static struct i2c_driver wm8994_i2c_driver = {
 	.driver = {
-- 
1.7.4.1

