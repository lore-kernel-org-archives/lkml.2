Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0CYJWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:22:01 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:38915 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0CYJV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JD93iDxapBh3GrpqakqyH+gGu5Xz0PG2TP+rcEz+Y+hNxiIsjl8agn8vUPD4N/d3lQ
         RiTXy2f+rgsicU4BmrUO5iagaL4SpZbJ8C83TJgzdOlyyYt3aVHqj4lJ6yrqsPK2GH4G
         Vj+urnniHNRICXe2GaFe5e4iRZU1CLu9wvrgU=
Date: Thu, 25 Mar 2010 17:21:54 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
Subject: [PATCH] Netfilter: Code cleanup on net/netfilter
Message-ID: <20100325092154.GB29056@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding styles and remove moduleparam.h

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 net/ipv4/netfilter/nf_nat_h323.c       |    1 -
 net/ipv4/netfilter/nf_nat_standalone.c |    3 +--
 net/ipv4/netfilter/nf_nat_tftp.c       |    1 -
 net/netfilter/nf_conntrack_proto.c     |    2 --
 4 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 7e8e6fc..d4c0618 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/tcp.h>
 #include <net/tcp.h>
 
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 5678e95..0b49248 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -137,9 +137,8 @@ nf_nat_fn(unsigned int hooknum,
 				ret = nf_nat_rule_find(skb, hooknum, in, out,
 						       ct);
 
-			if (ret != NF_ACCEPT) {
+			if (ret != NF_ACCEPT)
 				return ret;
-			}
 		} else
 			pr_debug("Already setup manip %s for ct %p\n",
 				 maniptype == IP_NAT_MANIP_SRC ? "SRC" : "DST",
diff --git a/net/ipv4/netfilter/nf_nat_tftp.c b/net/ipv4/netfilter/nf_nat_tftp.c
index b096e81..7274a43 100644
--- a/net/ipv4/netfilter/nf_nat_tftp.c
+++ b/net/ipv4/netfilter/nf_nat_tftp.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/udp.h>
 
 #include <net/netfilter/nf_nat_helper.h>
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 1a4568b..f71cd5d 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -13,12 +13,10 @@
 #include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/skbuff.h>
 #include <linux/vmalloc.h>
 #include <linux/stddef.h>
 #include <linux/err.h>
 #include <linux/percpu.h>
-#include <linux/moduleparam.h>
 #include <linux/notifier.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
-- 
1.6.5.3

