Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539Ab2JWVFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:05:34 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33297 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933686Ab2JWUFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:11 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Subject: [PATCH 078/193] drivers/net/ethernet/atheros: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:31 -0700
Message-Id: <1351022666-6960-79-git-send-email-keescook@chromium.org>
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

CC: Jay Cliburn <jcliburn@gmail.com>
CC: Chris Snook <chris.snook@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/atheros/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/Kconfig b/drivers/net/ethernet/atheros/Kconfig
index 1ed886d..36d6abd 100644
--- a/drivers/net/ethernet/atheros/Kconfig
+++ b/drivers/net/ethernet/atheros/Kconfig
@@ -44,8 +44,8 @@ config ATL1
 	  will be called atl1.
 
 config ATL1E
-	tristate "Atheros L1E Gigabit Ethernet support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Atheros L1E Gigabit Ethernet support"
+	depends on PCI
 	select CRC32
 	select NET_CORE
 	select MII
@@ -56,8 +56,8 @@ config ATL1E
 	  will be called atl1e.
 
 config ATL1C
-	tristate "Atheros L1C Gigabit Ethernet support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Atheros L1C Gigabit Ethernet support"
+	depends on PCI
 	select CRC32
 	select NET_CORE
 	select MII
-- 
1.7.9.5

