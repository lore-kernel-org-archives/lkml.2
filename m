Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1LBCBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:01:13 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33454 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1LBCBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:01:12 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org
Subject: [PATCH 2/5] staging: vt6656: datarate.c: General cleanup
Date: Fri,  2 Dec 2011 00:00:44 +0000
Message-Id: <1322784044-19729-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some blank lines, and commented some. Also removes a
return statement at the end of a void function.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/datarate.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
index 58ca0d4..16d5668 100644
--- a/drivers/staging/vt6656/datarate.c
+++ b/drivers/staging/vt6656/datarate.c
@@ -44,17 +44,6 @@
 #include "srom.h"
 #include "rf.h"
 
-/*---------------------  Static Definitions -------------------------*/
-
-
-
-
-/*---------------------  Static Classes  ----------------------------*/
-
-
-
-/*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =MSG_LEVEL_INFO;
 const BYTE acbyIERate[MAX_RATE] =
 {0x02, 0x04, 0x0B, 0x16, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
@@ -63,8 +52,6 @@ const BYTE acbyIERate[MAX_RATE] =
 #define AUTORATE_TXFAIL_CNT     0x0064
 #define AUTORATE_TIMEOUT        10
 
-/*---------------------  Static Functions  --------------------------*/
-
 void s_vResetCounter(PKnownNodeDB psNodeDBTable);
 
 void s_vResetCounter(PKnownNodeDB psNodeDBTable)
@@ -73,12 +60,6 @@ void s_vResetCounter(PKnownNodeDB psNodeDBTable)
     memset(psNodeDBTable->uTxFail, 0, sizeof(psNodeDBTable->uTxFail));
 }
 
-/*---------------------  Export Variables  --------------------------*/
-
-
-/*---------------------  Export Functions  --------------------------*/
-
-
 /*+
  *
  * Description:
@@ -110,8 +91,6 @@ DATARATEbyGetRateIdx (
     return 0;
 }
 
-
-
 /*+
  *
  * Routine Description:
@@ -130,9 +109,6 @@ DATARATEbyGetRateIdx (
 #define AUTORATE_TXCNT_THRESHOLD        20
 #define AUTORATE_INC_THRESHOLD          30
 
-
-
-
 /*+
  *
  * Description:
@@ -255,7 +231,6 @@ unsigned int  uRateLen;
             if (byRate > byHighSuppRate)
                 byHighSuppRate = byRate;
             *pwSuppRate |= (1<<RATEwGetRateIdx(byRate));
-            //DBG_PRN_GRP09(("ParseMaxRate : HighSuppRate: %d, %X\n", RATEwGetRateIdx(byRate), byRate));
         }
     } //if(pItemExtRates != NULL)
 
@@ -277,7 +252,6 @@ unsigned int  uRateLen;
      DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Exit ParseMaxRate\n");
 }
 
-
 /*+
  *
  * Routine Description:
@@ -382,7 +356,6 @@ DWORD           dwTxDiff = 0;
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"uTxOk[MAX_RATE] %d, uTxFail[MAX_RATE]:%d\n",(int)psNodeDBTable->uTxOk[MAX_RATE], (int)psNodeDBTable->uTxFail[MAX_RATE]);
     s_vResetCounter(psNodeDBTable);
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Rate: %d, U:%d, D:%d\n", (int)psNodeDBTable->wTxDataRate, (int)wIdxUpRate, (int)wIdxDownRate);
-    return;
 }
 
 /*+
-- 
1.7.4.4

