Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400Ab2JWVBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:01:23 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33556 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933711Ab2JWUFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:14 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH 094/193] drivers/net/hippi: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:47 -0700
Message-Id: <1351022666-6960-95-git-send-email-keescook@chromium.org>
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

CC: Jes Sorensen <jes@trained-monkey.org>
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

