Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab0FJBR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:17:56 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:16390 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758388Ab0FJBRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:17:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvUxAGjaD0w6B9paPGdsb2JhbACHcJZrDAEBAQE1LbEyjWuFGASDRw
X-IronPort-AV: E=Sophos;i="4.53,395,1272816000"; 
   d="scan'208";a="44446494"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 4/4] staging: rtl8192u: fix checkpatch.pl issues to line 3500 Fix most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 3500
Date: Thu, 10 Jun 2010 09:18:05 +0800
Message-Id: <1276132685-26713-5-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1276132685-26713-4-git-send-email-mike.kernel@gilksonline.com>
References: <1276132685-26713-1-git-send-email-mike.kernel@gilksonline.com>
 <1276132685-26713-2-git-send-email-mike.kernel@gilksonline.com>
 <1276132685-26713-3-git-send-email-mike.kernel@gilksonline.com>
 <1276132685-26713-4-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 14ef649..6f20518 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3410,13 +3410,13 @@ short rtl8192_init(struct net_device *dev)
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	memset(&(priv->stats),0,sizeof(struct Stats));
-	memset(priv->txqueue_to_outpipemap,0,9);
+	memset(&(priv->stats), 0, sizeof(struct Stats));
+	memset(priv->txqueue_to_outpipemap, 0, 9);
 #ifdef PIPE12
 	{
 		int i = 0;
-		u8 queuetopipe[]={3, 2, 1, 0, 4, 8, 7, 6, 5};
-		memcpy(priv->txqueue_to_outpipemap,queuetopipe, 9);
+		u8 queuetopipe[] = {3, 2, 1, 0, 4, 8, 7, 6, 5};
+		memcpy(priv->txqueue_to_outpipemap, queuetopipe, 9);
 		/* for(i = 0; i < 9; i++)
 		 *	printk("%d ", priv->txqueue_to_outpipemap[i]);
 		 *printk("\n");
@@ -3424,8 +3424,8 @@ short rtl8192_init(struct net_device *dev)
 	}
 #else
 	{
-		u8 queuetopipe[]={3, 2, 1, 0, 4, 4, 0, 4, 4};
-		memcpy(priv->txqueue_to_outpipemap,queuetopipe, 9);
+		u8 queuetopipe[] = {3, 2, 1, 0, 4, 4, 0, 4, 4};
+		memcpy(priv->txqueue_to_outpipemap, queuetopipe, 9);
 		/* for(i = 0; i < 9; i++)
 		 *	printk("%d ", priv->txqueue_to_outpipemap[i]);
 		 *printk("\n");
@@ -3442,7 +3442,7 @@ short rtl8192_init(struct net_device *dev)
 	init_timer(&priv->watch_dog_timer);
 	priv->watch_dog_timer.data = (unsigned long)dev;
 	priv->watch_dog_timer.function = watch_dog_timer_callback;
-	if(rtl8192_usb_initendpoints(dev)!=0){
+	if (rtl8192_usb_initendpoints(dev) != 0) {
 		DMESG("Endopoints initialization failed");
 		return -ENOMEM;
 	}
@@ -3463,7 +3463,7 @@ short rtl8192_init(struct net_device *dev)
  *  notice:  This part need to modified according to the rate set we filtered
  * ****************************************************************************
  */
-void rtl8192_hwconfig(struct net_device* dev)
+void rtl8192_hwconfig(struct net_device *dev)
 {
 	u32 regRATR = 0, regRRSR = 0;
 	u8 regBwOpMode = 0, regTmp = 0;
@@ -3477,7 +3477,7 @@ void rtl8192_hwconfig(struct net_device* dev)
 		regRRSR = RATE_ALL_CCK;
 		break;
 	case WIRELESS_MODE_A:
-		regBwOpMode = BW_OPMODE_5G |BW_OPMODE_20MHZ;
+		regBwOpMode = BW_OPMODE_5G | BW_OPMODE_20MHZ;
 		regRATR = RATE_ALL_OFDM_AG;
 		regRRSR = RATE_ALL_OFDM_AG;
 		break;
-- 
1.6.3.3

