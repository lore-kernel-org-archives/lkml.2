Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab2DJSvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:51:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59227 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab2DJSvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:51:36 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] net/ipv6/ipv6_sockglue.c: Removed redundant extern
Date: Tue, 10 Apr 2012 20:51:27 +0200
Message-Id: <1334083887-5375-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extern int sysctl_mld_max_msf is already defined in linux/ipv6.h.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 net/ipv6/ipv6_sockglue.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 63dd1f8..ca1af07 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -678,7 +678,6 @@ done:
 	}
 	case MCAST_MSFILTER:
 	{
-		extern int sysctl_mld_max_msf;
 		struct group_filter *gsf;
 
 		if (optlen < GROUP_FILTER_SIZE(0))
-- 
1.7.9.5

