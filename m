Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab2ATLGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 06:06:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12472 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2ATLGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 06:06:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Jan 2012 03:06:47 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] regulator: tps65910: use appropriate variable names.
Date: Fri, 20 Jan 2012 16:36:22 +0530
Message-Id: <1327057582-6635-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renaming the variables "table" to "voltage_table" and
"table_len" to "n_voltages" of regulator information
to have more meaningful.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
As per discussion in other patch 
regulator: tps65910: Initialize n_voltages for rails.
sending this patch on top of above where the variable
names are renamed to have more meaningful.

 drivers/regulator/tps65910-regulator.c |   82 ++++++++++++++++----------------
 1 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 3ac5f91..1d13cf9 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -83,8 +83,8 @@ struct tps_info {
 	const char *name;
 	unsigned min_uV;
 	unsigned max_uV;
-	u8 table_len;
-	const u16 *table;
+	u8 n_voltages;
+	const u16 *voltage_table;
 };
 
 static struct tps_info tps65910_regs[] = {
@@ -95,8 +95,8 @@ static struct tps_info tps65910_regs[] = {
 		.name = "VIO",
 		.min_uV = 1500000,
 		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(VIO_VSEL_table),
-		.table = VIO_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VIO_VSEL_table),
+		.voltage_table = VIO_VSEL_table,
 	},
 	{
 		.name = "VDD1",
@@ -112,64 +112,64 @@ static struct tps_info tps65910_regs[] = {
 		.name = "VDD3",
 		.min_uV = 5000000,
 		.max_uV = 5000000,
-		.table_len = ARRAY_SIZE(VDD3_VSEL_table),
-		.table = VDD3_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VDD3_VSEL_table),
+		.voltage_table = VDD3_VSEL_table,
 	},
 	{
 		.name = "VDIG1",
 		.min_uV = 1200000,
 		.max_uV = 2700000,
-		.table_len = ARRAY_SIZE(VDIG1_VSEL_table),
-		.table = VDIG1_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VDIG1_VSEL_table),
+		.voltage_table = VDIG1_VSEL_table,
 	},
 	{
 		.name = "VDIG2",
 		.min_uV = 1000000,
 		.max_uV = 1800000,
-		.table_len = ARRAY_SIZE(VDIG2_VSEL_table),
-		.table = VDIG2_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VDIG2_VSEL_table),
+		.voltage_table = VDIG2_VSEL_table,
 	},
 	{
 		.name = "VPLL",
 		.min_uV = 1000000,
 		.max_uV = 2500000,
-		.table_len = ARRAY_SIZE(VPLL_VSEL_table),
-		.table = VPLL_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VPLL_VSEL_table),
+		.voltage_table = VPLL_VSEL_table,
 	},
 	{
 		.name = "VDAC",
 		.min_uV = 1800000,
 		.max_uV = 2850000,
-		.table_len = ARRAY_SIZE(VDAC_VSEL_table),
-		.table = VDAC_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VDAC_VSEL_table),
+		.voltage_table = VDAC_VSEL_table,
 	},
 	{
 		.name = "VAUX1",
 		.min_uV = 1800000,
 		.max_uV = 2850000,
-		.table_len = ARRAY_SIZE(VAUX1_VSEL_table),
-		.table = VAUX1_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VAUX1_VSEL_table),
+		.voltage_table = VAUX1_VSEL_table,
 	},
 	{
 		.name = "VAUX2",
 		.min_uV = 1800000,
 		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(VAUX2_VSEL_table),
-		.table = VAUX2_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VAUX2_VSEL_table),
+		.voltage_table = VAUX2_VSEL_table,
 	},
 	{
 		.name = "VAUX33",
 		.min_uV = 1800000,
 		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(VAUX33_VSEL_table),
-		.table = VAUX33_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VAUX33_VSEL_table),
+		.voltage_table = VAUX33_VSEL_table,
 	},
 	{
 		.name = "VMMC",
 		.min_uV = 1800000,
 		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(VMMC_VSEL_table),
-		.table = VMMC_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VMMC_VSEL_table),
+		.voltage_table = VMMC_VSEL_table,
 	},
 };
 
@@ -181,74 +181,74 @@ static struct tps_info tps65911_regs[] = {
 		.name = "VIO",
 		.min_uV = 1500000,
 		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(VIO_VSEL_table),
-		.table = VIO_VSEL_table,
+		.n_voltages = ARRAY_SIZE(VIO_VSEL_table),
+		.voltage_table = VIO_VSEL_table,
 	},
 	{
 		.name = "VDD1",
 		.min_uV = 600000,
 		.max_uV = 4500000,
-		.table_len = 73,
+		.n_voltages = 73,
 	},
 	{
 		.name = "VDD2",
 		.min_uV = 600000,
 		.max_uV = 4500000,
-		.table_len = 73,
+		.n_voltages = 73,
 	},
 	{
 		.name = "VDDCTRL",
 		.min_uV = 600000,
 		.max_uV = 1400000,
-		.table_len = 65,
+		.n_voltages = 65,
 	},
 	{
 		.name = "LDO1",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
-		.table_len = 47,
+		.n_voltages = 47,
 	},
 	{
 		.name = "LDO2",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
-		.table_len = 47,
+		.n_voltages = 47,
 	},
 	{
 		.name = "LDO3",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
-		.table_len = 24,
+		.n_voltages = 24,
 	},
 	{
 		.name = "LDO4",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
-		.table_len = 47,
+		.n_voltages = 47,
 	},
 	{
 		.name = "LDO5",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
-		.table_len = 24,
+		.n_voltages = 24,
 	},
 	{
 		.name = "LDO6",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
-		.table_len = 24,
+		.n_voltages = 24,
 	},
 	{
 		.name = "LDO7",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
-		.table_len = 24,
+		.n_voltages = 24,
 	},
 	{
 		.name = "LDO8",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
-		.table_len = 24,
+		.n_voltages = 24,
 	},
 };
 
@@ -586,7 +586,7 @@ static int tps65910_get_voltage(struct regulator_dev *dev)
 		return -EINVAL;
 	}
 
-	voltage = pmic->info[id]->table[value] * 1000;
+	voltage = pmic->info[id]->voltage_table[value] * 1000;
 
 	return voltage;
 }
@@ -636,7 +636,7 @@ static int tps65911_get_voltage(struct regulator_dev *dev)
 		step_mv = 100;
 		break;
 	case TPS65910_REG_VIO:
-		return pmic->info[id]->table[value] * 1000;
+		return pmic->info[id]->voltage_table[value] * 1000;
 		break;
 	default:
 		return -EINVAL;
@@ -770,10 +770,10 @@ static int tps65910_list_voltage(struct regulator_dev *dev,
 	if (id < TPS65910_REG_VIO || id > TPS65910_REG_VMMC)
 		return -EINVAL;
 
-	if (selector >= pmic->info[id]->table_len)
+	if (selector >= pmic->info[id]->n_voltages)
 		return -EINVAL;
 	else
-		voltage = pmic->info[id]->table[selector] * 1000;
+		voltage = pmic->info[id]->voltage_table[selector] * 1000;
 
 	return voltage;
 }
@@ -809,7 +809,7 @@ static int tps65911_list_voltage(struct regulator_dev *dev, unsigned selector)
 		step_mv = 100;
 		break;
 	case TPS65910_REG_VIO:
-		return pmic->info[id]->table[selector] * 1000;
+		return pmic->info[id]->voltage_table[selector] * 1000;
 	default:
 		return -EINVAL;
 	}
@@ -940,7 +940,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 
 		pmic->desc[i].name = info->name;
 		pmic->desc[i].id = i;
-		pmic->desc[i].n_voltages = info->table_len;
+		pmic->desc[i].n_voltages = info->n_voltages;
 
 		if (i == TPS65910_REG_VDD1 || i == TPS65910_REG_VDD2) {
 			pmic->desc[i].ops = &tps65910_ops_dcdc;
-- 
1.7.1.1

