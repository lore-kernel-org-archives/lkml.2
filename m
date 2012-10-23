Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977Ab2JWU1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:27:09 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51460 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933929Ab2JWUHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:07:38 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Huang Shijie <b32955@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 075/193] drivers/mtd/nand: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:28 -0700
Message-Id: <1351022666-6960-76-git-send-email-keescook@chromium.org>
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

CC: David Woodhouse <dwmw2@infradead.org>
CC: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
CC: Huang Shijie <b32955@freescale.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/mtd/nand/Kconfig |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 4883139..d999620 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -259,8 +259,7 @@ config MTD_NAND_S3C2410_CLKSTOP
 	  approximately 5mA of power when there is nothing happening.
 
 config MTD_NAND_DISKONCHIP
-	tristate "DiskOnChip 2000, Millennium and Millennium Plus (NAND reimplementation) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "DiskOnChip 2000, Millennium and Millennium Plus (NAND reimplementation)"
 	depends on HAS_IOMEM
 	select REED_SOLOMON
 	select REED_SOLOMON_DEC16
@@ -330,8 +329,8 @@ config MTD_NAND_DISKONCHIP_BBTWRITE
 	  parameter "inftl_bbt_write=1".
 
 config MTD_NAND_DOCG4
-	tristate "Support for DiskOnChip G4 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && HAS_IOMEM
+	tristate "Support for DiskOnChip G4"
+	depends on HAS_IOMEM
 	select BCH
 	select BITREVERSE
 	help
-- 
1.7.9.5

