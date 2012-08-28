Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2H1Ebo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 00:31:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56783 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab2H1Ebl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 00:31:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] regulator: arizona-ldo: Support get/set bypass
Date: Mon, 27 Aug 2012 21:31:33 -0700
Message-Id: <1346128294-26652-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346128294-26652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1346128294-26652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 128fb94..d184aa3 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -39,6 +39,8 @@ static struct regulator_ops arizona_ldo1_ops = {
 	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_bypass = regulator_get_bypass_regmap,
+	.set_bypass = regulator_set_bypass_regmap,
 };
 
 static const struct regulator_desc arizona_ldo1 = {
@@ -49,6 +51,8 @@ static const struct regulator_desc arizona_ldo1 = {
 
 	.vsel_reg = ARIZONA_LDO1_CONTROL_1,
 	.vsel_mask = ARIZONA_LDO1_VSEL_MASK,
+	.bypass_reg = ARIZONA_LDO1_CONTROL_1,
+	.bypass_mask = ARIZONA_LDO1_BYPASS,
 	.min_uV = 900000,
 	.uV_step = 50000,
 	.n_voltages = 6,
-- 
1.7.10.4

