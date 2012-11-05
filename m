Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab2KEXXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:23:36 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49923 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab2KEXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:26 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 076/104] drivers/spi: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:33 -0800
Message-Id: <1352156701-4038-77-git-send-email-keescook@chromium.org>
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

CC: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/spi/Kconfig |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 1acae35..c580b1f 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -88,7 +88,7 @@ config SPI_BFIN_SPORT
 
 config SPI_AU1550
 	tristate "Au1550/Au1200/Au1300 SPI Controller"
-	depends on MIPS_ALCHEMY && EXPERIMENTAL
+	depends on MIPS_ALCHEMY
 	select SPI_BITBANG
 	help
 	  If you say yes to this option, support will be included for the
@@ -181,7 +181,7 @@ config SPI_IMX
 
 config SPI_LM70_LLP
 	tristate "Parallel port adapter for LM70 eval board (DEVELOPMENT)"
-	depends on PARPORT && EXPERIMENTAL
+	depends on PARPORT
 	select SPI_BITBANG
 	help
 	  This driver supports the NS LM70 LLP Evaluation Board,
@@ -197,7 +197,7 @@ config SPI_MPC52xx
 
 config SPI_MPC52xx_PSC
 	tristate "Freescale MPC52xx PSC SPI controller"
-	depends on PPC_MPC52xx && EXPERIMENTAL
+	depends on PPC_MPC52xx
 	help
 	  This enables using the Freescale MPC52xx Programmable Serial
 	  Controller in master SPI mode.
@@ -266,8 +266,8 @@ config SPI_OMAP_100K
 	  OMAP SPI 100K master controller for omap7xx boards.
 
 config SPI_ORION
-	tristate "Orion SPI master (EXPERIMENTAL)"
-	depends on PLAT_ORION && EXPERIMENTAL
+	tristate "Orion SPI master"
+	depends on PLAT_ORION
 	help
 	  This enables using the SPI master controller on the Orion chips.
 
@@ -292,7 +292,7 @@ config SPI_PPC4xx
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
-	depends on (ARCH_PXA || (X86_32 && PCI)) && EXPERIMENTAL
+	depends on (ARCH_PXA || (X86_32 && PCI))
 	select PXA_SSP if ARCH_PXA
 	help
 	  This enables using a PXA2xx or Sodaville SSP port as a SPI master
@@ -310,7 +310,7 @@ config SPI_RSPI
 
 config SPI_S3C24XX
 	tristate "Samsung S3C24XX series SPI"
-	depends on ARCH_S3C24XX && EXPERIMENTAL
+	depends on ARCH_S3C24XX
 	select SPI_BITBANG
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs
@@ -417,7 +417,7 @@ config SPI_XCOMM
 
 config SPI_XILINX
 	tristate "Xilinx SPI controller common module"
-	depends on HAS_IOMEM && EXPERIMENTAL
+	depends on HAS_IOMEM
 	select SPI_BITBANG
 	help
 	  This exposes the SPI controller IP from the Xilinx EDK.
@@ -429,7 +429,7 @@ config SPI_XILINX
 
 config SPI_NUC900
 	tristate "Nuvoton NUC900 series SPI"
-	depends on ARCH_W90X900 && EXPERIMENTAL
+	depends on ARCH_W90X900
 	select SPI_BITBANG
 	help
 	  SPI driver for Nuvoton NUC900 series ARM SoCs
@@ -463,7 +463,6 @@ comment "SPI Protocol Masters"
 
 config SPI_SPIDEV
 	tristate "User mode SPI device driver support"
-	depends on EXPERIMENTAL
 	help
 	  This supports user mode SPI protocol drivers.
 
-- 
1.7.9.5

