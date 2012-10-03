Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2JCER2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:17:28 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42933 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2JCER0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:17:26 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: aaro.koskinen@iki.fi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]staging "xgifb" Fix typos.
Date: Tue,  2 Oct 2012 21:17:11 -0700
Message-Id: <1349237831-4939-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The patch below fixes typos while reading through staging "xgifb".

 drivers/staging/xgifb/TODO         |    2 +-
 drivers/staging/xgifb/vb_setmode.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/xgifb/TODO b/drivers/staging/xgifb/TODO
index 13d9bc2..392b29d 100644
--- a/drivers/staging/xgifb/TODO
+++ b/drivers/staging/xgifb/TODO
@@ -1,4 +1,4 @@
-This drivers still need a lot of work. I can list all cleanups to do but it's
+This drivers still needs a lot of work. I can list all cleanups to do but it's
 going to be long. So, I'm writing "cleanups" and not the list.
 
 Arnaud
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index e95a165..c8561a0 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -2501,7 +2501,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		} else {
 			temp = 0x017C;
 		}
-	} else { /* 3nd party chip */
+	} else { /* 3rd party chip */
 		temp = SetCRT2ToLCD;
 	}
 
@@ -4390,7 +4390,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_and_or(pVBInfo->Part2Port, 0x17, 0xFB, 0x00);
 	xgifb_reg_and_or(pVBInfo->Part2Port, 0x18, 0xDF, 0x00);
 
-	/* Customized LCDB Des no add */
+	/* Customized LCDB Does not add */
 	tempbx = 5;
 	LCDBDesPtr = XGI_GetLcdPtr(tempbx, ModeNo, ModeIdIndex,
 				   RefreshRateTableIndex, pVBInfo);
-- 
1.7.9.5

