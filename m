Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965640Ab2JWVN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:13:29 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41564 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933652Ab2JWUFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:02 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 051/193] drivers/ide: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:04 -0700
Message-Id: <1351022666-6960-52-git-send-email-keescook@chromium.org>
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
 drivers/ide/Kconfig |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 5a26584..3c4417a 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -322,8 +322,7 @@ config BLK_DEV_GENERIC
           which otherwise might not be supported.
 
 config BLK_DEV_OPTI621
-	tristate "OPTi 82C621 chipset enhanced support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "OPTi 82C621 chipset enhanced support"
 	select BLK_DEV_IDEPCI
 	help
 	  This is a driver for the OPTi 82C621 EIDE controller.
@@ -417,7 +416,6 @@ config BLK_DEV_CY82C693
 
 config BLK_DEV_CS5520
 	tristate "Cyrix CS5510/20 MediaGX chipset support (VERY EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  Include support for PIO tuning and virtual DMA on the Cyrix MediaGX
@@ -761,8 +759,8 @@ config BLK_DEV_GAYLE
 	  use Gayle IDE interfaces on the Zorro expansion bus.
 
 config BLK_DEV_BUDDHA
-	tristate "Buddha/Catweasel/X-Surf IDE interface support (EXPERIMENTAL)"
-	depends on ZORRO && EXPERIMENTAL
+	tristate "Buddha/Catweasel/X-Surf IDE interface support"
+	depends on ZORRO
 	help
 	  This is the IDE driver for the IDE interfaces on the Buddha, Catweasel
 	  and X-Surf expansion boards.  It supports up to two interfaces on the
-- 
1.7.9.5

