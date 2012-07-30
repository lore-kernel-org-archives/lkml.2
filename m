Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2G3Ubf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 16:31:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58325 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab2G3Ubd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 16:31:33 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] mmc: host: Fix typo in mmc/hosts
Date: Tue, 31 Jul 2012 05:32:09 +0900
Message-Id: <1343680329-25343-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc0.56.g425b8a2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling in printk and comments in mmc/hosts.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/mmc/core/sdio.c            | 2 +-
 drivers/mmc/host/at91_mci.c        | 2 +-
 drivers/mmc/host/atmel-mci.c       | 2 +-
 drivers/mmc/host/omap_hsmmc.c      | 2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c | 2 +-
 drivers/mmc/host/vub300.c          | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 41c5fd8..595e1c8 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -644,7 +644,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	/*
 	 * If the host and card support UHS-I mode request the card
 	 * to switch to 1.8V signaling level.  No 1.8v signalling if
-	 * UHS mode is not enabled to maintain compatibilty and some
+	 * UHS mode is not enabled to maintain compatibility and some
 	 * systems that claim 1.8v signalling in fact do not support
 	 * it.
 	 */
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index efdb81d..74bed0f 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -356,7 +356,7 @@ static void at91_mci_handle_transmitted(struct at91mci_host *host)
 }
 
 /*
- * Update bytes tranfered count during a write operation
+ * Update bytes transfered count during a write operation
  */
 static void at91_mci_update_bytes_xfered(struct at91mci_host *host)
 {
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index f2c115e..383c93b 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1015,7 +1015,7 @@ static void atmci_stop_transfer(struct atmel_mci *host)
 }
 
 /*
- * Stop data transfer because error(s) occured.
+ * Stop data transfer because error(s) occurred.
  */
 static void atmci_stop_transfer_pdc(struct atmel_mci *host)
 {
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 9a7a60a..4d4f097 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -448,7 +448,7 @@ static void omap_hsmmc_stop_clock(struct omap_hsmmc_host *host)
 	OMAP_HSMMC_WRITE(host->base, SYSCTL,
 		OMAP_HSMMC_READ(host->base, SYSCTL) & ~CEN);
 	if ((OMAP_HSMMC_READ(host->base, SYSCTL) & CEN) != 0x0)
-		dev_dbg(mmc_dev(host->mmc), "MMC Clock is not stoped\n");
+		dev_dbg(mmc_dev(host->mmc), "MMC Clock is not stopped\n");
 }
 
 static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host,
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index ebbe984..ca22b6b 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -313,7 +313,7 @@ static void esdhc_writeb_le(struct sdhci_host *host, u8 val, int reg)
 		new_val = val & (SDHCI_CTRL_LED | \
 				SDHCI_CTRL_4BITBUS | \
 				SDHCI_CTRL_D3CD);
-		/* ensure the endianess */
+		/* ensure the endianness */
 		new_val |= ESDHC_HOST_CONTROL_LE;
 		/* DMA mode bits are shifted */
 		new_val |= (val & SDHCI_CTRL_DMA_MASK) << 5;
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 3135a1a..58eab9a 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -806,7 +806,7 @@ static void command_res_completed(struct urb *urb)
 		 * we suspect a buggy USB host controller
 		 */
 	} else if (!vub300->data) {
-		/* this means that the command (typically CMD52) suceeded */
+		/* this means that the command (typically CMD52) succeeded */
 	} else if (vub300->resp.common.header_type != 0x02) {
 		/*
 		 * this is an error response from the VUB300 chip
-- 
1.7.12.rc0.56.g425b8a2

