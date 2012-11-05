Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2KEXFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:05:32 -0500
Received: from smtp.outflux.net ([198.145.64.163]:48056 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab2KEXFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:16 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 007/104] drivers/net/ethernet/stmicro/stmmac: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:24 -0800
Message-Id: <1352156701-4038-8-git-send-email-keescook@chromium.org>
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

CC: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 9f44827..24bc663 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -26,8 +26,8 @@ config STMMAC_PLATFORM
 	  If unsure, say N.
 
 config STMMAC_PCI
-	bool "STMMAC PCI bus support (EXPERIMENTAL)"
-	depends on STMMAC_ETH && PCI && EXPERIMENTAL
+	bool "STMMAC PCI bus support"
+	depends on STMMAC_ETH && PCI
 	---help---
 	  This is to select the Synopsys DWMAC available on PCI devices,
 	  if you have a controller with this interface, say Y or M here.
-- 
1.7.9.5

