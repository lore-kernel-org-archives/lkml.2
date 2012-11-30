Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2K3RJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:09:40 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48751 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab2K3RJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:09:38 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 13/32] staging: wlags49_h2: wl_priv.h: fixes instances of 80+ char lines
Date: Fri, 30 Nov 2012 18:58:38 +0200
Message-Id: <1354294737-5735-13-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit corrects cases where lines where longer than 80
characters.  checkpatch.pl now reports that this file has no further
issues.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_priv.h |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.h b/drivers/staging/wlags49_h2/wl_priv.h
index daefc6c..f35e794 100644
--- a/drivers/staging/wlags49_h2/wl_priv.h
+++ b/drivers/staging/wlags49_h2/wl_priv.h
@@ -70,17 +70,23 @@
 #ifdef WIRELESS_EXT
 
 
-int wvlan_set_netname(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
+int wvlan_set_netname(struct net_device *, struct iw_request_info *,
+		      union iwreq_data *, char *extra);
 
-int wvlan_get_netname(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
+int wvlan_get_netname(struct net_device *, struct iw_request_info *,
+		      union iwreq_data *, char *extra);
 
-int wvlan_set_station_nickname(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
+int wvlan_set_station_nickname(struct net_device *, struct iw_request_info *,
+			       union iwreq_data *, char *extra);
 
-int wvlan_get_station_nickname(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
+int wvlan_get_station_nickname(struct net_device *, struct iw_request_info *,
+			       union iwreq_data *, char *extra);
 
-int wvlan_set_porttype(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
+int wvlan_set_porttype(struct net_device *, struct iw_request_info *,
+		       union iwreq_data *, char *extra);
 
-int wvlan_get_porttype(struct net_device *, struct iw_request_info *, union iwreq_data *, char *extra);
+int wvlan_get_porttype(struct net_device *, struct iw_request_info *,
+		       union iwreq_data *, char *extra);
 
 
 #endif  /* WIRELESS_EXT */
-- 
1.7.10.4

