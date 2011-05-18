Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab1ERSHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:07:17 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:62608 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab1ERSHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=U/bEaczepXxte8HLnPf9IyHdVIEkNg62BSE7sMukOXn5n52IOoYztYqoBr7Zf3mOgc
         PLDyYsS1s+udfFZ0ozr88sHXtfwWbXDxkN5ivySnpmg9REp2DgzVVSCuPtFW7azqUAmo
         GZIB2c6HR3x9Z8e/kOhklbHeXOEU9UEE2Jaew=
Subject: [patch 1/2] trivial: amba-clcd.c preferred form of passing size of
 structure
From: anish <anish198519851985@gmail.com>
To: linux@arm.linux.org.uk, lethal@linux-sh.org
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 23:37:06 +0530
Message-ID: <1305742026.8771.26.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preferred form for passing a size of a struct is the following:
         p = kmalloc(sizeof(*p), ...);
  Please refer Documentation/Codingstyle chapter 14

 Signed-off-by: anish kumar <anish198519851985@gmail.com>

---
 drivers/video/amba-clcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index 5fc983c..cb7ec86 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -549,7 +549,7 @@ static int clcdfb_probe(struct amba_device *dev, const struct amba_id *id)
 		goto out;
 	}
 
-	fb = kzalloc(sizeof(struct clcd_fb), GFP_KERNEL);
+	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
 	if (!fb) {
 		printk(KERN_INFO "CLCD: could not allocate new clcd_fb struct\n");
 		ret = -ENOMEM;
-- 
1.7.0.4




