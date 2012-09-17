Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2IQOZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:25:25 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:29453 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab2IQOXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:23:34 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 10:23:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkCABEvV1BbdWObgWdsb2JhbABEvBUiAQEWJieCIAEBBSdSECAxPBsHEogEulqSCQOVYok1iVQ
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="969870760"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 3/7] staging: sm7xxfb: cleanup on smtc_alloc_fb_info
Date: Mon, 17 Sep 2012 16:12:49 +0200
Message-Id: <1347891173-13916-4-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
References: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch improves code legibility after last changes.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index f6ecac3..5ad52b9 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -679,7 +679,7 @@ static struct fb_ops smtcfb_ops = {
 };
 
 /*
- * alloc struct smtcfb_info and assign the default value
+ * alloc struct smtcfb_info and assign default values
  */
 static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev)
 {
@@ -692,18 +692,12 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev)
 
 	sfb->pdev = pdev;
 
-	/* init sfb->fb with default value */
-
-	sfb->fb.flags = FBINFO_FLAG_DEFAULT;
-	sfb->fb.fbops = &smtcfb_ops;
-
-	sfb->fb.fix = smtcfb_fix;
-
-	sfb->fb.var = smtcfb_var;
-
-	sfb->fb.pseudo_palette  = sfb->colreg;
-
-	sfb->fb.par = sfb;
+	sfb->fb.flags          = FBINFO_FLAG_DEFAULT;
+	sfb->fb.fbops          = &smtcfb_ops;
+	sfb->fb.fix            = smtcfb_fix;
+	sfb->fb.var            = smtcfb_var;
+	sfb->fb.pseudo_palette = sfb->colreg;
+	sfb->fb.par            = sfb;
 
 	return sfb;
 }
-- 
1.7.10.4

