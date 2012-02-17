Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2BQOEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:04:42 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37388
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab2BQOEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:04:41 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] wireless: Fix typo in mac80211_hwsim.c
Date: Fri, 17 Feb 2012 23:04:10 +0900
Message-Id: <1329487450-1937-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "occured" to "occurred" in
drivers/net/wireless/mac80211_hwsim.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4b9e730..29e930a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -592,7 +592,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	return;
 
 nla_put_failure:
-	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
 }
 
 static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
@@ -1564,7 +1564,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	return 0;
 err:
-	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
 	goto out;
 out:
 	dev_kfree_skb(skb);
@@ -1584,7 +1584,7 @@ static int hwsim_register_received_nl(struct sk_buff *skb_2,
 
 	return 0;
 out:
-	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
 	return -EINVAL;
 }
 
@@ -1647,7 +1647,7 @@ static int hwsim_init_netlink(void)
 	return 0;
 
 failure:
-	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
 	return -EINVAL;
 }
 
-- 
1.7.4.4

