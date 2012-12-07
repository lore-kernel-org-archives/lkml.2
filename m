Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2LGLoC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:44:02 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53479 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab2LGLn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:43:59 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Vaibhav Hiremath <hvaibhav@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 04/10] video: da8xx-fb: remove unneeded "var" initialization
Date: Fri, 7 Dec 2012 17:13:55 +0530
Message-ID: <b12330ed57bd6eb720825aa63f267cac7e2bf7c7.1354874432.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1354874432.git.afzal@ti.com>
References: <cover.1354874432.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modedb helper now updates "var" information based on the detected
panel, remove the unnecessary initialization.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 0c404ed..79862ff 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -184,23 +184,7 @@ struct da8xx_fb_par {
 	u32 pseudo_palette[16];
 };
 
-/* Variable Screen Information */
-static struct fb_var_screeninfo da8xx_fb_var __devinitdata = {
-	.xoffset = 0,
-	.yoffset = 0,
-	.transp = {0, 0, 0},
-	.nonstd = 0,
-	.activate = 0,
-	.height = -1,
-	.width = -1,
-	.accel_flags = 0,
-	.left_margin = LEFT_MARGIN,
-	.right_margin = RIGHT_MARGIN,
-	.upper_margin = UPPER_MARGIN,
-	.lower_margin = LOWER_MARGIN,
-	.sync = 0,
-	.vmode = FB_VMODE_NONINTERLACED
-};
+static struct fb_var_screeninfo da8xx_fb_var;
 
 static struct fb_fix_screeninfo da8xx_fb_fix __devinitdata = {
 	.id = "DA8xx FB Drv",
-- 
1.7.12

