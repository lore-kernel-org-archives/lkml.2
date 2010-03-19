Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab0CSDS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 23:18:56 -0400
Received: from mail-qy0-f182.google.com ([209.85.221.182]:42506 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0CSDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Oedls8ddo5gkicNA0y9mmwjw/+6OFnLI9MNup2juusRZgDv1MgFsnMCdp1H0J/3ZZO
         BaaFMiCnBQpUs00JZ2QW4UPeFSY3TmbamzoK19rmCSjwR31bi5MAMLEZFlxSzDiofnY6
         hfG7NgiU+quRb26mmaO6svhqNgURLiP417Nwo=
Date: Fri, 19 Mar 2010 11:18:50 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
Subject: [PATCH] Netfilter: Remove unused headers in net/ipv6/netfilter/ip6t_LOG.c
Message-ID: <20100319031850.GB3137@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused headers in net/ipv6/netfilter/ip6t_LOG.c

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 net/ipv6/netfilter/ip6t_LOG.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 3a23169..55de0cf 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
 #include <linux/ip.h>
-- 
1.6.5.3

