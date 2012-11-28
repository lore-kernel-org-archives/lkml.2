Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab2K1SrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:47:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56112 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236Ab2K1SrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:47:05 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linx.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5102: Correct default for LDO1_CONTROL_2
Date: Wed, 28 Nov 2012 18:47:01 +0000
Message-Id: <1354128421-12620-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 50bbe15..065ffd3 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -307,6 +307,7 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x000001AA, 0x0004 },   /* R426   - FLL2 GPIO Clock */ 
 	{ 0x00000200, 0x0006 },   /* R512   - Mic Charge Pump 1 */ 
 	{ 0x00000210, 0x00D4 },   /* R528   - LDO1 Control 1 */ 
+	{ 0x00000212, 0x0001 },   /* R530   - LDO1 Control 2 */ 
 	{ 0x00000213, 0x0344 },   /* R531   - LDO2 Control 1 */ 
 	{ 0x00000218, 0x01A6 },   /* R536   - Mic Bias Ctrl 1 */ 
 	{ 0x00000219, 0x01A6 },   /* R537   - Mic Bias Ctrl 2 */ 
-- 
1.7.10.4

