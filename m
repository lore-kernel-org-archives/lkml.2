Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965005Ab2JWUgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:36:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41098 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933834Ab2JWUFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:34 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH 166/193] net/dsa: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:59 -0700
Message-Id: <1351022666-6960-167-git-send-email-keescook@chromium.org>
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
CC: Ben Hutchings <ben@decadent.org.uk>
CC: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/dsa/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 274791c..9c09f6e 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -1,7 +1,7 @@
 config NET_DSA
 	tristate "Distributed Switch Architecture support"
 	default n
-	depends on EXPERIMENTAL && NETDEVICES && !S390
+	depends on NETDEVICES && !S390
 	select PHYLIB
 	---help---
 	  This allows you to use hardware switch chips that use
-- 
1.7.9.5

