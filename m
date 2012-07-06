Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab2GFP3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:29:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:43256 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757587Ab2GFP2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:28:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="189248936"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 4/6] staging: vt6655: use %pM for BSSID
Date: Fri,  6 Jul 2012 18:28:16 +0300
Message-Id: <1341588498-21689-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/vt6655/bssdb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index 1368e8c..f4f108f 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -142,9 +142,8 @@ BSSpSearchBSSList(
     unsigned int ii = 0;
 
     if (pbyDesireBSSID != NULL) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSSpSearchBSSList BSSID[%02X %02X %02X-%02X %02X %02X]\n",
-                            *pbyDesireBSSID,*(pbyDesireBSSID+1),*(pbyDesireBSSID+2),
-                            *(pbyDesireBSSID+3),*(pbyDesireBSSID+4),*(pbyDesireBSSID+5));
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
         if ((!is_broadcast_ether_addr(pbyDesireBSSID)) &&
 	     (memcmp(pbyDesireBSSID, ZeroBSSID, 6)!= 0)){
             pbyBSSID = pbyDesireBSSID;
-- 
1.7.10.4

