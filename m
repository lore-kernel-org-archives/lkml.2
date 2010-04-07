Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0DGMP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:15:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42260 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752191Ab0DGMPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:15:25 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Fix WM831x I2C suspend prototype
Date: Wed,  7 Apr 2010 13:15:22 +0100
Message-Id: <1270642522-17468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about the oversight.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index d4331b2..1a968f3 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1767,7 +1767,7 @@ static int wm831x_i2c_remove(struct i2c_client *i2c)
 	return 0;
 }
 
-static int wm831x_i2c_suspend(struct i2c_client *i2c)
+static int wm831x_i2c_suspend(struct i2c_client *i2c, pm_message_t mesg)
 {
 	struct wm831x *wm831x = i2c_get_clientdata(i2c);
 
-- 
1.7.0.3

