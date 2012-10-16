Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2JPMAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:00:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33186 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab2JPMAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:00:54 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-9a-507d4c74ebfd
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH v2 2/2] regulator: max77686: Add
 set_suspend_disable/set_suspend_mode callbacks.
Date: Tue, 16 Oct 2012 17:24:19 +0530
Message-id: <1350388459-28975-2-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1350388459-28975-1-git-send-email-yadi.brar@samsung.com>
References: <1350388459-28975-1-git-send-email-yadi.brar@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWyRsSkVrfEpzbA4M1dfovLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVx/fNO1oK71hXfZ/5hamB8atDFyMkhIWAicWR/NyuELSZx4d56
	ti5GLg4hgaWMEk9uPmKDKZp2+TcrRGI6o8T+V1sYIZzlTBLtU08AZTg42ASMJF4dswNpEBFQ
	kNjc+wysgVngDpPE/kuNTCA1wgJJEnvmy4HUsAioSkw50MMCYvMKuEos3N7HBLFMQaJ12SF2
	EJtTwE1i6uf5jCC2EFDNrr+72CB6BSS+TT7EAjJSQkBWYtMBZojW62wSne8TIWxJiYMrbrBM
	YBRewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyMwAE//eya9g3FVg8UhRgEORiUe3gzn
	mgAh1sSy4srcQ4wSHMxKIryqtrUBQrwpiZVVqUX58UWlOanFhxh9gA6ZyCwlmpwPjI68knhD
	YxNzU2NTSyMjM1NTHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhgZTq+d/35KZvkUgUnx
	cZ9URDXWafGtXlztsvF8xZQVfWHsrup9d7YuXF8qafe28lVUX5hGyhxb3tAn+bLiNxZf6rb/
	sucRx6Ijj7fPeeJszWx95LXPz/X3HdKfJVxombDxGm/x4gOHTr9jlDlS+eB24LeQ7hnBLM+j
	d24QYVx+ftIz/QChrFBRJZbijERDLeai4kQAgMQejW0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xoG6JT22AwbQ/LBaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4/rnnawFd60rvs/8w9TA
	+NSgi5GTQ0LARGLa5d+sELaYxIV769m6GLk4hASmM0rsf7WFEcJZziTRPvUEUBUHB5uAkcSr
	Y3YgDSICChKbe5+xgtQwC9xhkth/qZEJpEZYIEliz3w5kBoWAVWJKQd6WEBsXgFXiYXb+5gg
	lilItC47xA5icwq4SUz9PJ8RxBYCqtn1dxfbBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1
	kvNzNzGCA/yZ9A7GVQ0WhxgFOBiVeHgznGsChFgTy4orcw8xSnAwK4nwqtrWBgjxpiRWVqUW
	5ccXleakFh9i9AG6aiKzlGhyPjD68kriDY1NzE2NTS1NLEzMLHEIK4nzNnukBAgJpCeWpGan
	phakFsGMY+LglGpg1OEMT49Z+Nty+u+fZQ86p+5aZxEq/F644oNZ2IV21xfdBrc2bM7YcNB9
	62/j6N166+RVZ9aEJsVEMD4QZs+58WPXSgZV8bt+X7jzZ7veyX+yP/jIeZ8NK3jYj0t8m2zJ
	Om3bjP2PrT/LXPdLdz80+/+EpNtHu/0DFmaaqeqvve0StXXCe6YN7EosxRmJhlrMRcWJACVU
	/hGdAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements set_suspend_disable callback for BUCKs which
support only switch ON/OFF modes during system suspend state, and
set_suspend_mode callbacks for LDOs which also suport Low power mode and
switch ON/OFF modes.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/max77686.c |  148 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 141 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 20dae7b..383eb9d 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -70,6 +70,82 @@ struct max77686_data {
 	unsigned int opmode[MAX77686_REGULATORS];
 };
 
+/* Some BUCKS supports Normal[ON/OFF] mode during suspend */
+static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
+{
+	unsigned int val;
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+
+	if (rdev->desc->id == MAX77686_BUCK1)
+		val = 0x1;
+	else
+		val = 0x1 << MAX77686_OPMODE_BUCK234_SHIFT;
+
+	max77686->opmode[rdev->desc->id] = val;
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask,
+				  val);
+}
+
+/* Some LDOs supports [LPM/Normal]ON mode during suspend state */
+static int max77686_set_suspend_mode(struct regulator_dev *rdev,
+				     unsigned int mode)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	unsigned int val;
+
+	/* BUCK[5-9] doesn't support this feature */
+	if (rdev->desc->id >= MAX77686_BUCK5)
+		return 0;
+
+	switch (mode) {
+	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
+		val = 0x2 << MAX77686_OPMODE_SHIFT;
+		break;
+	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
+		val = 0x3 << MAX77686_OPMODE_SHIFT;
+		break;
+	default:
+		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
+			rdev->desc->name, mode);
+		return -EINVAL;
+	}
+
+	max77686->opmode[rdev->desc->id] = val;
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask,
+				  val);
+}
+
+/* Some LDOs supports LPM-ON/OFF/Normal-ON mode during suspend state */
+static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
+				     unsigned int mode)
+{
+	unsigned int val;
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+
+	switch (mode) {
+	case REGULATOR_MODE_STANDBY:			/* switch off */
+		val = 0x1 << MAX77686_OPMODE_SHIFT;
+		break;
+	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
+		val = 0x2 << MAX77686_OPMODE_SHIFT;
+		break;
+	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
+		val = 0x3 << MAX77686_OPMODE_SHIFT;
+		break;
+	default:
+		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
+			rdev->desc->name, mode);
+		return -EINVAL;
+	}
+
+	max77686->opmode[rdev->desc->id] = val;
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask,
+				  val);
+}
+
 int max77686_enable(struct regulator_dev *rdev)
 {
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
@@ -113,6 +189,31 @@ static struct regulator_ops max77686_ops = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_suspend_mode	= max77686_set_suspend_mode,
+};
+
+static struct regulator_ops max77686_ldo_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= max77686_enable,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_suspend_mode	= max77686_ldo_set_suspend_mode,
+};
+
+static struct regulator_ops max77686_buck1_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= max77686_enable,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_suspend_disable	= max77686_buck_set_suspend_disable,
 };
 
 static struct regulator_ops max77686_buck_dvs_ops = {
@@ -125,6 +226,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_ramp_delay		= max77686_set_ramp_delay,
+	.set_suspend_disable	= max77686_buck_set_suspend_disable,
 };
 
 #define regulator_desc_ldo(num)		{				\
@@ -143,9 +245,41 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.enable_mask	= MAX77686_OPMODE_MASK				\
 			<< MAX77686_OPMODE_SHIFT,			\
 }
+#define regulator_desc_lpm_ldo(num)	{				\
+	.name		= "LDO"#num,					\
+	.id		= MAX77686_LDO##num,				\
+	.ops		= &max77686_ldo_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_LDO_MINUV,				\
+	.uV_step	= MAX77686_LDO_UVSTEP,				\
+	.ramp_delay	= MAX77686_RAMP_DELAY,				\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.enable_mask	= MAX77686_OPMODE_MASK				\
+			<< MAX77686_OPMODE_SHIFT,			\
+}
 #define regulator_desc_ldo_low(num)		{			\
 	.name		= "LDO"#num,					\
 	.id		= MAX77686_LDO##num,				\
+	.ops		= &max77686_ldo_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_LDO_LOW_MINUV,			\
+	.uV_step	= MAX77686_LDO_LOW_UVSTEP,			\
+	.ramp_delay	= MAX77686_RAMP_DELAY,				\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.enable_mask	= MAX77686_OPMODE_MASK				\
+			<< MAX77686_OPMODE_SHIFT,			\
+}
+#define regulator_desc_ldo1_low(num)		{			\
+	.name		= "LDO"#num,					\
+	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
 	.owner		= THIS_MODULE,					\
@@ -177,7 +311,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 #define regulator_desc_buck1(num)		{			\
 	.name		= "BUCK"#num,					\
 	.id		= MAX77686_BUCK##num,				\
-	.ops		= &max77686_ops,				\
+	.ops		= &max77686_buck1_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
 	.owner		= THIS_MODULE,					\
 	.min_uV		= MAX77686_BUCK_MINUV,				\
@@ -207,7 +341,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 
 static struct regulator_desc regulators[] = {
-	regulator_desc_ldo_low(1),
+	regulator_desc_ldo1_low(1),
 	regulator_desc_ldo_low(2),
 	regulator_desc_ldo(3),
 	regulator_desc_ldo(4),
@@ -216,13 +350,13 @@ static struct regulator_desc regulators[] = {
 	regulator_desc_ldo_low(7),
 	regulator_desc_ldo_low(8),
 	regulator_desc_ldo(9),
-	regulator_desc_ldo(10),
-	regulator_desc_ldo(11),
-	regulator_desc_ldo(12),
+	regulator_desc_lpm_ldo(10),
+	regulator_desc_lpm_ldo(11),
+	regulator_desc_lpm_ldo(12),
 	regulator_desc_ldo(13),
-	regulator_desc_ldo(14),
+	regulator_desc_lpm_ldo(14),
 	regulator_desc_ldo_low(15),
-	regulator_desc_ldo(16),
+	regulator_desc_lpm_ldo(16),
 	regulator_desc_ldo(17),
 	regulator_desc_ldo(18),
 	regulator_desc_ldo(19),
-- 
1.7.0.4

