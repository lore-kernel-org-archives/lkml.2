Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965243Ab2J3SMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:12:48 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59043 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965213Ab2J3SMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:41 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH] da8xx: Add CDTech_S035Q01 panel (used by LCD3 bone cape)
Date: Wed, 31 Oct 2012 17:56:44 +0200
Message-Id: <1351699004-4175-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/video/da8xx-fb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index c661665..c1f5d30 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -298,6 +298,20 @@ static struct da8xx_panel known_lcd_panels[] = {
 		.pxl_clk = 30000000,
 		.invert_pxl_clk = 0,
 	},
+	[5] = {
+		/* CDTech S035Q01 */
+		.name = "CDTech_S035Q01",
+		.width = 320,
+		.height = 240,
+		.hfp = 58,
+		.hbp = 21,
+		.hsw = 47,
+		.vfp = 23,
+		.vbp = 11,
+		.vsw = 2,
+		.pxl_clk = 8000000,
+		.invert_pxl_clk = 0,
+	},
 };
 
 /* Enable the Raster Engine of the LCD Controller */
-- 
1.7.12

