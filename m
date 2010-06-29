Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0F2KPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:15:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0F2KPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hHIIj9rtUqgRfxA31NdTG9NJGo2T+AXKSU2saLkUhd3bM4KLtG5JcATxEpGHCEjSwP
         +EVqhVzsgCMg3hvDpYKxtxR1PieI013B32afQjg07uQLysbRMHwAnDfSP5Cp6vBGlvo3
         gpOFAPXTzl5XfuyKUcvSW+sNVM1Y3dd1gbUm0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/25] r852: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:20 +0400
Message-Id: <1277806521-30942-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/mtd/nand/r852.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index c0a9835..43f0366 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -380,7 +380,7 @@ void r852_cmdctl(struct mtd_info *mtd, int dat, unsigned int ctrl)
  */
 int r852_wait(struct mtd_info *mtd, struct nand_chip *chip)
 {
-	struct r852_device *dev = (struct r852_device *)chip->priv;
+	struct r852_device *dev = chip->priv;
 
 	unsigned long timeout;
 	int status;
-- 
1.7.0.4

