Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433Ab2JWU4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:56:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56826 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933740Ab2JWUFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:18 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 090/193] drivers/net/ethernet/silan: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:43 -0700
Message-Id: <1351022666-6960-91-git-send-email-keescook@chromium.org>
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
CC: Cesar Eduardo Barros <cesarb@cesarb.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/silan/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/silan/Kconfig b/drivers/net/ethernet/silan/Kconfig
index ae1ce17..3409b3f 100644
--- a/drivers/net/ethernet/silan/Kconfig
+++ b/drivers/net/ethernet/silan/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_SILAN
 	bool "Silan devices"
 	default y
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -19,8 +19,8 @@ config NET_VENDOR_SILAN
 if NET_VENDOR_SILAN
 
 config SC92031
-	tristate "Silan SC92031 PCI Fast Ethernet Adapter driver (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Silan SC92031 PCI Fast Ethernet Adapter driver"
+	depends on PCI
 	select CRC32
 	---help---
 	  This is a driver for the Fast Ethernet PCI network cards based on
-- 
1.7.9.5

