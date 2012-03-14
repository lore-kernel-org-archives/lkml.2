Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640Ab2CNW26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:28:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43716 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2CNW2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:28:50 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 1/3] Staging: rtl8187se: r8180_core.c: Removed trailing spaces
Date: Wed, 14 Mar 2012 18:26:57 -0400
Message-Id: <1331764019-5808-2-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331764019-5808-1-git-send-email-amiller@amilx.com>
References: <1331764019-5808-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up some trailing spaces

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_core.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index e6e39c8..d1a3e65 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1619,9 +1619,9 @@ void rtl8180_rx(struct net_device *dev)
 		    !bHwError && !bCRC && !bICV &&
 		    eqMacAddr(priv->ieee80211->current_network.bssid,
 		    	fc & IEEE80211_FCTL_TODS ? hdr->addr1 :
-		    	fc & IEEE80211_FCTL_FROMDS ? hdr->addr2 : 
+		    	fc & IEEE80211_FCTL_FROMDS ? hdr->addr2 :
 		    	hdr->addr3)) {
-				 
+
 			/* Perform signal smoothing for dynamic
 			 * mechanism on demand. This is different
 			 * with PerformSignalSmoothing8185 in smoothing
@@ -1658,7 +1658,7 @@ void rtl8180_rx(struct net_device *dev)
 			}
 			/* support for prism header has been originally added by Christian */
 			if (priv->prism_hdr && priv->ieee80211->iw_mode == IW_MODE_MONITOR) {
-				
+
 			} else {
 				priv->rx_skb = dev_alloc_skb(len+2);
 				if (!priv->rx_skb)
@@ -1770,7 +1770,7 @@ void rtl8180_data_hard_resume(struct net_device *dev)
 	rtl8180_set_mode(dev, EPROM_CMD_NORMAL);
 }
 
-/* 
+/*
  * This function TX data frames when the ieee80211 stack requires this.
  * It checks also if we need to stop the ieee tx queue, eventually do it
  */
@@ -1814,7 +1814,7 @@ rate) {
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 }
 
-/* 
+/*
  * This is a rough attempt to TX a frame
  * This is called by the ieee 80211 stack to TX management frames.
  * If the ring is full packet are dropped (for data frame the queue
@@ -1920,7 +1920,7 @@ void rtl8180_prepare_beacon(struct net_device *dev)
 	}
 }
 
-/* 
+/*
  * This function do the real dirty work: it enqueues a TX command
  * descriptor in the ring buffer, copyes the frame in a TX buffer
  * and kicks the NIC to ensure it does the DMA transfer.
@@ -2188,7 +2188,7 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 			priv->txhpbufstail = buflist;
 			break;
 		case BEACON_PRIORITY:
-			/* 
+			/*
 			 * The HW seems to be happy with the 1st
 			 * descriptor filled and the 2nd empty...
 			 * So always update descriptor 1 and never
@@ -2308,13 +2308,13 @@ void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 
 	spin_lock_irqsave(&priv->ps_lock, flags);
 
-	/* 
+	/*
 	 * Writing HW register with 0 equals to disable
 	 * the timer, that is not really what we want
 	 */
 	tl -= MSECS(4+16+7);
 
-	/* 
+	/*
 	 * If the interval in witch we are requested to sleep is too
 	 * short then give up and remain awake
 	 */
@@ -2332,7 +2332,7 @@ void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 
 		queue_delayed_work(priv->ieee80211->wq, &priv->ieee80211->hw_wakeup_wq, tmp); /* as tl may be less than rb */
 	}
-	/* 
+	/*
 	 * If we suspect the TimerInt is gone beyond tl
 	 * while setting it, then give up
 	 */
@@ -3172,7 +3172,7 @@ void rtl8180_adapter_start(struct net_device *dev)
 	netif_start_queue(dev);
 }
 
-/* 
+/*
  * This configures registers for beacon tx and enables it via
  * rtl8180_beacon_tx_enable(). rtl8180_beacon_tx_disable() might
  * be used to stop beacon transmission
@@ -3843,7 +3843,7 @@ void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 			return;
 		}
 
-	/* 
+	/*
 	 * We check all the descriptors between the head and the nic,
 	 * but not the currently pointed by the nic (the next to be txed)
 	 * and the previous of the pointed (might be in process ??)
@@ -3881,7 +3881,7 @@ void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 			head += 8;
 	}
 
-	/* 
+	/*
 	 * The head has been moved to the last certainly TXed
 	 * (or at least processed by the nic) packet.
 	 * The driver take forcefully owning of all these packets
-- 
1.7.7.6

