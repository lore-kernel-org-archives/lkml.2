Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1BAKIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:08:07 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:44281 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1BAKIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:08:02 -0500
From: Simon Horman <horms@verge.net.au>
To: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans Schillstrom <hans@schillstrom.com>,
        Patrick McHardy <kaber@trash.net>, Simon Horman <horms@verge.net.au>
Subject: [PATCH 3/5] IPVS: Remove unused variables
Date: Tue,  1 Feb 2011 21:07:46 +1100
Message-Id: <1296554868-17002-4-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296554868-17002-1-git-send-email-horms@verge.net.au>
References: <1296554868-17002-1-git-send-email-horms@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These variables are unused as a result of the recent netns work.

Cc: Hans Schillstrom <hans@schillstrom.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 include/net/ip_vs.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index b23bea6..5d75fea 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1109,8 +1109,6 @@ extern int ip_vs_icmp_xmit_v6
  *	we are loaded. Just set ip_vs_drop_rate to 'n' and
  *	we start to drop 1/rate of the packets
  */
-extern int ip_vs_drop_rate;
-extern int ip_vs_drop_counter;
 
 static inline int ip_vs_todrop(struct netns_ipvs *ipvs)
 {
-- 
1.7.2.3

