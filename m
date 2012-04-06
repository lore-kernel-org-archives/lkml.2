Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2DFAb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:31:58 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40543 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab2DFAb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:31:56 -0400
Message-ID: <1333672311.2777.9.camel@phoenix>
Subject: [PATCH 6/6] regulator: tps65217: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: AnilKumar Ch <anilkumar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 06 Apr 2012 08:31:51 +0800
In-Reply-To: <1333671867.2777.2.camel@phoenix>
References: <1333671867.2777.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65217-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index e39521b..80fad2d 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -312,7 +312,7 @@ static struct regulator_ops tps65217_pmic_ldo1_ops = {
 	.list_voltage		= tps65217_pmic_list_voltage,
 };
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1, tps65217_pmic_ops, 64),
 	TPS65217_REGULATOR("DCDC2", TPS65217_DCDC_2, tps65217_pmic_ops, 64),
 	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3, tps65217_pmic_ops, 64),
-- 
1.7.5.4



