Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965167Ab2KVTal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:30:41 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58507 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2KVTah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:30:37 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 3/4] staging/rtl8187se: Fix spacing coding style in r8180_core.c
Date: Thu, 22 Nov 2012 09:06:50 +0900
Message-Id: <1353542810-21059-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353542753-20986-1-git-send-email-yamanetoshi@gmail.com>
References: <1353542753-20986-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
-ERROR: "foo * bar" should be "foo *bar"
-ERROR: "(foo*)" should be "(foo *)"

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 8c8b09d..3119fe6 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1699,7 +1699,7 @@ void rtl8180_prepare_beacon(struct net_device *dev)
  * descriptor in the ring buffer, copyes the frame in a TX buffer
  * and kicks the NIC to ensure it does the DMA transfer.
  */
-short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
+short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 		 short morefrag, short descfrag, int rate)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
@@ -2211,7 +2211,7 @@ void rtl8180_watch_dog(struct net_device *dev);
 
 void watch_dog_adaptive(unsigned long data)
 {
-	struct r8180_priv* priv = ieee80211_priv((struct net_device *)data);
+	struct r8180_priv *priv = ieee80211_priv((struct net_device *)data);
 
 	if (!priv->up) {
 		DMESG("<----watch_dog_adaptive():driver is not up!\n");
@@ -3462,7 +3462,7 @@ void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 		return ;
 	}
 
-	nicv = (u32 *)((nic - nicbegin) + (u8*)begin);
+	nicv = (u32 *)((nic - nicbegin) + (u8 *)begin);
 	if ((head <= tail && (nicv > tail || nicv < head)) ||
 		(head > tail && (nicv > tail && nicv < head))) {
 			DMESGW("nic has lost pointer");
-- 
1.7.9.5

