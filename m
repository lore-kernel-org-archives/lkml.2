Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965342Ab2J3SSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:18:13 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59049 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965218Ab2J3SMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:42 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH] da8xx: Add standard panel definition
Date: Wed, 31 Oct 2012 17:56:34 +0200
Message-Id: <1351698994-4091-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add standard panel definition that can work for the beaglebone
DVI cape.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/video/da8xx-fb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 866d804..4462d9e 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -270,6 +270,20 @@ static struct da8xx_panel known_lcd_panels[] = {
 		.pxl_clk = 7833600,
 		.invert_pxl_clk = 0,
 	},
+	[3] = {
+		 /* 1024 x 768 @ 60 Hz  Reduced blanking VESA CVT 0.79M3-R */
+		.name = "1024x768@60",
+		.width = 1024,
+		.height = 768,
+		.hfp = 48,
+		.hbp = 80,
+		.hsw = 32,
+		.vfp = 3,
+		.vbp = 15,
+		.vsw = 4,
+		.pxl_clk = 56000000,
+		.invert_pxl_clk = 0,
+	},
 };
 
 /* Enable the Raster Engine of the LCD Controller */
-- 
1.7.12

