Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab2KEXFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:05:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54415 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab2KEXFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:48 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 064/104] drivers/mtd/devices: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:21 -0800
Message-Id: <1352156701-4038-65-git-send-email-keescook@chromium.org>
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

CC: David Woodhouse <dwmw2@infradead.org>
CC: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
CC: Robert Jarzmik <robert.jarzmik@free.fr>
CC: Fabio Estevam <fabio.estevam@freescale.com>
CC: Richard Weinberger <richard@nod.at>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/mtd/devices/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 27f80cd..c187342 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -52,7 +52,7 @@ config MTD_MS02NV
 
 config MTD_DATAFLASH
 	tristate "Support for AT45xxx DataFlash"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER
 	help
 	  This enables access to AT45xxx DataFlash chips, using SPI.
 	  Sometimes DataFlash chips are packaged inside MMC-format
@@ -81,7 +81,7 @@ config MTD_DATAFLASH_OTP
 
 config MTD_M25P80
 	tristate "Support most SPI Flash chips (AT26DF, M25P, W25X, ...)"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER
 	help
 	  This enables access to most modern SPI flash chips, used for
 	  program and data storage.   Series supported include Atmel AT26DF,
-- 
1.7.9.5

