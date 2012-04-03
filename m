Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2DCRiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:38:52 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:57392 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab2DCRiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:38:51 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: pe1dnn@amsat.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: Fix typo in wlags49_h2
Date: Wed,  4 Apr 2012 02:38:44 +0900
Message-Id: <1333474724-11717-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.rc3.11.gd8282
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spellings within wlags49_h2

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/wlags49_h2/README.ubuntu |    2 +-
 drivers/staging/wlags49_h2/wl_netdev.c   |    2 +-
 drivers/staging/wlags49_h2/wl_profile.c  |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wlags49_h2/README.ubuntu b/drivers/staging/wlags49_h2/README.ubuntu
index edee8b9..5f1cfb8 100644
--- a/drivers/staging/wlags49_h2/README.ubuntu
+++ b/drivers/staging/wlags49_h2/README.ubuntu
@@ -87,7 +87,7 @@ The linux driver files (wl_xxxx.c) are changed in the following ways:
 -- Recovery actions added
 
 The major problem was the order in which calls can be made. The original
-looks like a traditonal UNIX driver. To call an "ioctl" function you
+looks like a traditional UNIX driver. To call an "ioctl" function you
 have to "open" the device first to get a handle and after "close" no
 "ioctl" function can be called anymore. With the 2.6 driver this all
 changed; the former ioctl functions are now called before "open" and
diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index 90820ff..1e26f08 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -1063,7 +1063,7 @@ void wl_multicast( struct net_device *dev )
 #if DBG
     if( DBG_FLAGS( DbgInfo ) & DBG_PARAM_ON ) {
         DBG_PRINT("  flags: %s%s%s\n",
-            ( dev->flags & IFF_PROMISC ) ? "Promiscous " : "",
+            ( dev->flags & IFF_PROMISC ) ? "Promiscuous " : "",
             ( dev->flags & IFF_MULTICAST ) ? "Multicast " : "",
             ( dev->flags & IFF_ALLMULTI ) ? "All-Multicast" : "" );
 
diff --git a/drivers/staging/wlags49_h2/wl_profile.c b/drivers/staging/wlags49_h2/wl_profile.c
index b8c96cf..0e49272 100644
--- a/drivers/staging/wlags49_h2/wl_profile.c
+++ b/drivers/staging/wlags49_h2/wl_profile.c
@@ -401,7 +401,7 @@ void translate_option(char *buffer, struct wl_private *lp)
 		if ((value_convert >= PARM_MIN_BRSC) || (value_convert <= PARM_MAX_BRSC))
 			lp->brsc[0] = value_convert;
 		else
-			DBG_WARNING(DbgInfo, "%s invaid; will be ignored\n", PARM_NAME_BRSC_2GHZ);
+			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_BRSC_2GHZ);
 	} else if (strcmp(key, PARM_NAME_BRSC_5GHZ) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_BRSC_5GHZ, value);
 
@@ -409,7 +409,7 @@ void translate_option(char *buffer, struct wl_private *lp)
 		if ((value_convert >= PARM_MIN_BRSC) || (value_convert <= PARM_MAX_BRSC))
 			lp->brsc[1] = value_convert;
 		else
-			DBG_WARNING(DbgInfo, "%s invaid; will be ignored\n", PARM_NAME_BRSC_5GHZ);
+			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_BRSC_5GHZ);
 	} else if ((strcmp(key, PARM_NAME_DESIRED_SSID) == 0) || (strcmp(key, PARM_NAME_OWN_SSID) == 0)) {
 		DBG_TRACE(DbgInfo, "SSID, value: %s\n", value);
 
@@ -556,7 +556,7 @@ void translate_option(char *buffer, struct wl_private *lp)
 		if ((value_convert >= PARM_MIN_SRSC) || (value_convert <= PARM_MAX_SRSC))
 			lp->srsc[0] = value_convert;
 		else
-			DBG_WARNING(DbgInfo, "%s invaid; will be ignored\n", PARM_NAME_SRSC_2GHZ);
+			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_SRSC_2GHZ);
 	} else if (strcmp(key, PARM_NAME_SRSC_5GHZ) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_SRSC_5GHZ, value);
 
@@ -564,7 +564,7 @@ void translate_option(char *buffer, struct wl_private *lp)
 		if ((value_convert >= PARM_MIN_SRSC) || (value_convert <= PARM_MAX_SRSC))
 			lp->srsc[1] = value_convert;
 		else
-			DBG_WARNING(DbgInfo, "%s invaid; will be ignored\n", PARM_NAME_SRSC_5GHZ);
+			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_SRSC_5GHZ);
 	} else if (strcmp(key, PARM_NAME_SYSTEM_SCALE) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_SYSTEM_SCALE, value);
 
-- 
1.7.10.rc3.11.gd8282

