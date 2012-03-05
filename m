Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab2CEXmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:42:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52460 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666Ab2CEXmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:42:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Fix register default for WM1811 AntiPOP2
Date: Mon,  5 Mar 2012 23:42:06 +0000
Message-Id: <1330990926-12191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be all bits clear.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-regmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index bd50d80..f00427d 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -59,7 +59,7 @@ static struct reg_default wm1811_defaults[] = {
 	{ 0x0036, 0x0000 },    /* R54   - Speaker Mixer */
 	{ 0x0037, 0x0000 },    /* R55   - Additional Control */
 	{ 0x0038, 0x0000 },    /* R56   - AntiPOP (1) */
-	{ 0x0039, 0x0180 },    /* R57   - AntiPOP (2) */
+	{ 0x0039, 0x0000 },    /* R57   - AntiPOP (2) */
 	{ 0x003B, 0x000D },    /* R59   - LDO 1 */
 	{ 0x003C, 0x0003 },    /* R60   - LDO 2 */
 	{ 0x003D, 0x0039 },    /* R61   - MICBIAS1 */
-- 
1.7.9.1

