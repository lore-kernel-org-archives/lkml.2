Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2ETNdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:33:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50100 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2ETNdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:33:51 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging/wlan-ng: Fix checkpatch warnings
Date: Sun, 20 May 2012 19:03:44 +0530
Message-Id: <1337520824-23122-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x.h     |   30 +++++++++++++++---------------
 drivers/staging/wlan-ng/hfa384x_usb.c |    6 +++---
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index 5631ad0..04c0433 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -81,8 +81,8 @@
 #define		HFA384x_WEPFLAGS_EXCLUDE		((u16)BIT(1))
 #define		HFA384x_WEPFLAGS_DISABLE_TXCRYPT	((u16)BIT(4))
 #define		HFA384x_WEPFLAGS_DISABLE_RXCRYPT	((u16)BIT(7))
-#define 	HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM	((u16)3)
-#define 	HFA384x_PORTSTATUS_DISABLED		((u16)1)
+#define		HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM	((u16)3)
+#define		HFA384x_PORTSTATUS_DISABLED		((u16)1)
 #define		HFA384x_RATEBIT_1			((u16)1)
 #define		HFA384x_RATEBIT_2			((u16)2)
 #define		HFA384x_RATEBIT_5dot5			((u16)4)
@@ -164,7 +164,7 @@
 #define		HFA384x_CMDCODE_DOWNLD		((u16)0x22)
 
 /*--- Debugging Commands -----------------------------*/
-#define 	HFA384x_CMDCODE_MONITOR		((u16)(0x38))
+#define		HFA384x_CMDCODE_MONITOR		((u16)(0x38))
 #define		HFA384x_MONITOR_ENABLE		((u16)(0x0b))
 #define		HFA384x_MONITOR_DISABLE		((u16)(0x0f))
 
@@ -275,15 +275,15 @@ API ENHANCEMENTS (NOT ALREADY IMPLEMENTED)
 #define		HFA384x_RID_CNFAUTHENTICATION	((u16)0xFC2A)
 #define		HFA384x_RID_CNFROAMINGMODE	((u16)0xFC2D)
 #define		HFA384x_RID_CNFAPBCNint		((u16)0xFC33)
-#define		HFA384x_RID_CNFDBMADJUST  	((u16)0xFC46)
-#define		HFA384x_RID_CNFWPADATA       	((u16)0xFC48)
+#define		HFA384x_RID_CNFDBMADJUST	((u16)0xFC46)
+#define		HFA384x_RID_CNFWPADATA		((u16)0xFC48)
 #define		HFA384x_RID_CNFBASICRATES	((u16)0xFCB3)
 #define		HFA384x_RID_CNFSUPPRATES	((u16)0xFCB4)
 #define		HFA384x_RID_CNFPASSIVESCANCTRL	((u16)0xFCBA)
-#define		HFA384x_RID_TXPOWERMAX        	((u16)0xFCBE)
+#define		HFA384x_RID_TXPOWERMAX		((u16)0xFCBE)
 #define		HFA384x_RID_JOINREQUEST		((u16)0xFCE2)
 #define		HFA384x_RID_AUTHENTICATESTA	((u16)0xFCE3)
-#define		HFA384x_RID_HOSTSCAN          	((u16)0xFCE5)
+#define		HFA384x_RID_HOSTSCAN		((u16)0xFCE5)
 
 #define		HFA384x_RID_CNFWEPDEFAULTKEY_LEN	((u16)6)
 #define		HFA384x_RID_CNFWEP128DEFAULTKEY_LEN	((u16)14)
@@ -311,7 +311,7 @@ PD Record codes
 #define HFA384x_PDR_HFA3861_IFRF	((u16)0x0204)
 #define HFA384x_PDR_HFA3861_CHCALSP	((u16)0x0300)
 #define HFA384x_PDR_HFA3861_CHCALI	((u16)0x0301)
-#define HFA384x_PDR_MAX_TX_POWER  	((u16)0x0302)
+#define HFA384x_PDR_MAX_TX_POWER	((u16)0x0302)
 #define HFA384x_PDR_MASTER_CHAN_LIST	((u16)0x0303)
 #define HFA384x_PDR_3842_NIC_CONFIG	((u16)0x0400)
 #define HFA384x_PDR_USB_ID		((u16)0x0401)
@@ -322,10 +322,10 @@ PD Record codes
 #define HFA384x_PDR_USB_POWER_TYPE      ((u16)0x0407)
 #define HFA384x_PDR_USB_MAX_POWER	((u16)0x0409)
 #define HFA384x_PDR_USB_MANUFACTURER	((u16)0x0410)
-#define HFA384x_PDR_USB_PRODUCT  	((u16)0x0411)
-#define HFA384x_PDR_ANT_DIVERSITY   	((u16)0x0412)
-#define HFA384x_PDR_HFO_DELAY       	((u16)0x0413)
-#define HFA384x_PDR_SCALE_THRESH 	((u16)0x0414)
+#define HFA384x_PDR_USB_PRODUCT		((u16)0x0411)
+#define HFA384x_PDR_ANT_DIVERSITY	((u16)0x0412)
+#define HFA384x_PDR_HFO_DELAY		((u16)0x0413)
+#define HFA384x_PDR_SCALE_THRESH	((u16)0x0414)
 
 #define HFA384x_PDR_HFA3861_MANF_TESTSP	((u16)0x0900)
 #define HFA384x_PDR_HFA3861_MANF_TESTI	((u16)0x0901)
@@ -383,7 +383,7 @@ typedef struct hfa384x_caplevel {
 /*-- Configuration Record: cnfAuthentication --*/
 #define HFA384x_CNFAUTHENTICATION_OPENSYSTEM	0x0001
 #define HFA384x_CNFAUTHENTICATION_SHAREDKEY	0x0002
-#define HFA384x_CNFAUTHENTICATION_LEAP     	0x0004
+#define HFA384x_CNFAUTHENTICATION_LEAP		0x0004
 
 /*--------------------------------------------------------------------
 Configuration Record Structures:
@@ -575,8 +575,8 @@ Information Types
 #define		HFA384x_IT_AUTHREQ			((u16)0xF202UL)
 #define		HFA384x_IT_PSUSERCNT			((u16)0xF203UL)
 #define		HFA384x_IT_KEYIDCHANGED			((u16)0xF204UL)
-#define		HFA384x_IT_ASSOCREQ    			((u16)0xF205UL)
-#define		HFA384x_IT_MICFAILURE  			((u16)0xF206UL)
+#define		HFA384x_IT_ASSOCREQ			((u16)0xF205UL)
+#define		HFA384x_IT_MICFAILURE			((u16)0xF206UL)
 
 /*--------------------------------------------------------------------
 Information Frames Structures
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 7843dfd..858e905 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -171,11 +171,11 @@ static void hfa384x_ctlxout_callback(struct urb *urb);
 static void hfa384x_usbin_callback(struct urb *urb);
 
 static void
-hfa384x_usbin_txcompl(wlandevice_t *wlandev, hfa384x_usbin_t * usbin);
+hfa384x_usbin_txcompl(wlandevice_t *wlandev, hfa384x_usbin_t *usbin);
 
 static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb);
 
-static void hfa384x_usbin_info(wlandevice_t *wlandev, hfa384x_usbin_t * usbin);
+static void hfa384x_usbin_info(wlandevice_t *wlandev, hfa384x_usbin_t *usbin);
 
 static void
 hfa384x_usbout_tx(wlandevice_t *wlandev, hfa384x_usbout_t *usbout);
@@ -285,7 +285,7 @@ static inline const char *ctlxstr(CTLX_STATE s)
 	return ctlx_str[s];
 };
 
-static inline hfa384x_usbctlx_t *get_active_ctlx(hfa384x_t * hw)
+static inline hfa384x_usbctlx_t *get_active_ctlx(hfa384x_t *hw)
 {
 	return list_entry(hw->ctlxq.active.next, hfa384x_usbctlx_t, list);
 }
-- 
1.7.9.5

