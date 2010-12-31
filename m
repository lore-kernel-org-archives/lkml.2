Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0LaFt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:49:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52549 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0LaFtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:49:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vAEfAgn89ZQSMjqKW3bFh/sjTSsArTGm51YbjxqbP8kRKunCRvFNQXE/cxoS6iU6A0
         KztpFYjFYmpaNuZvCAHQzE82/9H538SgNNfg+1b0/k3vPviBKdom1Hs45dZ+JCtezjFK
         z6tJfacy0wA8QhMZnbR2p5eUJxqoqu+IBzYPY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 15/15]drivers:staging:rtl8187se:ieee80211:ieee80211_tx.c Fix some comments.
Date: Thu, 30 Dec 2010 21:48:51 -0800
Message-Id: <1293774531-5294-16-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-15-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-5-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-6-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-7-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-8-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-9-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-10-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-11-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-12-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-13-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-14-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-15-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.6.5.2.180.gc5b3e

