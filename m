Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965420Ab2JWU6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:58:15 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44608 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933732Ab2JWUFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:17 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 091/193] drivers/net/ethernet/stmicro/stmmac: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:44 -0700
Message-Id: <1351022666-6960-92-git-send-email-keescook@chromium.org>
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

