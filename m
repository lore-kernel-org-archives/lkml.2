Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3AJMTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:19:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41526 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325Ab3AJMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:18:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 7/9] mfd: wm5102: Add registers for microphone detection level configuration
Date: Thu, 10 Jan 2013 12:18:50 +0000
Message-Id: <1357820332-14586-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110121828.GN20956@opensource.wolfsonmicro.com>
 <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 0317d11..167e6c4 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -315,6 +315,10 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x000002A3, 0x1102 },   /* R675   - Mic Detect 1 */ 
 	{ 0x000002A4, 0x009F },   /* R676   - Mic Detect 2 */ 
 	{ 0x000002A5, 0x0000 },   /* R677   - Mic Detect 3 */ 
+	{ 0x000002A6, 0x3737 },   /* R678   - Mic Detect Level 1 */
+	{ 0x000002A7, 0x372C },   /* R679   - Mic Detect Level 2 */
+	{ 0x000002A8, 0x1422 },   /* R680   - Mic Detect Level 3 */
+	{ 0x000002A9, 0x300A },   /* R681   - Mic Detect Level 4 */
 	{ 0x000002C3, 0x0000 },   /* R707   - Mic noise mix control 1 */ 
 	{ 0x000002CB, 0x0000 },   /* R715   - Isolation control */ 
 	{ 0x000002D3, 0x0000 },   /* R723   - Jack detect analogue */ 
@@ -1109,6 +1113,10 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_MIC_DETECT_1:
 	case ARIZONA_MIC_DETECT_2:
 	case ARIZONA_MIC_DETECT_3:
+	case ARIZONA_MIC_DETECT_LEVEL_1:
+	case ARIZONA_MIC_DETECT_LEVEL_2:
+	case ARIZONA_MIC_DETECT_LEVEL_3:
+	case ARIZONA_MIC_DETECT_LEVEL_4:
 	case ARIZONA_MIC_NOISE_MIX_CONTROL_1:
 	case ARIZONA_ISOLATION_CONTROL:
 	case ARIZONA_JACK_DETECT_ANALOGUE:
-- 
1.7.10.4

