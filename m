Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868Ab2JWUbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:31:09 -0400
Received: from smtp.outflux.net ([198.145.64.163]:50301 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964793Ab2JWUFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:44 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 175/193] net/netfilter: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:08 -0700
Message-Id: <1351022666-6960-176-git-send-email-keescook@chromium.org>
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
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/netfilter/Kconfig |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index fefa514..2e2d896 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -125,8 +125,7 @@ config NF_CONNTRACK_TIMESTAMP
 	  If unsure, say `N'.
 
 config NF_CT_PROTO_DCCP
-	tristate 'DCCP protocol connection tracking support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate 'DCCP protocol connection tracking support'
 	depends on NETFILTER_ADVANCED
 	default IP_DCCP
 	help
@@ -139,8 +138,7 @@ config NF_CT_PROTO_GRE
 	tristate
 
 config NF_CT_PROTO_SCTP
-	tristate 'SCTP protocol connection tracking support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate 'SCTP protocol connection tracking support'
 	depends on NETFILTER_ADVANCED
 	default IP_SCTP
 	help
@@ -281,8 +279,7 @@ config NF_CONNTRACK_PPTP
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_SANE
-	tristate "SANE protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "SANE protocol support"
 	depends on NETFILTER_ADVANCED
 	help
 	  SANE is a protocol for remote access to scanners as implemented
@@ -409,8 +406,7 @@ endif # NF_CONNTRACK
 
 # transparent proxy support
 config NETFILTER_TPROXY
-	tristate "Transparent proxying support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Transparent proxying support"
 	depends on IP_NF_MANGLE
 	depends on NETFILTER_ADVANCED
 	help
@@ -711,8 +707,7 @@ config NETFILTER_XT_TARGET_TEE
 	this clone be rerouted to another nexthop.
 
 config NETFILTER_XT_TARGET_TPROXY
-	tristate '"TPROXY" target support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate '"TPROXY" target support'
 	depends on NETFILTER_TPROXY
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
@@ -776,8 +771,7 @@ config NETFILTER_XT_TARGET_TCPMSS
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_TCPOPTSTRIP
-	tristate '"TCPOPTSTRIP" target support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate '"TCPOPTSTRIP" target support'
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	depends on NETFILTER_ADVANCED
 	help
@@ -1138,8 +1132,7 @@ config NETFILTER_XT_MATCH_RECENT
 	Official Website: <http://snowman.net/projects/ipt_recent/>
 
 config NETFILTER_XT_MATCH_SCTP
-	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate  '"sctp" protocol match support'
 	depends on NETFILTER_ADVANCED
 	default IP_SCTP
 	help
@@ -1151,8 +1144,7 @@ config NETFILTER_XT_MATCH_SCTP
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_SOCKET
-	tristate '"socket" match support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL
+	tristate '"socket" match support'
 	depends on NETFILTER_TPROXY
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
-- 
1.7.9.5

