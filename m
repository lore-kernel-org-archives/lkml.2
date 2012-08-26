Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2HZPRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 11:17:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38642 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2HZPQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 11:16:59 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/3]NEXT:staging "vt6656" Typo rename Embeded to Embedded.
Date: Sun, 26 Aug 2012 08:16:45 -0700
Message-Id: <1345994205-19044-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345994205-19044-1-git-send-email-justinmattock@gmail.com>
References: <1345994205-19044-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch renames Embeded to Embedded.

 drivers/staging/vt6656/rf.c |   52 +++++++++++++++++++++----------------------
 drivers/staging/vt6656/rf.h |    2 +-
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 6205e65..593cdc7 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -26,7 +26,7 @@
  * Date: Feb. 19, 2004
  *
  * Functions:
- *      IFRFbWriteEmbeded      - Embedded write RF register via MAC
+ *      IFRFbWriteEmbedded      - Embedded write RF register via MAC
  *
  * Revision History:
  *
@@ -722,7 +722,7 @@ const BYTE RFaby11aChannelIndex[200] = {
  * Return Value: TRUE if succeeded; FALSE if failed.
  *
  */
-BOOL IFRFbWriteEmbeded (PSDevice pDevice, DWORD dwData)
+BOOL IFRFbWriteEmbedded (PSDevice pDevice, DWORD dwData)
 {
     BYTE        pbyData[4];
 
@@ -828,23 +828,23 @@ BOOL        bResult = TRUE;
         case RF_AL2230 :
             if (pDevice->byCurPwr >= AL2230_PWR_IDX_LEN)
                 return FALSE;
-            bResult &= IFRFbWriteEmbeded(pDevice, dwAL2230PowerTable[pDevice->byCurPwr]);
+            bResult &= IFRFbWriteEmbedded(pDevice, dwAL2230PowerTable[pDevice->byCurPwr]);
             if (uRATE <= RATE_11M)
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
             else
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
             break;
 
         case RF_AL2230S :
             if (pDevice->byCurPwr >= AL2230_PWR_IDX_LEN)
                 return FALSE;
-            bResult &= IFRFbWriteEmbeded(pDevice, dwAL2230PowerTable[pDevice->byCurPwr]);
+            bResult &= IFRFbWriteEmbedded(pDevice, dwAL2230PowerTable[pDevice->byCurPwr]);
             if (uRATE <= RATE_11M) {
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
             }else {
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
             }
             break;
 
@@ -854,10 +854,10 @@ BOOL        bResult = TRUE;
                 DWORD       dwMax7230Pwr;
 
                 if (uRATE <= RATE_11M) { //RobertYu:20060426, for better 11b mask
-                    bResult &= IFRFbWriteEmbeded(pDevice, 0x111BB900+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW);
+                    bResult &= IFRFbWriteEmbedded(pDevice, 0x111BB900+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW);
                 }
                 else {
-                    bResult &= IFRFbWriteEmbeded(pDevice, 0x221BB900+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW);
+                    bResult &= IFRFbWriteEmbedded(pDevice, 0x221BB900+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW);
                 }
 
                 if (pDevice->byCurPwr > AL7230_PWR_IDX_LEN) return FALSE;
@@ -866,7 +866,7 @@ BOOL        bResult = TRUE;
                 dwMax7230Pwr = 0x080C0B00 | ( (pDevice->byCurPwr) << 12 ) |
                                  (BY_AL7230_REG_LEN << 3 )  | IFREGCTL_REGW;
 
-                bResult &= IFRFbWriteEmbeded(pDevice, dwMax7230Pwr);
+                bResult &= IFRFbWriteEmbedded(pDevice, dwMax7230Pwr);
                 break;
             }
             break;
@@ -879,7 +879,7 @@ BOOL        bResult = TRUE;
                 return FALSE;
             dwVT3226Pwr = ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0x17 << 8 ) /* Reg7 */ |
                            (BY_VT3226_REG_LEN << 3 )  | IFREGCTL_REGW;
-            bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226Pwr);
+            bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226Pwr);
             break;
         }
 
@@ -894,27 +894,27 @@ BOOL        bResult = TRUE;
 
                 dwVT3226Pwr = ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0xE07 << 8 ) /* Reg7 */ |   //RobertYu:20060420, TWIF 1.10
                                (BY_VT3226_REG_LEN << 3 )  | IFREGCTL_REGW;
-                bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226Pwr);
+                bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226Pwr);
 
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x03C6A200+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x03C6A200+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
                 if (pDevice->sMgmtObj.eScanState != WMAC_NO_SCANNING) {
                     // scanning, the channel number is pDevice->uScanChannel
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"@@@@ RFbRawSetPower> 11B mode uCurrChannel[%d]\n", pDevice->sMgmtObj.uScanChannel);
-                    bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226D0LoCurrentTable[pDevice->sMgmtObj.uScanChannel-1]); //RobertYu:20060420, sometimes didn't change channel just set power with different rate
+                    bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226D0LoCurrentTable[pDevice->sMgmtObj.uScanChannel-1]); //RobertYu:20060420, sometimes didn't change channel just set power with different rate
                 } else {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"@@@@ RFbRawSetPower> 11B mode uCurrChannel[%d]\n", pDevice->sMgmtObj.uCurrChannel);
-                    bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226D0LoCurrentTable[pDevice->sMgmtObj.uCurrChannel-1]); //RobertYu:20060420, sometimes didn't change channel just set power with different rate
+                    bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226D0LoCurrentTable[pDevice->sMgmtObj.uCurrChannel-1]); //RobertYu:20060420, sometimes didn't change channel just set power with different rate
                 }
 
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x015C0800+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060420, ok now, new switching power (mini-pci can have bigger power consumption)
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x015C0800+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060420, ok now, new switching power (mini-pci can have bigger power consumption)
             } else {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"@@@@ RFbRawSetPower> 11G mode\n");
                 dwVT3226Pwr = ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0x7 << 8 ) /* Reg7 */ |   //RobertYu:20060420, TWIF 1.10
                                (BY_VT3226_REG_LEN << 3 )  | IFREGCTL_REGW;
-                bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226Pwr);
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x00C6A200+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060327
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x016BC600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060111
-                bResult &= IFRFbWriteEmbeded(pDevice, 0x00900800+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060111
+                bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226Pwr);
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x00C6A200+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060327
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x016BC600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060111
+                bResult &= IFRFbWriteEmbedded(pDevice, 0x00900800+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060111
             }
             break;
         }
@@ -929,7 +929,7 @@ BOOL        bResult = TRUE;
 
             dwVT3342Pwr =  ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0x27 << 8 ) /* Reg7 */ |
                             (BY_VT3342_REG_LEN << 3 )  | IFREGCTL_REGW;
-            bResult &= IFRFbWriteEmbeded(pDevice, dwVT3342Pwr);
+            bResult &= IFRFbWriteEmbedded(pDevice, dwVT3342Pwr);
             break;
         }
 
@@ -1141,9 +1141,9 @@ BOOL s_bVT3226D0_11bLoCurrentAdjust(
 
     bResult = TRUE;
     if( b11bMode )
-        bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226D0LoCurrentTable[byChannel-1]);
+        bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226D0LoCurrentTable[byChannel-1]);
     else
-        bResult &= IFRFbWriteEmbeded(pDevice, 0x016BC600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060412
+        bResult &= IFRFbWriteEmbedded(pDevice, 0x016BC600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060412
 
     return bResult;
 }
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index f5ba8fd..72eb27a 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -63,7 +63,7 @@
 extern const BYTE RFaby11aChannelIndex[200];
 /*---------------------  Export Functions  --------------------------*/
 
-BOOL IFRFbWriteEmbeded(PSDevice pDevice, DWORD dwData);
+BOOL IFRFbWriteEmbedded(PSDevice pDevice, DWORD dwData);
 BOOL RFbSetPower(PSDevice pDevice, unsigned int uRATE, unsigned int uCH);
 
 BOOL RFbRawSetPower(
-- 
1.7.9.5

