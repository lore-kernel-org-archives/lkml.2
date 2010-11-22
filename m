Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab0KVBEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:04:30 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35395 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab0KVBEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:04:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LXK/cw+cDNOxsSAd7VJFiRSokX5B7nuwv5GThYMPkcadrt3glw96SGxfe7pTw/ovI7
         5r1E4F28DWHK5SqiWHBUpwbChJxIXAXbvZnFCK0uirIlBlOKF2p8IdWsQNDllIKO/iO+
         8OB5b0hfRNddbA2gnop9gK/e9DyHGDbtUPAb0=
From: Tracey Dent <tdent48227@gmail.com>
To: davem@davemloft.net
Cc: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        sjur.brandeland@stericsson.com, socketcan@hartkopp.net,
        urs.thuermann@volkswagen.de, socketcan-core@lists.berlios.de,
        sage@newdream.net, ceph-devel@vger.kernel.org, wang840925@gmail.com,
        jlayton@redhat.com, kaber@trash.net, pekkas@netcore.fi,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, samuel@sortiz.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 08/17] Net: ipv6: netfiliter: Makefile: Remove deprecated kbuild goal definitions
Date: Sun, 21 Nov 2010 20:03:19 -0500
Message-Id: <1290387808-2239-9-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276
In-Reply-To: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
References: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs
because -objs is deprecated and not mentioned in
Documentation/kbuild/makefiles.txt.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 net/ipv6/netfilter/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 0a432c9..abfee91 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -11,13 +11,13 @@ obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
 obj-$(CONFIG_IP6_NF_SECURITY) += ip6table_security.o
 
 # objects for l3 independent conntrack
-nf_conntrack_ipv6-objs  :=  nf_conntrack_l3proto_ipv6.o nf_conntrack_proto_icmpv6.o
+nf_conntrack_ipv6-y  :=  nf_conntrack_l3proto_ipv6.o nf_conntrack_proto_icmpv6.o
 
 # l3 independent conntrack
 obj-$(CONFIG_NF_CONNTRACK_IPV6) += nf_conntrack_ipv6.o nf_defrag_ipv6.o
 
 # defrag
-nf_defrag_ipv6-objs := nf_defrag_ipv6_hooks.o nf_conntrack_reasm.o
+nf_defrag_ipv6-y := nf_defrag_ipv6_hooks.o nf_conntrack_reasm.o
 obj-$(CONFIG_NF_DEFRAG_IPV6) += nf_defrag_ipv6.o
 
 # matches
-- 
1.7.3.2.245.g03276

