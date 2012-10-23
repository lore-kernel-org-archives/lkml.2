Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964803Ab2JWUis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:38:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36863 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933824Ab2JWUFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:33 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 186/193] net/xfrm: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:19 -0700
Message-Id: <1351022666-6960-187-git-send-email-keescook@chromium.org>
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
CC: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/xfrm/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index ce90b8d..bda1a13 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -21,8 +21,8 @@ config XFRM_USER
 	  If unsure, say Y.
 
 config XFRM_SUB_POLICY
-	bool "Transformation sub policy support (EXPERIMENTAL)"
-	depends on XFRM && EXPERIMENTAL
+	bool "Transformation sub policy support"
+	depends on XFRM
 	---help---
 	  Support sub policy for developers. By using sub policy with main
 	  one, two policies can be applied to the same packet at once.
@@ -31,8 +31,8 @@ config XFRM_SUB_POLICY
 	  If unsure, say N.
 
 config XFRM_MIGRATE
-	bool "Transformation migrate database (EXPERIMENTAL)"
-	depends on XFRM && EXPERIMENTAL
+	bool "Transformation migrate database"
+	depends on XFRM
 	---help---
 	  A feature to update locator(s) of a given IPsec security
 	  association dynamically.  This feature is required, for
@@ -42,8 +42,8 @@ config XFRM_MIGRATE
 	  If unsure, say N.
 
 config XFRM_STATISTICS
-	bool "Transformation statistics (EXPERIMENTAL)"
-	depends on INET && XFRM && PROC_FS && EXPERIMENTAL
+	bool "Transformation statistics"
+	depends on INET && XFRM && PROC_FS
 	---help---
 	  This statistics is not a SNMP/MIB specification but shows
 	  statistics about transformation error (or almost error) factor
@@ -68,8 +68,8 @@ config NET_KEY
 	  Say Y unless you know what you are doing.
 
 config NET_KEY_MIGRATE
-	bool "PF_KEY MIGRATE (EXPERIMENTAL)"
-	depends on NET_KEY && EXPERIMENTAL
+	bool "PF_KEY MIGRATE"
+	depends on NET_KEY
 	select XFRM_MIGRATE
 	---help---
 	  Add a PF_KEY MIGRATE message to PF_KEYv2 socket family.
-- 
1.7.9.5

