Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0CZDvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:51:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41458 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab0CZDvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:51:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PISifuFDthVnf63GVklLohLLRQMFaJQ1RVSeMDLa2telhRFFyEyN/ckTThcj1U7LjP
         26rhU1SP4RzOK4k3ObTAmalwY4cFnVWjq6VbFAPUX5tdjDnhR5y/oTOJnpwI6Ts3aCen
         N/dBqDuwOaSrc5aLxPs73LVJXuNflMw0q53K4=
Date: Fri, 26 Mar 2010 11:44:15 +0800
From: wzt.wzt@gmail.com
To: kaber@trash.net
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH] Netfilter: Fix some coding styles and remove moduleparam.h
Message-ID: <20100326034415.GB30224@localhost.localdomain>
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
 net/ipv4/netfilter/nf_nat_standalone.c |    3 +--
 net/ipv4/netfilter/nf_nat_tftp.c       |    1 -
 net/netfilter/nf_conntrack_proto.c     |    2 --
 3 files changed, 1 insertions(+), 5 deletions(-)

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

