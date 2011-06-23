Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033Ab1FWWf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:35:26 -0400
Received: from mail.perches.com ([173.55.12.10]:3190 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933959Ab1FWWfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:35:25 -0400
From: Joe Perches <joe@perches.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] video: Fix speficied typo
Date: Thu, 23 Jun 2011 15:35:19 -0700
Message-Id: <0b04217b5939dd9c5164913e9d2f9fde98e26e5c.1308868289.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <6002eb70809bb1c87c84f32ab4a4f034d2d1ffb5.1308868289.git.joe@perches.com>
References: <6002eb70809bb1c87c84f32ab4a4f034d2d1ffb5.1308868289.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/controlfb.c  |    2 +-
 drivers/video/platinumfb.c |    2 +-
 drivers/video/pm2fb.c      |    2 +-
 drivers/video/pm3fb.c      |    2 +-
 drivers/video/s3fb.c       |    2 +-
 drivers/video/skeletonfb.c |    2 +-
 drivers/video/valkyriefb.c |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/controlfb.c b/drivers/video/controlfb.c
index 9075bea..7b2c40a 100644
--- a/drivers/video/controlfb.c
+++ b/drivers/video/controlfb.c
@@ -550,7 +550,7 @@ static void control_set_hardware(struct fb_info_control *p, struct fb_par_contro
 
 
 /*
- * Parse user speficied options (`video=controlfb:')
+ * Parse user specified options (`video=controlfb:')
  */
 static void __init control_setup(char *options)
 {
diff --git a/drivers/video/platinumfb.c b/drivers/video/platinumfb.c
index f27ae16..6694923 100644
--- a/drivers/video/platinumfb.c
+++ b/drivers/video/platinumfb.c
@@ -490,7 +490,7 @@ static int platinum_var_to_par(struct fb_var_screeninfo *var,
 
 
 /* 
- * Parse user speficied options (`video=platinumfb:')
+ * Parse user specified options (`video=platinumfb:')
  */
 static int __init platinumfb_setup(char *options)
 {
diff --git a/drivers/video/pm2fb.c b/drivers/video/pm2fb.c
index f4f8ce8..dc7bfa9 100644
--- a/drivers/video/pm2fb.c
+++ b/drivers/video/pm2fb.c
@@ -1773,7 +1773,7 @@ MODULE_DEVICE_TABLE(pci, pm2fb_id_table);
 
 #ifndef MODULE
 /**
- * Parse user speficied options.
+ * Parse user specified options.
  *
  * This is, comma-separated options following `video=pm2fb:'.
  */
diff --git a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
index 8221b5b..6632ee5 100644
--- a/drivers/video/pm3fb.c
+++ b/drivers/video/pm3fb.c
@@ -1525,7 +1525,7 @@ static int __init pm3fb_setup(char *options)
 {
 	char *this_opt;
 
-	/* Parse user speficied options (`video=pm3fb:') */
+	/* Parse user specified options (`video=pm3fb:') */
 	if (!options || !*options)
 		return 0;
 
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index 0f9af1a..946a949 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -1505,7 +1505,7 @@ static struct pci_driver s3fb_pci_driver = {
 	.resume		= s3_pci_resume,
 };
 
-/* Parse user speficied options */
+/* Parse user specified options */
 
 #ifndef MODULE
 static int  __init s3fb_setup(char *options)
diff --git a/drivers/video/skeletonfb.c b/drivers/video/skeletonfb.c
index 89158bc..30f7a81 100644
--- a/drivers/video/skeletonfb.c
+++ b/drivers/video/skeletonfb.c
@@ -989,7 +989,7 @@ static struct platform_device *xxxfb_device;
  */
 int __init xxxfb_setup(char *options)
 {
-    /* Parse user speficied options (`video=xxxfb:') */
+    /* Parse user specified options (`video=xxxfb:') */
 }
 #endif /* MODULE */
 
diff --git a/drivers/video/valkyriefb.c b/drivers/video/valkyriefb.c
index 6b52bf6..3f5a041 100644
--- a/drivers/video/valkyriefb.c
+++ b/drivers/video/valkyriefb.c
@@ -555,7 +555,7 @@ static int __init valkyrie_init_info(struct fb_info *info,
 
 
 /*
- * Parse user speficied options (`video=valkyriefb:')
+ * Parse user specified options (`video=valkyriefb:')
  */
 int __init valkyriefb_setup(char *options)
 {
-- 
1.7.6.rc1

