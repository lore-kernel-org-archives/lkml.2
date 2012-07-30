Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2G3OPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:15:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62568 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2G3OPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:15:31 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, spi-devel-general@lists.sourceforge.net
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] spi: Fix typo in spi
Date: Mon, 30 Jul 2012 23:16:14 +0900
Message-Id: <1343657774-26045-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in drivers/spi

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/spi/spi-au1550.c       | 2 +-
 drivers/spi/spi-bfin-sport.c   | 2 +-
 drivers/spi/spi-oc-tiny.c      | 2 +-
 drivers/spi/spi-ppc4xx.c       | 4 ++--
 drivers/spi/spi-topcliff-pch.c | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-au1550.c b/drivers/spi/spi-au1550.c
index 5784c87..4de66d1 100644
--- a/drivers/spi/spi-au1550.c
+++ b/drivers/spi/spi-au1550.c
@@ -475,7 +475,7 @@ static irqreturn_t au1550_spi_dma_irq_callback(struct au1550_spi *hw)
 		/*
 		 * due to an spi error we consider transfer as done,
 		 * so mask all events until before next transfer start
-		 * and stop the possibly running dma immediatelly
+		 * and stop the possibly running dma immediately
 		 */
 		au1550_spi_mask_ack_all(hw);
 		au1xxx_dbdma_stop(hw->dma_rx_ch);
diff --git a/drivers/spi/spi-bfin-sport.c b/drivers/spi/spi-bfin-sport.c
index 1fe5119..6555ecd 100644
--- a/drivers/spi/spi-bfin-sport.c
+++ b/drivers/spi/spi-bfin-sport.c
@@ -467,7 +467,7 @@ bfin_sport_spi_pump_transfers(unsigned long data)
 		dev_dbg(drv_data->dev, "IO write error!\n");
 		drv_data->state = ERROR_STATE;
 	} else {
-		/* Update total byte transfered */
+		/* Update total byte transferred */
 		message->actual_length += transfer->len;
 		/* Move to next transfer of this msg */
 		drv_data->state = bfin_sport_spi_next_transfer(drv_data);
diff --git a/drivers/spi/spi-oc-tiny.c b/drivers/spi/spi-oc-tiny.c
index 698018f..9d9071b 100644
--- a/drivers/spi/spi-oc-tiny.c
+++ b/drivers/spi/spi-oc-tiny.c
@@ -129,7 +129,7 @@ static int tiny_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 	unsigned int i;
 
 	if (hw->irq >= 0) {
-		/* use intrrupt driven data transfer */
+		/* use interrupt driven data transfer */
 		hw->len = t->len;
 		hw->txp = t->tx_buf;
 		hw->rxp = t->rx_buf;
diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 75ac9d4..7a85f22 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -101,7 +101,7 @@ struct spi_ppc4xx_regs {
 	u8 dummy;
 	/*
 	 * Clock divisor modulus register
-	 * This uses the follwing formula:
+	 * This uses the following formula:
 	 *    SCPClkOut = OPBCLK/(4(CDM + 1))
 	 * or
 	 *    CDM = (OPBCLK/4*SCPClkOut) - 1
@@ -201,7 +201,7 @@ static int spi_ppc4xx_setupxfer(struct spi_device *spi, struct spi_transfer *t)
 		return -EINVAL;
 	}
 
-	/* Write new configration */
+	/* Write new configuration */
 	out_8(&hw->regs->mode, cs->mode);
 
 	/* Set the clock */
diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index cd56dcf..1284c9b 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -505,7 +505,7 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
 	}
 
 	if (unlikely(pspi->max_speed_hz == 0)) {
-		dev_err(&pspi->dev, "%s pch_spi_tranfer maxspeed=%d\n",
+		dev_err(&pspi->dev, "%s pch_spi_transfer maxspeed=%d\n",
 			__func__, pspi->max_speed_hz);
 		retval = -EINVAL;
 		goto err_out;
-- 
1.7.12.rc0.22.gcdd159b

