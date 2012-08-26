Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2HZPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 11:16:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38642 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2HZPQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 11:16:56 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/3]NEXT:staging "vt6656" Fix typos in comments, and in a printk message.
Date: Sun, 26 Aug 2012 08:16:43 -0700
Message-Id: <1345994205-19044-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

Note: the following three patches need to be applied in order for the correct alignment of the patche(s).
The below patch fixes typos found while reading through staging "vt6656". these are only typos in comments
and in a couple of printk messages. patches 2 and 3 are actual code typos. if you choose to take them. 

 drivers/staging/vt6656/80211mgr.h |    4 ++--
 drivers/staging/vt6656/baseband.c |    4 ++--
 drivers/staging/vt6656/bssdb.c    |   18 +++++++++---------
 drivers/staging/vt6656/card.c     |   10 +++++-----
 drivers/staging/vt6656/device.h   |    2 +-
 drivers/staging/vt6656/dpc.c      |    2 +-
 drivers/staging/vt6656/hostap.c   |   10 +++++-----
 drivers/staging/vt6656/int.c      |    2 +-
 drivers/staging/vt6656/ioctl.c    |    4 ++--
 drivers/staging/vt6656/iwctl.c    |    2 +-
 drivers/staging/vt6656/key.c      |    4 ++--
 drivers/staging/vt6656/main_usb.c |   20 ++++++++++----------
 drivers/staging/vt6656/power.c    |    2 +-
 drivers/staging/vt6656/rf.c       |    4 ++--
 drivers/staging/vt6656/rxtx.c     |   10 +++++-----
 drivers/staging/vt6656/tcrc.c     |    2 +-
 drivers/staging/vt6656/tcrc.h     |    2 +-
 drivers/staging/vt6656/tether.c   |    4 ++--
 drivers/staging/vt6656/tkip.c     |    2 +-
 drivers/staging/vt6656/wcmd.c     |    6 +++---
 drivers/staging/vt6656/wctl.c     |    2 +-
 drivers/staging/vt6656/wmgr.c     |   20 ++++++++++----------
 drivers/staging/vt6656/wpa.c      |    2 +-
 drivers/staging/vt6656/wpa2.c     |    6 +++---
 drivers/staging/vt6656/wpactl.c   |    6 +++---
 25 files changed, 75 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/vt6656/80211mgr.h b/drivers/staging/vt6656/80211mgr.h
index 515b9c1..e5db73b 100644
--- a/drivers/staging/vt6656/80211mgr.h
+++ b/drivers/staging/vt6656/80211mgr.h
@@ -191,7 +191,7 @@
 
 
 //
-// Cipher Suite Selectors defiened in 802.11i
+// Cipher Suite Selectors defined in 802.11i
 //
 #define WLAN_11i_CSS_USE_GROUP              0
 #define WLAN_11i_CSS_WEP40                  1
@@ -720,7 +720,7 @@ typedef struct tagWLAN_FR_AUTHEN {
 
 } WLAN_FR_AUTHEN, *PWLAN_FR_AUTHEN;
 
-// Deauthenication
+// Deauthentication
 typedef struct tagWLAN_FR_DEAUTHEN {
 
     unsigned int                    uType;
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 06f27f6..b24605a 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -27,7 +27,7 @@
  *
  * Functions:
  *      BBuGetFrameTime        - Calculate data frame transmitting time
- *      BBvCaculateParameter   - Caculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
+ *      BBvCaculateParameter   - Calculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
  *      BBbVT3184Init          - VIA VT3184 baseband chip init code
  *      BBvLoopbackOn          - Turn on BaseBand Loopback mode
  *      BBvLoopbackOff         - Turn off BaseBand Loopback mode
@@ -741,7 +741,7 @@ BBuGetFrameTime (
 }
 
 /*
- * Description: Caculate Length, Service, and Signal fields of Phy for Tx
+ * Description: Calculate Length, Service, and Signal fields of Phy for Tx
  *
  * Parameters:
  *  In:
diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 0999367..2ac066d 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -226,7 +226,7 @@ PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
                 if (pSelect == NULL) {
                     pSelect = pCurrBSS;
                 } else {
-                    // compare RSSI, select signal strong one
+                    // compare RSSI, select the strongest signal 
                     if (pCurrBSS->uRSSI < pSelect->uRSSI) {
                         pSelect = pCurrBSS;
                     }
@@ -274,9 +274,9 @@ void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID)
             if (pMgmt->sBSSList[ii].bActive &&
 		!compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
 				    pMgmt->abyCurrBSSID)) {
- //mike mark: there are two same BSSID in list if that AP is in hidden ssid mode,one 's SSID is null,
- //                 but other's is obvious, so if it acssociate with your STA  exactly,you must keep two
- //                 of them!!!!!!!!!
+ //mike mark: there are two BSSID's in list. If that AP is in hidden ssid mode, one SSID is null,
+ //                 but other's might not be obvious, so if it associate's with your STA,
+ //                 you must keep the two of them!!
                // bKeepCurrBSSID = FALSE;
                 continue;
             }
@@ -489,7 +489,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
     }
 
     if (pDevice->bUpdateBBVGA) {
-        // Moniter if RSSI is too strong.
+        // Monitor if RSSI is too strong.
         pBSSList->byRSSIStatCnt = 0;
         RFvRSSITodBm(pDevice, (BYTE)(pRxPacket->uRSSI), &pBSSList->ldBmMAX);
         pBSSList->ldBmAverage[0] = pBSSList->ldBmMAX;
@@ -621,7 +621,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
 
     if (pRxPacket->uRSSI != 0) {
         RFvRSSITodBm(pDevice, (BYTE)(pRxPacket->uRSSI), &ldBm);
-        // Moniter if RSSI is too strong.
+        // Monitor if RSSI is too strong.
         pBSSList->byRSSIStatCnt++;
         pBSSList->byRSSIStatCnt %= RSSI_STAT_COUNT;
         pBSSList->ldBmAverage[pBSSList->byRSSIStatCnt] = ldBm;
@@ -687,8 +687,8 @@ BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
 /*+
  *
  * Routine Description:
- *    Find an empty node and allocated; if no empty found,
- *    instand used of most inactive one.
+ *    Find an empty node and allocate it; if no empty node
+ *    is found, then use the most inactive one.
  *
  * Return Value:
  *    None
@@ -718,7 +718,7 @@ void BSSvCreateOneNode(void *hDeviceContext, unsigned int *puNodeIndex)
         }
     }
 
-    // if not found replace uInActiveCount is largest one.
+    // if not found replace uInActiveCount with the largest one.
     if ( ii == (MAX_NODE_NUM + 1)) {
         *puNodeIndex = SelectIndex;
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Replace inactive node = %d\n", SelectIndex);
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index e3ddc0b..694e648 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
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
@@ -40,7 +40,7 @@
  *
  * Revision History:
  *      06-10-2003 Bryan YC Fan:  Re-write codes to support VT3253 spec.
- *      08-26-2003 Kyle Hsu:      Modify the defination type of dwIoBase.
+ *      08-26-2003 Kyle Hsu:      Modify the definition type of dwIoBase.
  *      09-01-2003 Bryan YC Fan:  Add vUpdateIFS().
  *
  */
@@ -200,7 +200,7 @@ static WORD swGetOFDMControlRate(void *pDeviceHandler, WORD wRateIdx)
 }
 
 /*
- * Description: Caculate TxRate and RsvTime fields for RSPINF in OFDM mode.
+ * Description: Calculate TxRate and RsvTime fields for RSPINF in OFDM mode.
  *
  * Parameters:
  *  In:
@@ -640,7 +640,7 @@ BYTE CARDbyGetPktType(void *pDeviceHandler)
 
 
 /*
- * Description: Caculate TSF offset of two TSF input
+ * Description: Calculate TSF offset of two TSF input
  *              Get TSF Offset from RxBCN's TSF and local TSF
  *
  * Parameters:
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 171dd68..6370d10 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -478,7 +478,7 @@ typedef struct __device_info {
     unsigned int                        cbTD;
 
     //
-    //  Variables to track resources for the Interript In Pipe
+    //  Variables to track resources for the Interrupt In Pipe
     //
     INT_BUFFER                  intBuf;
     BOOL                        fKillEventPollingThread;
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index e4bdf2a..220bec8 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -748,7 +748,7 @@ RXbBulkInProcessData (
     if ((*pbyRSSI != 0) &&
         (pMgmt->pCurrBSS!=NULL)) {
         RFvRSSITodBm(pDevice, *pbyRSSI, &ldBm);
-        // Moniter if RSSI is too strong.
+        // Monitor if RSSI is too strong.
         pMgmt->pCurrBSS->byRSSIStatCnt++;
         pMgmt->pCurrBSS->byRSSIStatCnt %= RSSI_STAT_COUNT;
         pMgmt->pCurrBSS->ldBmAverage[pMgmt->pCurrBSS->byRSSIStatCnt] = ldBm;
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 9f2ca17..6106040 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -18,7 +18,7 @@
  *
  * File: hostap.c
  *
- * Purpose: handle hostap deamon ioctl input/out functions
+ * Purpose: handle hostap daemon ioctl input/out functions
  *
  * Author: Lyndon Chen
  *
@@ -48,7 +48,7 @@ static int          msglevel                =MSG_LEVEL_INFO;
 
 /*
  * Description:
- *      register net_device (AP) for hostap deamon
+ *      register net_device (AP) for hostap daemon
  *
  * Parameters:
  *  In:
@@ -176,7 +176,7 @@ int vt6656_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
 
 /*
  * Description:
- *      remove station function supported for hostap deamon
+ *      remove station function supported for hostap daemon
  *
  * Parameters:
  *  In:
@@ -204,7 +204,7 @@ static int hostap_remove_sta(PSDevice pDevice,
 
 /*
  * Description:
- *      add a station from hostap deamon
+ *      add a station from hostap daemon
  *
  * Parameters:
  *  In:
@@ -686,7 +686,7 @@ static int hostap_get_encryption(PSDevice pDevice,
 
 /*
  * Description:
- *      vt6656_hostap_ioctl main function supported for hostap deamon.
+ *      vt6656_hostap_ioctl main function supported for hostap daemon.
  *
  * Parameters:
  *  In:
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index eba4b50..bba31ca 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -149,7 +149,7 @@ void INTnsProcessData(PSDevice pDevice)
 					pMgmt->sNodeDBTable[0].bRxPSPoll =
 						FALSE;
 				} else if (pMgmt->byDTIMCount == 0) {
-					/* check if mutltcast tx bufferring */
+					/* check if multicast tx buffering */
 					pMgmt->byDTIMCount =
 						pMgmt->byDTIMPeriod-1;
 					pMgmt->sNodeDBTable[0].bRxPSPoll = TRUE;
diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index d67b29f..b6af5f6 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -617,7 +617,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			result = -EFAULT;
 			break;
 		}
-		/* for some AP maybe good authenticate */
+		/* for some AP's maybe a good authentication */
 		if (wpa_Result.key_mgmt == 0x20)
 			pMgmt->Cisco_cckm = 1;
 		else
@@ -641,7 +641,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		break;
 
 	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Private command not support..\n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Private command not supported..\n");
 	}
 
 	return result;
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 8b9894b..8f19874 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -674,7 +674,7 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 			jj++;
 		}
 
-		wrq->flags = 1; // Should be define'd
+		wrq->flags = 1; // Should be defined
 		wrq->length = jj;
 		memcpy(extra, sock, sizeof(struct sockaddr) * jj);
 		memcpy(extra + sizeof(struct sockaddr) * jj, qual, sizeof(struct iw_quality) * jj);
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index ee62a06..a61fcb9 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -403,7 +403,7 @@ BOOL KeybRemoveKey(
     BOOL    bReturnValue = FALSE;
 
     if (is_broadcast_ether_addr(pbyBSSID)) {
-        // dealte all key
+        // delete all keys
         if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
             for (i=0;i<MAX_KEY_TABLE;i++) {
                 pTable->KeyTable[i].PairwiseKey.bKeyValid = FALSE;
@@ -618,7 +618,7 @@ BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyType,
 
 
 /*
- * Description: Check Pairewise Key
+ * Description: Check Pairwise Key
  *
  * Parameters:
  *  In:
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d536756..ad422de 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -29,14 +29,14 @@
  *   vt6656_probe - module initial (insmod) driver entry
  *   device_remove1 - module remove entry
  *   device_open - allocate dma/descripter resource & initial mac/bbp function
- *   device_xmit - asynchrous data tx function
+ *   device_xmit - asynchronous data tx function
  *   device_set_multi - set mac filter
  *   device_ioctl - ioctl entry
- *   device_close - shutdown mac/bbp & free dma/descripter resource
+ *   device_close - shutdown mac/bbp & free dma/descriptor resource
  *   device_alloc_frag_buf - rx fragement pre-allocated function
  *   device_free_tx_bufs - free tx buffer function
  *   device_dma0_tx_80211- tx 802.11 frame via dma0
- *   device_dma0_xmit- tx PS bufferred frame via dma0
+ *   device_dma0_xmit- tx PS buffered frame via dma0
  *   device_init_registers- initial MAC & BBP & RF internal registers.
  *   device_init_rings- initial tx/rx ring buffer
  *   device_init_defrag_cb- initial & allocate de-fragement buffer.
@@ -316,7 +316,7 @@ static void device_init_diversity_timer(PSDevice pDevice)
 
 
 //
-// Initialiation of MAC & BBP registers
+// Initialization of MAC & BBP registers
 //
 
 static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
@@ -639,7 +639,7 @@ static BOOL device_release_WPADEV(PSDevice pDevice)
   viawget_wpa_header *wpahdr;
   int ii=0;
  // wait_queue_head_t	Set_wait;
-  //send device close to wpa_supplicnat layer
+  //send device close to wpa_supplicant layer
     if (pDevice->bWPADEVUp==TRUE) {
                  wpahdr = (viawget_wpa_header *)pDevice->skb->data;
                  wpahdr->type = VIAWGET_DEVICECLOSE_MSG;
@@ -1010,7 +1010,7 @@ static int  device_open(struct net_device *dev) {
     }
 
     if (device_init_defrag_cb(pDevice)== FALSE) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Initial defragement cb fail \n");
+        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Initial defragment cb fail \n");
         goto free_rx_tx;
     }
 
@@ -1296,7 +1296,7 @@ static inline u32 ether_crc(int length, unsigned char *data)
     return crc;
 }
 
-//find out  the start  position of str2 from str1
+//find out the start  position of str2 from str1
 static unsigned char *kstrstr(const unsigned char *str1,
 			      const unsigned char *str2) {
   int str1_len = strlen(str1);
@@ -1345,7 +1345,7 @@ static int Config_FileGetParameter(unsigned char *string,
        }
 
    memset(buf2,0,100);
-   memcpy(buf2,start_p,end_p-start_p);    //get the tartget line
+   memcpy(buf2,start_p,end_p-start_p);    //get the target line
    buf2[end_p-start_p]='\0';
 
    //find value
@@ -1396,7 +1396,7 @@ static unsigned char *Config_FileOperation(PSDevice pDevice)
 	  }
 
      if(!(filp->f_op) || !(filp->f_op->read) ||!(filp->f_op->write)) {
-           printk("file %s cann't readable or writable?\n",config_path);
+           printk("file %s is not read or writeable?\n",config_path);
 	  result = -1;
 	  goto error1;
      	}
@@ -1969,7 +1969,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
 	default:
 		rc = -EOPNOTSUPP;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Ioctl command not support..%x\n", cmd);
+        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Ioctl command not supported..%x\n", cmd);
 
 
     }
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index b313677..ab3a554 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -19,7 +19,7 @@
  *
  * File: power.c
  *
- * Purpose: Handles 802.11 power management  functions
+ * Purpose: Handles 802.11 power management functions
  *
  * Author: Lyndon Chen
  *
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index c82b3e6..6205e65 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -1048,7 +1048,7 @@ BYTE    abyArray[256];
                     wLength1,
                     abyArray
                     );
-    //Channle Table 0
+    //Channel Table 0
     wValue = 0;
     while ( wLength2 > 0 ) {
 
@@ -1106,7 +1106,7 @@ BYTE    abyArray[256];
                     wLength1,
                     abyArray);
 
-        //Channle Table 0
+        //Channel Table 0
         wValue = 0;
         while ( wLength2 > 0 ) {
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index dd28b91..46e62f4 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1827,7 +1827,7 @@ s_bPacketToWirelessUsb(
  *
  * Parameters:
  *  In:
- *      pDevice         - Pointer to adpater
+ *      pDevice         - Pointer to adapter
  *      dwTxBufferAddr  - Transmit Buffer
  *      pPacket         - Packet from upper layer
  *      cbPacketSize    - Transmit Data Length
@@ -2198,7 +2198,7 @@ CMD_STATUS csMgmt_xmit(
 
     if (bIsPSPOLL) {
         // The MAC will automatically replace the Duration-field of MAC header by Duration-field
-        // of  FIFO control header.
+        // of FIFO control header.
         // This will cause AID-field of PS-POLL packet be incorrect (Because PS-POLL's AID field is
         // in the same place of other packet's Duration-field).
         // And it will cause Cisco-AP to issue Disassociation-packet
@@ -2473,7 +2473,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
         cbMacHdLen = WLAN_HDR_ADDR3_LEN;
     }
 
-    // hostapd deamon ext support rate patch
+    // hostapd daemon ext support rate patch
     if (WLAN_GET_FC_FSTYPE(p80211Header->sA4.wFrameCtl) == WLAN_FSTYPE_ASSOCRESP) {
 
         if (((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates)->len != 0) {
@@ -2591,7 +2591,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
     pMACHeader->wFrameCtl &= cpu_to_le16(0xfffc);
     memcpy(pbyPayloadHead, (skb->data + cbMacHdLen), cbFrameBodySize);
 
-    // replace support rate, patch for hostapd deamon( only support 11M)
+    // replace support rate, patch for hostapd daemon( only support 11M)
     if (WLAN_GET_FC_FSTYPE(p80211Header->sA4.wFrameCtl) == WLAN_FSTYPE_ASSOCRESP) {
         if (cbExtSuppRate != 0) {
             if (((PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates)->len != 0)
@@ -2855,7 +2855,7 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uDMAIdx, struct sk_buff *skb)
 			  }
 			  PRINT_K("Authentication completed!!\n");
                         }
-		    else if((Key_info & BIT3) && (Descriptor_type==2) &&  //RSN pairse-key challenge
+		    else if((Key_info & BIT3) && (Descriptor_type==2) &&  //RSN pairwise-key challenge
 			       (Key_info & BIT8) && (Key_info & BIT9)) {
 			  pDevice->fWPA_Authened = TRUE;
                             PRINT_K("WPA2 Authentication completed!!\n");
diff --git a/drivers/staging/vt6656/tcrc.c b/drivers/staging/vt6656/tcrc.c
index e25021e..2237eeb 100644
--- a/drivers/staging/vt6656/tcrc.c
+++ b/drivers/staging/vt6656/tcrc.c
@@ -18,7 +18,7 @@
  *
  * File: tcrc.c
  *
- * Purpose: Implement functions to caculate CRC
+ * Purpose: Implement functions to calculate CRC
  *
  * Author: Tevin Chen
  *
diff --git a/drivers/staging/vt6656/tcrc.h b/drivers/staging/vt6656/tcrc.h
index 4dfd01e..dc54bd8 100644
--- a/drivers/staging/vt6656/tcrc.h
+++ b/drivers/staging/vt6656/tcrc.h
@@ -18,7 +18,7 @@
  *
  * File: tcrc.h
  *
- * Purpose: Implement functions to caculate CRC
+ * Purpose: Implement functions to calculate CRC
  *
  * Author: Tevin Chen
  *
diff --git a/drivers/staging/vt6656/tether.c b/drivers/staging/vt6656/tether.c
index 4f368f1..083b215 100644
--- a/drivers/staging/vt6656/tether.c
+++ b/drivers/staging/vt6656/tether.c
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
diff --git a/drivers/staging/vt6656/tkip.c b/drivers/staging/vt6656/tkip.c
index 0715636..003123e 100644
--- a/drivers/staging/vt6656/tkip.c
+++ b/drivers/staging/vt6656/tkip.c
@@ -168,7 +168,7 @@ static unsigned int rotr1(unsigned int a)
 
 
 /*
- * Description: Caculate RC4Key fom TK, TA, and TSC
+ * Description: Calculate RC4Key fom TK, TA, and TSC
  *
  * Parameters:
  *  In:
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 23ed03c..586fbe1 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -263,7 +263,7 @@ s_vProbeChannel(
  *
  *
  * Return Value:
- *    A ptr to Tx frame or NULL on allocation failue
+ *    A ptr to Tx frame or NULL on allocation failure
  *
 -*/
 
@@ -794,7 +794,7 @@ void vRunCommand(void *hDeviceContext)
 			DBG_PRT(MSG_LEVEL_DEBUG,
 				KERN_INFO "vMgrCreateOwnIBSS fail!\n");
                 }
-                // alway turn off unicast bit
+                // always turn off unicast bit
                 MACvRegBitsOff(pDevice, MAC_REG_RCR, RCR_UNICAST);
                 pDevice->byRxMode &= ~RCR_UNICAST;
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wcmd: rx_mode = %x\n", pDevice->byRxMode );
@@ -946,7 +946,7 @@ void vRunCommand(void *hDeviceContext)
                   pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
                   pItemSSID->len = 0;
                   memset(pItemSSID->abySSID, 0, WLAN_SSID_MAXLEN);
-                //clear dessire SSID
+                //clear desired SSID
                 pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
                 pItemSSID->len = 0;
                 memset(pItemSSID->abySSID, 0, WLAN_SSID_MAXLEN);
diff --git a/drivers/staging/vt6656/wctl.c b/drivers/staging/vt6656/wctl.c
index c231ae7..9249263 100644
--- a/drivers/staging/vt6656/wctl.c
+++ b/drivers/staging/vt6656/wctl.c
@@ -89,7 +89,7 @@ BOOL WCTLbIsDuplicate (PSCache pCache, PS802_11Header pMACHeader)
             ADD_ONE_WITH_WRAP_AROUND(uIndex, DUPLICATE_RX_CACHE_LENGTH);
         }
     }
-    /* Not fount in cache - insert */
+    /* Not found in cache - insert */
     pCacheEntry = &pCache->asCacheEntry[pCache->uInPtr];
     pCacheEntry->wFmSequence = pMACHeader->wSeqCtl;
     memcpy(&(pCacheEntry->abyAddr2[0]), &(pMACHeader->abyAddr2[0]), ETH_ALEN);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 9469c9e..7db6a8d 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -27,7 +27,7 @@
  *
  * Functions:
  *      nsMgrObjectInitial - Initialize Management Objet data structure
- *      vMgrObjectReset - Reset Management Objet data structure
+ *      vMgrObjectReset - Reset Management Object data structure
  *      vMgrAssocBeginSta - Start associate function
  *      vMgrReAssocBeginSta - Start reassociate function
  *      vMgrDisassocBeginSta - Start disassociate function
@@ -2188,7 +2188,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
             // During dpc, already in spinlocked.
             if (BSSbIsSTAInNodeDB(pDevice, sFrame.pHdr->sA3.abyAddr2, &uNodeIndex)) {
 
-                // Update the STA, (Techically the Beacons of all the IBSS nodes
+                // Update the STA, (Technically the Beacons of all the IBSS nodes
 		        // should be identical, but that's not happening in practice.
                 pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)sFrame.pSuppRates,
                                                         (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
@@ -2722,7 +2722,7 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
             memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
 
             // Add current BSS to Candidate list
-            // This should only works for WPA2 BSS, and WPA2 BSS check must be done before.
+            // This should only work for WPA2 BSS, and WPA2 BSS check must be done before.
             if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2) {
 		BOOL bResult = bAdd_PMKID_Candidate((void *) pDevice,
 						    pMgmt->abyCurrBSSID,
@@ -3181,7 +3181,7 @@ s_vMgrFormatTIM(
  *
  *
  * Return Value:
- *    PTR to frame; or NULL on allocation failue
+ *    PTR to frame; or NULL on allocation failure
  *
 -*/
 
@@ -3353,7 +3353,7 @@ s_MgrMakeBeacon(
  *
  *
  * Return Value:
- *    PTR to frame; or NULL on allocation failue
+ *    PTR to frame; or NULL on allocation failure
  *
 -*/
 
@@ -3528,7 +3528,7 @@ s_MgrMakeAssocRequest(
     memcpy( sFrame.pHdr->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
     memcpy( sFrame.pHdr->sA3.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
 
-    // Set the capibility and listen interval
+    // Set the capability and listen interval
     *(sFrame.pwCapInfo) = cpu_to_le16(wCurrCapInfo);
     *(sFrame.pwListenInterval) = cpu_to_le16(wListenInterval);
 
@@ -3749,7 +3749,7 @@ s_MgrMakeAssocRequest(
  *
  *
  * Return Value:
- *    A ptr to frame or NULL on allocation failue
+ *    A ptr to frame or NULL on allocation failure
  *
 -*/
 
@@ -3792,7 +3792,7 @@ s_MgrMakeReAssocRequest(
     memcpy( sFrame.pHdr->sA3.abyAddr2, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
     memcpy( sFrame.pHdr->sA3.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
 
-    /* Set the capibility and listen interval */
+    /* Set the capability and listen interval */
     *(sFrame.pwCapInfo) = cpu_to_le16(wCurrCapInfo);
     *(sFrame.pwListenInterval) = cpu_to_le16(wListenInterval);
 
@@ -4004,7 +4004,7 @@ s_MgrMakeReAssocRequest(
  *
  *
  * Return Value:
- *    PTR to frame; or NULL on allocation failue
+ *    PTR to frame; or NULL on allocation failure
  *
 -*/
 
@@ -4077,7 +4077,7 @@ s_MgrMakeAssocResponse(
  *
  *
  * Return Value:
- *    PTR to frame; or NULL on allocation failue
+ *    PTR to frame; or NULL on allocation failure
  *
 -*/
 
diff --git a/drivers/staging/vt6656/wpa.c b/drivers/staging/vt6656/wpa.c
index b16d4dd..f6429a2 100644
--- a/drivers/staging/vt6656/wpa.c
+++ b/drivers/staging/vt6656/wpa.c
@@ -231,7 +231,7 @@ WPA_ParseRSN(
  * Parameters:
  *  In:
  *      byCmd    - Search type
- *      byEncrypt- Encrcypt Type
+ *      byEncrypt- Encrypt Type
  *      pBSSList - BSS list
  *  Out:
  *      none
diff --git a/drivers/staging/vt6656/wpa2.c b/drivers/staging/vt6656/wpa2.c
index d4f3f75..c092697 100644
--- a/drivers/staging/vt6656/wpa2.c
+++ b/drivers/staging/vt6656/wpa2.c
@@ -174,16 +174,16 @@ WPA2vParseRSN (
                         pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_USE_GROUP;
                         bUseGK = TRUE;
                     } else if ( !memcmp(pbyOUI, abyOUIWEP40, 4)) {
-                        // Invialid CSS, continue to parsing
+                        // Invalid CSS, continue parsing
                     } else if ( !memcmp(pbyOUI, abyOUITKIP, 4)) {
                         if (pBSSNode->byCSSGK != WLAN_11i_CSS_CCMP)
                             pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_TKIP;
                         else
-                            ; // Invialid CSS, continue to parsing
+                            ; // Invalid CSS, continue parsing
                     } else if ( !memcmp(pbyOUI, abyOUICCMP, 4)) {
                         pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_CCMP;
                     } else if ( !memcmp(pbyOUI, abyOUIWEP104, 4)) {
-                        // Invialid CSS, continue to parsing
+                        // Invalid CSS, continue parsing
                     } else {
                         // any vendor checks here
                         pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_UNKNOWN;
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 5435e82..3e65aa1 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -74,7 +74,7 @@ static void wpadev_setup(struct net_device *dev)
 
 /*
  * Description:
- *      register netdev for wpa supplicant deamon
+ *      register netdev for wpa supplicant daemon
  *
  * Parameters:
  *  In:
@@ -154,7 +154,7 @@ static int wpa_release_wpadev(PSDevice pDevice)
 
 /*
  * Description:
- *      Set enable/disable dev for wpa supplicant deamon
+ *      Set enable/disable dev for wpa supplicant daemon
  *
  * Parameters:
  *  In:
@@ -326,7 +326,7 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
 	if ((byKeyDecMode == KEY_CTL_TKIP) &&
 		(param->u.wpa_key.key_len != MAX_KEY_LEN)) {
 		// TKIP Key must be 256 bits
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return- TKIP Key must be 256 bits!\n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return - TKIP Key must be 256 bits!\n");
 		return -EINVAL;
     }
 	// Check AES key length
-- 
1.7.9.5

