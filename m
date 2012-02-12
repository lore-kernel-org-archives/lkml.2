Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2BLNqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 08:46:12 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:52374
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753415Ab2BLNqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 08:46:11 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: peppe.cavallaro@st.com, netdev@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] stmicro: Fix typo in stmmac_pci.c and stmmac_platform.c
Date: Sun, 12 Feb 2012 22:45:41 +0900
Message-Id: <1329054341-1786-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "drivr" to "driver" in
drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |    2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index c796de9..b596578 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -98,7 +98,7 @@ static int __devinit stmmac_pci_probe(struct pci_dev *pdev,
 
 	priv = stmmac_dvr_probe(&(pdev->dev), &plat_dat);
 	if (!priv) {
-		pr_err("%s: main drivr probe failed", __func__);
+		pr_err("%s: main driver probe failed", __func__);
 		goto err_out;
 	}
 	priv->ioaddr = addr;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 1ac8324..11af27e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -61,7 +61,7 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
 	plat_dat = pdev->dev.platform_data;
 	priv = stmmac_dvr_probe(&(pdev->dev), plat_dat);
 	if (!priv) {
-		pr_err("%s: main drivr probe failed", __func__);
+		pr_err("%s: main driver probe failed", __func__);
 		goto out_unmap;
 	}
 
-- 
1.7.6.5

