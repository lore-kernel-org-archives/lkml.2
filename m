Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab3AIIkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:40:47 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:41034 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3AIIkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:40:46 -0500
From: Patrik Karlin <patrik.karlin@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Patrik Karlin <patrik.karlin@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=202/3=5D=20staging=3A=20rtl8192u=3A=20removed=20some=20non=20used=20else=27s?=
Date: Wed,  9 Jan 2013 09:40:23 +0100
Message-Id: <1357720823-4270-1-git-send-email-patrik.karlin@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <n>
References: <n>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some else blocks that has no function in the
code

Signed-off-by: Patrik Kårlin <patrik.karlin@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index c2260de..193822e 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2176,7 +2176,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 		dev->trans_start = jiffies;
 		atomic_inc(&priv->tx_pending[tcb_desc->queue_index]);
 		return 0;
-	}else{
+	} else {
 		RT_TRACE(COMP_ERR, "Error TX URB %d, error %d", atomic_read(&priv->tx_pending[tcb_desc->queue_index]),
 				status);
 		return -1;
@@ -4572,11 +4572,8 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 	{
 		// if previous packet is not aggregated packet
 		bcheck = true;
-	}else
-	{
 	}
 
-
 	if(slide_rssi_statistics++ >= PHY_RSSI_SLID_WIN_MAX)
 	{
 		slide_rssi_statistics = PHY_RSSI_SLID_WIN_MAX;
@@ -5676,10 +5673,6 @@ void rtl8192_rx_cmd(struct sk_buff *skb)
 
 		dev_kfree_skb_any(skb);
 	}
-	else
-		;
-
-
 }
 
 void rtl8192_irq_rx_tasklet(struct r8192_priv *priv)
-- 
1.7.10.4

