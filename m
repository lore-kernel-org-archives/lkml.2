Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab2BKLuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 06:50:10 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:46736
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754736Ab2BKLuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 06:50:08 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: isdn@linux-pingi.de, netdev@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] isdn: Fix typo in isdn_ppp.c
Date: Sat, 11 Feb 2012 20:49:28 +0900
Message-Id: <1328960968-1584-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "reseting" to "resetting" in
drivers/isdn/i4l/isdn_ppp.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/isdn/i4l/isdn_ppp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_ppp.c b/drivers/isdn/i4l/isdn_ppp.c
index 1b002b0..e38f674 100644
--- a/drivers/isdn/i4l/isdn_ppp.c
+++ b/drivers/isdn/i4l/isdn_ppp.c
@@ -1156,7 +1156,7 @@ isdn_ppp_push_higher(isdn_net_dev * net_dev, isdn_net_local * lp, struct sk_buff
 	if (!(is->active_filter
 	      && sk_run_filter(skb, is->active_filter) == 0)) {
 		if (is->debug & 0x2)
-			printk(KERN_DEBUG "IPPP: link-active filter: reseting huptimer.\n");
+			printk(KERN_DEBUG "IPPP: link-active filter: resetting huptimer.\n");
 		lp->huptimer = 0;
 		if (mlp)
 			mlp->huptimer = 0;
@@ -1302,7 +1302,7 @@ isdn_ppp_xmit(struct sk_buff *skb, struct net_device *netdev)
 	if (!(ipt->active_filter
 	      && sk_run_filter(skb, ipt->active_filter) == 0)) {
 		if (ipt->debug & 0x4)
-			printk(KERN_DEBUG "IPPP: link-active filter: reseting huptimer.\n");
+			printk(KERN_DEBUG "IPPP: link-active filter: resetting huptimer.\n");
 		lp->huptimer = 0;
 	}
 	skb_pull(skb, 4);
-- 
1.7.6.5

