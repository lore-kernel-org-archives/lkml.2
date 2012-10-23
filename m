Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965452Ab2JWU6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:58:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44612 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933729Ab2JWUFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:17 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tony Lindgren <tony@atomide.com>,
        Mugunthan V N <mugunthanvnm@ti.com>, Kevin Hilman <khilman@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH 093/193] drivers/net/ethernet/ti: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:46 -0700
Message-Id: <1351022666-6960-94-git-send-email-keescook@chromium.org>
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

CC: Tony Lindgren <tony@atomide.com>
CC: Mugunthan V N <mugunthanvnm@ti.com>
CC: Kevin Hilman <khilman@ti.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/ti/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index b26cbda..37cd8fd 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -79,8 +79,8 @@ config TLAN
 	  Please email feedback to <torben.mathiasen@compaq.com>.
 
 config CPMAC
-	tristate "TI AR7 CPMAC Ethernet support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && AR7
+	tristate "TI AR7 CPMAC Ethernet support"
+	depends on AR7
 	select PHYLIB
 	---help---
 	  TI AR7 CPMAC Ethernet support
-- 
1.7.9.5

