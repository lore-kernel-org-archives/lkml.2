Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2EUTFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:05:31 -0400
Received: from nm20-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.165]:21103 "HELO
	nm20-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753949Ab2EUTF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:05:29 -0400
X-Yahoo-Newman-Id: 42282.69634.bm@smtp108.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZiIyzWsVM1nmQyZQmzpNyYec4IAhsv2bqSQhYH_oUJc0GVc
 wU8pQa3vKRhWX4VntE68SBXn.cDFKZHqh1GumaoFWNc3OakvFRkK1d81HWGc
 8__2rA1DXIwjFISeqpwg9KeW5ModqOwl.ybKpXCutHUQG.KT92Y2syfI2yIR
 9lUYWmX9dq8WLWjRC1gZ7ryWJU2ofY7cQY5M4ffJrfQQgDvJvAMq.Ya2lWRr
 HRuNcpE6xv8.qRnA76gWN2HYyUuRqFB5QKmcYVawZ9aNWX.W4_CS4YuRHsH2
 udor28.aC6o26mWDVecvCQuQNQdomcCCabvrMJVOOjZRriRZgonXe1.MiGHj
 CM49gov5A.1xVaVIEmEpHmNei4vWUvpj.hrsFb0igLQa.gzg2Y9itRg_4sPu
 r3MWOMYqEJhBiBRm5.8S_GAY8aZWWxPlSkG.JeRd_r6spBTIT17OsetvJ2Cz
 e6Zfkdi49voMlybEwaBWRcDmPbZGrEbaC8BypomGo8EyIdWw.eMfjv4iW4sC
 3eW2X2H4-
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: davem@davemloft.net, edumazet@google.com, loke.chetan@gmail.com,
        herbert@gondor.hengli.com.au
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: [PATCH 1/4]net:ipv6:fixed a space issue relating to != operator
Date: Tue, 22 May 2012 00:33:35 +0530
Message-Id: <1337627015-3278-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a space issue relating to != operator
found by checkpatch.pl tool in net/ipv6/mcast.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 net/ipv6/mcast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 7dfb89f..8f7eee9 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -214,7 +214,7 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 	spin_lock(&ipv6_sk_mc_lock);
 	for (lnk = &np->ipv6_mc_list;
 	     (mc_lst = rcu_dereference_protected(*lnk,
-			lockdep_is_held(&ipv6_sk_mc_lock))) !=NULL ;
+			lockdep_is_held(&ipv6_sk_mc_lock))) != NULL ;
 	      lnk = &mc_lst->next) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&
 		    ipv6_addr_equal(&mc_lst->addr, addr)) {
-- 
1.7.10

