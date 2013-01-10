Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3AJMUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:20:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41530 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002Ab3AJMTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:19:00 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 9/9] mfd: wm5102: Update rev B patch for latest evaluation
Date: Thu, 10 Jan 2013 12:18:52 +0000
Message-Id: <1357820332-14586-9-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110121828.GN20956@opensource.wolfsonmicro.com>
 <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest evaluation of the revision B silicon suggests some changes to
the tuning applied for optimal performance.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index edee1da..a687901 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -59,12 +59,14 @@ static const struct reg_default wm5102_reva_patch[] = {
 static const struct reg_default wm5102_revb_patch[] = {
 	{ 0x80, 0x0003 },
 	{ 0x081, 0xE022 },
-	{ 0x410, 0x6080 },
-	{ 0x418, 0x6080 },
-	{ 0x420, 0x6080 },
+	{ 0x410, 0x4080 },
+	{ 0x418, 0x4080 },
+	{ 0x420, 0x4080 },
 	{ 0x428, 0xC000 },
-	{ 0x441, 0x8014 },
+	{ 0x4B0, 0x0066 },
 	{ 0x458, 0x000b },
+	{ 0x212, 0x0000 },
+	{ 0x171, 0x0000 },
 	{ 0x80, 0x0000 },
 };
 
@@ -274,7 +276,7 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000155, 0x0000 },   /* R341   - Rate Estimator 4 */ 
 	{ 0x00000156, 0x0000 },   /* R342   - Rate Estimator 5 */ 
 	{ 0x00000161, 0x0000 },   /* R353   - Dynamic Frequency Scaling 1 */ 
-	{ 0x00000171, 0x0002 },   /* R369   - FLL1 Control 1 */
+	{ 0x00000171, 0x0000 },   /* R369   - FLL1 Control 1 */
 	{ 0x00000172, 0x0008 },   /* R370   - FLL1 Control 2 */ 
 	{ 0x00000173, 0x0018 },   /* R371   - FLL1 Control 3 */ 
 	{ 0x00000174, 0x007D },   /* R372   - FLL1 Control 4 */ 
-- 
1.7.10.4

