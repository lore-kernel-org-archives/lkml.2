Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031093Ab2K3RBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:01:22 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57515 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031052Ab2K3RBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:01:15 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 11/32] staging: wlags49_h2: wl_priv.h: fixes spacing around parentheses
Date: Fri, 30 Nov 2012 18:58:36 +0200
Message-Id: <1354294737-5735-11-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the incorrect spacing around parentheses.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_priv.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.h b/drivers/staging/wlags49_h2/wl_priv.h
index b647bfd..aa1128a 100644
--- a/drivers/staging/wlags49_h2/wl_priv.h
+++ b/drivers/staging/wlags49_h2/wl_priv.h
@@ -70,17 +70,17 @@
 #ifdef WIRELESS_EXT
 
 
-int wvlan_set_netname( struct net_device *,  struct iw_request_info *, union iwreq_data *, char *extra );
+int wvlan_set_netname(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
 
-int wvlan_get_netname( struct net_device *,  struct iw_request_info *, union iwreq_data *, char *extra );
+int wvlan_get_netname(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
 
-int wvlan_set_station_nickname( struct net_device *,  struct iw_request_info *, union iwreq_data *, char *extra );
+int wvlan_set_station_nickname(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
 
-int wvlan_get_station_nickname( struct net_device *,  struct iw_request_info *, union iwreq_data *, char *extra );
+int wvlan_get_station_nickname(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
 
-int wvlan_set_porttype( struct net_device *,  struct iw_request_info *, union iwreq_data *, char *extra );
+int wvlan_set_porttype(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
 
-int wvlan_get_porttype( struct net_device *,  struct iw_request_info *, union iwreq_data *, char *extra );
+int wvlan_get_porttype(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
 
 
 #endif  // WIRELESS_EXT
@@ -90,7 +90,7 @@ int wvlan_get_porttype( struct net_device *,  struct iw_request_info *, union iw
 
 #ifdef USE_UIL
 
-int wvlan_uil( struct uilreq *urq, struct wl_private *lp );
+int wvlan_uil(struct uilreq *urq, struct wl_private *lp);
 
 // int wvlan_uil_connect( struct uilreq *urq, struct wl_private *lp );
 // int wvlan_uil_disconnect( struct uilreq *urq, struct wl_private *lp );
@@ -109,11 +109,11 @@ int wvlan_uil( struct uilreq *urq, struct wl_private *lp );
 
 #ifdef USE_RTS
 
-int wvlan_rts( struct rtsreq *rrq, __u32 io_base );
-int wvlan_rts_read( __u16 reg, __u16 *val, __u32 io_base );
-int wvlan_rts_write( __u16 reg, __u16 val, __u32 io_base );
-int wvlan_rts_batch_read( struct rtsreq *rrq, __u32 io_base );
-int wvlan_rts_batch_write( struct rtsreq *rrq, __u32 io_base );
+int wvlan_rts(struct rtsreq *rrq, __u32 io_base);
+int wvlan_rts_read(__u16 reg, __u16 *val, __u32 io_base);
+int wvlan_rts_write(__u16 reg, __u16 val, __u32 io_base);
+int wvlan_rts_batch_read(struct rtsreq *rrq, __u32 io_base);
+int wvlan_rts_batch_write(struct rtsreq *rrq, __u32 io_base);
 
 #endif  // USE_RTS
 
-- 
1.7.10.4

