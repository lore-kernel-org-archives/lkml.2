Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1K3Unk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 15:43:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43624 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab1K3Unj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 15:43:39 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add WM1811A device ID to wm8994 driver
Date: Wed, 30 Nov 2011 20:43:36 +0000
Message-Id: <1322685816-15006-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM1811A is a variant of the WM1811 with pin configuration changes.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index f49b1ac..92aa22f 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -611,6 +611,7 @@ static int wm8994_i2c_remove(struct i2c_client *i2c)
 
 static const struct i2c_device_id wm8994_i2c_id[] = {
 	{ "wm1811", WM1811 },
+	{ "wm1811a", WM1811 },
 	{ "wm8994", WM8994 },
 	{ "wm8958", WM8958 },
 	{ }
-- 
1.7.7.3

