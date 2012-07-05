Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab2GETgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:36:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41986 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757313Ab2GETfj (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 5 Jul 2012 15:35:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/6] mfd: wm5102: Mark headphone detect readback register volatile
Date: Thu,  5 Jul 2012 20:35:33 +0100
Message-Id: <1341516933-16474-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 9b38b6b..01b9255 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -813,7 +813,6 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x0000021A, 0x01A6 },   /* R538   - Mic Bias Ctrl 3 */ 
 	{ 0x00000293, 0x0000 },   /* R659   - Accessory Detect Mode 1 */ 
 	{ 0x0000029B, 0x0020 },   /* R667   - Headphone Detect 1 */ 
-	{ 0x0000029C, 0x0000 },   /* R668   - Headphone Detect 2 */ 
 	{ 0x000002A3, 0x1102 },   /* R675   - Mic Detect 1 */ 
 	{ 0x000002A4, 0x009F },   /* R676   - Mic Detect 2 */ 
 	{ 0x000002A5, 0x0000 },   /* R677   - Mic Detect 3 */ 
@@ -2362,6 +2361,7 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_AOD_IRQ_RAW_STATUS:
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
+	case ARIZONA_HEADPHONE_DETECT_2:
 	case ARIZONA_MIC_DETECT_3:
 		return true;
 	default:
-- 
1.7.10

