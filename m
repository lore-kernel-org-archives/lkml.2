Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0F2KPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:15:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0F2KPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RjRuCiFnihWYpc3mCXTf3Y/MfWd4cjg/FkCEl/2mcnxnkgorqTynMEEi0pTYvdeSlL
         RHLtUd+/6/KXN4bpnGaBiRTSj54AmVVFrKkNphBpy9T6aHgrCtDTi1NH6ezUmOthvxQp
         ssKAPSpsDVkMk9ous/4vqKfT/GBfYcqoftl8k=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
       Grant Likely <grant.likely@secretlab.ca>,
       Sean MacLennan <smaclennan@pikatech.com>, Jiri Kosina <jkosina@suse.cz>,
       Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/25] n2-drv: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:01 +0400
Message-Id: <1277806502-30772-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/hw_random/n2-drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 0f9cbf1..101d5f2 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -387,7 +387,7 @@ static int n2rng_init_control(struct n2rng *np)
 
 static int n2rng_data_read(struct hwrng *rng, u32 *data)
 {
-	struct n2rng *np = (struct n2rng *) rng->priv;
+	struct n2rng *np = rng->priv;
 	unsigned long ra = __pa(&np->test_data);
 	int len;
 
-- 
1.7.0.4

