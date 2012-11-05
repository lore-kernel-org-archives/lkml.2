Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab2KEX3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:29:35 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37990 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab2KEXFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:21 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jes Sorensen <jes@trained-monkey.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 009/104] drivers/net/hippi: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:26 -0800
Message-Id: <1352156701-4038-10-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Jes Sorensen <jes@trained-monkey.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/hippi/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hippi/Kconfig b/drivers/net/hippi/Kconfig
index 95eb34f..f71515d 100644
--- a/drivers/net/hippi/Kconfig
+++ b/drivers/net/hippi/Kconfig
@@ -3,8 +3,8 @@
 #
 
 config HIPPI
-	bool "HIPPI driver support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && INET && PCI
+	bool "HIPPI driver support"
+	depends on INET && PCI
 	---help---
 	  HIgh Performance Parallel Interface (HIPPI) is a 800Mbit/sec and
 	  1600Mbit/sec dual-simplex switched or point-to-point network. HIPPI
@@ -18,7 +18,7 @@ config HIPPI
 if HIPPI
 
 config ROADRUNNER
-	tristate "Essential RoadRunner HIPPI PCI adapter support (EXPERIMENTAL)"
+	tristate "Essential RoadRunner HIPPI PCI adapter support"
 	depends on PCI
 	---help---
 	  Say Y here if this is your PCI HIPPI network card.
@@ -27,7 +27,7 @@ config ROADRUNNER
 	  will be called rrunner.  If unsure, say N.
 
 config ROADRUNNER_LARGE_RINGS
-	bool "Use large TX/RX rings (EXPERIMENTAL)"
+	bool "Use large TX/RX rings"
 	depends on ROADRUNNER
 	---help---
 	  If you say Y here, the RoadRunner driver will preallocate up to 2 MB
-- 
1.7.9.5

