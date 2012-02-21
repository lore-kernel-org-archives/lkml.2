Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab2BUCXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:23:22 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48648 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2BUCXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:23:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of justinmattock@gmail.com designates 10.68.211.202 as permitted sender) smtp.mail=justinmattock@gmail.com; dkim=pass header.i=justinmattock@gmail.com
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:staging:et131x Fix some typo's in staging et131x.
Date: Mon, 20 Feb 2012 18:23:09 -0800
Message-Id: <1329790989-7366-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes some comments with typos in the them and makes a comment make more sense.

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/et131x/et131x.c |    6 +++---
 drivers/staging/et131x/et131x.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2c4069f..b34e6cf 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -802,7 +802,7 @@ static int et131x_init_eeprom(struct et131x_adapter *adapter)
 	/* THIS IS A WORKAROUND:
 	 * I need to call this function twice to get my card in a
 	 * LG M1 Express Dual running. I tried also a msleep before this
-	 * function, because I thougth there could be some time condidions
+	 * function, because I thought there could be some time condidions
 	 * but it didn't work. Call the whole function twice also work.
 	 */
 	if (pci_read_config_byte(pdev, ET1310_PCI_EEPROM_STATUS, &eestatus)) {
@@ -987,7 +987,7 @@ static void et1310_config_mac_regs1(struct et131x_adapter *adapter)
 	writel(station1, &macregs->station_addr_1);
 	writel(station2, &macregs->station_addr_2);
 
-	/* Max ethernet packet in bytes that will passed by the mac without
+	/* Max ethernet packet in bytes that will be passed by the mac without
 	 * being truncated.  Allow the MAC to pass 4 more than our max packet
 	 * size.  This is 4 for the Ethernet CRC.
 	 *
@@ -4413,7 +4413,7 @@ static void et131x_up(struct net_device *netdev)
 
 /**
  * et131x_down - Bring down the device
- * @netdev: device to be broght down
+ * @netdev: device to be brought down
  */
 static void et131x_down(struct net_device *netdev)
 {
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 7eed3c8..864379b 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -596,7 +596,7 @@ struct rxdma_regs {					/* Location: */
  * structure for tx test reg in txmac address map
  * located at address 0x3014
  * 31-17: unused
- * 16: reserved1
+ * 16: reserved
  * 15: txtest_en
  * 14-11: unused
  * 10-0: txq test pointer
@@ -1485,7 +1485,7 @@ struct address_map {
  *	3:	reserved
  *	2:	ignore_10g_fr
  *	1:	reserved
- *	0:	preamble_supress_en
+ *	0:	preamble_suppress_en
  */
 
 /* MI Register 22: PHY Configuration Reg(0x16)
-- 
1.7.5.4

