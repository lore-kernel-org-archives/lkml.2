Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2DARup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:50:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51860 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab2DARuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:50:06 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH 7/8] net/ipv6/icmp.c: Checkpatch cleanups
Date: Sun,  1 Apr 2012 19:49:07 +0200
Message-Id: <1333302548-9187-7-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
References: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

icmp.c:501: ERROR: "(foo*)" should be "(foo *)"
icmp.c:582: ERROR: "(foo*)" should be "(foo *)"
icmp.c:954: WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 net/ipv6/icmp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 27ac95a..cc079d8 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -498,7 +498,7 @@ void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
 	err = ip6_append_data(sk, icmpv6_getfrag, &msg,
 			      len + sizeof(struct icmp6hdr),
 			      sizeof(struct icmp6hdr), hlimit,
-			      np->tclass, NULL, &fl6, (struct rt6_info*)dst,
+			      np->tclass, NULL, &fl6, (struct rt6_info *)dst,
 			      MSG_DONTWAIT, np->dontfrag);
 	if (err) {
 		ICMP6_INC_STATS_BH(net, idev, ICMP6_MIB_OUTERRORS);
@@ -579,7 +579,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 
 	err = ip6_append_data(sk, icmpv6_getfrag, &msg, skb->len + sizeof(struct icmp6hdr),
 				sizeof(struct icmp6hdr), hlimit, np->tclass, NULL, &fl6,
-				(struct rt6_info*)dst, MSG_DONTWAIT,
+				(struct rt6_info *)dst, MSG_DONTWAIT,
 				np->dontfrag);
 
 	if (err) {
@@ -950,7 +950,6 @@ int icmpv6_err_convert(u8 type, u8 code, int *err)
 
 	return fatal;
 }
-
 EXPORT_SYMBOL(icmpv6_err_convert);
 
 #ifdef CONFIG_SYSCTL
-- 
1.7.9.5

