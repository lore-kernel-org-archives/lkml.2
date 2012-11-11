Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2KKQt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 11:49:29 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61546 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2KKQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 11:49:27 -0500
From: Dayanidhi Sreenivasan <dayanidhi.sreenivasan@gmail.com>
To: romieu@fr.zoreil.com, nic_swsd@realtek.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dayanidhi Sreenivasan <dayanidhi.sreenivasan@gmail.com>
Subject: [PATCH 1/1] 	r8169: Removed unused macros from r8169.c
Date: Sun, 11 Nov 2012 11:48:38 -0500
Message-Id: <1352652518-2287-1-git-send-email-dayanidhi.sreenivasan@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <r8169-Removed-unused-macros-from-r8169.c>
References: <r8169-Removed-unused-macros-from-r8169.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Dayanidhi Sreenivasan <dayanidhi.sreenivasan@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index b47d5b3..60b45ca 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -78,23 +78,18 @@ static const int multicast_filter_limit = 32;
 
 #define MAX_READ_REQUEST_SHIFT	12
 #define TX_DMA_BURST	6	/* Maximum PCI burst, '6' is 1024 */
-#define SafeMtu		0x1c20	/* ... actually life sucks beyond ~7k */
 #define InterFrameGap	0x03	/* 3 means InterFrameGap = the shortest one */
 
 #define R8169_REGS_SIZE		256
 #define R8169_NAPI_WEIGHT	64
 #define NUM_TX_DESC	64	/* Number of Tx descriptor registers */
 #define NUM_RX_DESC	256	/* Number of Rx descriptor registers */
-#define RX_BUF_SIZE	1536	/* Rx Buffer size */
 #define R8169_TX_RING_BYTES	(NUM_TX_DESC * sizeof(struct TxDesc))
 #define R8169_RX_RING_BYTES	(NUM_RX_DESC * sizeof(struct RxDesc))
 
 #define RTL8169_TX_TIMEOUT	(6*HZ)
 #define RTL8169_PHY_TIMEOUT	(10*HZ)
 
-#define RTL_EEPROM_SIG		cpu_to_le32(0x8129)
-#define RTL_EEPROM_SIG_MASK	cpu_to_le32(0xffff)
-#define RTL_EEPROM_SIG_ADDR	0x0000
 
 /* write/read MMIO register */
 #define RTL_W8(reg, val8)	writeb ((val8), ioaddr + (reg))
-- 
1.7.5.4

