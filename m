Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab2JWUGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:06:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56536 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933473Ab2JWUGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:06:08 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH 169/193] net/ipv4/netfilter: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:02 -0700
Message-Id: <1351022666-6960-170-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Patrick McHardy <kaber@trash.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
CC: James Morris <jmorris@namei.org>
CC: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ipv4/netfilter/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index d8d6f2a..ce2d43e 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -241,8 +241,8 @@ config IP_NF_MANGLE
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_TARGET_CLUSTERIP
-	tristate "CLUSTERIP target support (EXPERIMENTAL)"
-	depends on IP_NF_MANGLE && EXPERIMENTAL
+	tristate "CLUSTERIP target support"
+	depends on IP_NF_MANGLE
 	depends on NF_CONNTRACK_IPV4
 	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
-- 
1.7.9.5

