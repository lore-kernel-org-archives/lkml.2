Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3AHXcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:32:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15732 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab3AHXcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:32:04 -0500
X-AuditID: cbfee61b-b7f616d00000319b-64-50ecac713343
From: Byungho An <bh74.an@samsung.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Giuseppe CAVALLARO'" <peppe.cavallaro@st.com>, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, kgene.kim@samsung.com
Subject: [PATCH v2 2/3] net: stmmac: add autoneg complete irq
Date: Tue, 08 Jan 2013 15:32:00 -0800
Message-id: <000501cdedf8$5c323900$1496ab00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac3t+DwgMVCzeSFWTL6IjNnd1EzQrw==
Content-language: en-zw
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zQ93CNW8CDObvk7K4vGsOm8WxBWIO
	TB6fN8kFMEZx2aSk5mSWpRbp2yVwZdxb1MdU8FO0YuWvU+wNjJeEuhg5OSQETCTO/5zFBmGL
	SVy4tx7I5uIQEljGKDF59X0mmKIdn64xQyQWMUqcmnINrENI4DejxJMPrCA2m4CaRPPMy0Bx
	Dg4RAQuJE21ZIGFmgRqJq5dvMILYwgK2EtcPtYDNZBFQlVh98wU7iM0rYClx7uRVZghbUOLH
	5HssEL1aEut3HmeCsOUlNq95ywxxj4LEjrOvwWaKCOhJvFs6nRFkLbOAuMS0piKI8QIS3yYf
	YgEJSwjISmw6AHa9hEA/u8T9rZOgxkhKHFxxg2UCo9gsJJtnIdk8C8nmWQgbFjCyrGIUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIiRbpHYyrGiwOMQpwMCrx8D6c9iZAiDWxrLgy9xCjBAez
	kgjvXW+gEG9KYmVValF+fFFpTmrxIUYfoMMnMkuJJucDIzmvJN7Q2NjEzMTUxNzS1NwUh7CS
	OC/jqScBQgLpiSWp2ampBalFMOOYODilGhinPZ8q73EkqvDsXTF5J8ffmy5mpPuXywqk/2r3
	mGXtx3ZvBd/5uMkstbYbNxr1RO2MDTzhJeg4IUCtwcS2utJ9twUrX+sKEd/OqHyHBK3lXdtP
	6VtNPhB0I6T4nUf1hxnq7w0mZzEqb3w7z7DHcNHC8jm/n00L0tqe17j2TmXfsqLFkUqBoUos
	xRmJhlrMRcWJAJGvtKrDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jAd3CNW8CDJauFbW4vGsOm8WxBWIO
	TB6fN8kFMEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAE1WUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWbcW9THVPBTtGLl
	r1PsDYyXhLoYOTkkBEwkdny6xgxhi0lcuLeerYuRi0NIYBGjxKkp19hAEkICvxklnnxgBbHZ
	BNQkmmdeBopzcIgIWEicaMsCCTML1EhcvXyDEcQWFrCVuH6ohQnEZhFQlVh98wU7iM0rYClx
	7uRVZghbUOLH5HssEL1aEut3HmeCsOUlNq95C3WPgsSOs6/BZooI6Em8WzqdEWQts4C4xLSm
	ogmMArOQTJqFZNIsJJNmIXQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREci8+kdzCu
	arA4xCjAwajEw/tw2psAIdbEsuLK3EOMEhzMSiK8d72BQrwpiZVVqUX58UWlOanFhxh9gP6c
	yCwlmpwPTBN5JfGGxiZmRpZGZhZGJubmOISVxHkZTz0JEBJITyxJzU5NLUgtghnHxMEp1cBo
	vfkXr9VOLePjqQvmegSe3mDGOfNa+6XC/lW/tr6S/+Qdu6MvUXdxu7fXxpo3bkyPspsj/D52
	f3C+ajhLXl+i3pWRPTonTP744cSUCYVhOybGPU+8FN5xc8/XvNOJ8U/nL1NLn/LpQ5+X4TTB
	gLWfYuc9PR8jZqkav2on9yz5b6eMH5ifq1yvxFKckWioxVxUnAgA8s/fFvICAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds auto-negotiation complete irq and ISR.
when the irq is occured it read GMAC_AN_STATUS register
to clear PCSANCIS bit.

Singed-off-by: Byungho An <bh74.an@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h         |    1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |    5 +++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h         |    1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    2 ++
 4 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h
b/drivers/net/ethernet/stmicro/stmmac/common.h
index 72ba769..bc5ce7a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -203,6 +203,7 @@ enum core_specific_irq_mask {
 	core_irq_tx_path_exit_lpi_mode = 32,
 	core_irq_rx_path_in_lpi_mode = 64,
 	core_irq_rx_path_exit_lpi_mode = 128,
+	core_irq_pcs_autoneg_complete = 256,
 };
 
 /* DMA HW capabilities */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index a0737b39..0643ed3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -222,6 +222,11 @@ static int dwmac1000_irq_status(void __iomem *ioaddr)
 		readl(ioaddr + GMAC_PMT);
 		status |= core_irq_receive_pmt_irq;
 	}
+	if (unlikely(intr_status & pcs_ane_irq)) {
+		CHIP_DBG(KERN_INFO "GMAC: PCS Auto-negotiation complete\n");
+		readl(ioaddr + GMAC_AN_STATUS);
+		status |= core_irq_pcs_autoneg_complete;
+	}
 	/* MAC trx/rx EEE LPI entry/exit interrupts */
 	if (intr_status & lpiis_irq) {
 		/* Clean LPI interrupt by reading the Reg 12 */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index b05df89..b4220f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -93,6 +93,7 @@ struct stmmac_priv {
 	u32 tx_coal_timer;
 	int use_riwt;
 	u32 rx_riwt;
+	bool core_pcs_an;
 };
 
 extern int phyaddr;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3e28934..0d2afbb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1623,6 +1623,8 @@ static irqreturn_t stmmac_interrupt(int irq, void
*dev_id)
 				priv->xstats.mmc_rx_csum_offload_irq_n++;
 			if (status & core_irq_receive_pmt_irq)
 				priv->xstats.irq_receive_pmt_irq_n++;
+			if (status & core_irq_pcs_autoneg_complete)
+				priv->core_pcs_an = true;
 
 			/* For LPI we need to save the tx status */
 			if (status & core_irq_tx_path_in_lpi_mode) {
-- 
1.7.10.4


