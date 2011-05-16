Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab1EPPtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:49:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49474 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab1EPPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WTxN3vnaH6Ap93a93PzyZlambUKT10bY3s4mJKv8KuZeR3WDYNDczroaorm6M38IXW
         TWgy1mhsUWOWJJ21yp/DtmGNpd0Pt7lSYK7VzIKGgCf7AvKgOE0d+zn+9I9iuWwP1NRw
         rzyB5bk5de6CnQ8nLblZdZP/3DWK//RwSUuiE=
Subject: [PATCH 2/3] preferred form for passing a size to memory allocation
 routines[staging sm7xx]
From: anish <anish198519851985@gmail.com>
To: greg@kroah.com, teddy.wang@siliconmotion.com.cn,
        anish198519851985@gmail.com
Cc: linux-kernel@vger.kernel.org, harryxiyou@gmail.com
In-Reply-To: <1305395704.7400.17.camel@anish-desktop>
References: <1305395704.7400.17.camel@anish-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 21:19:30 +0530
Message-ID: <1305560970.6690.21.camel@anish-desktop>
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





