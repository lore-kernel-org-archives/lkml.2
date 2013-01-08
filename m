Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3AHXfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:35:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54811 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3AHXfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:35:43 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ce-50ecad4eda97
From: Byungho An <bh74.an@samsung.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Giuseppe CAVALLARO'" <peppe.cavallaro@st.com>, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, kgene.kim@samsung.com
Subject: [PATCH 1/3] net: stmac: add gmac autonet set for SGMII, TBI, and RTBI
Date: Tue, 08 Jan 2013 15:35:39 -0800
Message-id: <000901cdedf8$dfaf4390$9f0dcab0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac3t+LyMDZA9bFdgSmy1ed5ixOQfAg==
Content-language: en-zw
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ12/tW8CDBrmSVpc3jWHzeLYAjEH
	Jo/Pm+QCGKO4bFJSczLLUov07RK4MtrO72Ip6Jas+Pd8PlMD4wzRLkZODgkBE4nO3k+MELaY
	xIV769lAbCGBZYwS605ywdR0LbnI0sXIBRSfzijx7d4hKOc3o0T3ybtMIFVsAmoSzTMvA3Vz
	cIgIWEicaMsCCTML1EhcvXyDESQsLOAnsfuICUiYRUBVYtLtT6wgNq+ApcSHn0/ZIWxBiR+T
	77FAtGpJrN95nAnClpfYvOYtM8Q9ChI7zr4Gu1lEQE/i/YnrYOOZBcQlpjUVQYwXkPg2GeRK
	DqByWYlNB5hBDpYQ6GeX2Ln3GwvEGEmJgytusExgFJuFZPMsJJtnIdk8C2HDAkaWVYyiqQXJ
	BcVJ6blGesWJucWleel6yfm5mxghsSK9g3FVg8UhRgEORiUe3ofT3gQIsSaWFVfmHmKU4GBW
	EuG96w0U4k1JrKxKLcqPLyrNSS0+xOgDdPhEZinR5HxgHOeVxBsaG5uYmZiamFuampviEFYS
	52U89SRASCA9sSQ1OzW1ILUIZhwTB6dUA6Mwy0Wv2xXfO8oia45Nvy/21Ve3buOi3VeuG8xp
	926u8rVW2DPz0JwNJ2oU45abSPE7aB39v/97Q1oCC/eTg2xTlHebbOUM5knbNsXyxt4C1Tvr
	tBp/HSv9NLE39N21R1arnWUPfNFb9mTrS2lTXjXxZxtEZuzvceJUTt4j0KWk0/Dv/553qseV
	WIozEg21mIuKEwHlTYgGwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jQV2/tW8CDM61iFpc3jWHzeLYAjEH
	Jo/Pm+QCGKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ0
	3TJzgCYrKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDPazu9iKeiWrPj3
	fD5TA+MM0S5GTg4JAROJriUXWSBsMYkL99azdTFycQgJTGeU+HbvEAuE85tRovvkXSaQKjYB
	NYnmmZeBqjg4RAQsJE60ZYGEmQVqJK5evsEIEhYW8JPYfcQEJMwioCox6fYnVhCbV8BS4sPP
	p+wQtqDEj8n3WCBatSTW7zzOBGHLS2xe85YZ4h4FiR1nXzOC2CICehLvT1wHG88sIC4xralo
	AqPALCSTZiGZNAvJpFkIHQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfiM+kdjKsa
	LA4xCnAwKvHwPpz2JkCINbGsuDL3EKMEB7OSCO9db6AQb0piZVVqUX58UWlOavEhRh+gPycy
	S4km5wPTRF5JvKGxiZmRpZGZhZGJuTkOYSVxXsZTTwKEBNITS1KzU1MLUotgxjFxcEo1MPYI
	cF2MzmTLWn/RMMl9SaJDuwTb3/4Pbw69uzuBs7f+bE2zUf3NzDkyk71up/v57ru4mm8C57nv
	ddNDN+Y3rt/GqDhv7+pzG44b1/X9fryj6+0NNhMRt4+vM5lm5MxQkM/byXvt7+YDul1iblXP
	2w9+yhD6anijffb7ZIXLEk8Fina/0o/7f0mJpTgj0VCLuag4EQDPA4qx8gIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds gmac autoneg set function for SGMII, TBI,
and RTBI interface. In case of PHY's autoneg is set, gmac's
autoneg enable bit should set. After checking phy's autoneg
if phydev's autoneg is '1' gmac's ANE bit set for those
interface.

Signed-off-by: Byungho An <bh74.an@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h         |    1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |   11 +++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    9 +++++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h
b/drivers/net/ethernet/stmicro/stmmac/common.h
index 186d148..72ba769 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -344,6 +344,7 @@ struct stmmac_ops {
 	void (*reset_eee_mode) (void __iomem *ioaddr);
 	void (*set_eee_timer) (void __iomem *ioaddr, int ls, int tw);
 	void (*set_eee_pls) (void __iomem *ioaddr, int link);
+	void (*set_autoneg) (void __iomem *ioaddr);
 };
 
 struct mac_link {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index bfe0226..a0737b39 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -297,6 +297,16 @@ static void  dwmac1000_set_eee_timer(void __iomem
*ioaddr, int ls, int tw)
 	writel(value, ioaddr + LPI_TIMER_CTRL);
 }
 
+static void dwmac1000_set_autoneg(void __iomem *ioaddr)
+{
+	u32 value;
+
+	value = readl(ioaddr + GMAC_AN_CTRL);
+	value |= 0x1000;
+	writel(value, ioaddr + GMAC_AN_CTRL);
+}
+
+
 static const struct stmmac_ops dwmac1000_ops = {
 	.core_init = dwmac1000_core_init,
 	.rx_ipc = dwmac1000_rx_ipc_enable,
@@ -311,6 +321,7 @@ static const struct stmmac_ops dwmac1000_ops = {
 	.reset_eee_mode =  dwmac1000_reset_eee_mode,
 	.set_eee_timer =  dwmac1000_set_eee_timer,
 	.set_eee_pls =  dwmac1000_set_eee_pls,
+	.set_autoneg =  dwmac1000_set_autoneg,
 };
 
 struct mac_device_info *dwmac1000_setup(void __iomem *ioaddr)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f07c061..3e28934 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1007,6 +1007,7 @@ static int stmmac_open(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
+	int interface = priv->plat->interface;
 
 	clk_prepare_enable(priv->stmmac_clk);
 
@@ -1041,6 +1042,14 @@ static int stmmac_open(struct net_device *dev)
 	/* Initialize the MAC Core */
 	priv->hw->mac->core_init(priv->ioaddr);
 
+	/* If phy autoneg is on, set gmac autoneg for SGMII, TBI and RTBI*/
+	if((interface == PHY_INTERFACE_MODE_SGMII) ||
+		(interface == PHY_INTERFACE_MODE_TBI) ||
+		(interface == PHY_INTERFACE_MODE_RTBI)) {
+		if (priv->phydev->autoneg)
+			priv->hw->mac->set_autoneg(priv->ioaddr);
+	}
+
 	/* Request the IRQ lines */
 	ret = request_irq(dev->irq, stmmac_interrupt,
 			 IRQF_SHARED, dev->name, dev);
-- 
1.7.10.4


