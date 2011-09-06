Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1IFIz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:55:56 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:39279 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1IFIzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:55:35 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p868tSSq024459
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v5 4/5] r8169: add MODULE_FIRMWARE for the firmware of 8111evl
Date: Tue, 6 Sep 2011 16:55:17 +0800
X-BOX-Message-Id: p868tSSq024459
Message-ID: <1315299318-1547-4-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315299318-1547-1-git-send-email-hayeswang@realtek.com>
References: <1315299318-1547-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MODULE_FIRMWARE for the firmware of RTL8111E-VL

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 175c769..8cd305f 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -711,6 +711,7 @@ MODULE_FIRMWARE(FIRMWARE_8168D_1);
 MODULE_FIRMWARE(FIRMWARE_8168D_2);
 MODULE_FIRMWARE(FIRMWARE_8168E_1);
 MODULE_FIRMWARE(FIRMWARE_8168E_2);
+MODULE_FIRMWARE(FIRMWARE_8168E_3);
 MODULE_FIRMWARE(FIRMWARE_8105E_1);
 
 static int rtl8169_open(struct net_device *dev);
-- 
1.7.6

