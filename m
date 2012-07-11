Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab2GKNvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:51:33 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:64298 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757682Ab2GKNuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:50:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6E/U9bdWOb/2dsb2JhbABFt16BB4IgAQEFJ1IQIDE8GwcSiBG9V5EuA5U6iSaGYIJh
X-IronPort-AV: E=Sophos;i="4.77,568,1336341600"; 
   d="scan'208";a="541808138"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 9/9] staging: sm7xxfb: cleanup on smtc_alloc_fb_info
Date: Wed, 11 Jul 2012 15:49:41 +0200
Message-Id: <1342014581-2979-10-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
References: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch improves coding style on smtc_alloc_fb_info.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index baee015..d9b1cd3 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -673,7 +673,7 @@ static struct fb_ops smtcfb_ops = {
 };
 
 /*
- * Alloc struct smtcfb_info and assign the default value
+ * alloc struct smtcfb_info and assign the default value
  */
 static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev, char *name)
 {
@@ -686,30 +686,30 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev, char *name)
 
 	sfb->pdev = pdev;
 
-	/*** Init sfb->fb with default value ***/
+	/* init sfb->fb with default value */
+
 	sfb->fb.flags = FBINFO_FLAG_DEFAULT;
 	sfb->fb.fbops = &smtcfb_ops;
-	sfb->fb.var = smtcfb_var;
-	sfb->fb.fix = smtcfb_fix;
 
+	sfb->fb.fix = smtcfb_fix;
 	strcpy(sfb->fb.fix.id, name);
 
-	sfb->fb.fix.type = FB_TYPE_PACKED_PIXELS;
-	sfb->fb.fix.type_aux = 0;
-	sfb->fb.fix.xpanstep = 0;
-	sfb->fb.fix.ypanstep = 0;
-	sfb->fb.fix.ywrapstep = 0;
-	sfb->fb.fix.accel = FB_ACCEL_SMI_LYNX;
-
-	sfb->fb.var.nonstd = 0;
-	sfb->fb.var.activate = FB_ACTIVATE_NOW;
-	sfb->fb.var.height = -1;
-	sfb->fb.var.width = -1;
-	/* text mode acceleration */
+	sfb->fb.fix.type        = FB_TYPE_PACKED_PIXELS;
+	sfb->fb.fix.type_aux    = 0;
+	sfb->fb.fix.xpanstep    = 0;
+	sfb->fb.fix.ypanstep    = 0;
+	sfb->fb.fix.ywrapstep   = 0;
+	sfb->fb.fix.accel       = FB_ACCEL_SMI_LYNX;
+
+	sfb->fb.var             = smtcfb_var;
+	sfb->fb.var.nonstd      = 0;
+	sfb->fb.var.activate    = FB_ACTIVATE_NOW;
+	sfb->fb.var.height      = -1;
+	sfb->fb.var.width       = -1;
 	sfb->fb.var.accel_flags = FB_ACCELF_TEXT;
-	sfb->fb.var.vmode = FB_VMODE_NONINTERLACED;
+	sfb->fb.var.vmode       = FB_VMODE_NONINTERLACED;
 
-	sfb->fb.pseudo_palette = sfb->colreg;
+	sfb->fb.pseudo_palette  = sfb->colreg;
 
 	sfb->fb.par = sfb;
 
-- 
1.7.10

