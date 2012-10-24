Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935056Ab2JXOzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:55:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54239 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934915Ab2JXOzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:55:43 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, isdn@linux-pingi.de
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] isdn: Fix typo in isdn drivers
Date: Wed, 24 Oct 2012 23:55:36 +0900
Message-Id: <1351090536-26458-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling typo in debug messages within drivers/isdn.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/isdn/hardware/mISDN/mISDNisar.c | 2 +-
 drivers/isdn/hisax/amd7930_fn.c         | 2 +-
 drivers/isdn/hisax/isar.c               | 2 +-
 drivers/isdn/pcbit/layer2.c             | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c b/drivers/isdn/hardware/mISDN/mISDNisar.c
index be5973d..a2177cf 100644
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -1302,7 +1302,7 @@ modeisar(struct isar_ch *ch, u32 bprotocol)
 						   &ch->is->Flags))
 				ch->dpath = 1;
 			else {
-				pr_info("modeisar both pathes in use\n");
+				pr_info("modeisar both paths in use\n");
 				return -EBUSY;
 			}
 			if (bprotocol == ISDN_P_B_HDLC)
diff --git a/drivers/isdn/hisax/amd7930_fn.c b/drivers/isdn/hisax/amd7930_fn.c
index 89342f7..525471e 100644
--- a/drivers/isdn/hisax/amd7930_fn.c
+++ b/drivers/isdn/hisax/amd7930_fn.c
@@ -628,7 +628,7 @@ Amd7930_l1hw(struct PStack *st, int pr, void *arg)
 		if ((cs->dc.amd7930.ph_state == 8)) {
 			/* b-channels off, PH-AR cleared
 			 * change to F3 */
-			Amd7930_ph_command(cs, 0x20, "HW_RESET REQEST"); //LMR1 bit 5
+			Amd7930_ph_command(cs, 0x20, "HW_RESET REQUEST"); //LMR1 bit 5
 			spin_unlock_irqrestore(&cs->lock, flags);
 		} else {
 			Amd7930_ph_command(cs, 0x40, "HW_RESET REQUEST");
diff --git a/drivers/isdn/hisax/isar.c b/drivers/isdn/hisax/isar.c
index ff5e139..7fdf347 100644
--- a/drivers/isdn/hisax/isar.c
+++ b/drivers/isdn/hisax/isar.c
@@ -1417,7 +1417,7 @@ modeisar(struct BCState *bcs, int mode, int bc)
 						   &bcs->hw.isar.reg->Flags))
 				bcs->hw.isar.dpath = 1;
 			else {
-				printk(KERN_WARNING"isar modeisar both pathes in use\n");
+				printk(KERN_WARNING"isar modeisar both paths in use\n");
 				return (1);
 			}
 			break;
diff --git a/drivers/isdn/pcbit/layer2.c b/drivers/isdn/pcbit/layer2.c
index a18e639..42ecfef 100644
--- a/drivers/isdn/pcbit/layer2.c
+++ b/drivers/isdn/pcbit/layer2.c
@@ -508,7 +508,7 @@ pcbit_irq_handler(int interrupt, void *devptr)
 		return IRQ_NONE;
 	}
 	if (dev->interrupt) {
-		printk(KERN_DEBUG "pcbit: reentering interrupt hander\n");
+		printk(KERN_DEBUG "pcbit: reentering interrupt handler\n");
 		return IRQ_HANDLED;
 	}
 	dev->interrupt = 1;
-- 
1.8.0.rc3.16.g8ead1bf

