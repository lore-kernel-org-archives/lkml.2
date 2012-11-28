Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2K1RZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:25:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33055 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341Ab2K1RZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:25:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] regulator: arizona-ldo1: Add additional top voltage
Date: Wed, 28 Nov 2012 17:25:33 +0000
Message-Id: <1354123534-6927-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354123534-6927-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1354123534-6927-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of voltage slots supported by the LDO is 7, not 6.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index a1e0451..e4b7dd4 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -55,7 +55,7 @@ static const struct regulator_desc arizona_ldo1 = {
 	.bypass_mask = ARIZONA_LDO1_BYPASS,
 	.min_uV = 900000,
 	.uV_step = 50000,
-	.n_voltages = 6,
+	.n_voltages = 7,
 	.enable_time = 500,
 
 	.owner = THIS_MODULE,
-- 
1.7.10.4

