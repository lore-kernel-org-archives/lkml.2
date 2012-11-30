Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031109Ab2K3RB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:01:29 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46718 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031052Ab2K3RBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:01:24 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 12/32] staging: wlags49_h2: wl_priv.h: converts C99 // comments
Date: Fri, 30 Nov 2012 18:58:37 +0200
Message-Id: <1354294737-5735-12-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit converts C99 // comments to /* */

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_priv.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.h b/drivers/staging/wlags49_h2/wl_priv.h
index aa1128a..daefc6c 100644
--- a/drivers/staging/wlags49_h2/wl_priv.h
+++ b/drivers/staging/wlags49_h2/wl_priv.h
@@ -83,7 +83,7 @@ int wvlan_set_porttype(struct net_device *, struct iw_request_info *, union iwre
 int wvlan_get_porttype(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
 
 
-#endif  // WIRELESS_EXT
+#endif  /* WIRELESS_EXT */
 
 
 
@@ -92,19 +92,19 @@ int wvlan_get_porttype(struct net_device *, struct iw_request_info *, union iwre
 
 int wvlan_uil(struct uilreq *urq, struct wl_private *lp);
 
-// int wvlan_uil_connect( struct uilreq *urq, struct wl_private *lp );
-// int wvlan_uil_disconnect( struct uilreq *urq, struct wl_private *lp );
-// int wvlan_uil_action( struct uilreq *urq, struct wl_private *lp );
-// int wvlan_uil_block( struct uilreq *urq, struct wl_private *lp );
-// int wvlan_uil_unblock( struct uilreq *urq, struct wl_private *lp );
-// int wvlan_uil_send_diag_msg( struct uilreq *urq, struct wl_private *lp );
-// int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp );
-// int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp );
+/* int wvlan_uil_connect( struct uilreq *urq, struct wl_private *lp ); */
+/* int wvlan_uil_disconnect( struct uilreq *urq, struct wl_private *lp ); */
+/* int wvlan_uil_action( struct uilreq *urq, struct wl_private *lp ); */
+/* int wvlan_uil_block( struct uilreq *urq, struct wl_private *lp ); */
+/* int wvlan_uil_unblock( struct uilreq *urq, struct wl_private *lp ); */
+/* int wvlan_uil_send_diag_msg( struct uilreq *urq, struct wl_private *lp ); */
+/* int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp ); */
+/* int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp ); */
 
-//int cfg_driver_info( struct uilreq *urq, struct wl_private *lp );
-//int cfg_driver_identity( struct uilreq *urq, struct wl_private *lp );
+/* int cfg_driver_info( struct uilreq *urq, struct wl_private *lp ); */
+/* int cfg_driver_identity( struct uilreq *urq, struct wl_private *lp ); */
 
-#endif  // USE_UIL
+#endif  /* USE_UIL */
 
 
 #ifdef USE_RTS
@@ -115,7 +115,7 @@ int wvlan_rts_write(__u16 reg, __u16 val, __u32 io_base);
 int wvlan_rts_batch_read(struct rtsreq *rrq, __u32 io_base);
 int wvlan_rts_batch_write(struct rtsreq *rrq, __u32 io_base);
 
-#endif  // USE_RTS
+#endif  /* USE_RTS */
 
 
-#endif  // __WL_PRIV_H__
+#endif  /* __WL_PRIV_H__ */
-- 
1.7.10.4

