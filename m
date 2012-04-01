Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2DARuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:50:37 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41794 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2DARtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:49:53 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH 5/8] net/ipv6/exthdrs_core.c: Checkpatch cleanups
Date: Sun,  1 Apr 2012 19:49:05 +0200
Message-Id: <1333302548-9187-5-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
References: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exthdrs_core.c:113: WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
exthdrs_core.c:114: WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 net/ipv6/exthdrs_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index 72957f4..7b1a884 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -21,6 +21,7 @@ int ipv6_ext_hdr(u8 nexthdr)
 		 (nexthdr == NEXTHDR_NONE)	||
 		 (nexthdr == NEXTHDR_DEST);
 }
+EXPORT_SYMBOL(ipv6_ext_hdr);
 
 /*
  * Skip any extension headers. This is used by the ICMP module.
@@ -109,6 +110,4 @@ int ipv6_skip_exthdr(const struct sk_buff *skb, int start, u8 *nexthdrp,
 	*nexthdrp = nexthdr;
 	return start;
 }
-
-EXPORT_SYMBOL(ipv6_ext_hdr);
 EXPORT_SYMBOL(ipv6_skip_exthdr);
-- 
1.7.9.5

