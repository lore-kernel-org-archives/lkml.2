Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031153Ab2K3RB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:01:59 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45959 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab2K3RB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:01:56 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 15/32] staging: wlags49_h2: wl_netdev.h: sorts out spacing issues
Date: Fri, 30 Nov 2012 18:58:40 +0200
Message-Id: <1354294737-5735-15-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes issues regarding spacing around parentheses. The
checkpatch.pl tool reports that this file has no further styling
issues.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_netdev.h |   90 ++++++++++++++++----------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.h b/drivers/staging/wlags49_h2/wl_netdev.h
index 78a7057..95bfbeb 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.h
+++ b/drivers/staging/wlags49_h2/wl_netdev.h
@@ -68,85 +68,85 @@
 /*******************************************************************************
  *  function prototypes
  ******************************************************************************/
-int wl_init( struct net_device *dev );
+int wl_init(struct net_device *dev);
 
-int wl_config( struct net_device *dev, struct ifmap *map );
+int wl_config(struct net_device *dev, struct ifmap *map);
 
-struct net_device *wl_device_alloc( void );
+struct net_device *wl_device_alloc(void);
 
-void wl_device_dealloc( struct net_device *dev );
+void wl_device_dealloc(struct net_device *dev);
 
-int wl_open( struct net_device *dev );
+int wl_open(struct net_device *dev);
 
-int wl_close( struct net_device *dev );
+int wl_close(struct net_device *dev);
 
-int wl_ioctl( struct net_device *dev, struct ifreq *rq, int cmd );
+int wl_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 
-int wl_tx( struct sk_buff *skb, struct net_device *dev, int port );
+int wl_tx(struct sk_buff *skb, struct net_device *dev, int port);
 
-int wl_send( struct wl_private *lp );
+int wl_send(struct wl_private *lp);
 
-int wl_rx( struct net_device *dev );
+int wl_rx(struct net_device *dev);
 
-void wl_tx_timeout( struct net_device *dev );
+void wl_tx_timeout(struct net_device *dev);
 
-struct net_device_stats *wl_stats( struct net_device *dev );
+struct net_device_stats *wl_stats(struct net_device *dev);
 
 
 #ifdef ENABLE_DMA
-int wl_send_dma( struct wl_private *lp, struct sk_buff *skb, int port );
-int wl_rx_dma( struct net_device *dev );
+int wl_send_dma(struct wl_private *lp, struct sk_buff *skb, int port);
+int wl_rx_dma(struct net_device *dev);
 #endif
 
 #ifdef NEW_MULTICAST
-void wl_multicast( struct net_device *dev );
+void wl_multicast(struct net_device *dev);
 #else
-void wl_multicast( struct net_device *dev, int num_addrs, void *addrs );
+void wl_multicast(struct net_device *dev, int num_addrs, void *addrs);
 #endif /* NEW_MULTICAST */
 
 
-int wl_tx_port0( struct sk_buff *skb, struct net_device *dev );
+int wl_tx_port0(struct sk_buff *skb, struct net_device *dev);
 
 
 #ifdef USE_WDS
 
-int wl_tx_port1( struct sk_buff *skb, struct net_device *dev );
-int wl_tx_port2( struct sk_buff *skb, struct net_device *dev );
-int wl_tx_port3( struct sk_buff *skb, struct net_device *dev );
-int wl_tx_port4( struct sk_buff *skb, struct net_device *dev );
-int wl_tx_port5( struct sk_buff *skb, struct net_device *dev );
-int wl_tx_port6( struct sk_buff *skb, struct net_device *dev );
-
-void wl_wds_device_alloc( struct wl_private *lp );
-void wl_wds_device_dealloc( struct wl_private *lp );
-void wl_wds_netif_start_queue( struct wl_private *lp );
-void wl_wds_netif_stop_queue( struct wl_private *lp );
-void wl_wds_netif_wake_queue( struct wl_private *lp );
-void wl_wds_netif_carrier_on( struct wl_private *lp );
-void wl_wds_netif_carrier_off( struct wl_private *lp );
+int wl_tx_port1(struct sk_buff *skb, struct net_device *dev);
+int wl_tx_port2(struct sk_buff *skb, struct net_device *dev);
+int wl_tx_port3(struct sk_buff *skb, struct net_device *dev);
+int wl_tx_port4(struct sk_buff *skb, struct net_device *dev);
+int wl_tx_port5(struct sk_buff *skb, struct net_device *dev);
+int wl_tx_port6(struct sk_buff *skb, struct net_device *dev);
+
+void wl_wds_device_alloc(struct wl_private *lp);
+void wl_wds_device_dealloc(struct wl_private *lp);
+void wl_wds_netif_start_queue(struct wl_private *lp);
+void wl_wds_netif_stop_queue(struct wl_private *lp);
+void wl_wds_netif_wake_queue(struct wl_private *lp);
+void wl_wds_netif_carrier_on(struct wl_private *lp);
+void wl_wds_netif_carrier_off(struct wl_private *lp);
 
 #endif  /* USE_WDS */
 
 
 #ifdef USE_WDS
 
-#define WL_WDS_DEVICE_ALLOC( ARG )      wl_wds_device_alloc( ARG )
-#define WL_WDS_DEVICE_DEALLOC( ARG )    wl_wds_device_dealloc( ARG )
-#define WL_WDS_NETIF_START_QUEUE( ARG ) wl_wds_netif_start_queue( ARG )
-#define WL_WDS_NETIF_STOP_QUEUE( ARG )  wl_wds_netif_stop_queue( ARG )
-#define WL_WDS_NETIF_WAKE_QUEUE( ARG )  wl_wds_netif_wake_queue( ARG )
-#define WL_WDS_NETIF_CARRIER_ON( ARG )  wl_wds_netif_carrier_on( ARG )
-#define WL_WDS_NETIF_CARRIER_OFF( ARG ) wl_wds_netif_carrier_off( ARG )
+#define WL_WDS_DEVICE_ALLOC(ARG)      wl_wds_device_alloc(ARG)
+#define WL_WDS_DEVICE_DEALLOC(ARG)    wl_wds_device_dealloc(ARG)
+#define WL_WDS_NETIF_START_QUEUE(ARG) wl_wds_netif_start_queue(ARG)
+#define WL_WDS_NETIF_STOP_QUEUE(ARG)  wl_wds_netif_stop_queue(ARG)
+#define WL_WDS_NETIF_WAKE_QUEUE(ARG)  wl_wds_netif_wake_queue(ARG)
+#define WL_WDS_NETIF_CARRIER_ON(ARG)  wl_wds_netif_carrier_on(ARG)
+#define WL_WDS_NETIF_CARRIER_OFF(ARG) wl_wds_netif_carrier_off(ARG)
 
 #else
 
-#define WL_WDS_DEVICE_ALLOC( ARG )
-#define WL_WDS_DEVICE_DEALLOC( ARG )
-#define WL_WDS_NETIF_START_QUEUE( ARG )
-#define WL_WDS_NETIF_STOP_QUEUE( ARG )
-#define WL_WDS_NETIF_WAKE_QUEUE( ARG )
-#define WL_WDS_NETIF_CARRIER_ON( ARG )
-#define WL_WDS_NETIF_CARRIER_OFF( ARG )
+#define WL_WDS_DEVICE_ALLOC(ARG)
+#define WL_WDS_DEVICE_DEALLOC(ARG)
+#define WL_WDS_NETIF_START_QUEUE(ARG)
+#define WL_WDS_NETIF_STOP_QUEUE(ARG)
+#define WL_WDS_NETIF_WAKE_QUEUE(ARG)
+#define WL_WDS_NETIF_CARRIER_ON(ARG)
+#define WL_WDS_NETIF_CARRIER_OFF(ARG)
 
 #endif  /* USE_WDS */
 
-- 
1.7.10.4

