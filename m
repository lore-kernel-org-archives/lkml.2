Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570Ab2JWVHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:07:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60745 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933445Ab2JWUFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:10 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 082/193] drivers/net/ethernet/icplus: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:35 -0700
Message-Id: <1351022666-6960-83-git-send-email-keescook@chromium.org>
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

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/icplus/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/icplus/Kconfig b/drivers/net/ethernet/icplus/Kconfig
index 3aff81d..5119ef1 100644
--- a/drivers/net/ethernet/icplus/Kconfig
+++ b/drivers/net/ethernet/icplus/Kconfig
@@ -4,7 +4,7 @@
 
 config IP1000
 	tristate "IP1000 Gigabit Ethernet support"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select NET_CORE
 	select MII
 	---help---
-- 
1.7.9.5

