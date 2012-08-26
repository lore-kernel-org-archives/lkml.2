Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2HZPRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 11:17:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42323 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2HZPQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 11:16:57 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/3]NEXT:staging "vt6656" Typo rename Caculate to Calculate.
Date: Sun, 26 Aug 2012 08:16:44 -0700
Message-Id: <1345994205-19044-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345994205-19044-1-git-send-email-justinmattock@gmail.com>
References: <1345994205-19044-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patches renames Caculate to Calculate.

 drivers/staging/vt6656/baseband.c |    4 ++--
 drivers/staging/vt6656/baseband.h |    2 +-
 drivers/staging/vt6656/card.c     |   28 +++++++++++++--------------
 drivers/staging/vt6656/rxtx.c     |   38 ++++++++++++++++++-------------------
 4 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index b24605a..3855015 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -27,7 +27,7 @@
  *
  * Functions:
  *      BBuGetFrameTime        - Calculate data frame transmitting time
- *      BBvCaculateParameter   - Calculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
+ *      BBvCalculateParameter   - Calculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
  *      BBbVT3184Init          - VIA VT3184 baseband chip init code
  *      BBvLoopbackOn          - Turn on BaseBand Loopback mode
  *      BBvLoopbackOff         - Turn off BaseBand Loopback mode
@@ -757,7 +757,7 @@ BBuGetFrameTime (
  *
  */
 void
-BBvCaculateParameter (
+BBvCalculateParameter (
       PSDevice pDevice,
       unsigned int cbFrameLength,
       WORD wRate,
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 8db8cd0..844d5a8 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -104,7 +104,7 @@ BBuGetFrameTime(
      WORD wRate
     );
 
-void BBvCaculateParameter(PSDevice pDevice,
+void BBvCalculateParameter(PSDevice pDevice,
 			  unsigned int cbFrameLength,
 			  WORD wRate,
 			  BYTE byPacketType,
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 694e648..826520b 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -214,7 +214,7 @@ static WORD swGetOFDMControlRate(void *pDeviceHandler, WORD wRateIdx)
  *
  */
 void
-CARDvCaculateOFDMRParameter (
+CARDvCalculateOFDMRParameter (
       WORD wRate,
       BYTE byBBType,
      PBYTE pbyTxRate,
@@ -337,7 +337,7 @@ void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType)
     int     i;
 
     //RSPINF_b_1
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          swGetCCKControlRate(pDevice, RATE_1M),
                          PK_TYPE_11B,
@@ -347,7 +347,7 @@ void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType)
     );
 
     ///RSPINF_b_2
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          swGetCCKControlRate(pDevice, RATE_2M),
                          PK_TYPE_11B,
@@ -357,7 +357,7 @@ void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType)
     );
 
     //RSPINF_b_5
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          swGetCCKControlRate(pDevice, RATE_5M),
                          PK_TYPE_11B,
@@ -367,7 +367,7 @@ void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType)
     );
 
     //RSPINF_b_11
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          swGetCCKControlRate(pDevice, RATE_11M),
                          PK_TYPE_11B,
@@ -377,55 +377,55 @@ void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType)
     );
 
     //RSPINF_a_6
-    CARDvCaculateOFDMRParameter (RATE_6M,
+    CARDvCalculateOFDMRParameter (RATE_6M,
                                  byBBType,
                                  &abyTxRate[0],
                                  &abyRsvTime[0]);
 
     //RSPINF_a_9
-    CARDvCaculateOFDMRParameter (RATE_9M,
+    CARDvCalculateOFDMRParameter (RATE_9M,
                                  byBBType,
                                  &abyTxRate[1],
                                  &abyRsvTime[1]);
 
     //RSPINF_a_12
-    CARDvCaculateOFDMRParameter (RATE_12M,
+    CARDvCalculateOFDMRParameter (RATE_12M,
                                  byBBType,
                                  &abyTxRate[2],
                                  &abyRsvTime[2]);
 
     //RSPINF_a_18
-    CARDvCaculateOFDMRParameter (RATE_18M,
+    CARDvCalculateOFDMRParameter (RATE_18M,
                                  byBBType,
                                  &abyTxRate[3],
                                  &abyRsvTime[3]);
 
     //RSPINF_a_24
-    CARDvCaculateOFDMRParameter (RATE_24M,
+    CARDvCalculateOFDMRParameter (RATE_24M,
                                  byBBType,
                                  &abyTxRate[4],
                                  &abyRsvTime[4]);
 
     //RSPINF_a_36
-    CARDvCaculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_36M),
+    CARDvCalculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_36M),
                                  byBBType,
                                  &abyTxRate[5],
                                  &abyRsvTime[5]);
 
     //RSPINF_a_48
-    CARDvCaculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_48M),
+    CARDvCalculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_48M),
                                  byBBType,
                                  &abyTxRate[6],
                                  &abyRsvTime[6]);
 
     //RSPINF_a_54
-    CARDvCaculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_54M),
+    CARDvCalculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_54M),
                                  byBBType,
                                  &abyTxRate[7],
                                  &abyRsvTime[7]);
 
     //RSPINF_a_72
-    CARDvCaculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_54M),
+    CARDvCalculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_54M),
                                  byBBType,
                                  &abyTxRate[8],
                                  &abyRsvTime[8]);
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 46e62f4..c082b90 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -841,7 +841,7 @@ s_uFillDataHead (
 	if ((uDMAIdx == TYPE_ATIMDMA) || (uDMAIdx == TYPE_BEACONDMA)) {
 		PSTxDataHead_ab pBuf = (PSTxDataHead_ab) pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (PWORD)&(pBuf->wTransmitLength), (PBYTE)&(pBuf->byServiceField), (PBYTE)&(pBuf->bySignalField)
             );
             //Get Duration and TimeStampOff
@@ -858,10 +858,10 @@ s_uFillDataHead (
             if (byFBOption == AUTO_FB_NONE) {
                 PSTxDataHead_g pBuf = (PSTxDataHead_g)pTxDataHead;
                 //Get SignalField,ServiceField,Length
-                BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+                BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                     (PWORD)&(pBuf->wTransmitLength_a), (PBYTE)&(pBuf->byServiceField_a), (PBYTE)&(pBuf->bySignalField_a)
                 );
-                BBvCaculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+                BBvCalculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                     (PWORD)&(pBuf->wTransmitLength_b), (PBYTE)&(pBuf->byServiceField_b), (PBYTE)&(pBuf->bySignalField_b)
                 );
                 //Get Duration and TimeStamp
@@ -881,10 +881,10 @@ s_uFillDataHead (
                 // Auto Fallback
                 PSTxDataHead_g_FB pBuf = (PSTxDataHead_g_FB)pTxDataHead;
                 //Get SignalField,ServiceField,Length
-                BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+                BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                     (PWORD)&(pBuf->wTransmitLength_a), (PBYTE)&(pBuf->byServiceField_a), (PBYTE)&(pBuf->bySignalField_a)
                 );
-                BBvCaculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+                BBvCalculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                     (PWORD)&(pBuf->wTransmitLength_b), (PBYTE)&(pBuf->byServiceField_b), (PBYTE)&(pBuf->bySignalField_b)
                 );
                 //Get Duration and TimeStamp
@@ -907,7 +907,7 @@ s_uFillDataHead (
             // Auto Fallback
             PSTxDataHead_a_FB pBuf = (PSTxDataHead_a_FB)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (PWORD)&(pBuf->wTransmitLength), (PBYTE)&(pBuf->byServiceField), (PBYTE)&(pBuf->bySignalField)
             );
             //Get Duration and TimeStampOff
@@ -924,7 +924,7 @@ s_uFillDataHead (
         } else {
             PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (PWORD)&(pBuf->wTransmitLength), (PBYTE)&(pBuf->byServiceField), (PBYTE)&(pBuf->bySignalField)
             );
             //Get Duration and TimeStampOff
@@ -942,7 +942,7 @@ s_uFillDataHead (
     else if (byPktType == PK_TYPE_11B) {
             PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (PWORD)&(pBuf->wTransmitLength), (PBYTE)&(pBuf->byServiceField), (PBYTE)&(pBuf->bySignalField)
             );
             //Get Duration and TimeStampOff
@@ -993,11 +993,11 @@ s_vFillRTSHead (
         if (byFBOption == AUTO_FB_NONE) {
             PSRTS_g pBuf = (PSRTS_g)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (PWORD)&(wLen), (PBYTE)&(pBuf->byServiceField_b), (PBYTE)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (PWORD)&(wLen), (PBYTE)&(pBuf->byServiceField_a), (PBYTE)&(pBuf->bySignalField_a)
             );
             pBuf->wTransmitLength_a = cpu_to_le16(wLen);
@@ -1035,11 +1035,11 @@ s_vFillRTSHead (
         else {
            PSRTS_g_FB pBuf = (PSRTS_g_FB)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (PWORD)&(wLen), (PBYTE)&(pBuf->byServiceField_b), (PBYTE)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (PWORD)&(wLen), (PBYTE)&(pBuf->byServiceField_a), (PBYTE)&(pBuf->bySignalField_a)
             );
             pBuf->wTransmitLength_a = cpu_to_le16(wLen);
@@ -1084,7 +1084,7 @@ s_vFillRTSHead (
         if (byFBOption == AUTO_FB_NONE) {
             PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (PWORD)&(wLen), (PBYTE)&(pBuf->byServiceField), (PBYTE)&(pBuf->bySignalField)
             );
             pBuf->wTransmitLength = cpu_to_le16(wLen);
@@ -1119,7 +1119,7 @@ s_vFillRTSHead (
         else {
             PSRTS_a_FB pBuf = (PSRTS_a_FB)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (PWORD)&(wLen), (PBYTE)&(pBuf->byServiceField), (PBYTE)&(pBuf->bySignalField)
             );
             pBuf->wTransmitLength = cpu_to_le16(wLen);
@@ -1155,7 +1155,7 @@ s_vFillRTSHead (
     else if (byPktType == PK_TYPE_11B) {
         PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
         //Get SignalField,ServiceField,Length
-        BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+        BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
             (PWORD)&(wLen), (PBYTE)&(pBuf->byServiceField), (PBYTE)&(pBuf->bySignalField)
         );
         pBuf->wTransmitLength = cpu_to_le16(wLen);
@@ -1221,7 +1221,7 @@ s_vFillCTSHead (
             // Auto Fall back
             PSCTS_FB pBuf = (PSCTS_FB)pvCTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+            BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (PWORD)&(wLen), (PBYTE)&(pBuf->byServiceField_b), (PBYTE)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
@@ -1246,7 +1246,7 @@ s_vFillCTSHead (
         } else { //if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA)
             PSCTS pBuf = (PSCTS)pvCTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+            BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (PWORD)&(wLen), (PBYTE)&(pBuf->byServiceField_b), (PBYTE)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
@@ -2272,7 +2272,7 @@ csBeacon_xmit(
         wCurrentRate = RATE_6M;
         pTxDataHead = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize);
         //Get SignalField,ServiceField,Length
-        BBvCaculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11A,
+        BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11A,
             (PWORD)&(pTxDataHead->wTransmitLength), (PBYTE)&(pTxDataHead->byServiceField), (PBYTE)&(pTxDataHead->bySignalField)
         );
         //Get Duration and TimeStampOff
@@ -2285,7 +2285,7 @@ csBeacon_xmit(
         pTxBufHead->wFIFOCtl |= FIFOCTL_11B;
         pTxDataHead = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize);
         //Get SignalField,ServiceField,Length
-        BBvCaculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11B,
+        BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11B,
             (PWORD)&(pTxDataHead->wTransmitLength), (PBYTE)&(pTxDataHead->byServiceField), (PBYTE)&(pTxDataHead->bySignalField)
         );
         //Get Duration and TimeStampOff
-- 
1.7.9.5

