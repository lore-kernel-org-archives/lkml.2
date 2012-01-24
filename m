Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab2AXLcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:32:21 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64744 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2AXLcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:32:20 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 24 Jan 2012 12:31:11 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH] max8997: Avoid spaces in regulator names
To: myungjoo.ham@smasung.com
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        rnayak@ti.com, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Message-id: <1327404672-5459-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max8997-pmic instantiated from device tree uses names, not numerical
ids to distinguish between outputs.

Replace spaces with underscores in said names to make it possible to
describe these outputs as regulators in DTS.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/regulator/max8997.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 053d0b7..4b572eb 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -910,13 +910,13 @@ static struct regulator_desc regulators[] = {
 	},
 	regulator_desc_buck(7),
 	{
-		.name	= "EN32KHz AP",
+		.name	= "EN32KHz_AP",
 		.id	= MAX8997_EN32KHZ_AP,
 		.ops	= &max8997_fixedvolt_ops,
 		.type	= REGULATOR_VOLTAGE,
 		.owner	= THIS_MODULE,
 	}, {
-		.name	= "EN32KHz CP",
+		.name	= "EN32KHz_CP",
 		.id	= MAX8997_EN32KHZ_CP,
 		.ops	= &max8997_fixedvolt_ops,
 		.type	= REGULATOR_VOLTAGE,
@@ -940,7 +940,7 @@ static struct regulator_desc regulators[] = {
 		.type	= REGULATOR_VOLTAGE,
 		.owner	 = THIS_MODULE,
 	}, {
-		.name	= "CHARGER CV",
+		.name	= "CHARGER_CV",
 		.id	= MAX8997_CHARGER_CV,
 		.ops	= &max8997_fixedstate_ops,
 		.type	= REGULATOR_VOLTAGE,
@@ -952,7 +952,7 @@ static struct regulator_desc regulators[] = {
 		.type	= REGULATOR_CURRENT,
 		.owner	 = THIS_MODULE,
 	}, {
-		.name	= "CHARGER TOPOFF",
+		.name	= "CHARGER_TOPOFF",
 		.id	= MAX8997_CHARGER_TOPOFF,
 		.ops	= &max8997_charger_fixedstate_ops,
 		.type	= REGULATOR_CURRENT,
-- 
1.7.8.3

