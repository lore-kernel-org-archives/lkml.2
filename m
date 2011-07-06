Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1GFEwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 00:52:21 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51426 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1GFEwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 00:52:19 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/2]drivers:net:wireless:ipw2x00:libipw_tx.c Typo fix encryptiong to encryption
Date: Tue,  5 Jul 2011 21:51:36 -0700
Message-Id: <1309927897-25404-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes a typo.
 
Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/ipw2x00/libipw_tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw_tx.c b/drivers/net/wireless/ipw2x00/libipw_tx.c
index 01c88a7..e8c0398 100644
--- a/drivers/net/wireless/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_tx.c
@@ -395,7 +395,7 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 		    (CFG_LIBIPW_COMPUTE_FCS | CFG_LIBIPW_RESERVE_FCS))
 			bytes_per_frag -= LIBIPW_FCS_LEN;
 
-		/* Each fragment may need to have room for encryptiong
+		/* Each fragment may need to have room for encryption
 		 * pre/postfix */
 		if (host_encrypt)
 			bytes_per_frag -= crypt->ops->extra_mpdu_prefix_len +
-- 
1.7.6

