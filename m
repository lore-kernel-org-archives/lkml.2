Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278Ab2ESLmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 07:42:14 -0400
Received: from nm23-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.224]:36086 "HELO
	nm23-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754487Ab2ESLmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 07:42:12 -0400
X-Yahoo-Newman-Id: 33702.91801.bm@smtp103.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EChdYE8VM1nXyl_LouoIR1cfjZr29NYozX43fyvik8Ft0p.
 qerOnhjTnbhDSTQTe.igfAvDbJvN.uxBFNAh8zYoD7KGF55iYHphrVDVqFgb
 BYW9884MaoWtoKx4AhaOZYSEpI_RchlOfKykqh9XjEH2AayCMaSKD4GQ.FWq
 .nRqz462.mNqT25FTecuxj35MFHmGmSQgWga7fVTx0PomQLQ2Ast.qDgQxaS
 BGw9NxS0XO1KoJMaGVdvzetAPMWITTp.kNafYinvXLOUeC6zKgxmoti34slH
 bj0LggT3QuZh6Ih_O37IHqm5EDnYQw1FwBG0PKgi3k_k9MDqckoL_xfFdXQB
 s_nw3EMFbj.n9MPcwbPfWm8VVvQ7hRHL3kcxFaKk6Gmk1mZy.UAFZtzmxHfj
 lqPBFDxYleztg42LNusiIrIMRg5zxqtlEKunKvyoHo48N_BINyVQGwVQFbzs
 6Kr9IVSZucM1DunO0qGpmlFl4vaDuDLTEuA.uee7JMOiNzhgDbVy8k3Yr_s8
 -
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: [PATCH 1/1] net:ipv6:fixed a trailing white space issue.
Date: Sat, 19 May 2012 17:15:21 +0530
Message-Id: <1337427921-2848-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a trailing white space issue found by
checkpatch.pl tool in net/ipv6/udp.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 net/ipv6/udp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index c1d91a7..847253c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -103,7 +103,7 @@ int udp_v6_get_port(struct sock *sk, unsigned short snum)
 {
 	unsigned int hash2_nulladdr =
 		udp6_portaddr_hash(sock_net(sk), &in6addr_any, snum);
-	unsigned int hash2_partial = 
+	unsigned int hash2_partial =
 		udp6_portaddr_hash(sock_net(sk), &inet6_sk(sk)->rcv_saddr, 0);
 
 	/* precompute partial secondary hash */
-- 
1.7.10

