Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab2GLBgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 21:36:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab2GLBf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 21:35:59 -0400
Message-ID: <1342056950.19192.0.camel@phoenix>
Subject: [PATCH 1/3] regulator: s2mps11: Fixup missing commas
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Jul 2012 09:35:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s2mps11.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 514cf54..da8c3d1 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -88,7 +88,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.uV_step	= S2MPS11_LDO_STEP1,		\
 	.n_voltages	= S2MPS11_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPS11_REG_L1CTRL + num - 1,	\
-	.vsel_mask	= S2MPS11_LDO_VSEL_MASK		\
+	.vsel_mask	= S2MPS11_LDO_VSEL_MASK,	\
 	.enable_reg	= S2MPS11_REG_L1CTRL + num - 1,	\
 	.enable_mask	= S2MPS11_ENABLE_MASK		\
 }
@@ -102,7 +102,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.uV_step	= S2MPS11_LDO_STEP2,		\
 	.n_voltages	= S2MPS11_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPS11_REG_L1CTRL + num - 1,	\
-	.vsel_mask	= S2MPS11_LDO_VSEL_MASK		\
+	.vsel_mask	= S2MPS11_LDO_VSEL_MASK,	\
 	.enable_reg	= S2MPS11_REG_L1CTRL + num - 1,	\
 	.enable_mask	= S2MPS11_ENABLE_MASK		\
 }
@@ -117,7 +117,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.uV_step	= S2MPS11_BUCK_STEP1,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.vsel_reg	= S2MPS11_REG_B1CTRL2 + (num - 1) * 2,	\
-	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK		\
+	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
 	.enable_reg	= S2MPS11_REG_B1CTRL1 + (num - 1) * 2,	\
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
@@ -132,7 +132,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.uV_step	= S2MPS11_BUCK_STEP1,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.vsel_reg	= S2MPS11_REG_B5CTRL2,			\
-	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK		\
+	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
 	.enable_reg	= S2MPS11_REG_B5CTRL1,			\
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
@@ -147,7 +147,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.uV_step	= S2MPS11_BUCK_STEP1,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.vsel_reg	= S2MPS11_REG_B6CTRL2 + (num - 6) * 2,	\
-	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK		\
+	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
 	.enable_reg	= S2MPS11_REG_B6CTRL1 + (num - 6) * 2,	\
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
@@ -162,7 +162,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.uV_step	= S2MPS11_BUCK_STEP3,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.vsel_reg	= S2MPS11_REG_B9CTRL2,			\
-	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK		\
+	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
 	.enable_reg	= S2MPS11_REG_B9CTRL1,			\
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
@@ -177,7 +177,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.uV_step	= S2MPS11_BUCK_STEP2,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
 	.vsel_reg	= S2MPS11_REG_B9CTRL2,			\
-	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK		\
+	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
 	.enable_reg	= S2MPS11_REG_B9CTRL1,			\
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
-- 
1.7.9.5



