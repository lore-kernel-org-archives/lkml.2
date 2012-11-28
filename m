Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2K1RZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:25:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33053 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277Ab2K1RZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:25:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] regulator: arizona-ldo1: Add enable time
Date: Wed, 28 Nov 2012 17:25:31 +0000
Message-Id: <1354123534-6927-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index b44fa6f..908996a 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -56,6 +56,7 @@ static const struct regulator_desc arizona_ldo1 = {
 	.min_uV = 900000,
 	.uV_step = 50000,
 	.n_voltages = 6,
+	.enable_time = 500,
 
 	.owner = THIS_MODULE,
 };
-- 
1.7.10.4

