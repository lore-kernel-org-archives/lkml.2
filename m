Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054Ab2JWUim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:38:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34123 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933828Ab2JWUFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:33 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 183/193] net/tipc: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:16 -0700
Message-Id: <1351022666-6960-184-git-send-email-keescook@chromium.org>
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

CC: Jon Maloy <jon.maloy@ericsson.com>
CC: Allan Stephens <allan.stephens@windriver.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/tipc/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/Kconfig b/net/tipc/Kconfig
index 5854601..51faafc 100644
--- a/net/tipc/Kconfig
+++ b/net/tipc/Kconfig
@@ -3,8 +3,8 @@
 #
 
 menuconfig TIPC
-	tristate "The TIPC Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "The TIPC Protocol"
+	depends on INET
 	---help---
 	  The Transparent Inter Process Communication (TIPC) protocol is
 	  specially designed for intra cluster communication. This protocol
-- 
1.7.9.5

