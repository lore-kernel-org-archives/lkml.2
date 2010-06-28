Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0F1Lyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:54:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:29378 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0F1Lyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AEe6xOfb2/jaTEul/Pxwrv/QY0y2SZmS0u9PSHVghW452BO0xWH/5t87DqEaxs154I
         EfL36Aoy9kZEGAPiBNtqPo5h5QTereTgkbNzzzxI1a3aOviuIWvRj5mMkc1BUESefzk3
         rYQRygTAXOYG8UIO8Hxv+uq379xVl2bUo76XQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Mike Miller <mike.miller@hp.com>, Jens Axboe <jens.axboe@oracle.com>,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>, iss_storagedev@hp.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 01/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:54:44 +0400
Message-Id: <1277726085-24434-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 51ceaee..e1e7143 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -335,7 +335,7 @@ static void cciss_map_sg_chain_block(ctlr_info_t *h, CommandList_struct *c,
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 	"UNKNOWN"
 };
-#define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0])-1)
+#define RAID_UNKNOWN (ARRAY_SIZE(raid_label)-1)
 
 #ifdef CONFIG_PROC_FS
 
-- 
1.7.0.4

