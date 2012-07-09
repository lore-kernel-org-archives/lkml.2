Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2GICyt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:54:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41690 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2GICyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:54:46 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 5/6] staging: vt6655: Remove all commented macros
Date: Sun,  8 Jul 2012 23:51:25 -0300
Message-Id: <1341802286-28281-6-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros were reported by forgotten-macros tool
(https://github.com/marcosps/forgotten_macros).

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6655/80211hdr.h    |    2 --
 drivers/staging/vt6655/baseband.c    |    2 --
 drivers/staging/vt6655/bssdb.c       |    1 -
 drivers/staging/vt6655/desc.h        |   11 -----------
 drivers/staging/vt6655/device.h      |   15 ---------------
 drivers/staging/vt6655/device_main.c |    4 ----
 drivers/staging/vt6655/dpc.c         |    1 -
 drivers/staging/vt6655/mib.h         |    2 --
 drivers/staging/vt6655/rf.h          |    1 -
 drivers/staging/vt6655/tether.h      |    3 ---
 drivers/staging/vt6655/vntwifi.c     |    2 --
 11 files changed, 44 deletions(-)

diff --git a/drivers/staging/vt6655/80211hdr.h b/drivers/staging/vt6655/80211hdr.h
index f55283b..c4d2349 100644
--- a/drivers/staging/vt6655/80211hdr.h
+++ b/drivers/staging/vt6655/80211hdr.h
@@ -80,7 +80,6 @@
 #define WLAN_HDR_ADDR4_LEN          30
 #define WLAN_IEHDR_LEN              2
 #define WLAN_SSID_MAXLEN            32
-/*#define WLAN_RATES_MAXLEN           255*/
 #define WLAN_RATES_MAXLEN           16
 #define WLAN_RATES_MAXLEN_11B       4
 #define WLAN_RSN_MAXLEN             32
@@ -106,7 +105,6 @@
 #define WLAN_WEP40_KEYLEN           5
 #define WLAN_WEP104_KEYLEN          13
 #define WLAN_WEP232_KEYLEN          29
-/*#define WLAN_WEPMAX_KEYLEN          29*/
 #define WLAN_WEPMAX_KEYLEN          32
 #define WLAN_CHALLENGE_IE_MAXLEN    255
 #define WLAN_CHALLENGE_IE_LEN       130
diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 1e1c6e3..e7b93a2 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -60,8 +60,6 @@
 //static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =MSG_LEVEL_INFO;
 
-//#define	PLICE_DEBUG
-
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index f4f108f..fcffa4f 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -58,7 +58,6 @@
 #include "wpa2.h"
 #include "iowpa.h"
 
-//#define	PLICE_DEBUG
 /*---------------------  Static Definitions -------------------------*/
 
 
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 138897a..084a1a5 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -152,10 +152,6 @@
 #define FRAGCTL_TKIP        0x0002 // 0000 0010 0000 0000
 #define FRAGCTL_LEGACY      0x0001 // 0000 0001 0000 0000
 #define FRAGCTL_NONENCRYPT  0x0000 // 0000 0000 0000 0000
-//#define FRAGCTL_AC3         0x0C00 // 0000 0000 0000 1100
-//#define FRAGCTL_AC2         0x0800 // 0000 0000 0000 1000
-//#define FRAGCTL_AC1         0x0400 // 0000 0000 0000 0100
-//#define FRAGCTL_AC0         0x0000 // 0000 0000 0000 0000
 #define FRAGCTL_ENDFRAG     0x0300 // 0000 0000 0000 0011
 #define FRAGCTL_MIDFRAG     0x0200 // 0000 0000 0000 0010
 #define FRAGCTL_STAFRAG     0x0100 // 0000 0000 0000 0001
@@ -184,10 +180,6 @@
 #define FRAGCTL_TKIP        0x0200 // 0000 0010 0000 0000
 #define FRAGCTL_LEGACY      0x0100 // 0000 0001 0000 0000
 #define FRAGCTL_NONENCRYPT  0x0000 // 0000 0000 0000 0000
-//#define FRAGCTL_AC3         0x000C // 0000 0000 0000 1100
-//#define FRAGCTL_AC2         0x0008 // 0000 0000 0000 1000
-//#define FRAGCTL_AC1         0x0004 // 0000 0000 0000 0100
-//#define FRAGCTL_AC0         0x0000 // 0000 0000 0000 0000
 #define FRAGCTL_ENDFRAG     0x0003 // 0000 0000 0000 0011
 #define FRAGCTL_MIDFRAG     0x0002 // 0000 0000 0000 0010
 #define FRAGCTL_STAFRAG     0x0001 // 0000 0000 0000 0001
@@ -195,8 +187,6 @@
 
 #endif // #ifdef __BIG_ENDIAN
 
-//#define TYPE_AC0DMA     0
-//#define TYPE_TXDMA0     1
 #define TYPE_TXDMA0     0
 #define TYPE_AC0DMA     1
 #define TYPE_ATIMDMA    2
@@ -215,7 +205,6 @@
 #define TD_FLAGS_NETIF_SKB               0x01       // check if need release skb
 #define TD_FLAGS_PRIV_SKB                0x02       // check if called from private skb(hostap)
 #define TD_FLAGS_PS_RETRY                0x04       // check if PS STA frame re-transmit
-//#define TD_FLAGS_NETIF_SKB                0x04
 
 /*---------------------  Export Types  ------------------------------*/
 
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 780205c..c5e6b98 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -69,10 +69,6 @@
 #ifndef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 #define WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 #endif
-//2008-4-14<add> by chester for led issue
-//#define FOR_LED_ON_NOTEBOOK
-//
-
 
 //
 // device specific
@@ -91,12 +87,6 @@
 #include "key.h"
 #include "mac.h"
 
-//PLICE_DEBUG->
-//#define		THREAD
-
-//#define	TASK_LET
-//PLICE_DEBUG<-
-
 
 /*---------------------  Export Definitions -------------------------*/
 
@@ -105,11 +95,6 @@
 #define MAX_MULTICAST_ADDRESS_NUM       32
 #define MULTICAST_ADDRESS_LIST_SIZE     (MAX_MULTICAST_ADDRESS_NUM * ETH_ALEN)
 
-
-//#define OP_MODE_INFRASTRUCTURE  0
-//#define OP_MODE_ADHOC           1
-//#define OP_MODE_AP              2
-
 #define DUPLICATE_RX_CACHE_LENGTH       5
 
 #define NUM_KEY_ENTRY                   11
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index d0fefb1..89d1c22 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -87,12 +87,10 @@
 #include <linux/kthread.h>
 #include <linux/slab.h>
 
-//#define	DEBUG
 /*---------------------  Static Definitions -------------------------*/
 //static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =   MSG_LEVEL_INFO;
 
-//#define	PLICE_DEBUG
 //
 // Define module options
 //
@@ -100,10 +98,8 @@ MODULE_AUTHOR("VIA Networking Technologies, Inc., <lyndonchen@vntek.com.tw>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VIA Networking Solomon-A/B/G Wireless LAN Adapter Driver");
 
-//PLICE_DEBUG ->
 	static int mlme_kill;
 	//static  struct task_struct * mlme_task;
-//PLICE_DEBUG <-
 
 #define DEVICE_PARAM(N,D)
 /*
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index c0fab4b..e8a71ba 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -55,7 +55,6 @@
 #include "iowpa.h"
 #include "aes_ccmp.h"
 
-//#define	PLICE_DEBUG
 
 
 /*---------------------  Static Definitions -------------------------*/
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index 009f3a4..5cd697a 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -98,7 +98,6 @@ typedef struct tagSMib2Counter {
 } SMib2Counter, *PSMib2Counter;
 
 // Value in the ifType entry
-//#define ETHERNETCSMACD      6           //
 #define WIRELESSLANIEEE80211b      6           //
 
 // Value in the ifAdminStatus/ifOperStatus entry
@@ -210,7 +209,6 @@ typedef struct tagSISRCounters {
 #define UNDER_CREATION      3           //
 #define INVALID             4           //
 
-//#define MAX_RATE            12
 //
 // statistic counter
 //
diff --git a/drivers/staging/vt6655/rf.h b/drivers/staging/vt6655/rf.h
index 1f8d82e..73f0969 100644
--- a/drivers/staging/vt6655/rf.h
+++ b/drivers/staging/vt6655/rf.h
@@ -41,7 +41,6 @@
 #define RF_MAXIMAG              0x02
 #define RF_AIROHA               0x03
 
-//#define RF_GCT5103              0x04
 #define RF_UW2451               0x05
 #define RF_MAXIMG               0x06
 #define RF_MAXIM2829            0x07 // RobertYu: 20041118
diff --git a/drivers/staging/vt6655/tether.h b/drivers/staging/vt6655/tether.h
index 787d885..6a68f97 100644
--- a/drivers/staging/vt6655/tether.h
+++ b/drivers/staging/vt6655/tether.h
@@ -90,8 +90,6 @@
 #define TYPE_CTL_ACK        0xd400
 
 
-//#define WEP_IV_MASK         0xFFFFFF00
-
 #else //if LITTLE_ENDIAN
 //
 // wType field in the SEthernetHeader
@@ -143,7 +141,6 @@
 #define TYPE_CTL_ACK        0x00d4
 
 
-//#define WEP_IV_MASK         0x00FFFFFF
 
 #endif //#ifdef __BIG_ENDIAN
 
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index 0491d0b..d645ecd 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -38,8 +38,6 @@
 #include "wmgr.h"
 #include "datarate.h"
 
-//#define	PLICE_DEBUG
-
 /*---------------------  Static Definitions -------------------------*/
 //static int          msglevel                =MSG_LEVEL_DEBUG;
 //static int          msglevel                =MSG_LEVEL_INFO;
-- 
1.7.10.4

