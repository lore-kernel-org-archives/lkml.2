Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965686Ab2EOCad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:30:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:49858 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965480Ab2EOCSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 160/179] atm: br2864: sent packets truncated in VC routed mode
Date: Mon, 14 May 2012 22:14:16 -0400
Message-ID: <1337048075-6132-161-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chas Williams <chas@cmf.nrl.navy.mil>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a08af810cdc29d2ca930e8a869d3d01744c392d8 upstream.

Reported-by: Pascal Hambourg <pascal@plouf.fr.eu.org>
Signed-off-by: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/atm/br2684.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index d6c7cea..f3bae14 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -205,8 +205,6 @@ static int br2684_xmit_vcc(struct sk_buff *skb, struct net_device *dev,
 		if (brdev->payload == p_bridged) {
 			skb_push(skb, 2);
 			memset(skb->data, 0, 2);
-		} else { /* p_routed */
-			skb_pull(skb, ETH_HLEN);
 		}
 	}
 	skb_debug(skb);
-- 
1.7.9.6

