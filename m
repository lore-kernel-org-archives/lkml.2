Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892Ab1FWXFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:05:22 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25204 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933959Ab1FWXFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:05:21 -0400
Date: Fri, 24 Jun 2011 00:56:26 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, devel@driverdev.osuosl.org,
        David Brown <davidb@codeaurora.org>, Ingo Molnar <mingo@elte.hu>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, Torben Hohn <torbenh@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/37] Remove unneeded version.h includes from
 drivers/staging/msm/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240054540.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/staging/msm/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/msm/ebi2_lcd.c     |    3 +--
 drivers/staging/msm/msm_fb.c       |    1 -
 drivers/staging/msm/msm_fb_bl.c    |    1 -
 drivers/staging/msm/msm_fb_def.h   |    1 -
 drivers/staging/msm/msm_fb_panel.c |    1 -
 5 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/msm/ebi2_lcd.c b/drivers/staging/msm/ebi2_lcd.c
index b41e123..4834b7b 100644
--- a/drivers/staging/msm/ebi2_lcd.c
+++ b/drivers/staging/msm/ebi2_lcd.c
@@ -29,7 +29,6 @@
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/debugfs.h>
@@ -247,4 +246,4 @@ static int __init ebi2_lcd_driver_init(void)
 	return ebi2_lcd_register_driver();
 }
 
-module_init(ebi2_lcd_driver_init);
\ No newline at end of file
+module_init(ebi2_lcd_driver_init);
diff --git a/drivers/staging/msm/msm_fb.c b/drivers/staging/msm/msm_fb.c
index e7ef836..e60f8f9 100644
--- a/drivers/staging/msm/msm_fb.c
+++ b/drivers/staging/msm/msm_fb.c
@@ -32,7 +32,6 @@
 
 #include <linux/workqueue.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/debugfs.h>
diff --git a/drivers/staging/msm/msm_fb_bl.c b/drivers/staging/msm/msm_fb_bl.c
index 2a80775..9c8cb88 100644
--- a/drivers/staging/msm/msm_fb_bl.c
+++ b/drivers/staging/msm/msm_fb_bl.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <linux/backlight.h>
 
 #include "msm_fb.h"
diff --git a/drivers/staging/msm/msm_fb_def.h b/drivers/staging/msm/msm_fb_def.h
index bc7f256..8b4626f 100644
--- a/drivers/staging/msm/msm_fb_def.h
+++ b/drivers/staging/msm/msm_fb_def.h
@@ -28,7 +28,6 @@
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/debugfs.h>
diff --git a/drivers/staging/msm/msm_fb_panel.c b/drivers/staging/msm/msm_fb_panel.c
index b17a239..651de16 100644
--- a/drivers/staging/msm/msm_fb_panel.c
+++ b/drivers/staging/msm/msm_fb_panel.c
@@ -29,7 +29,6 @@
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/debugfs.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

