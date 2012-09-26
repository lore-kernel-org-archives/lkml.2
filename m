Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2IZRAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:00:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54812 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757423Ab2IZRAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:00:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: wm5110: Add register patches for revision B
Date: Wed, 26 Sep 2012 18:00:29 +0100
Message-Id: <1348678829-15496-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348678829-15496-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1348678829-15496-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c |   96 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index bd8782c..adda6b1 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -133,15 +133,109 @@ static const struct reg_default wm5110_reva_patch[] = {
 	{ 0x209, 0x002A },
 };
 
+static const struct reg_default wm5110_revb_patch[] = {
+	{ 0x80, 0x3 },
+	{ 0x36e, 0x0210 },
+	{ 0x370, 0x0210 },
+	{ 0x372, 0x0210 },
+	{ 0x374, 0x0210 },
+	{ 0x376, 0x0210 },
+	{ 0x378, 0x0210 },
+	{ 0x36d, 0x0028 },
+	{ 0x36f, 0x0028 },
+	{ 0x371, 0x0028 },
+	{ 0x373, 0x0028 },
+	{ 0x375, 0x0028 },
+	{ 0x377, 0x0028 },
+	{ 0x280, 0x2002 },
+	{ 0x44, 0x20 },
+	{ 0x45, 0x40 },
+	{ 0x46, 0x60 },
+	{ 0x47, 0x80 },
+	{ 0x48, 0xa0 },
+	{ 0x51, 0x13 },
+	{ 0x52, 0x33 },
+	{ 0x53, 0x53 },
+	{ 0x54, 0x73 },
+	{ 0x55, 0x93 },
+	{ 0x56, 0xb3 },
+	{ 0xc30, 0x3e3e },
+	{ 0xc31, 0x3e },
+	{ 0xc32, 0x3e3e },
+	{ 0xc33, 0x3e3e },
+	{ 0xc34, 0x3e3e },
+	{ 0xc35, 0x3e3e },
+	{ 0xc36, 0x3e3e },
+	{ 0xc37, 0x3e3e },
+	{ 0xc38, 0x3e3e },
+	{ 0xc39, 0x3e3e },
+	{ 0xc3a, 0x3e3e },
+	{ 0xc3b, 0x3e3e },
+	{ 0xc3c, 0x3e },
+	{ 0x201, 0x18a5 },
+	{ 0x202, 0x4100 },
+	{ 0x460, 0x0c40 },
+	{ 0x461, 0x8000 },
+	{ 0x462, 0x0c41 },
+	{ 0x463, 0x4820 },
+	{ 0x464, 0x0c41 },
+	{ 0x465, 0x4040 },
+	{ 0x466, 0x0841 },
+	{ 0x467, 0x3940 },
+	{ 0x468, 0x0841 },
+	{ 0x469, 0x2030 },
+	{ 0x46a, 0x0842 },
+	{ 0x46b, 0x1990 },
+	{ 0x46c, 0x08c2 },
+	{ 0x46d, 0x1450 },
+	{ 0x46e, 0x08c6 },
+	{ 0x46f, 0x1020 },
+	{ 0x470, 0x08c6 },
+	{ 0x471, 0x0cd0 },
+	{ 0x472, 0x08c6 },
+	{ 0x473, 0x0a30 },
+	{ 0x474, 0x0442 },
+	{ 0x475, 0x0660 },
+	{ 0x476, 0x0446 },
+	{ 0x477, 0x0510 },
+	{ 0x478, 0x04c6 },
+	{ 0x479, 0x0400 },
+	{ 0x47a, 0x04ce },
+	{ 0x47b, 0x0330 },
+	{ 0x47c, 0x05df },
+	{ 0x47d, 0x0001 },
+	{ 0x47e, 0x07ff },
+	{ 0x2db, 0x0a00 },
+	{ 0x2dd, 0x0023 },
+	{ 0x2df, 0x0102 },
+	{ 0x2ef, 0x924 },
+	{ 0x2f0, 0x924 },
+	{ 0x2f1, 0x924 },
+	{ 0x2f2, 0x924 },
+	{ 0x2f3, 0x924 },
+	{ 0x2f4, 0x924 },
+	{ 0x2eb, 0x60 },
+	{ 0x2ec, 0x60 },
+	{ 0x2ed, 0x60 },
+	{ 0x4f2, 0x33e },
+	{ 0x458, 0x0000 },
+	{ 0x15a, 0x0003 },
+	{ 0x80, 0x0 },
+};
+
 /* We use a function so we can use ARRAY_SIZE() */
 int wm5110_patch(struct arizona *arizona)
 {
 	switch (arizona->rev) {
 	case 0:
-	case 1:
 		return regmap_register_patch(arizona->regmap,
 					     wm5110_reva_patch,
 					     ARRAY_SIZE(wm5110_reva_patch));
+	case 1:
+		return regmap_register_patch(arizona->regmap,
+					     wm5110_revb_patch,
+					     ARRAY_SIZE(wm5110_revb_patch));
+
 	default:
 		return 0;
 	}
-- 
1.7.10.4

