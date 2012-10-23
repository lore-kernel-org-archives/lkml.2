Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968Ab2JWUkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:40:09 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35398 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933821Ab2JWUFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:32 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 184/193] net/wanrouter: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:17 -0700
Message-Id: <1351022666-6960-185-git-send-email-keescook@chromium.org>
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
CC: Joe Perches <joe@perches.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/wanrouter/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/wanrouter/Kconfig b/net/wanrouter/Kconfig
index a157a2e..fc1bd40 100644
--- a/net/wanrouter/Kconfig
+++ b/net/wanrouter/Kconfig
@@ -4,7 +4,6 @@
 
 config WAN_ROUTER
 	tristate "WAN router (DEPRECATED)"
-	depends on EXPERIMENTAL
 	---help---
 	  Wide Area Networks (WANs), such as X.25, frame relay and leased
 	  lines, are used to interconnect Local Area Networks (LANs) over vast
-- 
1.7.9.5

