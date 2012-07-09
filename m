Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2GICAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:00:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55309 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2GIB7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 21:59:53 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 4/5] staging: vt6656: Remove all commented macros
Date: Sun,  8 Jul 2012 22:55:49 -0300
Message-Id: <1341798950-11215-5-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros were reported by forgotten-macros tool
(https://github.com/marcosps/forgotten_macros).

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6656/80211hdr.h |    2 --
 drivers/staging/vt6656/bssdb.h    |    2 --
 drivers/staging/vt6656/card.h     |    1 -
 drivers/staging/vt6656/device.h   |    4 ----
 drivers/staging/vt6656/main_usb.c |    5 -----
 drivers/staging/vt6656/mib.h      |    1 -
 drivers/staging/vt6656/tether.h   |    2 --
 drivers/staging/vt6656/usbpipe.c  |    3 ---
 8 files changed, 20 deletions(-)

diff --git a/drivers/staging/vt6656/80211hdr.h b/drivers/staging/vt6656/80211hdr.h
index 15c6ef1..b87d543 100644
--- a/drivers/staging/vt6656/80211hdr.h
+++ b/drivers/staging/vt6656/80211hdr.h
@@ -78,7 +78,6 @@
 #define WLAN_HDR_ADDR4_LEN          30
 #define WLAN_IEHDR_LEN              2
 #define WLAN_SSID_MAXLEN            32
-/* #define WLAN_RATES_MAXLEN           255 */
 #define WLAN_RATES_MAXLEN           16
 #define WLAN_RATES_MAXLEN_11B       4
 #define WLAN_RSN_MAXLEN             32
@@ -104,7 +103,6 @@
 #define WLAN_WEP40_KEYLEN           5
 #define WLAN_WEP104_KEYLEN          13
 #define WLAN_WEP232_KEYLEN          29
-/* #define WLAN_WEPMAX_KEYLEN          29 */
 #define WLAN_WEPMAX_KEYLEN          32
 #define WLAN_CHALLENGE_IE_MAXLEN    255
 #define WLAN_CHALLENGE_IE_LEN       130
diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
index a8f97eb..6b2ec39 100644
--- a/drivers/staging/vt6656/bssdb.h
+++ b/drivers/staging/vt6656/bssdb.h
@@ -64,8 +64,6 @@
 // send and receive non-IEEE 802.1X frames
 #define WLAN_STA_AUTHORIZED      BIT5
 
-//#define MAX_RATE            12
-
 #define MAX_WPA_IE_LEN      64
 
 
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 9cf71a3..55962b1 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -52,7 +52,6 @@ typedef enum _CARD_OP_MODE {
 } CARD_OP_MODE, *PCARD_OP_MODE;
 
 #define CB_MAX_CHANNEL_24G  14
-/* #define CB_MAX_CHANNEL_5G   24 */
 #define CB_MAX_CHANNEL_5G       42 /* add channel9(5045MHz), 41==>42 */
 #define CB_MAX_CHANNEL      (CB_MAX_CHANNEL_24G+CB_MAX_CHANNEL_5G)
 
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f1496ec..171dd68 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -106,10 +106,6 @@
 #define MAX_MULTICAST_ADDRESS_NUM       32
 #define MULTICAST_ADDRESS_LIST_SIZE     (MAX_MULTICAST_ADDRESS_NUM * ETH_ALEN)
 
-//#define OP_MODE_INFRASTRUCTURE  0
-//#define OP_MODE_ADHOC           1
-//#define OP_MODE_AP              2
-
 #define DUPLICATE_RX_CACHE_LENGTH       5
 
 #define NUM_KEY_ENTRY                   11
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 5048341..b06fd5b 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -205,11 +205,6 @@ static const long frequency_list[] = {
 	};
 
 
-#ifndef IW_ENCODE_NOKEY
-#define IW_ENCODE_NOKEY         0x0800
-#define IW_ENCODE_MODE  (IW_ENCODE_DISABLED | IW_ENCODE_RESTRICTED | IW_ENCODE_OPEN)
-#endif
-
 static const struct iw_handler_def	iwctl_handler_def;
 */
 
diff --git a/drivers/staging/vt6656/mib.h b/drivers/staging/vt6656/mib.h
index a89cca0..82d69a9 100644
--- a/drivers/staging/vt6656/mib.h
+++ b/drivers/staging/vt6656/mib.h
@@ -113,7 +113,6 @@ typedef struct tagSMib2Counter {
 } SMib2Counter, *PSMib2Counter;
 
 // Value in the ifType entry
-//#define ETHERNETCSMACD      6           //
 #define WIRELESSLANIEEE80211b      6           //
 
 // Value in the ifAdminStatus/ifOperStatus entry
diff --git a/drivers/staging/vt6656/tether.h b/drivers/staging/vt6656/tether.h
index 4ec0523..8c1f5d2 100644
--- a/drivers/staging/vt6656/tether.h
+++ b/drivers/staging/vt6656/tether.h
@@ -72,7 +72,6 @@
 #define TYPE_CTL_ACK        0xd400
 
 
-//#define WEP_IV_MASK         0xFFFFFF00
 
 #else //if LITTLE_ENDIAN
 //
@@ -111,7 +110,6 @@
 #define TYPE_CTL_ACK        0x00d4
 
 
-//#define WEP_IV_MASK         0x00FFFFFF
 
 #endif //#ifdef __BIG_ENDIAN
 
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index c612ab5..609e8fa 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -52,9 +52,6 @@
 //endpoint 2: read bulk
 //endpoint 3: write bulk
 
-//RequestType:
-//#define REQUEST_OUT       (USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE) // 0x40
-//#define REQUEST_IN        (USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE )  //0xc0
 //static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =MSG_LEVEL_INFO;
 
-- 
1.7.10.4

