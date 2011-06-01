Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162399Ab1FAIUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:20:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162335Ab1FAIT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:19:59 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:22 2011
Message-Id: <20110601081122.006211315@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:25 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [055/165] net: ethtool: fix IPV6 checksum feature name string
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 921
Lines: 24


From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>

[ Upstream commit 7cc31a9ae1477abc79d5992b3afe889f25c50c99 ]

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -330,7 +330,7 @@ static const char netdev_features_string
 	/* NETIF_F_IP_CSUM */         "tx-checksum-ipv4",
 	/* NETIF_F_NO_CSUM */         "tx-checksum-unneeded",
 	/* NETIF_F_HW_CSUM */         "tx-checksum-ip-generic",
-	/* NETIF_F_IPV6_CSUM */       "tx_checksum-ipv6",
+	/* NETIF_F_IPV6_CSUM */       "tx-checksum-ipv6",
 	/* NETIF_F_HIGHDMA */         "highdma",
 	/* NETIF_F_FRAGLIST */        "tx-scatter-gather-fraglist",
 	/* NETIF_F_HW_VLAN_TX */      "tx-vlan-hw-insert",


