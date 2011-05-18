Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab1ERRMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:12:15 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:35696 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269Ab1ERRMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=N+q7nmPDD8DZN0vSTcbw4j9JrquiTOQDAjGGTTRBayeRBcEy7b+dVl5lJ5wW2gUXHW
         XM4EFBR9n8Dco2z5poQjQaJPXkEIWs7KNbDi6MbMY8M/4sX6HDNKFJcSyJLCIvQ0oRxB
         RcRiIFVt7E+mBoRvfDGIQ5qd8cz6kmo+U3J14=
Subject: [patch 2/3] Staging: sm7xx: preferred form for passing a size to
 memory allocation routines
From: anish <anish198519851985@gmail.com>
To: greg@kroah.com, teddy.wang@siliconmotion.com.cn
Cc: linux-kernel@vger.kernel.org, harryxiyou@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 22:42:08 +0530
Message-ID: <1305738728.1881.84.camel@anish-desktop>
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
 Acked-by: Harry Wei <harryxiyou@gmail.com>

---
 drivers/staging/sm7xx/smtcfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 1aca0cb..c41d2f7 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -714,7 +714,7 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *dev,
 {
 	struct smtcfb_info *sfb;
 
-	sfb = kzalloc(sizeof(struct smtcfb_info), GFP_KERNEL);
+	sfb = kzalloc(sizeof(*sfb), GFP_KERNEL);
 
 	if (!sfb)
 		return NULL;
-- 
1.7.0.4


