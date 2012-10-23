Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950Ab2JWUKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:10:53 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42516 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933408Ab2JWUKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:10:49 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 171/193] net/l2tp: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:04 -0700
Message-Id: <1351022666-6960-172-git-send-email-keescook@chromium.org>
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
 net/l2tp/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/Kconfig b/net/l2tp/Kconfig
index 147a8fd..adb9843 100644
--- a/net/l2tp/Kconfig
+++ b/net/l2tp/Kconfig
@@ -46,8 +46,8 @@ config L2TP_DEBUGFS
 	  will be called l2tp_debugfs.
 
 config L2TP_V3
-	bool "L2TPv3 support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && L2TP
+	bool "L2TPv3 support"
+	depends on L2TP
 	help
 	  Layer Two Tunneling Protocol Version 3
 
-- 
1.7.9.5

