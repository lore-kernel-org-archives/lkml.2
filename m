Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0K1VBa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:01:30 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:37403 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab0K1VAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:13 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 06/13] w35und: Remove empty sysdef.h header
Date: Sun, 28 Nov 2010 23:00:01 +0200
Message-Id: <1290978008-29095-6-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysdef.h header is empty now so kill it.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mds.c             |    1 -
 drivers/staging/winbond/mlmetxrx.c        |    2 --
 drivers/staging/winbond/mto.c             |    1 -
 drivers/staging/winbond/phy_calibration.c |    1 -
 drivers/staging/winbond/reg.c             |    1 -
 drivers/staging/winbond/sysdef.h          |    6 ------
 drivers/staging/winbond/wb35reg.c         |    1 -
 drivers/staging/winbond/wb35rx.c          |    1 -
 drivers/staging/winbond/wb35tx.c          |    1 -
 9 files changed, 0 insertions(+), 15 deletions(-)
 delete mode 100644 drivers/staging/winbond/sysdef.h

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 8ae3d84..b4e0514 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -1,7 +1,6 @@
 #include "mds_f.h"
 #include "mlmetxrx_f.h"
 #include "mto.h"
-#include "sysdef.h"
 #include "wbhal.h"
 #include "wblinux_f.h"
 #include "wb35tx_f.h"
diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
index 7425a23..87f339f 100644
--- a/drivers/staging/winbond/mlmetxrx.c
+++ b/drivers/staging/winbond/mlmetxrx.c
@@ -15,8 +15,6 @@
 
   Copyright (c) 1996-2002 Winbond Electronics Corp. All Rights Reserved.
 ============================================================================ */
-#include "sysdef.h"
-
 #include "mds_f.h"
 
 void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *desc)
diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index 1faebce..c03e501 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -17,7 +17,6 @@
  * ============================================================================
  */
 
-#include "sysdef.h"
 #include "sme_api.h"
 #include "wbhal.h"
 #include "wb35reg_f.h"
diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 0658b09..09844db 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -10,7 +10,6 @@
  */
 
 /****************** INCLUDE FILES SECTION ***********************************/
-#include "sysdef.h"
 #include "phy_calibration.h"
 #include "wbhal.h"
 #include "wb35reg_f.h"
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index dcd7560..4d2c6a1 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1,4 +1,3 @@
-#include "sysdef.h"
 #include "wbhal.h"
 #include "wb35reg_f.h"
 #include "core.h"
diff --git a/drivers/staging/winbond/sysdef.h b/drivers/staging/winbond/sysdef.h
deleted file mode 100644
index 04e6e8f..0000000
--- a/drivers/staging/winbond/sysdef.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/*  Winbond WLAN System Configuration defines */
-
-#ifndef SYS_DEF_H
-#define SYS_DEF_H
-
-#endif
diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index f33f4f8..a15de1e 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -1,4 +1,3 @@
-#include "sysdef.h"
 #include "wb35reg_f.h"
 
 #include <linux/usb.h>
diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index 0255728..190758e 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 
 #include "core.h"
-#include "sysdef.h"
 #include "wb35rx_f.h"
 
 static void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int PacketSize)
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 8f0d527..5e9e21a 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -13,7 +13,6 @@
 
 #include "wb35tx_f.h"
 #include "mds_f.h"
-#include "sysdef.h"
 
 unsigned char
 Wb35Tx_get_tx_buffer(struct hw_data * pHwData, u8 **pBuffer)
-- 
1.7.0.4

