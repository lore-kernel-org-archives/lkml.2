Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2DARu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:50:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41794 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2DARtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:49:33 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH 2/8] net/ipv6/addrconf_core.c: Checkpatch cleanup
Date: Sun,  1 Apr 2012 19:49:02 +0200
Message-Id: <1333302548-9187-2-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
References: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

addrconf_core.c:13: ERROR: space required before the open parenthesis '('

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 net/ipv6/addrconf_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index 399287e..7981bde 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -10,7 +10,7 @@
 
 static inline unsigned ipv6_addr_scope2type(unsigned scope)
 {
-	switch(scope) {
+	switch (scope) {
 	case IPV6_ADDR_SCOPE_NODELOCAL:
 		return (IPV6_ADDR_SCOPE_TYPE(IPV6_ADDR_SCOPE_NODELOCAL) |
 			IPV6_ADDR_LOOPBACK);
-- 
1.7.9.5

