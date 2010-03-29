Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab0C2Lkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:40:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59507 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0C2Lkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=el1uhT/H1sJtWWdX9QC9roASSy4xKM4vxaMAwAC6AjIZkuuKifY/Wbhk7xzuCOOoVe
         4SKrnuguiDMBOKT8JkbrIxJzsZPXgjVvo/kpCIt7m2qaTVE0/sxidXJ4NK8pgAp31lTv
         pUY22Ru3lwKAb3FrifT9jC6SDgfUao7aWBIqo=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 5/5] staging: vt6656: control.c: Fixed coding style issues
Date: Mon, 29 Mar 2010 22:40:54 +1100
Message-Id: <1269862854-16487-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced lots of spaces by real tabs and fixed some 80+ lines.
Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/vt6656/control.c |   87 ++++++++++++++++---------------------
 1 files changed, 38 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/vt6656/control.c b/drivers/staging/vt6656/control.c
index 7dba771..8aab671 100644
--- a/drivers/staging/vt6656/control.c
+++ b/drivers/staging/vt6656/control.c
@@ -30,11 +30,13 @@
  *      CONTROLnsRequestIn - Read variable length bytes from MEM/BB/MAC/EEPROM
  *      ControlvWriteByte - Write one byte to MEM/BB/MAC/EEPROM
  *      ControlvReadByte - Read one byte from MEM/BB/MAC/EEPROM
- *      ControlvMaskByte - Read one byte from MEM/BB/MAC/EEPROM and clear/set some bits in the same address
+ *      ControlvMaskByte - Read one byte from MEM/BB/MAC/EEPROM and clear/set
+ *				some bits in the same address
  *
  * Revision History:
  *      04-05-2004 Jerry Chen:  Initial release
- *      11-24-2004 Warren Hsu: Add ControlvWriteByte,ControlvReadByte,ControlvMaskByte
+ *      11-24-2004 Warren Hsu: Add ControlvWriteByte, ControlvReadByte,
+ *					ControlvMaskByte
  *
  */
 
@@ -42,8 +44,8 @@
 #include "rndis.h"
 
 /*---------------------  Static Definitions -------------------------*/
-//static int          msglevel                =MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
+/* static int          msglevel                =MSG_LEVEL_INFO;  */
+/* static int          msglevel                =MSG_LEVEL_DEBUG; */
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
@@ -54,56 +56,43 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-
-void ControlvWriteByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs, BYTE byData)
+void ControlvWriteByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs,
+			BYTE byData)
 {
-BYTE            byData1;
-
-    byData1 = byData;
-
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        byRegOfs,
-                        byRegType,
-                        1,
-                        &byData1
-                        );
-
+	BYTE	byData1;
+	byData1 = byData;
+	CONTROLnsRequestOut(pDevice,
+		MESSAGE_TYPE_WRITE,
+		byRegOfs,
+		byRegType,
+		1,
+		&byData1);
 }
 
-
-void ControlvReadByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs, PBYTE pbyData)
+void ControlvReadByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs,
+			PBYTE pbyData)
 {
-NTSTATUS        ntStatus;
-BYTE            byData1;
-
-
-    ntStatus = CONTROLnsRequestIn(pDevice,
-                                    MESSAGE_TYPE_READ,
-                                    byRegOfs,
-                                    byRegType,
-                                    1,
-                                    &byData1);
-
-    *pbyData = byData1;
-
+	NTSTATUS	ntStatus;
+	BYTE	byData1;
+	ntStatus = CONTROLnsRequestIn(pDevice,
+					MESSAGE_TYPE_READ,
+					byRegOfs,
+					byRegType,
+					1,
+					&byData1);
+	*pbyData = byData1;
 }
 
-
-
-void ControlvMaskByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs, BYTE byMask, BYTE byData)
+void ControlvMaskByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs,
+			BYTE byMask, BYTE byData)
 {
-BYTE            pbyData[2];
-
-    pbyData[0] = byData;
-    pbyData[1] = byMask;
-
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE_MASK,
-                        byRegOfs,
-                        byRegType,
-                        2,
-                        pbyData
-                        );
-
+	BYTE	pbyData[2];
+	pbyData[0] = byData;
+	pbyData[1] = byMask;
+	CONTROLnsRequestOut(pDevice,
+				MESSAGE_TYPE_WRITE_MASK,
+				byRegOfs,
+				byRegType,
+				2,
+				pbyData);
 }
-- 
1.6.3.3

