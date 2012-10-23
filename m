Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079Ab2JWUkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:40:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47531 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933817Ab2JWUFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:30 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 185/193] net/x25: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:18 -0700
Message-Id: <1351022666-6960-186-git-send-email-keescook@chromium.org>
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

CC: Andrew Hendry <andrew.hendry@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/x25/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/x25/Kconfig b/net/x25/Kconfig
index e6759c9..c959312c 100644
--- a/net/x25/Kconfig
+++ b/net/x25/Kconfig
@@ -3,8 +3,7 @@
 #
 
 config X25
-	tristate "CCITT X.25 Packet Layer (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "CCITT X.25 Packet Layer"
 	---help---
 	  X.25 is a set of standardized network protocols, similar in scope to
 	  frame relay; the one physical line from your box to the X.25 network
-- 
1.7.9.5

