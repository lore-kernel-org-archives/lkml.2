Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0K1VCH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:02:07 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:37635 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab0K1VAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:12 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 11/13] w35und: Kill wblinux_f.h header
Date: Sun, 28 Nov 2010 23:00:06 +0200
Message-Id: <1290978008-29095-11-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wblinux_f.h header file doesn't contain anything that's actually used. Kill
it.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mds.c       |    1 -
 drivers/staging/winbond/wblinux_f.h |   17 -----------------
 drivers/staging/winbond/wbusb.c     |    1 -
 3 files changed, 0 insertions(+), 19 deletions(-)
 delete mode 100644 drivers/staging/winbond/wblinux_f.h

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 00e9756..9cfea94 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -1,7 +1,6 @@
 #include "mds_f.h"
 #include "mto.h"
 #include "wbhal.h"
-#include "wblinux_f.h"
 #include "wb35tx_f.h"
 
 unsigned char
diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
deleted file mode 100644
index 0a9d214..0000000
--- a/drivers/staging/winbond/wblinux_f.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef __WBLINUX_F_H
-#define __WBLINUX_F_H
-
-#include "core.h"
-#include "mds_s.h"
-
-/*
- * ====================================================================
- * Copyright (c) 1996-2004 Winbond Electronic Corporation
- *
- * wblinux_f.h
- * ====================================================================
- */
-int wb35_start_xmit(struct sk_buff *skb, struct net_device *netdev);
-void wb35_set_multicast(struct net_device *netdev);
-struct net_device_stats *wb35_netdev_stats(struct net_device *netdev);
-#endif
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index c5a3107..4f959c2 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -19,7 +19,6 @@
 #include "wb35reg_f.h"
 #include "wb35tx_f.h"
 #include "wb35rx_f.h"
-#include "wblinux_f.h"
 
 MODULE_DESCRIPTION("IS89C35 802.11bg WLAN USB Driver");
 MODULE_LICENSE("GPL");
-- 
1.7.0.4

