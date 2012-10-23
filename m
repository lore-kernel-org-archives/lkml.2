Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab2JWUij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:38:39 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59075 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933829Ab2JWUFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:33 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Chris Ball <cjb@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 071/193] drivers/mmc/host: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:24 -0700
Message-Id: <1351022666-6960-72-git-send-email-keescook@chromium.org>
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

CC: Chris Ball <cjb@laptop.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>
CC: Fabio Estevam <fabio.estevam@freescale.com>
CC: Manuel Lauss <manuel.lauss@googlemail.com>
CC: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/mmc/host/Kconfig |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 9bf10e7..576fdab 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -69,7 +69,7 @@ config MMC_SDHCI_PCI
 	  If unsure, say N.
 
 config MMC_RICOH_MMC
-	bool "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
+	bool "Ricoh MMC Controller Disabler"
 	depends on MMC_SDHCI_PCI
 	help
 	  This adds a pci quirk to disable Ricoh MMC Controller. This
@@ -174,9 +174,6 @@ config MMC_SDHCI_S3C
 	  often referrered to as the HSMMC block in some of the Samsung S3C
 	  range of SoC.
 
-	  Note, due to the problems with DMA, the DMA support is only
-	  available with CONFIG_EXPERIMENTAL is selected.
-
 	  If you have a controller with this interface, say Y or M here.
 
 	  If unsure, say N.
@@ -221,7 +218,7 @@ config MMC_SDHCI_SPEAR
 
 config MMC_SDHCI_S3C_DMA
 	bool "DMA support on S3C SDHCI"
-	depends on MMC_SDHCI_S3C && EXPERIMENTAL
+	depends on MMC_SDHCI_S3C
 	help
 	  Enable DMA support on the Samsung S3C SDHCI glue. The DMA
 	  has proved to be problematic if the controller encounters
@@ -338,8 +335,8 @@ config MMC_MXS
 	  If unsure, say N.
 
 config MMC_TIFM_SD
-	tristate "TI Flash Media MMC/SD Interface support  (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	tristate "TI Flash Media MMC/SD Interface support"
+	depends on PCI
 	select TIFM_CORE
 	help
 	  Say Y here if you want to be able to access MMC/SD cards with
@@ -418,8 +415,7 @@ config MMC_S3C_PIO
 	  the S3C MCI driver.
 
 config MMC_S3C_DMA
-	bool "Use DMA transfers only (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Use DMA transfers only"
 	help
 	  Use DMA to transfer data between memory and the hardare.
 
@@ -428,7 +424,7 @@ config MMC_S3C_DMA
 	  option is useful.
 
 config MMC_S3C_PIODMA
-	bool "Support for both PIO and DMA (EXPERIMENTAL)"
+	bool "Support for both PIO and DMA"
 	help
 	  Compile both the PIO and DMA transfer routines into the
 	  driver and let the platform select at run-time which one
@@ -439,8 +435,8 @@ config MMC_S3C_PIODMA
 endchoice
 
 config MMC_SDRICOH_CS
-	tristate "MMC/SD driver for Ricoh Bay1Controllers (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI && PCMCIA
+	tristate "MMC/SD driver for Ricoh Bay1Controllers"
+	depends on PCI && PCMCIA
 	help
 	  Say Y here if your Notebook reports a Ricoh Bay1Controller PCMCIA
 	  card whenever you insert a MMC or SD card into the card slot.
-- 
1.7.9.5

