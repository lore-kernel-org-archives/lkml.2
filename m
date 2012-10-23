Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016Ab2JWUkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:40:14 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52664 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933819Ab2JWUFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:30 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 163/193] net/dccp/ccids: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:56 -0700
Message-Id: <1351022666-6960-164-git-send-email-keescook@chromium.org>
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
 net/dccp/ccids/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/dccp/ccids/Kconfig b/net/dccp/ccids/Kconfig
index 0581143..8ba3fc9 100644
--- a/net/dccp/ccids/Kconfig
+++ b/net/dccp/ccids/Kconfig
@@ -1,5 +1,4 @@
-menu "DCCP CCIDs Configuration (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+menu "DCCP CCIDs Configuration"
 
 config IP_DCCP_CCID2_DEBUG
 	bool "CCID-2 debugging messages"
@@ -12,7 +11,7 @@ config IP_DCCP_CCID2_DEBUG
 	  If in doubt, say N.
 
 config IP_DCCP_CCID3
-	bool "CCID-3 (TCP-Friendly) (EXPERIMENTAL)"
+	bool "CCID-3 (TCP-Friendly)"
 	def_bool y if (IP_DCCP = y || IP_DCCP = m)
 	---help---
 	  CCID-3 denotes TCP-Friendly Rate Control (TFRC), an equation-based
-- 
1.7.9.5

