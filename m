Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab1BAKIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:08:05 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:44265 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1BAKIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:08:01 -0500
From: Simon Horman <horms@verge.net.au>
To: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans Schillstrom <hans@schillstrom.com>,
        Patrick McHardy <kaber@trash.net>, Simon Horman <horms@verge.net.au>
Subject: [PATCH 1/5] IPVS: use z modifier for sizeof() argument
Date: Tue,  1 Feb 2011 21:07:44 +1100
Message-Id: <1296554868-17002-2-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296554868-17002-1-git-send-email-horms@verge.net.au>
References: <1296554868-17002-1-git-send-email-horms@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Hans Schillstrom <hans@schillstrom.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index d889f4f..4d06617 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1887,7 +1887,7 @@ static int __net_init __ip_vs_init(struct net *net)
 	ipvs->gen = atomic_read(&ipvs_netns_cnt);
 	atomic_inc(&ipvs_netns_cnt);
 	net->ipvs = ipvs;
-	printk(KERN_INFO "IPVS: Creating netns size=%lu id=%d\n",
+	printk(KERN_INFO "IPVS: Creating netns size=%zu id=%d\n",
 			 sizeof(struct netns_ipvs), ipvs->gen);
 	return 0;
 }
-- 
1.7.2.3

