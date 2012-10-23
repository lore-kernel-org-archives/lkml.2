Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876Ab2JWUGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:06:05 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44773 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964848Ab2JWUGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:06:00 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH 170/193] net/ipv6: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:03 -0700
Message-Id: <1351022666-6960-171-git-send-email-keescook@chromium.org>
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

CC: "David S. Miller" <davem@davemloft.net>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
CC: James Morris <jmorris@namei.org>
CC: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC: Patrick McHardy <kaber@trash.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ipv6/Kconfig |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 4f7fe72..3f2eb57 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -50,16 +50,15 @@ config IPV6_ROUTER_PREF
 	  If unsure, say N.
 
 config IPV6_ROUTE_INFO
-	bool "IPv6: Route Information (RFC 4191) support (EXPERIMENTAL)"
-	depends on IPV6_ROUTER_PREF && EXPERIMENTAL
+	bool "IPv6: Route Information (RFC 4191) support"
+	depends on IPV6_ROUTER_PREF
 	---help---
 	  This is experimental support of Route Information.
 
 	  If unsure, say N.
 
 config IPV6_OPTIMISTIC_DAD
-	bool "IPv6: Enable RFC 4429 Optimistic DAD (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "IPv6: Enable RFC 4429 Optimistic DAD"
 	---help---
 	  This is experimental support for optimistic Duplicate
 	  Address Detection.  It allows for autoconfigured addresses
@@ -105,8 +104,7 @@ config INET6_IPCOMP
 	  If unsure, say Y.
 
 config IPV6_MIP6
-	tristate "IPv6: Mobility (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "IPv6: Mobility"
 	select XFRM
 	---help---
 	  Support for IPv6 Mobility described in RFC 3775.
@@ -150,8 +148,7 @@ config INET6_XFRM_MODE_BEET
 	  If unsure, say Y.
 
 config INET6_XFRM_MODE_ROUTEOPTIMIZATION
-	tristate "IPv6: MIPv6 route optimization mode (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "IPv6: MIPv6 route optimization mode"
 	select XFRM
 	---help---
 	  Support for MIPv6 route optimization mode.
@@ -171,8 +168,8 @@ config IPV6_SIT
 	  Saying M here will produce a module called sit. If unsure, say Y.
 
 config IPV6_SIT_6RD
-	bool "IPv6: IPv6 Rapid Deployment (6RD) (EXPERIMENTAL)"
-	depends on IPV6_SIT && EXPERIMENTAL
+	bool "IPv6: IPv6 Rapid Deployment (6RD)"
+	depends on IPV6_SIT
 	default n
 	---help---
 	  IPv6 Rapid Deployment (6rd; draft-ietf-softwire-ipv6-6rd) builds upon
@@ -219,7 +216,6 @@ config IPV6_GRE
 
 config IPV6_MULTIPLE_TABLES
 	bool "IPv6: Multiple Routing Tables"
-	depends on EXPERIMENTAL
 	select FIB_RULES
 	---help---
 	  Support multiple routing tables.
@@ -239,8 +235,8 @@ config IPV6_SUBTREES
 	  If unsure, say N.
 
 config IPV6_MROUTE
-	bool "IPv6: multicast routing (EXPERIMENTAL)"
-	depends on IPV6 && EXPERIMENTAL
+	bool "IPv6: multicast routing"
+	depends on IPV6
 	---help---
 	  Experimental support for IPv6 multicast forwarding.
 	  If unsure, say N.
@@ -260,7 +256,7 @@ config IPV6_MROUTE_MULTIPLE_TABLES
 	  If unsure, say N.
 
 config IPV6_PIMSM_V2
-	bool "IPv6: PIM-SM version 2 support (EXPERIMENTAL)"
+	bool "IPv6: PIM-SM version 2 support"
 	depends on IPV6_MROUTE
 	---help---
 	  Support for IPv6 PIM multicast routing protocol PIM-SMv2.
-- 
1.7.9.5

