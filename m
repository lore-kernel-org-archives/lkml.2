Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2D3Sao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 14:30:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59423 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2D3San (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 14:30:43 -0400
From: joseph daniel <josephdanielwalter@gmail.com>
To: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Francois Romieu <romieu@fr.zoreil.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: joseph daniel <josephdanielwalter@gmail.com>
Subject: [PATCH] staging/et131x: Fix coding style issues
Date: Tue,  1 May 2012 00:30:34 +0600
Message-Id: <1335810634-31151-1-git-send-email-josephdanielwalter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
---
 drivers/staging/et131x/et131x.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 886f565..5b11c5e 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1710,7 +1710,8 @@ static int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg)
 		return value;
 }
 
-static int et131x_mdio_write(struct mii_bus *bus, int phy_addr, int reg, u16 value)
+static int et131x_mdio_write(struct mii_bus *bus, int phy_addr,
+			     int reg, u16 value)
 {
 	struct net_device *netdev = bus->priv;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
@@ -4013,7 +4014,7 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 		dev_err(&pdev->dev, "Missing PCIe capabilities\n");
 		goto err_out;
 	}
-		
+
 	/* Let's set up the PORT LOGIC Register.  First we need to know what
 	 * the max_payload_size is
 	 */
@@ -4060,7 +4061,7 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 		goto err_out;
 	}
 
-	ctl = (ctl & ~PCI_EXP_DEVCTL_READRQ) | ( 0x04 << 12);
+	ctl = (ctl & ~PCI_EXP_DEVCTL_READRQ) | (0x04 << 12);
 
 	if (pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL, ctl)) {
 		dev_err(&pdev->dev,
@@ -4824,7 +4825,8 @@ static int et131x_open(struct net_device *netdev)
 	adapter->error_timer.data = (unsigned long)adapter;
 	add_timer(&adapter->error_timer);
 
-	result = request_irq(irq, et131x_isr, IRQF_SHARED, netdev->name, netdev);
+	result = request_irq(irq, et131x_isr,
+			     IRQF_SHARED, netdev->name, netdev);
 	if (result) {
 		dev_err(&pdev->dev, "could not register IRQ %d\n", irq);
 		return result;
-- 
1.7.9.5

