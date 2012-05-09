Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2EIU1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:27:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42424 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932122Ab2EIU1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:27:03 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Staticise non-exported symbol s5m8767_opmode_reg
Date: Wed,  9 May 2012 21:26:57 +0100
Message-Id: <1336595217-21265-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/s5m8767.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index cf12e635..290d6fc 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -141,7 +141,7 @@ static int s5m8767_list_voltage(struct regulator_dev *rdev,
 	return val;
 }
 
-unsigned int s5m8767_opmode_reg[][4] = {
+static unsigned int s5m8767_opmode_reg[][4] = {
 	/* {OFF, ON, LOWPOWER, SUSPEND} */
 	/* LDO1 ... LDO28 */
 	{0x0, 0x3, 0x2, 0x1}, /* LDO1 */
-- 
1.7.10

