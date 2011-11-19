Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1KSXcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 18:32:17 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52291 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751654Ab1KSXcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 18:32:16 -0500
Message-ID: <1321745535.18250.15.camel@Joe-Laptop>
Subject: jfs: Remove unused debugging macros
From: Joe Perches <joe@perches.com>
To: Dave Kleikamp <shaggy@kernel.org>
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Sat, 19 Nov 2011 15:32:15 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just neatening.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/jfs/jfs_extent.c |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
index e5fe850..c2789e4 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -34,32 +34,6 @@ static int extBrealloc(struct inode *, s64, s64, s64 *, s64 *);
 #endif
 static s64 extRoundDown(s64 nb);
 
-#define DPD(a)		(printk("(a): %d\n",(a)))
-#define DPC(a)		(printk("(a): %c\n",(a)))
-#define DPL1(a)					\
-{						\
-	if ((a) >> 32)				\
-		printk("(a): %x%08x  ",(a));	\
-	else					\
-		printk("(a): %x  ",(a) << 32);	\
-}
-#define DPL(a)					\
-{						\
-	if ((a) >> 32)				\
-		printk("(a): %x%08x\n",(a));	\
-	else					\
-		printk("(a): %x\n",(a) << 32);	\
-}
-
-#define DPD1(a)		(printk("(a): %d  ",(a)))
-#define DPX(a)		(printk("(a): %08x\n",(a)))
-#define DPX1(a)		(printk("(a): %08x  ",(a)))
-#define DPS(a)		(printk("%s\n",(a)))
-#define DPE(a)		(printk("\nENTERING: %s\n",(a)))
-#define DPE1(a)		(printk("\nENTERING: %s",(a)))
-#define DPS1(a)		(printk("  %s  ",(a)))
-
-
 /*
  * NAME:	extAlloc()
  *


