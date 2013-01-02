Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3ABOaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 09:30:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34472 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682Ab3ABOaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 09:30:21 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5102: Update rev B patch for latest evaluation
Date: Wed,  2 Jan 2013 14:30:18 +0000
Message-Id: <1357137018-32201-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest evaluation of the revision B silicon suggests some changes to
the tuning applied for optimal performance.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index cf7784b..277bc61 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -59,12 +59,13 @@ static const struct reg_default wm5102_reva_patch[] = {
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
 	{ 0x80, 0x0000 },
 };
 
-- 
1.7.10.4

