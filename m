Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987Ab2JWU0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:26:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42516 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933295Ab2JWUKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:10:51 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 172/193] net/lapb: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:05 -0700
Message-Id: <1351022666-6960-173-git-send-email-keescook@chromium.org>
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
 net/lapb/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/lapb/Kconfig b/net/lapb/Kconfig
index f0b5efb..6481839 100644
--- a/net/lapb/Kconfig
+++ b/net/lapb/Kconfig
@@ -3,8 +3,7 @@
 #
 
 config LAPB
-	tristate "LAPB Data Link Driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "LAPB Data Link Driver"
 	---help---
 	  Link Access Procedure, Balanced (LAPB) is the data link layer (i.e.
 	  the lower) part of the X.25 protocol. It offers a reliable
-- 
1.7.9.5

