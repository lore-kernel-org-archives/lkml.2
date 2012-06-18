Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab2FRL31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:29:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38073 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2FRL3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:29:24 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-80-4fdf1112168e
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH 4/7] regulator: s5m8767: Modify function and variable name
Date: Mon, 18 Jun 2012 20:29:22 +0900
Message-id: <067601cd4d45$9b82dfa0$d2889ee0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1NRZtkXQI8PSzwSaeyXLiMGvMTsA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jAV0hwfv+Blemilhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M9qs7mQteulVsOOXYwLjfsouRk0NCwETi075/LBC2mMSFe+vZ
	QGwhgUWMEudnCXQxcgHZc5kk9kz5xg6SYBPQkFi5+y1YkYiAr8Sll/9Zuxg5OJgFgiW2ntYD
	CQsLeEmcXTSXFcRmEVCVmHX0HSOIzStgKPG5uYsJwhaU+DH5HtheZgEtifU7jzNB2PISm9e8
	ZQYZKSGgLvHory7EJj2J09vPMUKUiEjse/GOcQKjwCwkk2YhmTQLyaRZSFoWMLKsYhRNLUgu
	KE5KzzXSK07MLS7NS9dLzs/dxAgOyWfSOxhXNVgcYhTgYFTi4X3Dft9fiDWxrLgy9xCjBAez
	kgjvDy6gEG9KYmVValF+fFFpTmrxIUZpDhYlcd4m6wv+QgLpiSWp2ampBalFMFkmDk6pBkb+
	xaecrQUUPb2bDAzdO1p8t1mKv8zZnDNRqEWjd3ahwfS9r72E+DRdJh1/z3H2eLv+u31Fk65c
	mRCduIot40a2uduB2FmB37qmPFBYFyhSufvNuZKAiNsf5OeqWh3f7zf7vOnUpp1vFm1V3DFl
	Q1vf9b57qvMFQ9c0dNnZ7jr5L2aJ6Monxr+UWIozEg21mIuKEwHuYdLmRQIAAA==
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
index bd9cca8..8ac984c 100644
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
@@ -124,7 +124,7 @@ static const struct s5m_voltage_desc *reg_voltage_map[] = {
 static int s5m8767_list_voltage(struct regulator_dev *rdev,
 				unsigned int selector)
 {
-	const struct s5m_voltage_desc *desc;
+	const struct sec_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
 	int val;
 
@@ -234,7 +234,7 @@ static int s5m8767_reg_is_enabled(struct regulator_dev *rdev)
 	else if (ret)
 		return ret;
 
-	ret = s5m_reg_read(s5m8767->iodev, reg, &val);
+	ret = sec_reg_read(s5m8767->iodev, reg, &val);
 	if (ret)
 		return ret;
 
@@ -251,7 +251,7 @@ static int s5m8767_reg_enable(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return s5m_reg_update(s5m8767->iodev, reg, enable_ctrl, mask);
+	return sec_reg_update(s5m8767->iodev, reg, enable_ctrl, mask);
 }
 
 static int s5m8767_reg_disable(struct regulator_dev *rdev)
@@ -264,7 +264,7 @@ static int s5m8767_reg_disable(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return s5m_reg_update(s5m8767->iodev, reg, ~mask, mask);
+	return sec_reg_update(s5m8767->iodev, reg, ~mask, mask);
 }
 
 static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
@@ -326,7 +326,7 @@ static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 
 	mask = (reg_id < S5M8767_BUCK1) ? 0x3f : 0xff;
 
-	ret = s5m_reg_read(s5m8767->iodev, reg, &val);
+	ret = sec_reg_read(s5m8767->iodev, reg, &val);
 	if (ret)
 		return ret;
 
@@ -336,7 +336,7 @@ static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 }
 
 static int s5m8767_convert_voltage_to_sel(
-		const struct s5m_voltage_desc *desc,
+		const struct sec_voltage_desc *desc,
 		int min_vol, int max_vol)
 {
 	int selector = 0;
@@ -428,7 +428,7 @@ static int s5m8767_set_voltage_sel(struct regulator_dev *rdev,
 		if (ret)
 			return ret;
 
-		return s5m_reg_update(s5m8767->iodev, reg, selector, mask);
+		return sec_reg_update(s5m8767->iodev, reg, selector, mask);
 	}
 }
 
@@ -437,7 +437,7 @@ static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
 					     unsigned int new_sel)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	const struct s5m_voltage_desc *desc;
+	const struct sec_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
 
 	desc = reg_voltage_map[reg_id];
@@ -508,8 +508,8 @@ static struct regulator_desc regulators[] = {
 
 static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 {
-	struct s5m87xx_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct s5m_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct sec_pmic_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct regulator_config config = { };
 	struct regulator_dev **rdev;
 	struct s5m8767_info *s5m8767;
@@ -579,21 +579,21 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
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
@@ -679,13 +679,13 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 
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
@@ -693,57 +693,57 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
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
 		case 15:
-			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xc0, 0xf0);
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
1.7.1


