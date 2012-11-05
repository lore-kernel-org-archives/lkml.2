Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab2KEX0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:26:18 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35631 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab2KEXFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:24 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 066/104] drivers/parport: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:23 -0800
Message-Id: <1352156701-4038-67-git-send-email-keescook@chromium.org>
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

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/parport/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 4b6e4e7..0e60438 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -57,8 +57,8 @@ config PARPORT_SERIAL
 	  will be called parport_serial.
 
 config PARPORT_PC_FIFO
-	bool "Use FIFO/DMA if available (EXPERIMENTAL)"
-	depends on PARPORT_PC && EXPERIMENTAL
+	bool "Use FIFO/DMA if available"
+	depends on PARPORT_PC
 	help
 	  Many parallel port chipsets provide hardware that can speed up
 	  printing. Say Y here if you want to take advantage of that.
@@ -70,8 +70,8 @@ config PARPORT_PC_FIFO
 	  specify which IRQ/DMA to use.
 
 config PARPORT_PC_SUPERIO
-	bool "SuperIO chipset support (EXPERIMENTAL)"
-	depends on PARPORT_PC && EXPERIMENTAL
+	bool "SuperIO chipset support"
+	depends on PARPORT_PC
 	help
 	  Saying Y here enables some probes for Super-IO chipsets in order to
 	  find out things like base addresses, IRQ lines and DMA channels.  It
@@ -85,8 +85,8 @@ config PARPORT_PC_PCMCIA
 	  ports. If unsure, say N.
 
 config PARPORT_IP32
-	tristate "SGI IP32 builtin port (EXPERIMENTAL)"
-	depends on SGI_IP32 && EXPERIMENTAL
+	tristate "SGI IP32 builtin port"
+	depends on SGI_IP32
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port on
@@ -126,8 +126,8 @@ config PARPORT_GSC
 	select PARPORT_NOT_PC
 
 config PARPORT_SUNBPP
-	tristate "Sparc hardware (EXPERIMENTAL)"
-	depends on SBUS && EXPERIMENTAL
+	tristate "Sparc hardware"
+	depends on SBUS
 	select PARPORT_NOT_PC
 	help
 	  This driver provides support for the bidirectional parallel port
-- 
1.7.9.5

