Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150Ab0FKKRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:17:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37014 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043Ab0FKKRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:17:15 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/10] staging/trivial: fix typos concerning "management"
Date: Fri, 11 Jun 2010 12:17:04 +0200
Message-Id: <1276251424-12806-10-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100611101624.GD10894@pengutronix.de>
References: <20100611101624.GD10894@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/staging/vt6655/80211mgr.h |    2 +-
 drivers/staging/vt6656/80211mgr.c |    2 +-
 drivers/staging/vt6656/80211mgr.h |    2 +-
 drivers/staging/vt6656/power.c    |    2 +-
 drivers/staging/vt6656/power.h    |    2 +-
 drivers/staging/vt6656/wmgr.h     |    4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6655/80211mgr.h b/drivers/staging/vt6655/80211mgr.h
index 658fe14..1f7b863 100644
--- a/drivers/staging/vt6655/80211mgr.h
+++ b/drivers/staging/vt6655/80211mgr.h
@@ -19,7 +19,7 @@
  *
  * File: 80211mgr.h
  *
- * Purpose: 802.11 managment frames pre-defines.
+ * Purpose: 802.11 management frames pre-defines.
  *
  *
  * Author: Lyndon Chen
diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
index f24dc55..5fc96a1 100644
--- a/drivers/staging/vt6656/80211mgr.c
+++ b/drivers/staging/vt6656/80211mgr.c
@@ -18,7 +18,7 @@
  *
  * File: 80211mgr.c
  *
- * Purpose: Handles the 802.11 managment support functions
+ * Purpose: Handles the 802.11 management support functions
  *
  * Author: Lyndon Chen
  *
diff --git a/drivers/staging/vt6656/80211mgr.h b/drivers/staging/vt6656/80211mgr.h
index c140a95..2139839 100644
--- a/drivers/staging/vt6656/80211mgr.h
+++ b/drivers/staging/vt6656/80211mgr.h
@@ -19,7 +19,7 @@
  *
  * File: 80211mgr.h
  *
- * Purpose: 802.11 managment frames pre-defines.
+ * Purpose: 802.11 management frames pre-defines.
  *
  *
  * Author: Lyndon Chen
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 766c5be..5ff15bf 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -19,7 +19,7 @@
  *
  * File: power.c
  *
- * Purpose: Handles 802.11 power managment  functions
+ * Purpose: Handles 802.11 power management  functions
  *
  * Author: Lyndon Chen
  *
diff --git a/drivers/staging/vt6656/power.h b/drivers/staging/vt6656/power.h
index 50792bb..41bffe5 100644
--- a/drivers/staging/vt6656/power.h
+++ b/drivers/staging/vt6656/power.h
@@ -18,7 +18,7 @@
  *
  * File: power.h
  *
- * Purpose: Handles 802.11 power managment  functions
+ * Purpose: Handles 802.11 power management  functions
  *
  * Author: Lyndon Chen
  *
diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index 1e5b916..5a890e8 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -343,11 +343,11 @@ typedef struct tagSMgmtObject
     BOOL                    bRxBeaconInTBTTWake;
     BYTE                    abyPSTxMap[MAX_NODE_NUM + 1];
 
-    // managment command related
+    // management command related
     unsigned int                    uCmdBusy;
     unsigned int                    uCmdHostAPBusy;
 
-    // managment packet pool
+    // management packet pool
     PBYTE                   pbyMgmtPacketPool;
     BYTE                    byMgmtPacketPool[sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN];
 
-- 
1.7.1

