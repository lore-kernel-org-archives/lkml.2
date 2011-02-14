Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1BNXGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:06:05 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:35277 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1BNXGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:06:03 -0500
Subject: [PATCH] [TRIVIAL] mISDN: fix printk typo fushing
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 15 Feb 2011 00:05:23 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1297724762.1793.35.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/isdn/mISDN/hwchannel.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/mISDN/hwchannel.c b/drivers/isdn/mISDN/hwchannel.c
index 199f374..f6e108d 100644
--- a/drivers/isdn/mISDN/hwchannel.c
+++ b/drivers/isdn/mISDN/hwchannel.c
@@ -206,7 +206,7 @@ recv_Bchannel(struct bchannel *bch, unsigned int id)
 	hh->id = id;
 	if (bch->rcount >= 64) {
 		printk(KERN_WARNING "B-channel %p receive queue overflow, "
-			"fushing!\n", bch);
+			"flushing!\n", bch);
 		skb_queue_purge(&bch->rqueue);
 		bch->rcount = 0;
 		return;
@@ -231,7 +231,7 @@ recv_Bchannel_skb(struct bchannel *bch, struct sk_buff *skb)
 {
 	if (bch->rcount >= 64) {
 		printk(KERN_WARNING "B-channel %p receive queue overflow, "
-			"fushing!\n", bch);
+			"flushing!\n", bch);
 		skb_queue_purge(&bch->rqueue);
 		bch->rcount = 0;
 	}
@@ -279,7 +279,7 @@ confirm_Bsend(struct bchannel *bch)
 
 	if (bch->rcount >= 64) {
 		printk(KERN_WARNING "B-channel %p receive queue overflow, "
-			"fushing!\n", bch);
+			"flushing!\n", bch);
 		skb_queue_purge(&bch->rqueue);
 		bch->rcount = 0;
 	}
-- 
1.7.4



