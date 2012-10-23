Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965446Ab2JWU4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:56:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59126 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739Ab2JWUFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:18 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 088/193] drivers/net/ethernet/realtek: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:41 -0700
Message-Id: <1351022666-6960-89-git-send-email-keescook@chromium.org>
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
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Cesar Eduardo Barros <cesarb@cesarb.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/realtek/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/Kconfig b/drivers/net/ethernet/realtek/Kconfig
index 5821966..783fa8b 100644
--- a/drivers/net/ethernet/realtek/Kconfig
+++ b/drivers/net/ethernet/realtek/Kconfig
@@ -34,8 +34,8 @@ config ATP
 	  will be called atp.
 
 config 8139CP
-	tristate "RealTek RTL-8139 C+ PCI Fast Ethernet Adapter support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "RealTek RTL-8139 C+ PCI Fast Ethernet Adapter support"
+	depends on PCI
 	select CRC32
 	select NET_CORE
 	select MII
-- 
1.7.9.5

