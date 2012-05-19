Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554Ab2ESOko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:40:44 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13018 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760343Ab2ESOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:39:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 19 May 2012 07:39:20 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/5] regulator: tps65910: use small letter for regulator names
Date: Sat, 19 May 2012 20:04:06 +0530
Message-ID: <1337438050-3707-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the small-letter for names of different regulator to
match the names with dt binding documents.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |  104 ++++++++++++++++----------------
 1 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 7014843..bd616a0 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -94,11 +94,11 @@ struct tps_info {
 
 static struct tps_info tps65910_regs[] = {
 	{
-		.name = "VRTC",
+		.name = "vrtc",
 		.enable_time_us = 2200,
 	},
 	{
-		.name = "VIO",
+		.name = "vio",
 		.min_uV = 1500000,
 		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VIO_VSEL_table),
@@ -106,19 +106,19 @@ static struct tps_info tps65910_regs[] = {
 		.enable_time_us = 350,
 	},
 	{
-		.name = "VDD1",
+		.name = "vdd1",
 		.min_uV = 600000,
 		.max_uV = 4500000,
 		.enable_time_us = 350,
 	},
 	{
-		.name = "VDD2",
+		.name = "vdd2",
 		.min_uV = 600000,
 		.max_uV = 4500000,
 		.enable_time_us = 350,
 	},
 	{
-		.name = "VDD3",
+		.name = "vdd3",
 		.min_uV = 5000000,
 		.max_uV = 5000000,
 		.n_voltages = ARRAY_SIZE(VDD3_VSEL_table),
@@ -126,7 +126,7 @@ static struct tps_info tps65910_regs[] = {
 		.enable_time_us = 200,
 	},
 	{
-		.name = "VDIG1",
+		.name = "vdig1",
 		.min_uV = 1200000,
 		.max_uV = 2700000,
 		.n_voltages = ARRAY_SIZE(VDIG1_VSEL_table),
@@ -134,7 +134,7 @@ static struct tps_info tps65910_regs[] = {
 		.enable_time_us = 100,
 	},
 	{
-		.name = "VDIG2",
+		.name = "vdig2",
 		.min_uV = 1000000,
 		.max_uV = 1800000,
 		.n_voltages = ARRAY_SIZE(VDIG2_VSEL_table),
@@ -142,7 +142,7 @@ static struct tps_info tps65910_regs[] = {
 		.enable_time_us = 100,
 	},
 	{
-		.name = "VPLL",
+		.name = "vpll",
 		.min_uV = 1000000,
 		.max_uV = 2500000,
 		.n_voltages = ARRAY_SIZE(VPLL_VSEL_table),
@@ -150,7 +150,7 @@ static struct tps_info tps65910_regs[] = {
 		.enable_time_us = 100,
 	},
 	{
-		.name = "VDAC",
+		.name = "vdac",
 		.min_uV = 1800000,
 		.max_uV = 2850000,
 		.n_voltages = ARRAY_SIZE(VDAC_VSEL_table),
@@ -158,7 +158,7 @@ static struct tps_info tps65910_regs[] = {
 		.enable_time_us = 100,
 	},
 	{
-		.name = "VAUX1",
+		.name = "vaux1",
 		.min_uV = 1800000,
 		.max_uV = 2850000,
 		.n_voltages = ARRAY_SIZE(VAUX1_VSEL_table),
@@ -166,7 +166,7 @@ static struct tps_info tps65910_regs[] = {
 		.enable_time_us = 100,
 	},
 	{
-		.name = "VAUX2",
+		.name = "vaux2",
 		.min_uV = 1800000,
 		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VAUX2_VSEL_table),
@@ -174,7 +174,7 @@ static struct tps_info tps65910_regs[] = {
 		.enable_time_us = 100,
 	},
 	{
-		.name = "VAUX33",
+		.name = "vaux33",
 		.min_uV = 1800000,
 		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VAUX33_VSEL_table),
@@ -182,7 +182,7 @@ static struct tps_info tps65910_regs[] = {
 		.enable_time_us = 100,
 	},
 	{
-		.name = "VMMC",
+		.name = "vmmc",
 		.min_uV = 1800000,
 		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VMMC_VSEL_table),
@@ -193,11 +193,11 @@ static struct tps_info tps65910_regs[] = {
 
 static struct tps_info tps65911_regs[] = {
 	{
-		.name = "VRTC",
+		.name = "vrtc",
 		.enable_time_us = 2200,
 	},
 	{
-		.name = "VIO",
+		.name = "vio",
 		.min_uV = 1500000,
 		.max_uV = 3300000,
 		.n_voltages = ARRAY_SIZE(VIO_VSEL_table),
@@ -205,77 +205,77 @@ static struct tps_info tps65911_regs[] = {
 		.enable_time_us = 350,
 	},
 	{
-		.name = "VDD1",
+		.name = "vdd1",
 		.min_uV = 600000,
 		.max_uV = 4500000,
 		.n_voltages = 73,
 		.enable_time_us = 350,
 	},
 	{
-		.name = "VDD2",
+		.name = "vdd2",
 		.min_uV = 600000,
 		.max_uV = 4500000,
 		.n_voltages = 73,
 		.enable_time_us = 350,
 	},
 	{
-		.name = "VDDCTRL",
+		.name = "vddctrl",
 		.min_uV = 600000,
 		.max_uV = 1400000,
 		.n_voltages = 65,
 		.enable_time_us = 900,
 	},
 	{
-		.name = "LDO1",
+		.name = "ldo1",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 47,
 		.enable_time_us = 420,
 	},
 	{
-		.name = "LDO2",
+		.name = "ldo2",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 47,
 		.enable_time_us = 420,
 	},
 	{
-		.name = "LDO3",
+		.name = "ldo3",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
-		.name = "LDO4",
+		.name = "ldo4",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 47,
 		.enable_time_us = 230,
 	},
 	{
-		.name = "LDO5",
+		.name = "ldo5",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
-		.name = "LDO6",
+		.name = "ldo6",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
-		.name = "LDO7",
+		.name = "ldo7",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
-		.name = "LDO8",
+		.name = "ldo8",
 		.min_uV = 1000000,
 		.max_uV = 3300000,
 		.n_voltages = 24,
@@ -1039,35 +1039,35 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
 #ifdef CONFIG_OF
 
 static struct of_regulator_match tps65910_matches[] = {
-	{ .name = "VRTC",	.driver_data = (void *) &tps65910_regs[0] },
-	{ .name = "VIO",	.driver_data = (void *) &tps65910_regs[1] },
-	{ .name = "VDD1",	.driver_data = (void *) &tps65910_regs[2] },
-	{ .name = "VDD2",	.driver_data = (void *) &tps65910_regs[3] },
-	{ .name = "VDD3",	.driver_data = (void *) &tps65910_regs[4] },
-	{ .name = "VDIG1",	.driver_data = (void *) &tps65910_regs[5] },
-	{ .name = "VDIG2",	.driver_data = (void *) &tps65910_regs[6] },
-	{ .name = "VPLL",	.driver_data = (void *) &tps65910_regs[7] },
-	{ .name = "VDAC",	.driver_data = (void *) &tps65910_regs[8] },
-	{ .name = "VAUX1",	.driver_data = (void *) &tps65910_regs[9] },
-	{ .name = "VAUX2",	.driver_data = (void *) &tps65910_regs[10] },
-	{ .name = "VAUX33",	.driver_data = (void *) &tps65910_regs[11] },
-	{ .name = "VMMC",	.driver_data = (void *) &tps65910_regs[12] },
+	{ .name = "vrtc",	.driver_data = (void *) &tps65910_regs[0] },
+	{ .name = "vio",	.driver_data = (void *) &tps65910_regs[1] },
+	{ .name = "vdd1",	.driver_data = (void *) &tps65910_regs[2] },
+	{ .name = "vdd2",	.driver_data = (void *) &tps65910_regs[3] },
+	{ .name = "vdd3",	.driver_data = (void *) &tps65910_regs[4] },
+	{ .name = "vdig1",	.driver_data = (void *) &tps65910_regs[5] },
+	{ .name = "vdig2",	.driver_data = (void *) &tps65910_regs[6] },
+	{ .name = "vpll",	.driver_data = (void *) &tps65910_regs[7] },
+	{ .name = "vdac",	.driver_data = (void *) &tps65910_regs[8] },
+	{ .name = "vaux1",	.driver_data = (void *) &tps65910_regs[9] },
+	{ .name = "vaux2",	.driver_data = (void *) &tps65910_regs[10] },
+	{ .name = "vaux33",	.driver_data = (void *) &tps65910_regs[11] },
+	{ .name = "vmmc",	.driver_data = (void *) &tps65910_regs[12] },
 };
 
 static struct of_regulator_match tps65911_matches[] = {
-	{ .name = "VRTC",	.driver_data = (void *) &tps65911_regs[0] },
-	{ .name = "VIO",	.driver_data = (void *) &tps65911_regs[1] },
-	{ .name = "VDD1",	.driver_data = (void *) &tps65911_regs[2] },
-	{ .name = "VDD2",	.driver_data = (void *) &tps65911_regs[3] },
-	{ .name = "VDDCTRL",	.driver_data = (void *) &tps65911_regs[4] },
-	{ .name = "LDO1",	.driver_data = (void *) &tps65911_regs[5] },
-	{ .name = "LDO2",	.driver_data = (void *) &tps65911_regs[6] },
-	{ .name = "LDO3",	.driver_data = (void *) &tps65911_regs[7] },
-	{ .name = "LDO4",	.driver_data = (void *) &tps65911_regs[8] },
-	{ .name = "LDO5",	.driver_data = (void *) &tps65911_regs[9] },
-	{ .name = "LDO6",	.driver_data = (void *) &tps65911_regs[10] },
-	{ .name = "LDO7",	.driver_data = (void *) &tps65911_regs[11] },
-	{ .name = "LDO8",	.driver_data = (void *) &tps65911_regs[12] },
+	{ .name = "vrtc",	.driver_data = (void *) &tps65911_regs[0] },
+	{ .name = "vio",	.driver_data = (void *) &tps65911_regs[1] },
+	{ .name = "vdd1",	.driver_data = (void *) &tps65911_regs[2] },
+	{ .name = "vdd2",	.driver_data = (void *) &tps65911_regs[3] },
+	{ .name = "vddctrl",	.driver_data = (void *) &tps65911_regs[4] },
+	{ .name = "ldo1",	.driver_data = (void *) &tps65911_regs[5] },
+	{ .name = "ldo2",	.driver_data = (void *) &tps65911_regs[6] },
+	{ .name = "ldo3",	.driver_data = (void *) &tps65911_regs[7] },
+	{ .name = "ldo4",	.driver_data = (void *) &tps65911_regs[8] },
+	{ .name = "ldo5",	.driver_data = (void *) &tps65911_regs[9] },
+	{ .name = "ldo6",	.driver_data = (void *) &tps65911_regs[10] },
+	{ .name = "ldo7",	.driver_data = (void *) &tps65911_regs[11] },
+	{ .name = "ldo8",	.driver_data = (void *) &tps65911_regs[12] },
 };
 
 static struct tps65910_board *tps65910_parse_dt_reg_data(
-- 
1.7.1.1

