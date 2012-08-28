Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab2H1Ebp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 00:31:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56784 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab2H1Ebl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 00:31:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] regulator: arizona-micsupp: Support get/set bypass
Date: Mon, 27 Aug 2012 21:31:34 -0700
Message-Id: <1346128294-26652-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346128294-26652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1346128294-26652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-micsupp.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 450a069..d9b1f82 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -82,6 +82,9 @@ static struct regulator_ops arizona_micsupp_ops = {
 
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+
+	.get_bypass = regulator_get_bypass_regmap,
+	.set_bypass = regulator_set_bypass_regmap,
 };
 
 static const struct regulator_desc arizona_micsupp = {
@@ -95,6 +98,8 @@ static const struct regulator_desc arizona_micsupp = {
 	.vsel_mask = ARIZONA_LDO2_VSEL_MASK,
 	.enable_reg = ARIZONA_MIC_CHARGE_PUMP_1,
 	.enable_mask = ARIZONA_CPMIC_ENA,
+	.bypass_reg = ARIZONA_MIC_CHARGE_PUMP_1,
+	.bypass_mask = ARIZONA_CPMIC_BYPASS,
 
 	.owner = THIS_MODULE,
 };
-- 
1.7.10.4

