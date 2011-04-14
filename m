Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776Ab1DNSD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:03:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:42342 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965060Ab1DNR7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, stephen hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 201/209] ip6ip6: autoload ip6 tunnel
Date: Thu, 14 Apr 2011 13:55:59 -0400
Message-Id: <1302803767-9715-88-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: stephen hemminger <shemminger@vyatta.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 6dfbd87a20a737641ef228230c77f4262434fa24 upstream.

Add necessary alias to autoload ip6ip6 tunnel module.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv6/ip6_tunnel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2599870..a2efe69 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -57,6 +57,7 @@
 MODULE_AUTHOR("Ville Nuorvala");
 MODULE_DESCRIPTION("IPv6 tunneling device");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NETDEV("ip6tnl0");
 
 #define IPV6_TLV_TEL_DST_SIZE 8
 
-- 
1.7.4.4

