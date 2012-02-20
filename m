Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2BTOch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:32:37 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:52577
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2BTOcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:32:36 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/2] [trivial] staging: Fix typo in bssdb.c
Date: Mon, 20 Feb 2012 23:31:31 +0900
Message-Id: <1329748291-1768-3-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329748291-1768-1-git-send-email-standby24x7@gmail.com>
References: <1329748291-1768-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "scaning" to "scanning" in
drivers/staging/vt6656/bssdb.c
drivers/staging/vt6655/bssdb.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/vt6655/bssdb.c |    4 ++--
 drivers/staging/vt6656/bssdb.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index 577599e..1368e8c 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -1327,13 +1327,13 @@ start:
     }
 
     if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
-        // if adhoc started which essid is NULL string, rescaning.
+        // if adhoc started which essid is NULL string, rescanning.
         if ((pMgmt->eCurrState == WMAC_STATE_STARTED) && (pCurrSSID->len == 0)) {
             if (pDevice->uAutoReConnectTime < 10) {
                 pDevice->uAutoReConnectTime++;
             }
             else {
-                DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Adhoc re-scaning ...\n");
+                DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Adhoc re-scanning ...\n");
 	      pMgmt->eScanType = WMAC_SCAN_ACTIVE;
                 bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
                 bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 32c67ed..619c257 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -1195,13 +1195,13 @@ else {
     }
 
     if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
-        // if adhoc started which essid is NULL string, rescaning.
+        // if adhoc started which essid is NULL string, rescanning.
         if ((pMgmt->eCurrState == WMAC_STATE_STARTED) && (pCurrSSID->len == 0)) {
             if (pDevice->uAutoReConnectTime < 10) {
                 pDevice->uAutoReConnectTime++;
             }
             else {
-                DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Adhoc re-scaning ...\n");
+                DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Adhoc re-scanning ...\n");
 	       pMgmt->eScanType = WMAC_SCAN_ACTIVE;
 		bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 		bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
-- 
1.7.6.5

