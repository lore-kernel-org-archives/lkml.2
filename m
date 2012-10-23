Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965479Ab2JWVF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:05:29 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57520 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933689Ab2JWUFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:11 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 084/193] drivers/net/ethernet/microchip: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:37 -0700
Message-Id: <1351022666-6960-85-git-send-email-keescook@chromium.org>
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

