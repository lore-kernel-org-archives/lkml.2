Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031139Ab2K3RBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:01:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55829 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab2K3RBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:01:45 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 14/32] staging: wlags49_h2: wl_netdev.h: converts C99 // comments
Date: Fri, 30 Nov 2012 18:58:39 +0200
Message-Id: <1354294737-5735-14-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit converts C99 // comments to /* */

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_netdev.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.h b/drivers/staging/wlags49_h2/wl_netdev.h
index 61f040f..78a7057 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.h
+++ b/drivers/staging/wlags49_h2/wl_netdev.h
@@ -102,7 +102,7 @@ int wl_rx_dma( struct net_device *dev );
 void wl_multicast( struct net_device *dev );
 #else
 void wl_multicast( struct net_device *dev, int num_addrs, void *addrs );
-#endif // NEW_MULTICAST
+#endif /* NEW_MULTICAST */
 
 
 int wl_tx_port0( struct sk_buff *skb, struct net_device *dev );
@@ -151,4 +151,4 @@ void wl_wds_netif_carrier_off( struct wl_private *lp );
 #endif  /* USE_WDS */
 
 
-#endif  // __WL_NETDEV_H__
+#endif  /* __WL_NETDEV_H__ */
-- 
1.7.10.4

