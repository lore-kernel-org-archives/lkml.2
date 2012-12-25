Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2LYQau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 11:30:50 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46196 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2LYQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 11:30:49 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] staging: vt6655: Fix typo in vt6655 driver
Date: Wed, 26 Dec 2012 01:23:29 +0900
Message-Id: <1356452609-11583-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.1.rc2.38.gb10c4ad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in comments within vt6655 driver.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 6 +++---
 drivers/staging/vt6655/wcmd.c | 2 +-
 drivers/staging/vt6655/wmgr.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 875ee44..d66854f 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -2421,7 +2421,7 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
     pTxBufHead->wFragCtl |= cpu_to_le16((unsigned short)(cbMacHdLen << 10));
 
     // Notes:
-    // Although spec says MMPDU can be fragmented; In most case,
+    // Although spec says MMPDU can be fragmented; In most cases,
     // no one will send a MMPDU under fragmentation. With RTS may occur.
     pDevice->bAES = false;  //Set FRAGCTL_WEPTYP
 
@@ -2510,7 +2510,7 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket) {
         pbyPayloadHead = (unsigned char *)(pbyTxBufferAddr + cbHeaderSize + cbMacHdLen + uPadding + cbIVlen);
 
         //Fill TXKEY
-        //Kyle: Need fix: TKIP and AES did't encryt Mnt Packet.
+        //Kyle: Need fix: TKIP and AES did't encrypt Mnt Packet.
         //s_vFillTxKey(pDevice, (unsigned char *)pTxBufHead->adwTxKey, NULL);
 
         //Fill IV(ExtIV,RSNHDR)
@@ -2957,7 +2957,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
     pTxBufHead->wFragCtl |= cpu_to_le16((unsigned short)cbMacHdLen << 10);
 
     // Notes:
-    // Although spec says MMPDU can be fragmented; In most casses,
+    // Although spec says MMPDU can be fragmented; In most cases,
     // no one will send a MMPDU under fragmentation. With RTS may occur.
     pDevice->bAES = false;  //Set FRAGCTL_WEPTYP
 
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 6d0b87a..101c735 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -720,7 +720,7 @@ printk("chester-abyDesireSSID=%s\n",((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySS
                       pDevice->nTxDataTimeCout = 0;
 		 }
 		 else {
-		   // printk("mike:-->First time triger TimerTxData InSleep\n");
+		   // printk("mike:-->First time trigger TimerTxData InSleep\n");
 		 }
 		pDevice->IsTxDataTrigger = true;
                 add_timer(&pDevice->sTimerTxData);
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index b6f99ec..b08a611 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -2068,7 +2068,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
 
         if (pBSSList != NULL) {
 
-            // Compare PHY paramater setting
+            // Compare PHY parameter setting
             if (pMgmt->wCurrCapInfo != pBSSList->wCapInfo) {
                 bUpdatePhyParameter = true;
                 pMgmt->wCurrCapInfo = pBSSList->wCapInfo;
-- 
1.8.1.rc2.38.gb10c4ad

