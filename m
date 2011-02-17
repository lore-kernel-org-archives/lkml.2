Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab1BQV3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:29:33 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:34402 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139Ab1BQV3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:29:18 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] staging: xgifb: clean up xgifb_remove()
Date: Thu, 17 Feb 2011 23:29:16 +0200
Message-Id: <1297978157-14927-6-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete redudant comments, blank lines and a redundant semicolon.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index f69ff57..6e86830 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -3428,8 +3428,6 @@ error:
 
 static void __devexit xgifb_remove(struct pci_dev *pdev)
 {
-	/* Unregister the framebuffer */
-	/* if (xgi_video_info.registered) { */
 	unregister_framebuffer(fb_info);
 	iounmap(xgi_video_info.mmio_vbase);
 	iounmap(xgi_video_info.video_vbase);
@@ -3438,11 +3436,8 @@ static void __devexit xgifb_remove(struct pci_dev *pdev)
 			   xgi_video_info.video_size);
 	vfree(XGIhw_ext.pjVirtualRomBase);
 	framebuffer_release(fb_info);
-	/* } */
-
 	pci_set_drvdata(pdev, NULL);
-
-};
+}
 
 static struct pci_driver xgifb_driver = {
 	.name = "xgifb",
-- 
1.5.6.5

