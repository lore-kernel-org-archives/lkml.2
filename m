Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab2HWPKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:10:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49222 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab2HWPKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:10:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Update WM1811 register patches for latest evaluation
Date: Thu, 23 Aug 2012 16:10:29 +0100
Message-Id: <1345734629-19545-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further evaluation of the device has yielded some improvements to the
device configuration.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 2febf88..3d6d9be 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -390,7 +390,7 @@ static const __devinitdata struct reg_default wm8958_reva_patch[] = {
 
 static const __devinitdata struct reg_default wm1811_reva_patch[] = {
 	{ 0x102, 0x3 },
-	{ 0x56, 0x7 },
+	{ 0x56, 0xc07 },
 	{ 0x5d, 0x7e },
 	{ 0x5e, 0x0 },
 	{ 0x102, 0x0 },
-- 
1.7.10.4

