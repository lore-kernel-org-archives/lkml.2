Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227Ab2ESLzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 07:55:55 -0400
Received: from nm15-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.91]:27902 "HELO
	nm15-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752208Ab2ESLzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 07:55:54 -0400
X-Yahoo-Newman-Id: 241094.28037.bm@smtp219.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: y4pgvJoVM1nphv.lr7oovhUvrSJMZFUNVwzEXF6apeBylAq
 XGoiqkMs0lxQs0lWQmH1akOUJ5.aLE8JSp5UkzBv2lZ.IEe2kNbXowLVX8EL
 tC1BGk0aeDeChOhvZalTiou5dH1MdWjyEAvenCWFMSa61oIMWyrxacgGzi7t
 VzT1zRg0v6by5w7s3F5Tc01rKsh8tCRsfCdD8OwdMSO0e1hoqW0a.2P6e5K5
 6C0IDNjhKC1ei5sWvgE.Vl6RP6mNCbMTuKsVofxMLucP_fLWZfiuO2EGBnXQ
 RmMzTLsA0TgCXd5snA4SG4Nf4favoI4eH_QHCGwT15cc9wHkBjtqhIRq3hcG
 rnyzNQqGNB0QEFseUhoNaY0NKcATxQYDr_GX16rwkIrBD_C2o.ae_E_B26yh
 uCA4gVjRlLcqgJo3LKVJhDRVygkzTRhXp_mlzd7Tgde2R7XulG6p6ac3t0pS
 _rOwGVUakw1_psfWd.tqG1DM8v9mxjGlfbDtPyLfW
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: [PATCH 1/1] net:ipv6:fixed space issues relating to operators.
Date: Sat, 19 May 2012 17:29:04 +0530
Message-Id: <1337428744-2935-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed space issues relating to operators found by
checkpatch.pl tool in net/ipv6/udp.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 net/ipv6/udp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 847253c..f05099f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -349,7 +349,7 @@ int udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	bool slow;
 
 	if (addr_len)
-		*addr_len=sizeof(struct sockaddr_in6);
+		*addr_len = sizeof(struct sockaddr_in6);
 
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len);
@@ -1379,7 +1379,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 	 * do checksum of UDP packets sent as multiple IP fragments.
 	 */
 	offset = skb_checksum_start_offset(skb);
-	csum = skb_checksum(skb, offset, skb->len- offset, 0);
+	csum = skb_checksum(skb, offset, skb->len - offset, 0);
 	offset += skb->csum_offset;
 	*(__sum16 *)(skb->data + offset) = csum_fold(csum);
 	skb->ip_summed = CHECKSUM_NONE;
-- 
1.7.10

