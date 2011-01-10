Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1AJPg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:36:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab1AJPgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:36:25 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Weber <weber@corscience.de>
Subject: [PATCH] Drivers: video: Add modes for Devkit8000 displays
Date: Mon, 10 Jan 2011 16:34:32 +0100
Message-Id: <1294673672-30924-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc1
X-Provags-ID: V02:K0:XsApzvfyKKagP7KcSVl1ICnqc2XtCb6yS4ILB38lqqL
 aSvCbOsyhNEXAF3jNj6+l6dyP9jyMMGusBi1Qpe0WQWqtXFosM
 HeSBkKrQGii0eJRH1+y1OBv2ZzGRCELzOGJJ8UvRFGJQL43Re9
 xZCRR8/yCo8hmq+Ku8P6XX8aFZFt/BWhFXo2RC/eWSdq6vZWmZ
 r6Q0PQzbRiLvTvG4I2CtA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the video modes for the 4.3, 5.6 and 7 inch panels that
are sold with the devkit8000.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/video/modedb.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index de450c1..7b2581c 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -274,7 +274,19 @@ static const struct fb_videomode modedb[] = {
        /* 800x520i @ 50 Hz, 15.625 kHz hsync (PAL RGB) */
        NULL, 50, 800, 520, 58823, 144, 64, 72, 28, 80, 5,
        0, FB_VMODE_INTERLACED
-    },
+    }, {
+       /* 480x272 @ 60 Hz */
+       NULL, 60, 480, 272, KHZ2PICOS(10164), 2, 2, 2, 2, 41, 10,
+       0, FB_VMODE_NONINTERLACED
+    }, {
+       /* 640x480 @ 60 Hz */
+       NULL, 60, 640, 480, KHZ2PICOS(25000), 16, 134, 32, 11, 10, 2,
+       0, FB_VMODE_NONINTERLACED
+    }, {
+       /* 800x480 @ 60 Hz */
+       NULL, 60, 800, 480, KHZ2PICOS(30000), 40, 40, 13, 29, 48, 3,
+       0, FB_VMODE_NONINTERLACED
+    }
 };
 
 #ifdef CONFIG_FB_MODE_HELPERS
-- 
1.7.4.rc1

