Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1EQR21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:28:27 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:32974 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1EQR2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:28:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pUQ0fmHF6Khkfy2nts0j5QUoIbnvSIztJNM44CKzfWVsG2s5kP/9qA05sV2oEZwqAf
         SlIiGmwkaWRBon5VLkphTnfSdXneO6kNoU1Nhz2I72h1WiSjZx5wjr1o0xBCcer5Ur7S
         YDviaTGVdp2cIOzDiLCHOJDAT8L5yIlVNfmqQ=
Subject: [patch 1/2] trivial: preferred form for passing a size of struct
From: anish <anish198519851985@gmail.com>
To: linux@arm.linux.org.uk, lethal@linux-sh.org
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 22:58:06 +0530
Message-ID: <1305653286.2182.14.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preferred form for passing a size of a struct is the following:
         p = kmalloc(sizeof(*p), ...);
  Please refer Documentation/Codingstyle chapter 14
 Signed-off-by: anish kumar<anish198519851985@gmail.com>

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





