Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0KATuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:50:11 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:58682 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab0KATuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:50:09 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 2/2] w35und: Rename wbhal_s.h to wbhal.h
Date: Mon,  1 Nov 2010 21:50:06 +0200
Message-Id: <1288641006-30100-2-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288641006-30100-1-git-send-email-penberg@kernel.org>
References: <1288641006-30100-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the wbhal_s.h header file to wbhal.h now that it contains
both structure and function definitions.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/core.h                 |    2 +-
 drivers/staging/winbond/mds.c                  |    2 +-
 drivers/staging/winbond/mds_f.h                |    2 +-
 drivers/staging/winbond/mto.c                  |    2 +-
 drivers/staging/winbond/phy_calibration.c      |    2 +-
 drivers/staging/winbond/phy_calibration.h      |    2 +-
 drivers/staging/winbond/reg.c                  |    2 +-
 drivers/staging/winbond/wb35reg_f.h            |    2 +-
 drivers/staging/winbond/wb35rx_f.h             |    2 +-
 drivers/staging/winbond/{wbhal_s.h => wbhal.h} |    0
 drivers/staging/winbond/wbusb.c                |    2 +-
 11 files changed, 10 insertions(+), 10 deletions(-)
 rename drivers/staging/winbond/{wbhal_s.h => wbhal.h} (100%)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 2b87a00..d7b3aca 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -4,7 +4,7 @@
 #include <linux/wireless.h>
 #include <linux/types.h>
 
-#include "wbhal_s.h"
+#include "wbhal.h"
 #include "mto.h"
 
 #include "mac_structures.h"
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 2128e6e..9ac2c87 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -2,7 +2,7 @@
 #include "mlmetxrx_f.h"
 #include "mto.h"
 #include "sysdef.h"
-#include "wbhal_s.h"
+#include "wbhal.h"
 #include "wblinux_f.h"
 #include "wb35tx_f.h"
 
diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index 7f68dea..d902843 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -1,7 +1,7 @@
 #ifndef __WINBOND_MDS_F_H
 #define __WINBOND_MDS_F_H
 
-#include "wbhal_s.h"
+#include "wbhal.h"
 #include "core.h"
 
 unsigned char Mds_initial(struct wbsoft_priv *adapter);
diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index 05d1262..1faebce 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -19,7 +19,7 @@
 
 #include "sysdef.h"
 #include "sme_api.h"
-#include "wbhal_s.h"
+#include "wbhal.h"
 #include "wb35reg_f.h"
 #include "core.h"
 
diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 08cec74..0658b09 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -12,7 +12,7 @@
 /****************** INCLUDE FILES SECTION ***********************************/
 #include "sysdef.h"
 #include "phy_calibration.h"
-#include "wbhal_s.h"
+#include "wbhal.h"
 #include "wb35reg_f.h"
 #include "core.h"
 
diff --git a/drivers/staging/winbond/phy_calibration.h b/drivers/staging/winbond/phy_calibration.h
index 9fcdab1..84f6e84 100644
--- a/drivers/staging/winbond/phy_calibration.h
+++ b/drivers/staging/winbond/phy_calibration.h
@@ -1,7 +1,7 @@
 #ifndef __WINBOND_PHY_CALIBRATION_H
 #define __WINBOND_PHY_CALIBRATION_H
 
-#include "wbhal_s.h"
+#include "wbhal.h"
 
 #define REG_AGC_CTRL1		0x1000
 #define REG_AGC_CTRL2		0x1004
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 8df05c4..439d213 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1,5 +1,5 @@
 #include "sysdef.h"
-#include "wbhal_s.h"
+#include "wbhal.h"
 #include "wb35reg_f.h"
 #include "core.h"
 
diff --git a/drivers/staging/winbond/wb35reg_f.h b/drivers/staging/winbond/wb35reg_f.h
index bf23c10..95dc980 100644
--- a/drivers/staging/winbond/wb35reg_f.h
+++ b/drivers/staging/winbond/wb35reg_f.h
@@ -1,7 +1,7 @@
 #ifndef __WINBOND_WB35REG_F_H
 #define __WINBOND_WB35REG_F_H
 
-#include "wbhal_s.h"
+#include "wbhal.h"
 
 /*
  * ====================================
diff --git a/drivers/staging/winbond/wb35rx_f.h b/drivers/staging/winbond/wb35rx_f.h
index 98acce5..1fdf65e 100644
--- a/drivers/staging/winbond/wb35rx_f.h
+++ b/drivers/staging/winbond/wb35rx_f.h
@@ -2,7 +2,7 @@
 #define __WINBOND_WB35RX_F_H
 
 #include <net/mac80211.h>
-#include "wbhal_s.h"
+#include "wbhal.h"
 
 //====================================
 // Interface function declare
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal.h
similarity index 100%
rename from drivers/staging/winbond/wbhal_s.h
rename to drivers/staging/winbond/wbhal.h
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index a053bbb..df055ab 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -16,7 +16,7 @@
 #include "mds_f.h"
 #include "mlmetxrx_f.h"
 #include "mto.h"
-#include "wbhal_s.h"
+#include "wbhal.h"
 #include "wb35reg_f.h"
 #include "wb35tx_f.h"
 #include "wb35rx_f.h"
-- 
1.7.0.4

