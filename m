Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2DARuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:50:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41794 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2DARuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:50:00 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH 6/8] net/ipv6/fib6_rules.c: Checkpatch cleanup
Date: Sun,  1 Apr 2012 19:49:06 +0200
Message-Id: <1333302548-9187-6-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
References: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fib6_rules.c:26: ERROR: open brace '{' following struct go on the same line

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 net/ipv6/fib6_rules.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index b6c5731..da75c67 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -22,8 +22,7 @@
 #include <net/ip6_route.h>
 #include <net/netlink.h>
 
-struct fib6_rule
-{
+struct fib6_rule {
 	struct fib_rule		common;
 	struct rt6key		src;
 	struct rt6key		dst;
-- 
1.7.9.5

