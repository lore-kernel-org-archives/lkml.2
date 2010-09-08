Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173Ab0IHEF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 00:05:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53163 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0IHEF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 00:05:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=oOT1nizxtyhPC4Hgtu7mWkPfNbBCzbd+kQ1UsJl8BJ1NHr3A1JmI14dVY2TsgPCL13
         o0j6OyNZTHb5hha/MpBKrpQQTmtQQMB5GNO1jk8xw8aSa0k8UGm+AFAFv0C8E5edjmrP
         ns84LPlM25IWFzPl7bP3C9PzKl6Cvszr5fAMw=
Subject: [PATCH 1/2 v2] staging: xgifb: Removes unnecesary log
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 00:05:40 -0400
Message-ID: <1283918740.4905.3.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compile warning removing an unnecessary log message. 
I redo the patch against today linux-next.

Thanks a lot

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index bd863a0..dbce3d0 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -3419,13 +3419,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 		XGIfb_registered = 1;
 
-		printk(KERN_INFO "XGIfb: Installed XGIFB_GET_INFO ioctl (%lx)\n",
-				XGIFB_GET_INFO);
-
-		/*		printk(KERN_INFO "XGIfb: 2D acceleration is %s, scrolling mode %s\n",
-		 XGIfb_accel ? "enabled" : "disabled",
-		 XGIfb_ypan  ? "ypan" : "redraw");
-		 */
 		printk(KERN_INFO "fb%d: %s frame buffer device, Version %d.%d.%02d\n",
 				fb_info->node, myid, VER_MAJOR, VER_MINOR, VER_LEVEL);
 
-- 
1.7.0.4



