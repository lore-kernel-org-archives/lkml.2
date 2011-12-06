Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab1LFK2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:28:32 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:51647 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab1LFK23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:28:29 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH][NET] several cleanups and bugfixes for fec.c: misc cleanups
Date: Tue,  6 Dec 2011 11:27:09 +0100
Message-Id: <bd4415514fa0b40ece04d56b3ac4f549e79d87d7.1323163127.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1323163127.git.LW@KARO-electronics.de>
References: <cover.1323163127.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323163127.git.LW@KARO-electronics.de>
References: <cover.1323163127.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - remove some bogus whitespace
 - remove line wraps from printk messages

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/ethernet/freescale/fec.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
index 1124ce0..f224e58 100644
--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@ -99,7 +99,7 @@ static struct platform_device_id fec_devtype[] = {
 MODULE_DEVICE_TABLE(platform, fec_devtype);
 
 enum imx_fec_type {
-	IMX25_FEC = 1, 	/* runs on i.mx25/50/53 */
+	IMX25_FEC = 1,	/* runs on i.mx25/50/53 */
 	IMX27_FEC,	/* runs on i.mx27/35/51 */
 	IMX28_FEC,
 	IMX6Q_FEC,
@@ -132,7 +132,7 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #elif defined (CONFIG_M5272C3)
 #define	FEC_FLASHMAC	(0xffe04000 + 4)
 #elif defined(CONFIG_MOD5272)
-#define FEC_FLASHMAC 	0xffc0406b
+#define FEC_FLASHMAC	0xffc0406b
 #else
 #define	FEC_FLASHMAC	0
 #endif
@@ -972,8 +972,9 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	}
 
 	if (phy_id >= PHY_MAX_ADDR) {
-		printk(KERN_INFO "%s: no PHY, assuming direct connection "
-			"to switch\n", ndev->name);
+		printk(KERN_INFO
+			"%s: no PHY, assuming direct connection to switch\n",
+			ndev->name);
 		strncpy(mdio_bus_id, "0", MII_BUS_ID_SIZE);
 		phy_id = 0;
 	}
@@ -998,8 +999,9 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	fep->link = 0;
 	fep->full_duplex = 0;
 
-	printk(KERN_INFO "%s: Freescale FEC PHY driver [%s] "
-		"(mii_bus:phy_addr=%s, irq=%d)\n", ndev->name,
+	printk(KERN_INFO
+		"%s: Freescale FEC PHY driver [%s] (mii_bus:phy_addr=%s, irq=%d)\n",
+		ndev->name,
 		fep->phy_dev->drv->name, dev_name(&fep->phy_dev->dev),
 		fep->phy_dev->irq);
 
-- 
1.5.6.5

