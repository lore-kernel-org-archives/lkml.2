Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2HTPno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:43:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64875 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2HTPnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:43:32 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/3]NEXT:staging: "vt6655" Typo change *Caculate to *Calculate. 
Date: Mon, 20 Aug 2012 08:43:15 -0700
Message-Id: <1345477395-24263-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345477395-24263-1-git-send-email-justinmattock@gmail.com>
References: <1345477395-24263-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
The below patch changes *Caculate to *Calculate in comments and code.

 drivers/staging/vt6655/baseband.c |    6 ++--
 drivers/staging/vt6655/baseband.h |    2 +-
 drivers/staging/vt6655/card.c     |   62 ++++++++++++++++++-------------------
 drivers/staging/vt6655/rxtx.c     |   36 ++++++++++-----------
 drivers/staging/vt6655/tether.c   |    4 +--
 drivers/staging/vt6655/tkip.c     |    2 +-
 6 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 9a039ea..8d2c6a7 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -40,7 +40,7 @@
  * Revision History:
  *      06-10-2003 Bryan YC Fan:  Re-write codes to support VT3253 spec.
  *      08-07-2003 Bryan YC Fan:  Add MAXIM2827/2825 and RFMD2959 support.
- *      08-26-2003 Kyle Hsu    :  Modify BBuGetFrameTime() and BBvCaculateParameter().
+ *      08-26-2003 Kyle Hsu    :  Modify BBuGetFrameTime() and BBvCalculateParameter().
  *                                cancel the setting of MAC_REG_SOFTPWRCTL on BBbVT3253Init().
  *                                Add the comments.
  *      09-01-2003 Bryan YC Fan:  RF & BB tables updated.
@@ -1826,7 +1826,7 @@ BBuGetFrameTime (
 }
 
 /*
- * Description: Caculate Length, Service, and Signal fields of Phy for Tx
+ * Description: Calculate Length, Service, and Signal fields of Phy for Tx
  *
  * Parameters:
  *  In:
@@ -1842,7 +1842,7 @@ BBuGetFrameTime (
  *
  */
 void
-BBvCaculateParameter (
+BBvCalculateParameter (
     PSDevice pDevice,
     unsigned int cbFrameLength,
     unsigned short wRate,
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index c6909fa..9b5bc9c 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -97,7 +97,7 @@ BBuGetFrameTime(
     );
 
 void
-BBvCaculateParameter (
+BBvCalculateParameter (
     PSDevice pDevice,
     unsigned int cbFrameLength,
     unsigned short wRate,
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index b740cf2..319ca48 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -28,9 +28,9 @@
  *      CARDbIsOFDMinBasicRate - Check if any OFDM rate is in BasicRateSet
  *      CARDvSetLoopbackMode - Set Loopback mode
  *      CARDbSoftwareReset - Sortware reset NIC
- *      CARDqGetTSFOffset - Caculate TSFOffset
+ *      CARDqGetTSFOffset - Calculate TSFOffset
  *      CARDbGetCurrentTSF - Read Current NIC TSF counter
- *      CARDqGetNextTBTT - Caculate Next Beacon TSF counter
+ *      CARDqGetNextTBTT - Calculate Next Beacon TSF counter
  *      CARDvSetFirstNextTBTT - Set NIC Beacon time
  *      CARDvUpdateNextTBTT - Sync. NIC Beacon time
  *      CARDbRadioPowerOff - Turn Off NIC Radio Power
@@ -100,7 +100,7 @@ const unsigned short cwRXBCNTSFOff[MAX_RATE] =
 
 static
 void
-s_vCaculateOFDMRParameter(
+s_vCalculateOFDMRParameter(
     unsigned char byRate,
     CARD_PHY_TYPE ePHYType,
     unsigned char *pbyTxRate,
@@ -111,7 +111,7 @@ s_vCaculateOFDMRParameter(
 /*---------------------  Export Functions  --------------------------*/
 
 /*
- * Description: Caculate TxRate and RsvTime fields for RSPINF in OFDM mode.
+ * Description: Calculate TxRate and RsvTime fields for RSPINF in OFDM mode.
  *
  * Parameters:
  *  In:
@@ -126,7 +126,7 @@ s_vCaculateOFDMRParameter(
  */
 static
 void
-s_vCaculateOFDMRParameter (
+s_vCalculateOFDMRParameter (
     unsigned char byRate,
     CARD_PHY_TYPE ePHYType,
     unsigned char *pbyTxRate,
@@ -251,7 +251,7 @@ s_vSetRSPINF (PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs,
     MACvSelectPage1(pDevice->PortOffset);
 
     //RSPINF_b_1
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          VNTWIFIbyGetACKTxRate(RATE_1M, pvSupportRateIEs, pvExtSupportRateIEs),
                          PK_TYPE_11B,
@@ -262,7 +262,7 @@ s_vSetRSPINF (PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs,
 
     VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_1, MAKEDWORD(wLen,MAKEWORD(bySignal,byServ)));
     ///RSPINF_b_2
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          VNTWIFIbyGetACKTxRate(RATE_2M, pvSupportRateIEs, pvExtSupportRateIEs),
                          PK_TYPE_11B,
@@ -273,7 +273,7 @@ s_vSetRSPINF (PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs,
 
     VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_2, MAKEDWORD(wLen,MAKEWORD(bySignal,byServ)));
     //RSPINF_b_5
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          VNTWIFIbyGetACKTxRate(RATE_5M, pvSupportRateIEs, pvExtSupportRateIEs),
                          PK_TYPE_11B,
@@ -284,7 +284,7 @@ s_vSetRSPINF (PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs,
 
     VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_5, MAKEDWORD(wLen,MAKEWORD(bySignal,byServ)));
     //RSPINF_b_11
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          VNTWIFIbyGetACKTxRate(RATE_11M, pvSupportRateIEs, pvExtSupportRateIEs),
                          PK_TYPE_11B,
@@ -295,51 +295,51 @@ s_vSetRSPINF (PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs,
 
     VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_11, MAKEDWORD(wLen,MAKEWORD(bySignal,byServ)));
     //RSPINF_a_6
-    s_vCaculateOFDMRParameter(RATE_6M,
+    s_vCalculateOFDMRParameter(RATE_6M,
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_6, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_9
-    s_vCaculateOFDMRParameter(RATE_9M,
+    s_vCalculateOFDMRParameter(RATE_9M,
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_9, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_12
-    s_vCaculateOFDMRParameter(RATE_12M,
+    s_vCalculateOFDMRParameter(RATE_12M,
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_12, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_18
-    s_vCaculateOFDMRParameter(RATE_18M,
+    s_vCalculateOFDMRParameter(RATE_18M,
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_18, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_24
-    s_vCaculateOFDMRParameter(RATE_24M,
+    s_vCalculateOFDMRParameter(RATE_24M,
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_24, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_36
-    s_vCaculateOFDMRParameter(
+    s_vCalculateOFDMRParameter(
                               VNTWIFIbyGetACKTxRate(RATE_36M, pvSupportRateIEs, pvExtSupportRateIEs),
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_36, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_48
-    s_vCaculateOFDMRParameter(
+    s_vCalculateOFDMRParameter(
                               VNTWIFIbyGetACKTxRate(RATE_48M, pvSupportRateIEs, pvExtSupportRateIEs),
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_48, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_54
-    s_vCaculateOFDMRParameter(
+    s_vCalculateOFDMRParameter(
                               VNTWIFIbyGetACKTxRate(RATE_54M, pvSupportRateIEs, pvExtSupportRateIEs),
                               ePHYType,
                               &byTxRate,
@@ -1739,7 +1739,7 @@ void CARDvSetRSPINF (void *pDeviceHandler, CARD_PHY_TYPE ePHYType)
     MACvSelectPage1(pDevice->PortOffset);
 
     //RSPINF_b_1
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          CARDwGetCCKControlRate((void *)pDevice, RATE_1M),
                          PK_TYPE_11B,
@@ -1750,7 +1750,7 @@ void CARDvSetRSPINF (void *pDeviceHandler, CARD_PHY_TYPE ePHYType)
 
     VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_1, MAKEDWORD(wLen,MAKEWORD(bySignal,byServ)));
     ///RSPINF_b_2
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          CARDwGetCCKControlRate((void *)pDevice, RATE_2M),
                          PK_TYPE_11B,
@@ -1761,7 +1761,7 @@ void CARDvSetRSPINF (void *pDeviceHandler, CARD_PHY_TYPE ePHYType)
 
     VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_2, MAKEDWORD(wLen,MAKEWORD(bySignal,byServ)));
     //RSPINF_b_5
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          CARDwGetCCKControlRate((void *)pDevice, RATE_5M),
                          PK_TYPE_11B,
@@ -1772,7 +1772,7 @@ void CARDvSetRSPINF (void *pDeviceHandler, CARD_PHY_TYPE ePHYType)
 
     VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_5, MAKEDWORD(wLen,MAKEWORD(bySignal,byServ)));
     //RSPINF_b_11
-    BBvCaculateParameter(pDevice,
+    BBvCalculateParameter(pDevice,
                          14,
                          CARDwGetCCKControlRate((void *)pDevice, RATE_11M),
                          PK_TYPE_11B,
@@ -1783,56 +1783,56 @@ void CARDvSetRSPINF (void *pDeviceHandler, CARD_PHY_TYPE ePHYType)
 
     VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_11, MAKEDWORD(wLen,MAKEWORD(bySignal,byServ)));
     //RSPINF_a_6
-    s_vCaculateOFDMRParameter(RATE_6M,
+    s_vCalculateOFDMRParameter(RATE_6M,
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_6, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_9
-    s_vCaculateOFDMRParameter(RATE_9M,
+    s_vCalculateOFDMRParameter(RATE_9M,
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_9, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_12
-    s_vCaculateOFDMRParameter(RATE_12M,
+    s_vCalculateOFDMRParameter(RATE_12M,
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_12, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_18
-    s_vCaculateOFDMRParameter(RATE_18M,
+    s_vCalculateOFDMRParameter(RATE_18M,
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
    VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_18, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_24
-    s_vCaculateOFDMRParameter(RATE_24M,
+    s_vCalculateOFDMRParameter(RATE_24M,
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_24, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_36
-    s_vCaculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_36M),
+    s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_36M),
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_36, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_48
-    s_vCaculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_48M),
+    s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_48M),
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_48, MAKEWORD(byTxRate,byRsvTime));
     //RSPINF_a_54
-    s_vCaculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_54M),
+    s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_54M),
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
     VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_54, MAKEWORD(byTxRate,byRsvTime));
 
     //RSPINF_a_72
-    s_vCaculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_54M),
+    s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_54M),
                               ePHYType,
                               &byTxRate,
                               &byRsvTime);
@@ -2042,7 +2042,7 @@ bool CARDbSoftwareReset (void *pDeviceHandler)
 
 
 /*
- * Description: Caculate TSF offset of two TSF input
+ * Description: Calculate TSF offset of two TSF input
  *              Get TSF Offset from RxBCN's TSF and local TSF
  *
  * Parameters:
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index c1e1f4f..4972e57 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -27,7 +27,7 @@
  * Functions:
  *      s_vGenerateTxParameter - Generate tx dma required parameter.
  *      vGenerateMACHeader - Translate 802.3 to 802.11 header
- *      cbGetFragCount - Caculate fragment number count
+ *      cbGetFragCount - Calculate fragment number count
  *      csBeacon_xmit - beacon tx function
  *      csMgmt_xmit - management tx function
  *      s_cbFillTxBufHead - fulfill tx dma buffer header
@@ -733,11 +733,11 @@ s_uFillDataHead (
         if (byFBOption == AUTO_FB_NONE) {
             PSTxDataHead_g pBuf = (PSTxDataHead_g)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_a), (unsigned char *)&(pBuf->bySignalField_a)
             );
             pBuf->wTransmitLength_a = cpu_to_le16(wLen);
-            BBvCaculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+            BBvCalculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
@@ -759,11 +759,11 @@ s_uFillDataHead (
             // Auto Fallback
             PSTxDataHead_g_FB pBuf = (PSTxDataHead_g_FB)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_a), (unsigned char *)&(pBuf->bySignalField_a)
             );
             pBuf->wTransmitLength_a = cpu_to_le16(wLen);
-            BBvCaculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+            BBvCalculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
@@ -788,7 +788,7 @@ s_uFillDataHead (
             // Auto Fallback
             PSTxDataHead_a_FB pBuf = (PSTxDataHead_a_FB)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
             );
             pBuf->wTransmitLength = cpu_to_le16(wLen);
@@ -805,7 +805,7 @@ s_uFillDataHead (
         } else {
             PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
             );
             pBuf->wTransmitLength = cpu_to_le16(wLen);
@@ -823,7 +823,7 @@ s_uFillDataHead (
     else {
             PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
+            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
             );
             pBuf->wTransmitLength = cpu_to_le16(wLen);
@@ -871,11 +871,11 @@ s_vFillRTSHead (
         if (byFBOption == AUTO_FB_NONE) {
             PSRTS_g pBuf = (PSRTS_g)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_a), (unsigned char *)&(pBuf->bySignalField_a)
             );
             pBuf->wTransmitLength_a = cpu_to_le16(wLen);
@@ -904,11 +904,11 @@ s_vFillRTSHead (
         else {
            PSRTS_g_FB pBuf = (PSRTS_g_FB)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_a), (unsigned char *)&(pBuf->bySignalField_a)
             );
             pBuf->wTransmitLength_a = cpu_to_le16(wLen);
@@ -946,7 +946,7 @@ s_vFillRTSHead (
         if (byFBOption == AUTO_FB_NONE) {
             PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
             );
             pBuf->wTransmitLength = cpu_to_le16(wLen);
@@ -975,7 +975,7 @@ s_vFillRTSHead (
         else {
             PSRTS_a_FB pBuf = (PSRTS_a_FB)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
+            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
             );
             pBuf->wTransmitLength = cpu_to_le16(wLen);
@@ -1005,7 +1005,7 @@ s_vFillRTSHead (
     else if (byPktType == PK_TYPE_11B) {
         PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
         //Get SignalField,ServiceField,Length
-        BBvCaculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+        BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
             (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
         );
         pBuf->wTransmitLength = cpu_to_le16(wLen);
@@ -1065,7 +1065,7 @@ s_vFillCTSHead (
             // Auto Fall back
             PSCTS_FB pBuf = (PSCTS_FB)pvCTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+            BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
             );
 
@@ -1092,7 +1092,7 @@ s_vFillCTSHead (
         } else { //if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA)
             PSCTS pBuf = (PSCTS)pvCTS;
             //Get SignalField,ServiceField,Length
-            BBvCaculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
+            BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
@@ -2664,7 +2664,7 @@ CMD_STATUS csBeacon_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
                                                           wCurrentRate, false, 0, 0, 1, AUTO_FB_NONE));
     }
 
-    BBvCaculateParameter(pDevice, cbFrameSize, wCurrentRate, byPktType,
+    BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, byPktType,
         (unsigned short *)&(wLen), (unsigned char *)&(pTxDataHead->byServiceField), (unsigned char *)&(pTxDataHead->bySignalField)
     );
     pTxDataHead->wTransmitLength = cpu_to_le16(wLen);
diff --git a/drivers/staging/vt6655/tether.c b/drivers/staging/vt6655/tether.c
index 1cf8508..28554bf 100644
--- a/drivers/staging/vt6655/tether.c
+++ b/drivers/staging/vt6655/tether.c
@@ -25,7 +25,7 @@
  * Date: May 21, 1996
  *
  * Functions:
- *      ETHbyGetHashIndexByCrc32 - Caculate multicast hash value by CRC32
+ *      ETHbyGetHashIndexByCrc32 - Calculate multicast hash value by CRC32
  *      ETHbIsBufferCrc32Ok - Check CRC value of the buffer if Ok or not
  *
  * Revision History:
@@ -50,7 +50,7 @@
 
 
 /*
- * Description: Caculate multicast hash value by CRC32
+ * Description: Calculate multicast hash value by CRC32
  *
  * Parameters:
  *  In:
diff --git a/drivers/staging/vt6655/tkip.c b/drivers/staging/vt6655/tkip.c
index ed3eac1..f141ba1 100644
--- a/drivers/staging/vt6655/tkip.c
+++ b/drivers/staging/vt6655/tkip.c
@@ -170,7 +170,7 @@ unsigned int rotr1(unsigned int a)
 
 
 /*
- * Description: Caculate RC4Key fom TK, TA, and TSC
+ * Description: Calculate RC4Key fom TK, TA, and TSC
  *
  * Parameters:
  *  In:
-- 
1.7.9.5

