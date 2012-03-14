Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab2CNS1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:27:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53028 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106Ab2CNS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:27:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jin Park <jinyoungp@nvidia.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: aat2870: Add MODULE_ALIAS
Date: Wed, 14 Mar 2012 18:27:13 +0000
Message-Id: <1331749633-27164-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not that it's ever likely to get used.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/aat2870-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 9ed5c5d..7cc380e 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -231,3 +231,4 @@ module_exit(aat2870_regulator_exit);
 MODULE_DESCRIPTION("AnalogicTech AAT2870 Regulator");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jin Park <jinyoungp@nvidia.com>");
+MODULE_ALIAS("platform:aat2870-regulator");
-- 
1.7.9.1

