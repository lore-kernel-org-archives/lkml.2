Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2KEXVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:21:12 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59211 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab2KEXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 041/104] drivers/ata: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:58 -0800
Message-Id: <1352156701-4038-42-git-send-email-keescook@chromium.org>
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

CC: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/ata/Kconfig |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index e08d322..cdadce2 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -163,7 +163,7 @@ config SATA_QSTOR
 
 config SATA_SX4
 	tristate "Promise SATA SX4 support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for Promise Serial ATA SX4.
 
@@ -390,7 +390,7 @@ config PATA_CS5530
 
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
-	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on PCI && X86 && !X86_64
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
@@ -408,7 +408,7 @@ config PATA_CS5536
 
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
@@ -496,7 +496,7 @@ config PATA_IMX
 
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the ITE 821 PATA
           controllers via the new ATA layer.
@@ -589,7 +589,7 @@ config PATA_OLDPIIX
 
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
@@ -616,7 +616,7 @@ config PATA_PDC_OLD
 
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the RADISYS 82600
 	  PATA controllers via the new ATA layer
@@ -687,7 +687,7 @@ config PATA_SIS
 
 config PATA_TOSHIBA
 	tristate "Toshiba Piccolo support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  Support for the Toshiba Piccolo controllers. Currently only the
 	  primary channel is supported by this driver.
@@ -738,7 +738,7 @@ comment "PIO-only SFF controllers"
 
 config PATA_AT32
 	tristate "Atmel AVR32 PATA support (Experimental)"
-	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
+	depends on AVR32 && PLATFORM_AT32AP
 	help
 	  This option enables support for the IDE devices on the
 	  Atmel AT32AP platform.
@@ -755,7 +755,7 @@ config PATA_AT91
 
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables support for the CMD640 PCI IDE
 	  interface chip. Only the primary channel is currently
@@ -801,7 +801,7 @@ config PATA_NS87410
 
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  This option enables full PIO support for the early Opti ATA
 	  controllers found on some old motherboards.
@@ -881,7 +881,7 @@ config PATA_SAMSUNG_CF
 
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on ISA
 	select PATA_LEGACY
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
@@ -909,7 +909,7 @@ config ATA_GENERIC
 
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
-	depends on (ISA || PCI) && EXPERIMENTAL
+	depends on (ISA || PCI)
 	help
 	  This option enables support for ISA/VLB/PCI bus legacy PATA
 	  ports and allows them to be accessed via the new ATA layer.
-- 
1.7.9.5

