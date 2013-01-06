Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3AFEmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 23:42:17 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47714 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3AFEmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 23:42:15 -0500
Message-ID: <1357447320.17918.0.camel@phoenix>
Subject: [PATCH] regulator: da9055: Remove unused v_shift field from struct
 da9055_volt_reg
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2013 12:42:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9055-regulator.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 1a05ac6..3022109 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -58,7 +58,6 @@ struct da9055_volt_reg {
 	int reg_b;
 	int sl_shift;
 	int v_mask;
-	int v_shift;
 };
 
 struct da9055_mode_reg {
@@ -388,7 +387,6 @@ static struct regulator_ops da9055_ldo_ops = {
 		.reg_b = DA9055_REG_VBCORE_B + DA9055_ID_##_id, \
 		.sl_shift = 7,\
 		.v_mask = (1 << (vbits)) - 1,\
-		.v_shift = (vbits),\
 	},\
 }
 
@@ -417,7 +415,6 @@ static struct regulator_ops da9055_ldo_ops = {
 		.reg_b = DA9055_REG_VBCORE_B + DA9055_ID_##_id, \
 		.sl_shift = 7,\
 		.v_mask = (1 << (vbits)) - 1,\
-		.v_shift = (vbits),\
 	},\
 	.mode = {\
 		.reg = DA9055_REG_BCORE_MODE,\
-- 
1.7.9.5



