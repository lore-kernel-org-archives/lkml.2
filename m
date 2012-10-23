Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868Ab2JWUok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:44:40 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40228 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933802Ab2JWUF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:26 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 164/193] net/decnet: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:57 -0700
Message-Id: <1351022666-6960-165-git-send-email-keescook@chromium.org>
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
 net/decnet/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/decnet/Kconfig b/net/decnet/Kconfig
index 7914fd6..f3393e1 100644
--- a/net/decnet/Kconfig
+++ b/net/decnet/Kconfig
@@ -25,8 +25,8 @@ config DECNET
 	  The module is called decnet.
 
 config DECNET_ROUTER
-	bool "DECnet: router support (EXPERIMENTAL)"
-	depends on DECNET && EXPERIMENTAL
+	bool "DECnet: router support"
+	depends on DECNET
 	select FIB_RULES
 	---help---
 	  Add support for turning your DECnet Endnode into a level 1 or 2
-- 
1.7.9.5

