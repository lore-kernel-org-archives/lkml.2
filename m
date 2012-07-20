Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2GTMbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:31:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33561 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2GTMb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:31:29 -0400
Message-ID: <1342787479.3531.1.camel@phoenix>
Subject: [PATCH] regulator: lp8788-ldo: Set n_voltages to 1 for fixed voltage
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Jul 2012 20:31:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For fixed voltage, the n_voltages should be 1 rather than 0.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp8788-ldo.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index d2122e4..6796eeb 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -496,6 +496,7 @@ static struct regulator_desc lp8788_dldo_desc[] = {
 		.name = "dldo12",
 		.id = DLDO12,
 		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_B,
@@ -521,6 +522,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.name = "aldo2",
 		.id = ALDO2,
 		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_B,
@@ -530,6 +532,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.name = "aldo3",
 		.id = ALDO3,
 		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_B,
@@ -539,6 +542,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.name = "aldo4",
 		.id = ALDO4,
 		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_B,
@@ -548,6 +552,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.name = "aldo5",
 		.id = ALDO5,
 		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_C,
@@ -583,6 +588,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.name = "aldo8",
 		.id = ALDO8,
 		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_C,
@@ -592,6 +598,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.name = "aldo9",
 		.id = ALDO9,
 		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_C,
@@ -601,6 +608,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.name = "aldo10",
 		.id = ALDO10,
 		.ops = &lp8788_ldo_voltage_fixed_ops,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_C,
-- 
1.7.9.5



