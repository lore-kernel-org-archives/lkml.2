Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150Ab2JWUps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:45:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60839 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab2JWUFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:25 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 160/193] net: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:53 -0700
Message-Id: <1351022666-6960-161-git-send-email-keescook@chromium.org>
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
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index 30b48f5..7bdab26 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -90,7 +90,6 @@ config NETWORK_SECMARK
 
 config NETWORK_PHY_TIMESTAMPING
 	bool "Timestamping in PHY devices"
-	depends on EXPERIMENTAL
 	help
 	  This allows timestamping of network packets by PHYs with
 	  hardware timestamping capabilities. This option adds some
@@ -278,7 +277,7 @@ config NET_PKTGEN
 
 config NET_TCPPROBE
 	tristate "TCP connection probing"
-	depends on INET && EXPERIMENTAL && PROC_FS && KPROBES
+	depends on INET && PROC_FS && KPROBES
 	---help---
 	This module allows for capturing the changes to TCP connection
 	state in response to incoming packets. It is used for debugging
@@ -295,7 +294,7 @@ config NET_TCPPROBE
 
 config NET_DROP_MONITOR
 	tristate "Network packet drop alerting service"
-	depends on INET && EXPERIMENTAL && TRACEPOINTS
+	depends on INET && TRACEPOINTS
 	---help---
 	This feature provides an alerting service to userspace in the
 	event that packets are discarded in the network stack.  Alerts
-- 
1.7.9.5

