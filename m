Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab2HTPnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:43:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35924 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2HTPn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:43:29 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/3]NEXT:staging: "vt6655" Fix typos in comments. 
Date: Mon, 20 Aug 2012 08:43:13 -0700
Message-Id: <1345477395-24263-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
Note: the patches must be applied in order.
The patch below is 1 out of 3 that I will be sending out for fixing typos in
staging vt6655. This patch mainly focuses on comments; patch 2 and 3 focus on actual code change.

 drivers/staging/vt6655/80211mgr.h    |    2 +-
 drivers/staging/vt6655/baseband.c    |    8 ++---
 drivers/staging/vt6655/bssdb.c       |    4 +--
 drivers/staging/vt6655/card.c        |    3 +-
 drivers/staging/vt6655/datarate.c    |    2 +-
 drivers/staging/vt6655/device.h      |    4 +--
 drivers/staging/vt6655/device_main.c |    6 ++--
 drivers/staging/vt6655/dpc.c         |    2 +-
 drivers/staging/vt6655/ioctl.c       |    2 +-
 drivers/staging/vt6655/iwctl.c       |    6 ++--
 drivers/staging/vt6655/key.c         |    2 +-
 drivers/staging/vt6655/mac.c         |   12 ++++----
 drivers/staging/vt6655/mac.h         |    2 +-
 drivers/staging/vt6655/mib.c         |    2 +-
 drivers/staging/vt6655/power.c       |    2 +-
 drivers/staging/vt6655/rf.c          |   10 +++---
 drivers/staging/vt6655/rxtx.c        |    6 ++--
 drivers/staging/vt6655/tcrc.c        |    2 +-
 drivers/staging/vt6655/tcrc.h        |    2 +-
 drivers/staging/vt6655/vntwifi.c     |    2 +-
 drivers/staging/vt6655/wcmd.c        |    6 ++--
 drivers/staging/vt6655/wmgr.c        |   56 +++++++++++++++++-----------------
 drivers/staging/vt6655/wmgr.h        |    4 +--
 drivers/staging/vt6655/wpa.c         |    2 +-
 drivers/staging/vt6655/wpa2.c        |    8 ++---
 drivers/staging/vt6655/wpactl.c      |    6 ++--
 drivers/staging/vt6655/wroute.c      |    2 +-
 27 files changed, 83 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/vt6655/80211mgr.h b/drivers/staging/vt6655/80211mgr.h
index 3bdab3f..65780f2 100644
--- a/drivers/staging/vt6655/80211mgr.h
+++ b/drivers/staging/vt6655/80211mgr.h
@@ -186,7 +186,7 @@
 
 
 //
-// Cipher Suite Selectors defiened in 802.11i
+// Cipher Suite Selectors defined in 802.11i
 //
 #define WLAN_11i_CSS_USE_GROUP              0
 #define WLAN_11i_CSS_WEP40                  1
diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index e7b93a2..6a06f64 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -28,8 +28,8 @@
  * Functions:
  *      BBuGetFrameTime        - Calculate data frame transmitting time
  *      BBvCaculateParameter   - Caculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
- *      BBbReadEmbeded         - Embeded read baseband register via MAC
- *      BBbWriteEmbeded        - Embeded write baseband register via MAC
+ *      BBbReadEmbeded         - Embedded read baseband register via MAC
+ *      BBbWriteEmbeded        - Embedded write baseband register via MAC
  *      BBbIsRegBitsOn         - Test if baseband register bits on
  *      BBbIsRegBitsOff        - Test if baseband register bits off
  *      BBbVT3253Init          - VIA VT3253 baseband chip init code
@@ -2001,7 +2001,7 @@ BBvCaculateParameter (
 }
 
 /*
- * Description: Read a byte from BASEBAND, by embeded programming
+ * Description: Read a byte from BASEBAND, by embedded programming
  *
  * Parameters:
  *  In:
@@ -2043,7 +2043,7 @@ bool BBbReadEmbeded (unsigned long dwIoBase, unsigned char byBBAddr, unsigned ch
 
 
 /*
- * Description: Write a Byte to BASEBAND, by embeded programming
+ * Description: Write a Byte to BASEBAND, by embedded programming
  *
  * Parameters:
  *  In:
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index fcffa4f..fe57fb8 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -784,8 +784,8 @@ BSSDBbIsSTAInNodeDB(void *pMgmtObject, unsigned char *abyDstAddr,
 /*+
  *
  * Routine Description:
- *    Find an empty node and allocated; if no empty found,
- *    instand used of most inactive one.
+ *    Find an empty node and allocat it; if there is no empty node,
+ *    then use the most inactive one.
  *
  * Return Value:
  *    None
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 2721e07..e2785c3 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -1354,7 +1354,8 @@ CARDbSetQuiet (
 /*
  *
  * Description:
- *    Do Quiet, It will called by either ISR (after start) or VNTWIFI (before start) so do not need SPINLOCK
+ *    Do Quiet, It will be called by either ISR(after start) 
+ *    or VNTWIFI(before start) so we do not need a SPINLOCK
  *
  * Parameters:
  *  In:
diff --git a/drivers/staging/vt6655/datarate.c b/drivers/staging/vt6655/datarate.c
index efbb8f4..b86ec1b 100644
--- a/drivers/staging/vt6655/datarate.c
+++ b/drivers/staging/vt6655/datarate.c
@@ -126,7 +126,7 @@ DATARATEbyGetRateIdx (
 /*+
  *
  * Routine Description:
- *      Rate fallback Algorithm Implementaion
+ *      Rate fallback Algorithm Implementation
  *
  * Parameters:
  *  In:
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index c5e6b98..e54e00b 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -327,7 +327,7 @@ typedef struct tagSDeFragControlBlock
 //flags for driver status
 #define     DEVICE_FLAGS_OPENED          0x00010000UL
 #define     DEVICE_FLAGS_WOL_ENABLED     0x00080000UL
-//flags for capbilities
+//flags for capabilities
 #define     DEVICE_FLAGS_TX_ALIGN        0x01000000UL
 #define     DEVICE_FLAGS_HAVE_CAM        0x02000000UL
 #define     DEVICE_FLAGS_FLOW_CTRL       0x04000000UL
@@ -567,7 +567,7 @@ typedef struct __device_info {
     bool bPrvActive4RadioOFF;
     bool bGPIOBlockRead;
 
-    // Beacon releated
+    // Beacon related
     unsigned short wSeqCounter;
     unsigned short wBCNBufLen;
     bool bBeaconBufReady;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 89d1c22..ee4fb16 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -518,7 +518,7 @@ static void s_vCompleteCurrentMeasure (PSDevice pDevice, unsigned char byResult)
 
 
 //
-// Initialiation of MAC & BBP registers
+// Initialisation of MAC & BBP registers
 //
 
 static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
@@ -1064,7 +1064,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
     //Mask out the options cannot be set to the chip
     pDevice->sOpts.flags &= pChip_info->flags;
 
-    //Enable the chip specified capbilities
+    //Enable the chip specified capabilities
     pDevice->flags = pDevice->sOpts.flags | (pChip_info->flags & 0xFF000000UL);
     pDevice->tx_80211 = device_dma0_tx_80211;
     pDevice->sMgmtObj.pAdapter = (void *)pDevice;
@@ -1678,7 +1678,7 @@ static int device_tx_srv(PSDevice pDevice, unsigned int uIdx) {
                 uFrameSize = pTD->pTDInfo->dwReqCount - uFIFOHeaderSize;
                 pTxBufHead = (PSTxBufHead) (pTD->pTDInfo->buf);
                 // Update the statistics based on the Transmit status
-                // now, we DO'NT check TSR0_CDH
+                // now, we DONT check TSR0_CDH
 
                 STAvUpdateTDStatCounter(&pDevice->scStatistic,
                         byTsr0, byTsr1,
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index e8a71ba..373e9e4 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -718,7 +718,7 @@ device_receive_frame (
     if ((*pbyRSSI != 0) &&
         (pMgmt->pCurrBSS!=NULL)) {
         RFvRSSITodBm(pDevice, *pbyRSSI, &ldBm);
-        // Moniter if RSSI is too strong.
+        // Monitor if RSSI is too strong.
         pMgmt->pCurrBSS->byRSSIStatCnt++;
         pMgmt->pCurrBSS->byRSSIStatCnt %= RSSI_STAT_COUNT;
         pMgmt->pCurrBSS->ldBmAverage[pMgmt->pCurrBSS->byRSSIStatCnt] = ldBm;
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index ac15d38..afed6e3 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -111,7 +111,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		break;
 
 	case WLAN_CMD_ZONETYPE_SET:
-		/* mike add :cann't support. */
+		/* mike add :can't support. */
 		result = -EOPNOTSUPP;
 		break;
 
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 77aad7f..5cdda8d 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -358,7 +358,7 @@ int iwctl_giwscan(struct net_device *dev,
 
 
 /*
- * Wireless Handler : set frequence or channel
+ * Wireless Handler : set frequency or channel
  */
 
 int iwctl_siwfreq(struct net_device *dev,
@@ -404,7 +404,7 @@ int iwctl_siwfreq(struct net_device *dev,
 }
 
 /*
- * Wireless Handler : get frequence or channel
+ * Wireless Handler : get frequency or channel
  */
 
 int iwctl_giwfreq(struct net_device *dev,
@@ -1346,7 +1346,7 @@ if((wrq->flags & IW_ENCODE_DISABLED)==0){
 
 		}else if(index>0){
 	//when the length is 0 the request only changes the default transmit key index
-	//check the new key has a non zero lenget
+	//check the new key if it has a non zero length
 	if(pDevice->bEncryptionEnable==false)
 	{
 		rc = -EINVAL;
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index 774b0d4..194fedc 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -372,7 +372,7 @@ bool KeybRemoveKey (
     int  i;
 
     if (is_broadcast_ether_addr(pbyBSSID)) {
-        // dealte all key
+        // delete all keys
         if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
             for (i=0;i<MAX_KEY_TABLE;i++) {
                 pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index f8d1651..30c2615 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -56,9 +56,9 @@
  *      MACbSafeStop - Stop MAC function
  *      MACbShutdown - Shut down MAC
  *      MACvInitialize - Initialize MAC
- *      MACvSetCurrRxDescAddr - Set Rx Descriptos Address
- *      MACvSetCurrTx0DescAddr - Set Tx0 Descriptos Address
- *      MACvSetCurrTx1DescAddr - Set Tx1 Descriptos Address
+ *      MACvSetCurrRxDescAddr - Set Rx Descriptors Address
+ *      MACvSetCurrTx0DescAddr - Set Tx0 Descriptors Address
+ *      MACvSetCurrTx1DescAddr - Set Tx1 Descriptors Address
  *      MACvTimer0MicroSDelay - Micro Second Delay Loop by MAC
  *
  * Revision History:
@@ -1498,7 +1498,7 @@ int     ii;
 
     wOffset += (uKeyIdx * 4);
     for (ii=0;ii<4;ii++) {
-        // alway push 128 bits
+        // always push 128 bits
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"3.(%d) wOffset: %d, Data: %lX\n", ii, wOffset+ii, *pdwKey);
         VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
         VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, *pdwKey++);
@@ -1567,7 +1567,7 @@ int     ii;
     wOffset++;
     wOffset++;
     wOffset += (uKeyIdx * 4);
-    // alway push 128 bits
+    // always push 128 bits
     for (ii=0; ii<3; ii++) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"(%d) wOffset: %d, Data: %lX\n", ii, wOffset+ii, *pdwKey);
         VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
@@ -1696,7 +1696,7 @@ int     ii;
 
     wOffset += (uKeyIdx * 4);
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"1. wOffset: %d, Data: %lX, idx:%d\n", wOffset, *pdwKey, uKeyIdx);
-    // alway push 128 bits
+    // always push 128 bits
     for (ii=0; ii<4; ii++) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"2.(%d) wOffset: %d, Data: %lX\n", ii, wOffset+ii, *pdwKey);
         VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index e3ccfee..adfb366 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -586,7 +586,7 @@
 #define PKT_TYPE_NONE           0x00    // turn off receiver
 #define PKT_TYPE_ALL_MULTICAST  0x80
 #define PKT_TYPE_PROMISCUOUS    0x40
-#define PKT_TYPE_DIRECTED       0x20    // obselete, directed address is always accepted
+#define PKT_TYPE_DIRECTED       0x20    // obsolete, directed address is always accepted
 #define PKT_TYPE_BROADCAST      0x10
 #define PKT_TYPE_MULTICAST      0x08
 #define PKT_TYPE_ERROR_WPA      0x04
diff --git a/drivers/staging/vt6655/mib.c b/drivers/staging/vt6655/mib.c
index 1b91a83..63ae4ad 100644
--- a/drivers/staging/vt6655/mib.c
+++ b/drivers/staging/vt6655/mib.c
@@ -191,7 +191,7 @@ void STAvUpdateRDStatCounter (PSStatCounter pStatistic,
         pStatistic->ullRsrOK++;
 
         if (cbFrameLength >= ETH_ALEN) {
-            // update counters in case that successful transmit
+            // update counters in case of successful transmit
             if (byRSR & RSR_ADDRBROAD) {
                 pStatistic->ullRxBroadcastFrames++;
                 pStatistic->ullRxBroadcastBytes += (unsigned long long) cbFrameLength;
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 4c0b02e..661d534 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -207,7 +207,7 @@ PSbConsiderPowerDown(
     if (pDevice->bCmdRunning)
         return false;
 
-    // Froce PSEN on
+    // Force PSEN on
     MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_PSEN);
 
     // check if all TD are empty,
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index aa69665..537a190 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -26,7 +26,7 @@
  * Date: Feb. 19, 2004
  *
  * Functions:
- *      IFRFbWriteEmbeded      - Embeded write RF register via MAC
+ *      IFRFbWriteEmbeded      - Embedded write RF register via MAC
  *
  * Revision History:
  *
@@ -460,11 +460,11 @@ bool s_bAL7230Init (unsigned long dwIoBase)
 
     //Calibration
     MACvTimer0MicroSDelay(dwIoBase, 150);//150us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:active, RCK:diable
+    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:active, RCK:disable
     MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:diable, RCK:active
+    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:disable, RCK:active
     MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]); //TXDCOC:diable, RCK:diable
+    bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]); //TXDCOC:disable, RCK:disable
 
     MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE3    |
                                                      SOFTPWRCTL_SWPE2    |
@@ -574,7 +574,7 @@ bool s_bAL7230SelectChannel (unsigned long dwIoBase, unsigned char byChannel)
 /*---------------------  Export Functions  --------------------------*/
 
 /*
- * Description: Write to IF/RF, by embeded programming
+ * Description: Write to IF/RF, by embedded programming
  *
  * Parameters:
  *  In:
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 6935b37..c1e1f4f 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -2568,7 +2568,7 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
     if (bIsPSPOLL) {
         // The MAC will automatically replace the Duration-field of MAC header by Duration-field
         // of  FIFO control header.
-        // This will cause AID-field of PS-POLL packet be incorrect (Because PS-POLL's AID field is
+        // This will cause AID-field of PS-POLL packet to be incorrect (Because PS-POLL's AID field is
         // in the same place of other packet's Duration-field).
         // And it will cause Cisco-AP to issue Disassociation-packet
         if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
@@ -2860,7 +2860,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 
     // SetPower will cause error power TX state for OFDM Date packet in TX buffer.
     // 2004.11.11 Kyle -- Using OFDM power to tx MngPkt will decrease the connection capability.
-    //                    And cmd timer will wait data pkt TX finish before scanning so it's OK
+    //                    And cmd timer will wait data pkt TX to finish before scanning so it's OK
     //                    to set power here.
     if (pDevice->pMgmt->eScanState != WMAC_NO_SCANNING) {
         RFbSetPower(pDevice, wCurrentRate, pDevice->byCurrentCh);
@@ -2957,7 +2957,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
     pTxBufHead->wFragCtl |= cpu_to_le16((unsigned short)cbMacHdLen << 10);
 
     // Notes:
-    // Although spec says MMPDU can be fragmented; In most case,
+    // Although spec says MMPDU can be fragmented; In most casses,
     // no one will send a MMPDU under fragmentation. With RTS may occur.
     pDevice->bAES = false;  //Set FRAGCTL_WEPTYP
 
diff --git a/drivers/staging/vt6655/tcrc.c b/drivers/staging/vt6655/tcrc.c
index f9c28bf..1313c4c 100644
--- a/drivers/staging/vt6655/tcrc.c
+++ b/drivers/staging/vt6655/tcrc.c
@@ -18,7 +18,7 @@
  *
  * File: tcrc.c
  *
- * Purpose: Implement functions to caculate CRC
+ * Purpose: Implement functions to calculate CRC
  *
  * Author: Tevin Chen
  *
diff --git a/drivers/staging/vt6655/tcrc.h b/drivers/staging/vt6655/tcrc.h
index d044985..a204421 100644
--- a/drivers/staging/vt6655/tcrc.h
+++ b/drivers/staging/vt6655/tcrc.h
@@ -18,7 +18,7 @@
  *
  * File: tcrc.h
  *
- * Purpose: Implement functions to caculate CRC
+ * Purpose: Implement functions to calculate CRC
  *
  * Author: Tevin Chen
  *
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index d645ecd..62c44b8 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -60,7 +60,7 @@
  * Parameters:
  *  In:
  *      pMgmtHandle - pointer to management object
- *      eOPMode     - Opreation Mode
+ *      eOPMode     - Operation Mode
  *  Out:
  *      none
  *
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 7b5b99c..94bd1fc 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -121,7 +121,7 @@ vAdHocBeaconStop(PSDevice  pDevice)
 
     /*
      * temporarily stop Beacon packet for AdHoc Server
-     * if all of the following coditions are met:
+     * if all of the following conditions are met:
      *  (1) STA is in AdHoc mode
      *  (2) VT3253 is programmed as automatic Beacon Transmitting
      *  (3) One of the following conditions is met
@@ -812,8 +812,8 @@ printk("chester-abyDesireSSID=%s\n",((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySS
                             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "sta ps tx fail \n");
                         }
                         pMgmt->sNodeDBTable[ii].wEnQueueCnt--;
-                        // check if sta ps enable, wait next pspoll
-                        // if sta ps disable, send all pending buffers.
+                        // check if sta ps enabled, and wait next pspoll.
+                        // if sta ps disable, then send all pending buffers.
                         if (pMgmt->sNodeDBTable[ii].bPSEnable)
                             break;
                     }
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index c46d519..b6f99ec 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -26,8 +26,8 @@
  * Date: May 8, 2002
  *
  * Functions:
- *      nsMgrObjectInitial - Initialize Management Objet data structure
- *      vMgrObjectReset - Reset Management Objet data structure
+ *      nsMgrObjectInitial - Initialize Management Object data structure
+ *      vMgrObjectReset - Reset Management Object data structure
  *      vMgrAssocBeginSta - Start associate function
  *      vMgrReAssocBeginSta - Start reassociate function
  *      vMgrDisassocBeginSta - Start disassociate function
@@ -54,7 +54,7 @@
  *      bMgrPrepareBeaconToSend - Prepare Beacon frame
  *      s_vMgrLogStatus - Log 802.11 Status
  *      vMgrRxManagePacket - Rcv management frame dispatch function
- *      s_vMgrFormatTIM- Assember TIM field of beacon
+ *      s_vMgrFormatTIM- Assembler TIM field of beacon
  *      vMgrTimerInit- Initial 1-sec and command call back funtions
  *
  * Revision History:
@@ -425,7 +425,7 @@ vMgrTimerInit(
 /*+
  *
  * Routine Description:
- *    Reset the management object  structure.
+ *    Reset the management object structure.
  *
  * Return Value:
  *    None.
@@ -1287,14 +1287,14 @@ s_vMgrRxAuthentication(
     vMgrDecodeAuthen(&sFrame);
     switch (cpu_to_le16((*(sFrame.pwAuthSequence )))){
         case 1:
-            //AP funciton
+            //AP function
             s_vMgrRxAuthenSequence_1(pDevice,pMgmt, &sFrame);
             break;
         case 2:
             s_vMgrRxAuthenSequence_2(pDevice, pMgmt, &sFrame);
             break;
         case 3:
-            //AP funciton
+            //AP function
             s_vMgrRxAuthenSequence_3(pDevice, pMgmt, &sFrame);
             break;
         case 4:
@@ -1923,7 +1923,7 @@ s_vMgrRxBeacon(
             byIEChannel = sFrame.pDSParms->byCurrChannel;
         }
         if (byCurrChannel != byIEChannel) {
-            // adjust channel info. bcs we rcv adjcent channel pakckets
+            // adjust channel info. bcs we rcv adjacent channel packets
             bChannelHit = false;
             byCurrChannel = byIEChannel;
         }
@@ -2081,7 +2081,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                 }
             }
             //
-            // Basic Rate Set may change dynamiclly
+            // Basic Rate Set may change dynamically
             //
             if (pBSSList->eNetworkTypeInUse == PHY_TYPE_11B) {
                 uRateLen = WLAN_RATES_MAXLEN_11B;
@@ -2134,7 +2134,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
     }
 
 //    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Beacon 2 \n");
-    // check if CF field exisit
+    // check if CF field exists
     if (WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)) {
         if (sFrame.pCFParms->wCFPDurRemaining > 0) {
             // TODO: deal with CFP period to set NAV
@@ -2244,7 +2244,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
 		    if (pMgmt->sNodeDBTable[0].uInActiveCount != 0)
 		 	    pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 
-            // adhoc mode:TSF updated only when beacon larger then local TSF
+            // adhoc mode:TSF updated only when beacon larger than local TSF
             if (bTSFLargeDiff && bTSFOffsetPostive &&
                 (pMgmt->eCurrState == WMAC_STATE_JOINTED))
                 bUpdateTSF = true;
@@ -2252,7 +2252,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
             // During dpc, already in spinlocked.
             if (BSSDBbIsSTAInNodeDB(pMgmt, sFrame.pHdr->sA3.abyAddr2, &uNodeIndex)) {
 
-                // Update the STA, (Techically the Beacons of all the IBSS nodes
+                // Update the STA, (Technically the Beacons of all the IBSS nodes
 		        // should be identical, but that's not happening in practice.
                 pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
                                                         (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
@@ -2305,7 +2305,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
 */
             }
 
-            // if other stations jointed, indicate connect to upper layer..
+            // if other stations joined, indicate connection to upper layer..
             if (pMgmt->eCurrState == WMAC_STATE_STARTED) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Current IBSS State: [Started]........to: [Jointed] \n");
                 pMgmt->eCurrState = WMAC_STATE_JOINTED;
@@ -3081,8 +3081,8 @@ s_vMgrSynchBSS (
                //   }
            // }
   //   if( uSameBssidNum>=2) {	 //we only check AP in hidden sssid  mode
-        if ((pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) ||           //networkmanager 0.7.0 does not give the pairwise-key selsection,
-             (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {         // so we need re-selsect it according to real pairwise-key info.
+        if ((pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) ||           //networkmanager 0.7.0 does not give the pairwise-key selection,
+             (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {         // so we need re-select it according to real pairwise-key info.
                if(pCurr->bWPAValid == true)  {   //WPA-PSK
                           pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
 		    if(pCurr->abyPKType[0] == WPA_TKIP) {
@@ -3193,7 +3193,7 @@ s_vMgrFormatTIM(
  *
  *
  * Return Value:
- *    PTR to frame; or NULL on allocation failue
+ *    PTR to frame; or NULL on allocation failure
  *
 -*/
 
@@ -3310,7 +3310,7 @@ s_MgrMakeBeacon(
             *((unsigned short *)(sFrame.pBuf + sFrame.len + sFrame.pRSNWPA->len))=0;
             sFrame.pRSNWPA->len +=2;
 
-            // RSN Capabilites
+            // RSN Capabilities
             *((unsigned short *)(sFrame.pBuf + sFrame.len + sFrame.pRSNWPA->len))=0;
             sFrame.pRSNWPA->len +=2;
             sFrame.len += sFrame.pRSNWPA->len + WLAN_IEHDR_LEN;
@@ -3420,7 +3420,7 @@ s_MgrMakeBeacon(
  *
  *
  * Return Value:
- *    PTR to frame; or NULL on allocation failue
+ *    PTR to frame; or NULL on allocation failure
  *
 -*/
 
@@ -3611,7 +3611,7 @@ s_MgrMakeProbeResponse(
  *
  *
  * Return Value:
- *    A ptr to frame or NULL on allocation failue
+ *    A ptr to frame or NULL on allocation failure
  *
 -*/
 
@@ -3652,7 +3652,7 @@ s_MgrMakeAssocRequest(
     memcpy( sFrame.pHdr->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
     memcpy( sFrame.pHdr->sA3.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
 
-    // Set the capibility and listen interval
+    // Set the capability and listen interval
     *(sFrame.pwCapInfo) = cpu_to_le16(wCurrCapInfo);
     *(sFrame.pwListenInterval) = cpu_to_le16(wListenInterval);
 
@@ -3762,7 +3762,7 @@ s_MgrMakeAssocRequest(
 
         sFrame.pRSNWPA->len +=6;
 
-        // RSN Capabilites
+        // RSN Capabilities
 
         *pbyRSN++=0x00;
         *pbyRSN++=0x00;
@@ -3831,7 +3831,7 @@ s_MgrMakeAssocRequest(
         }
         sFrame.pRSN->len +=6;
 
-        // RSN Capabilites
+        // RSN Capabilities
         if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == true) {
             memcpy(&sFrame.pRSN->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
         } else {
@@ -3886,7 +3886,7 @@ s_MgrMakeAssocRequest(
  *
  *
  * Return Value:
- *    A ptr to frame or NULL on allocation failue
+ *    A ptr to frame or NULL on allocation failure
  *
 -*/
 
@@ -3929,7 +3929,7 @@ s_MgrMakeReAssocRequest(
     memcpy( sFrame.pHdr->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
     memcpy( sFrame.pHdr->sA3.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
 
-    /* Set the capibility and listen interval */
+    /* Set the capability and listen interval */
     *(sFrame.pwCapInfo) = cpu_to_le16(wCurrCapInfo);
     *(sFrame.pwListenInterval) = cpu_to_le16(wListenInterval);
 
@@ -4019,7 +4019,7 @@ s_MgrMakeReAssocRequest(
 
         sFrame.pRSNWPA->len +=6;
 
-        // RSN Capabilites
+        // RSN Capabilities
         *pbyRSN++=0x00;
         *pbyRSN++=0x00;
         sFrame.pRSNWPA->len +=2;
@@ -4087,7 +4087,7 @@ s_MgrMakeReAssocRequest(
         }
         sFrame.pRSN->len +=6;
 
-        // RSN Capabilites
+        // RSN Capabilities
         if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == true) {
             memcpy(&sFrame.pRSN->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
         } else {
@@ -4138,7 +4138,7 @@ s_MgrMakeReAssocRequest(
  *
  *
  * Return Value:
- *    PTR to frame; or NULL on allocation failue
+ *    PTR to frame; or NULL on allocation failure
  *
 -*/
 
@@ -4212,7 +4212,7 @@ s_MgrMakeAssocResponse(
  *
  *
  * Return Value:
- *    PTR to frame; or NULL on allocation failue
+ *    PTR to frame; or NULL on allocation failure
  *
 -*/
 
@@ -4333,7 +4333,7 @@ s_vMgrRxProbeResponse(
             byIEChannel = sFrame.pDSParms->byCurrChannel;
         }
         if (byCurrChannel != byIEChannel) {
-            // adjust channel info. bcs we rcv adjcent channel pakckets
+            // adjust channel info. bcs we rcv adjacent channel packets
             bChannelHit = false;
             byCurrChannel = byIEChannel;
         }
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index e3ae562..bfa67ae 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -286,7 +286,7 @@ typedef struct tagSMgmtObject
     CMD_STATE               eCommandState;
     unsigned int	uScanChannel;
 
-    // Desire joinning BSS vars
+    // Desire joining BSS vars
     unsigned char abyDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
     unsigned char abyDesireBSSID[WLAN_BSSID_LEN];
 
@@ -310,7 +310,7 @@ typedef struct tagSMgmtObject
     unsigned int	uScanEndCh;
     unsigned short wScanSteps;
     unsigned int	uScanBSSType;
-    // Desire scannig vars
+    // Desire scanning vars
     unsigned char abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
     unsigned char abyScanBSSID[WLAN_BSSID_LEN];
 
diff --git a/drivers/staging/vt6655/wpa.c b/drivers/staging/vt6655/wpa.c
index 0afb9fe..4412fe9 100644
--- a/drivers/staging/vt6655/wpa.c
+++ b/drivers/staging/vt6655/wpa.c
@@ -229,7 +229,7 @@ WPA_ParseRSN (
  * Parameters:
  *  In:
  *      byCmd    - Search type
- *      byEncrypt- Encrcypt Type
+ *      byEncrypt- Encrypt Type
  *      pBSSList - BSS list
  *  Out:
  *      none
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
index 744799c..884db1a 100644
--- a/drivers/staging/vt6655/wpa2.c
+++ b/drivers/staging/vt6655/wpa2.c
@@ -175,16 +175,16 @@ WPA2vParseRSN (
                         pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_USE_GROUP;
                         bUseGK = true;
                     } else if ( !memcmp(pbyOUI, abyOUIWEP40, 4)) {
-                        // Invialid CSS, continue to parsing
+                        // Invalid CSS, continue to parsing
                     } else if ( !memcmp(pbyOUI, abyOUITKIP, 4)) {
                         if (pBSSNode->byCSSGK != WLAN_11i_CSS_CCMP)
                             pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_TKIP;
                         else
-                            ; // Invialid CSS, continue to parsing
+                            ; // Invalid CSS, continue to parsing
                     } else if ( !memcmp(pbyOUI, abyOUICCMP, 4)) {
                         pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_CCMP;
                     } else if ( !memcmp(pbyOUI, abyOUIWEP104, 4)) {
-                        // Invialid CSS, continue to parsing
+                        // Invalid CSS, continue to parsing
                     } else {
                         // any vendor checks here
                         pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_UNKNOWN;
@@ -329,7 +329,7 @@ WPA2uSetIEs(
         }
         pRSNIEs->len +=6;
 
-        // RSN Capabilites
+        // RSN Capabilities
         if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == true) {
             memcpy(&pRSNIEs->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
         } else {
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 732ba88..2b6ae1e 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -77,7 +77,7 @@ static void wpadev_setup(struct net_device *dev)
 
 /*
  * Description:
- *      register netdev for wpa supplicant deamon
+ *      register netdev for wpa supplicant daemon
  *
  * Parameters:
  *  In:
@@ -164,7 +164,7 @@ static int wpa_release_wpadev(PSDevice pDevice)
 
 /*
  * Description:
- *      Set enable/disable dev for wpa supplicant deamon
+ *      Set enable/disable dev for wpa supplicant daemon
  *
  * Parameters:
  *  In:
@@ -847,7 +847,7 @@ else
           if(!bWepEnabled)  pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 	else pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
             //pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-            //pMgmt->bShareKeyAlgorithm = false; //20080717-06,<Modify> by chester//Fix Open mode, WEP encrytion
+            //pMgmt->bShareKeyAlgorithm = false; //20080717-06,<Modify> by chester//Fix Open mode, WEP encryption
            }
 //mike save old encryption status
 	pDevice->eOldEncryptionStatus = pDevice->eEncryptionStatus;
diff --git a/drivers/staging/vt6655/wroute.c b/drivers/staging/vt6655/wroute.c
index 66e2eea..82e93cb 100644
--- a/drivers/staging/vt6655/wroute.c
+++ b/drivers/staging/vt6655/wroute.c
@@ -18,7 +18,7 @@
  *
  * File: wroute.c
  *
- * Purpose: handle WMAC frame relay & filterring
+ * Purpose: handle WMAC frame relay & filtering
  *
  * Author: Lyndon Chen
  *
-- 
1.7.9.5

