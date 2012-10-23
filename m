Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067Ab2JWUkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:40:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:50909 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933818Ab2JWUFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:30 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 162/193] net/dccp: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:55 -0700
Message-Id: <1351022666-6960-163-git-send-email-keescook@chromium.org>
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

CC: Gerrit Renker <gerrit@erg.abdn.ac.uk>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/dccp/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dccp/Kconfig b/net/dccp/Kconfig
index b75968a..8c0ef71 100644
--- a/net/dccp/Kconfig
+++ b/net/dccp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig IP_DCCP
-	tristate "The DCCP Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "The DCCP Protocol"
+	depends on INET
 	---help---
 	  Datagram Congestion Control Protocol (RFC 4340)
 
-- 
1.7.9.5

