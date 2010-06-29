Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0F2KTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:19:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47959 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab0F2KPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fSIXHTFGMOBMTfGVAUkcpVZSgU69Arjxg4sivGnhHDIaBVic1scAGlFYaDxpU7u3Gm
         lPxgN22KkB8jf8wI7PI6wn8AGQykvScocAwEyjMdSKE62Yrcq6QbHbAjsG09QnaFcMbE
         sd2EKzil4kA4YiJL5oDOKhqoporLqy+Hu6+B4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 08/25] sm_common: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:24 +0400
Message-Id: <1277806525-30976-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/mtd/nand/sm_common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/sm_common.c b/drivers/mtd/nand/sm_common.c
index ac80fb3..4a8f367 100644
--- a/drivers/mtd/nand/sm_common.c
+++ b/drivers/mtd/nand/sm_common.c
@@ -109,7 +109,7 @@ static struct nand_flash_dev nand_xd_flash_ids[] = {
 
 int sm_register_device(struct mtd_info *mtd, int smartmedia)
 {
-	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+	struct nand_chip *chip = mtd->priv;
 	int ret;
 
 	chip->options |= NAND_SKIP_BBTSCAN;
-- 
1.7.0.4

