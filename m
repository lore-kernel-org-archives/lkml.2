Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0IQVv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 17:51:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55399 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab0IQVvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 17:51:25 -0400
From: James Hogan <james@albanarts.com>
To: Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Denys Vlasenko <vda.linux@googlemail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fbmem: Fix whitespace (indentation with spaces).
Date: Fri, 17 Sep 2010 22:51:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.6-54.fc13.x86_64; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009172251.18740.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change a few lines of indentation to tabs.

Signed-off-by: James Hogan <james@albanarts.com>
---
 drivers/video/fbmem.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index b066475..bafc558 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -877,13 +877,13 @@ fb_pan_display(struct fb_info *info, struct fb_var_screeninfo *var)
 
 	if ((err = info->fbops->fb_pan_display(var, info)))
 		return err;
-        info->var.xoffset = var->xoffset;
-        info->var.yoffset = var->yoffset;
-        if (var->vmode & FB_VMODE_YWRAP)
-                info->var.vmode |= FB_VMODE_YWRAP;
-        else
-                info->var.vmode &= ~FB_VMODE_YWRAP;
-        return 0;
+	info->var.xoffset = var->xoffset;
+	info->var.yoffset = var->yoffset;
+	if (var->vmode & FB_VMODE_YWRAP)
+		info->var.vmode |= FB_VMODE_YWRAP;
+	else
+		info->var.vmode &= ~FB_VMODE_YWRAP;
+	return 0;
 }
 
 static int fb_check_caps(struct fb_info *info, struct fb_var_screeninfo *var,
