Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab2KEXFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:05:42 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52346 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab2KEXFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:15 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 004/104] drivers/net/ethernet/microchip: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:21 -0800
Message-Id: <1352156701-4038-5-git-send-email-keescook@chromium.org>
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

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/microchip/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index 8163fd0..afaf0c0 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_MICROCHIP
 	bool "Microchip devices"
 	default y
-	depends on SPI && EXPERIMENTAL
+	depends on SPI
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -20,7 +20,7 @@ if NET_VENDOR_MICROCHIP
 
 config ENC28J60
 	tristate "ENC28J60 support"
-	depends on SPI && EXPERIMENTAL
+	depends on SPI
 	select CRC32
 	---help---
 	  Support for the Microchip EN28J60 ethernet chip.
-- 
1.7.9.5

