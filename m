Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044Ab1C3VI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:6140 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965018Ab1C3VIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133636"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: shemminger@vyatta.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [183/275] ip6ip6: autoload ip6 tunnel
Message-Id: <20110330210706.63B083E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: stephen hemminger <shemminger@vyatta.com>
Date: Thu, 10 Mar 2011 11:43:19 +0000 (+0000)
Subject: ip6ip6: autoload ip6 tunnel

From: stephen hemminger <shemminger@vyatta.com>

commit 6dfbd87a20a737641ef228230c77f4262434fa24 upstream

ip6ip6: autoload ip6 tunnel

Add necessary alias to autoload ip6ip6 tunnel module.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/ipv6/ip6_tunnel.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/net/ipv6/ip6_tunnel.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv6/ip6_tunnel.c	2011-03-29 22:50:49.173000204 -0700
+++ linux-2.6.35.y/net/ipv6/ip6_tunnel.c	2011-03-29 23:03:02.067247275 -0700
@@ -57,6 +57,7 @@
 MODULE_AUTHOR("Ville Nuorvala");
 MODULE_DESCRIPTION("IPv6 tunneling device");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NETDEV("ip6tnl0");
 
 #define IPV6_TLV_TEL_DST_SIZE 8
 
