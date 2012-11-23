Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030292Ab2KWJE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:04:27 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:27180 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab2KWJEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:04:14 -0500
X-AuditID: cbfee61b-b7f616d00000319b-bc-50af3c0ba470
From: Byungho An <bh74.an@samsung.com>
To: davem@davemloft.net, peppe.cavallaro@st.com, jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: stmmac: change GMAC control register for SGMII
Date: Fri, 23 Nov 2012 18:04:11 +0900
Message-id: <004b01cdc959$80af8030$820e8090$%an@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3JWYCZkX9I870WSxWSjQvpbUM78w==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zQ11um/UBBr+OKVhc3jWHzeLYAjEH
	Jo/Pm+QCGKO4bFJSczLLUov07RK4MjZdPMRa8J+rYt6O0+wNjNM4uxg5OSQETCRaVj5jh7DF
	JC7cW8/WxcjFISSwjFHizOdT7DBFd5Z9YYJITGeUmHntOSOE84tR4sj5U2wgVWwCahLNMy+D
	2SICPhI3lr9jAbGZBfwluicfBYsLC3hILNt/Acjm4GARUJV4+0IcxOQVsJHYMrMWpIJXQFDi
	x+R7UJ1aEut3HmeCsOUlNq95ywxSLiGgLvHory7EIj2J948/sEKUiEjse/GOEcRmERCQ+Db5
	EAtEuazEpgPMIAdLCHSzSyx+380I8ZakxMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWMoqkF
	yQXFSem5RnrFibnFpXnpesn5uZsYIfEivYNxVYPFIUYBDkYlHl7DsnUBQqyJZcWVuYcYJTiY
	lUR4mcTWBwjxpiRWVqUW5ccXleakFh9i9AG6fCKzlGhyPjCW80riDY2NTcxMTE3MLU3NTXEI
	K4nzNnukBAgJpCeWpGanphakFsGMY+LglGpgZLss/Tzu9/5bjuqnXxTIv/+x68rvj/MSu5vX
	/ym07q9rFs7dXbAqOpn947dQnXYR1/3vjK6V2Fv8X3+xxDJSVeDbCovLP6u3sEk6Lg7c5SCt
	PGmBmtc9qYM5vUtOtpzJ8VlRovpl/c/q+UXb3hx2apzgfGLKqRfRiwR/nOX+sN7MK0kjzOFE
	iRJLcUaioRZzUXEiAJicUQrEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQV1um/UBBr+eSFlc3jWHzeLYAjEH
	Jo/Pm+QCGKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ0
	3TJzgCYrKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDM2XTzEWvCfq2Le
	jtPsDYzTOLsYOTkkBEwk7iz7wgRhi0lcuLeerYuRi0NIYDqjxMxrzxkhnF+MEkfOn2IDqWIT
	UJNonnkZzBYR8JG4sfwdC4jNLOAv0T35KFhcWMBDYtn+C0A2BweLgKrE2xfiICavgI3Elpm1
	IBW8AoISPybfg+rUkli/8zgThC0vsXnNW2aQcgkBdYlHf3UhFulJvH/8gRWiRERi34t3jBMY
	BWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwND6T3sG4qsHi
	EKMAB6MSD69h2boAIdbEsuLK3EOMEhzMSiK8TGLrA4R4UxIrq1KL8uOLSnNSiw8x+gC9OZFZ
	SjQ5H5go8kriDY1NzIwsjcwsjEzMzXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpg5Nud
	9VLm6vbU2bsSrnKbHln8LEpH/vKjRQcK+iMi+8ReX1T9EVpeWqWn+vXAz171sMwrTlpv3ZMS
	rGw6Vkww2L3T/MOryxdLL56929hr1CtwjNHlYs/MntdhJv4fvslWb9FO8xL5M6G52E6G+1P7
	phnn1S7q9H+7JPza+G3KvEfZl0625vQxKLEUZyQaajEXFScCAMguYbzzAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch changes GMAC control register (TC(Transmit
Configuration) and PS(Port Selection) bit for SGMII.
In case of SGMII, TC bit is '1' and PS bit is 0.

Signed-off-by: Byungho An <bh74.an@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c6cdbc4..a719c87 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1037,6 +1037,7 @@ static int stmmac_open(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
+	u32 value;
 
 #ifdef CONFIG_STMMAC_TIMER
 	priv->tm = kzalloc(sizeof(struct stmmac_timer *), GFP_KERNEL);
@@ -1088,6 +1089,15 @@ static int stmmac_open(struct net_device *dev)
 	/* Initialize the MAC Core */
 	priv->hw->mac->core_init(priv->ioaddr);
 
+	if (priv->phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		value = readl(priv->ioaddr);
+		/* GMAC_CONTROL_TC : transmit config in RGMII/SGMII */
+		value |= 0x1000000;
+		/* GMAC_CONTROL_PS : Port Selection for GMII */
+		value &= ~(0x8000);
+		writel(value, priv->ioaddr);
+	}
+
 	/* Request the IRQ lines */
 	ret = request_irq(dev->irq, stmmac_interrupt,
 			 IRQF_SHARED, dev->name, dev);
-- 
1.7.9.5

