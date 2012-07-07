Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab2GGJkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 05:40:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38688 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2GGJj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 05:39:59 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-ae-4ff803ed4f1a
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, sbkim01@gmail.com
Subject: [PATCH V2 3/7] regulator: s5m8767: Modify function and variable name
Date: Sat, 07 Jul 2012 18:39:58 +0900
Message-id: <0ff001cd5c24$793ab100$6bb01300$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1cJHS5gqHJH9GcTGeYcLkZXwOavA==
Content-language: ko
x-cr-hashedpuzzle: BM8b BP3j DiU0 MPW+ OANT QmKm WWxR eGpc h6Jo phj1 pyvw tKip
 vEQY zEog 3S1b
 5wnB;5;YgByAG8AbwBuAGkAZQBAAG8AcABlAG4AcwBvAHUAcgBjAGUALgB3AG8AbABmAHMAbwBuAG0AaQBjAHIAbwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAcgBnAEAAdABpAC4AYwBvAG0AOwBzAGEAbQBlAG8AQABsAGkAbgB1AHgALgBpAG4AdABlAGwALgBjAG8AbQA7AHMAYgBrAGkAbQAwADEAQABnAG0AYQBpAGwALgBjAG8AbQA=;Sosha1_v1;7;{5C12E12D-C92F-466B-8C8C-CE7E0F90EFED};cwBiAGsAaQBtADcAMwBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Sat,
 07 Jul 2012 09:39:51
 GMT;WwBQAEEAVABDAEgAIABWADIAIAAzAC8ANwBdACAAcgBlAGcAdQBsAGEAdABvAHIAOgAgAHMANQBtADgANwA2ADcAOgAgAE0AbwBkAGkAZgB5ACAAZgB1AG4AYwB0AGkAbwBuACAAYQBuAGQAIAB2AGEAcgBpAGEAYgBsAGUAIABuAGEAbQBlAA==
x-cr-puzzleid: {5C12E12D-C92F-466B-8C8C-CE7E0F90EFED}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAd23zD/8DRZOsbK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZM+dMYSm47lrx8uYulgbGYxZdjJwcEgImEjNubWKFsMUkLtxb
	z9bFyMUhJLCIUeLtwTcsEM5cJombc3uZQarYBDQkVu5+ywZiiwiEScyctZIFxGYW8JK4+Oo5
	mC0s4CvxYudxRhCbRUBVYkf7frANvAKGEr3TnzBD2IISPybfg+rVkli/8zgThC0vsXnNW6Aa
	DqCL1CUe/dWFWKUn8WrSI6gSEYl9L94xgtwmIfCAVWLl2f+MEB+YSnzfu5ZlAqPQLCQrZiFZ
	MQvJillIZi1gZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzKz6R2MK5ssDjEKMDBqMTD
	+2HHd38h1sSy4srcQ4wSHMxKIrw/7gGFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8xp7f/UXEkhP
	LEnNTk0tSC2CyTJxcEoB4+IPy5Uk3tnWxiKlTb+XzN6h9lW49aiezO+zeR9aZ1kwNaou+NNy
	fdH2i9ueKJj4N/F9jKnu7ZUtElTjs7VUyrnDtnXmZLX4DpdrTcabN166fv/JLeOJsTeeNgpJ
	THe5nmMyQ887I+CAUj2DA9+lZ1Pqew23OF85eEOv1q1OJevxAb7Kv+W3lFiKMxINtZiLihMB
	NCqEimECAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As function and variable name of Samsung mfd driver is changed,
This patch modify s5m8767 regulator driver.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |   74 +++++++++++++++++++++---------------------
 1 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index f292e56..79b0659 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -24,10 +24,10 @@
 
 struct s5m8767_info {
 	struct device *dev;
-	struct s5m87xx_dev *iodev;
+	struct sec_pmic_dev *iodev;
 	int num_regulators;
 	struct regulator_dev **rdev;
-	struct s5m_opmode_data *opmode;
+	struct sec_opmode_data *opmode;
 
 	int ramp_delay;
 	bool buck2_ramp;
@@ -45,43 +45,43 @@ struct s5m8767_info {
 	int buck_gpioindex;
 };
 
-struct s5m_voltage_desc {
+struct sec_voltage_desc {
 	int max;
 	int min;
 	int step;
 };
 
-static const struct s5m_voltage_desc buck_voltage_val1 = {
+static const struct sec_voltage_desc buck_voltage_val1 = {
 	.max = 2225000,
 	.min =  650000,
 	.step =   6250,
 };
 
-static const struct s5m_voltage_desc buck_voltage_val2 = {
+static const struct sec_voltage_desc buck_voltage_val2 = {
 	.max = 1600000,
 	.min =  600000,
 	.step =   6250,
 };
 
-static const struct s5m_voltage_desc buck_voltage_val3 = {
+static const struct sec_voltage_desc buck_voltage_val3 = {
 	.max = 3000000,
 	.min =  750000,
 	.step =  12500,
 };
 
-static const struct s5m_voltage_desc ldo_voltage_val1 = {
+static const struct sec_voltage_desc ldo_voltage_val1 = {
 	.max = 3950000,
 	.min =  800000,
 	.step =  50000,
 };
 
-static const struct s5m_voltage_desc ldo_voltage_val2 = {
+static const struct sec_voltage_desc ldo_voltage_val2 = {
 	.max = 2375000,
 	.min =  800000,
 	.step =  25000,
 };
 
-static const struct s5m_voltage_desc *reg_voltage_map[] = {
+static const struct sec_voltage_desc *reg_voltage_map[] = {
 	[S5M8767_LDO1] = &ldo_voltage_val2,
 	[S5M8767_LDO2] = &ldo_voltage_val2,
 	[S5M8767_LDO3] = &ldo_voltage_val1,
@@ -213,7 +213,7 @@ static int s5m8767_reg_is_enabled(struct regulator_dev *rdev)
 	else if (ret)
 		return ret;
 
-	ret = s5m_reg_read(s5m8767->iodev, reg, &val);
+	ret = sec_reg_read(s5m8767->iodev, reg, &val);
 	if (ret)
 		return ret;
 
@@ -230,7 +230,7 @@ static int s5m8767_reg_enable(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return s5m_reg_update(s5m8767->iodev, reg, enable_ctrl, mask);
+	return sec_reg_update(s5m8767->iodev, reg, enable_ctrl, mask);
 }
 
 static int s5m8767_reg_disable(struct regulator_dev *rdev)
@@ -243,7 +243,7 @@ static int s5m8767_reg_disable(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return s5m_reg_update(s5m8767->iodev, reg, ~mask, mask);
+	return sec_reg_update(s5m8767->iodev, reg, ~mask, mask);
 }
 
 static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
@@ -305,7 +305,7 @@ static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 
 	mask = (reg_id < S5M8767_BUCK1) ? 0x3f : 0xff;
 
-	ret = s5m_reg_read(s5m8767->iodev, reg, &val);
+	ret = sec_reg_read(s5m8767->iodev, reg, &val);
 	if (ret)
 		return ret;
 
@@ -315,7 +315,7 @@ static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 }
 
 static int s5m8767_convert_voltage_to_sel(
-		const struct s5m_voltage_desc *desc,
+		const struct sec_voltage_desc *desc,
 		int min_vol, int max_vol)
 {
 	int selector = 0;
@@ -407,7 +407,7 @@ static int s5m8767_set_voltage_sel(struct regulator_dev *rdev,
 		if (ret)
 			return ret;
 
-		return s5m_reg_update(s5m8767->iodev, reg, selector, mask);
+		return sec_reg_update(s5m8767->iodev, reg, selector, mask);
 	}
 }
 
@@ -416,7 +416,7 @@ static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
 					     unsigned int new_sel)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	const struct s5m_voltage_desc *desc;
+	const struct sec_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
 
 	desc = reg_voltage_map[reg_id];
@@ -501,8 +501,8 @@ static struct regulator_desc regulators[] = {
 
 static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 {
-	struct s5m87xx_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct s5m_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct sec_pmic_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct regulator_config config = { };
 	struct regulator_dev **rdev;
 	struct s5m8767_info *s5m8767;
@@ -572,21 +572,21 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 						pdata->buck2_init +
 						buck_voltage_val2.step);
 
-	s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS2, buck_init);
+	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS2, buck_init);
 
 	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
 						pdata->buck3_init,
 						pdata->buck3_init +
 						buck_voltage_val2.step);
 
-	s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS2, buck_init);
+	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS2, buck_init);
 
 	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
 						pdata->buck4_init,
 						pdata->buck4_init +
 						buck_voltage_val2.step);
 
-	s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS2, buck_init);
+	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS2, buck_init);
 
 	for (i = 0; i < 8; i++) {
 		if (s5m8767->buck2_gpiodvs) {
@@ -672,13 +672,13 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 
 	if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs ||
 	   pdata->buck4_gpiodvs) {
-		s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
+		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
 				(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1),
 				1 << 1);
-		s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
+		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
 				(pdata->buck3_gpiodvs) ? (1 << 1) : (0 << 1),
 				1 << 1);
-		s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
+		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
 				(pdata->buck4_gpiodvs) ? (1 << 1) : (0 << 1),
 				1 << 1);
 	}
@@ -686,61 +686,61 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 	/* Initialize GPIO DVS registers */
 	for (i = 0; i < 8; i++) {
 		if (s5m8767->buck2_gpiodvs) {
-			s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS1 + i,
+			sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS1 + i,
 					   s5m8767->buck2_vol[i]);
 		}
 
 		if (s5m8767->buck3_gpiodvs) {
-			s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS1 + i,
+			sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS1 + i,
 					   s5m8767->buck3_vol[i]);
 		}
 
 		if (s5m8767->buck4_gpiodvs) {
-			s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS1 + i,
+			sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS1 + i,
 					   s5m8767->buck4_vol[i]);
 		}
 	}
 
 	if (s5m8767->buck2_ramp)
-		s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x08, 0x08);
+		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x08, 0x08);
 
 	if (s5m8767->buck3_ramp)
-		s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x04, 0x04);
+		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x04, 0x04);
 
 	if (s5m8767->buck4_ramp)
-		s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x02, 0x02);
+		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x02, 0x02);
 
 	if (s5m8767->buck2_ramp || s5m8767->buck3_ramp
 		|| s5m8767->buck4_ramp) {
 		switch (s5m8767->ramp_delay) {
 		case 5:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0x40, 0xf0);
 			break;
 		case 10:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0x90, 0xf0);
 			break;
 		case 25:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xd0, 0xf0);
 			break;
 		case 50:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xe0, 0xf0);
 			break;
 		case 100:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xf0, 0xf0);
 			break;
 		default:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0x90, 0xf0);
 		}
 	}
 
 	for (i = 0; i < pdata->num_regulators; i++) {
-		const struct s5m_voltage_desc *desc;
+		const struct sec_voltage_desc *desc;
 		int id = pdata->regulators[i].id;
 
 		desc = reg_voltage_map[id];
-- 
1.7.5.4


