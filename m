Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab1GFEwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 00:52:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43412 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1GFEw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 00:52:26 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/2]drivers:staging:rtl typo fix encryptiong to encryption.
Date: Tue,  5 Jul 2011 21:51:37 -0700
Message-Id: <1309927897-25404-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309927897-25404-1-git-send-email-justinmattock@gmail.com>
References: <1309927897-25404-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The beow patch fixes a typo.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
index 6cb31e1..552115c 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
@@ -445,7 +445,7 @@ int ieee80211_rtl_xmit(struct sk_buff *skb,
 		(CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
 			bytes_per_frag -= IEEE80211_FCS_LEN;
 
-		/* Each fragment may need to have room for encryptiong pre/postfix */
+		/* Each fragment may need to have room for encryption pre/postfix */
 		if (encrypt)
 			bytes_per_frag -= crypt->ops->extra_prefix_len +
 				crypt->ops->extra_postfix_len;
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
index 995346d..d13be4c 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
@@ -762,7 +762,7 @@ int ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 		(CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
 			bytes_per_frag -= IEEE80211_FCS_LEN;
 
-		/* Each fragment may need to have room for encryptiong pre/postfix */
+		/* Each fragment may need to have room for encryption pre/postfix */
 		if (encrypt)
 			bytes_per_frag -= crypt->ops->extra_prefix_len +
 				crypt->ops->extra_postfix_len;
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index ec7845e..59c45a5 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -723,7 +723,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		(CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
 			bytes_per_frag -= IEEE80211_FCS_LEN;
 
-		/* Each fragment may need to have room for encryptiong pre/postfix */
+		/* Each fragment may need to have room for encryption pre/postfix */
 		if (encrypt)
 			bytes_per_frag -= crypt->ops->extra_prefix_len +
 				crypt->ops->extra_postfix_len;
-- 
1.7.6

