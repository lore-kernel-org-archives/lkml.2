Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850Ab2GLVvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:51:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35733 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964834Ab2GLVvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:51:04 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 3/8] staging: ft1000-usb: Remove leading spaces from struct ft1000_info.
Date: Thu, 12 Jul 2012 23:50:45 +0200
Message-Id: <1342129850-32209-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
References: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |   94 ++++++++++++------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index d4f1aa1..3f22df9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -84,57 +84,57 @@ struct ft1000_debug_dirs {
 };
 
 struct ft1000_info {
-    struct ft1000_device *pFt1000Dev;
-    struct net_device_stats stats;
+	struct ft1000_device *pFt1000Dev;
+	struct net_device_stats stats;
 
-    struct task_struct *pPollThread;
+	struct task_struct *pPollThread;
 
-    unsigned char fcodeldr;
-    unsigned char bootmode;
+	unsigned char fcodeldr;
+	unsigned char bootmode;
 	unsigned char usbboot;
-    unsigned short dspalive;
-    u16 ASIC_ID;
-    bool fProvComplete;
-    bool fCondResetPend;
-    bool fAppMsgPend;
-    u16 DrvErrNum;
-    u16 AsicID;
-    int DspAsicReset;
-    int DeviceCreated;
-    int CardReady;
-    int NetDevRegDone;
-    u8 CardNumber;
-    u8 DeviceName[15];
-    struct ft1000_debug_dirs nodes;
-    int registered;
-    int mediastate;
-    u8 squeseqnum;                 // sequence number on slow queue
-    spinlock_t dpram_lock;
-    spinlock_t fifo_lock;
-    u16 fifo_cnt;
-    u8 DspVer[DSPVERSZ];        // DSP version number
-    u8 HwSerNum[HWSERNUMSZ];    // Hardware Serial Number
-    u8 Sku[SKUSZ];              // SKU
-    u8 eui64[EUISZ];            // EUI64
-    time_t ConTm;               // Connection Time
-    u8 ProductMode[MODESZ];
-    u8 RfCalVer[CALVERSZ];
-    u8 RfCalDate[CALDATESZ];
-    u16 DSP_TIME[4];
-    u16 LedStat;	//mbelian
-    u16 ConStat;	//mbelian
-    u16 ProgConStat;
-    struct list_head prov_list;
-    int appcnt;
+	unsigned short dspalive;
+	u16 ASIC_ID;
+	bool fProvComplete;
+	bool fCondResetPend;
+	bool fAppMsgPend;
+	u16 DrvErrNum;
+	u16 AsicID;
+	int DspAsicReset;
+	int DeviceCreated;
+	int CardReady;
+	int NetDevRegDone;
+	u8 CardNumber;
+	u8 DeviceName[15];
+	struct ft1000_debug_dirs nodes;
+	int registered;
+	int mediastate;
+	u8 squeseqnum;                 // sequence number on slow queue
+	spinlock_t dpram_lock;
+	spinlock_t fifo_lock;
+	u16 fifo_cnt;
+	u8 DspVer[DSPVERSZ];        // DSP version number
+	u8 HwSerNum[HWSERNUMSZ];    // Hardware Serial Number
+	u8 Sku[SKUSZ];              // SKU
+	u8 eui64[EUISZ];            // EUI64
+	time_t ConTm;               // Connection Time
+	u8 ProductMode[MODESZ];
+	u8 RfCalVer[CALVERSZ];
+	u8 RfCalDate[CALDATESZ];
+	u16 DSP_TIME[4];
+	u16 LedStat;	//mbelian
+	u16 ConStat;	//mbelian
+	u16 ProgConStat;
+	struct list_head prov_list;
+	int appcnt;
 	struct app_info_block app_info[MAX_NUM_APP];
-    u16 DSPInfoBlklen;
-    u16 DrvMsgPend;
-    int (*ft1000_reset)(struct net_device *dev);
-    u16 DSPInfoBlk[MAX_DSP_SESS_REC];
-    union {
-        u16 Rec[MAX_DSP_SESS_REC];
-        u32 MagRec[MAX_DSP_SESS_REC/2];
-    } DSPSess;
+	u16 DSPInfoBlklen;
+	u16 DrvMsgPend;
+	int (*ft1000_reset)(struct net_device *dev);
+	u16 DSPInfoBlk[MAX_DSP_SESS_REC];
+	union {
+		u16 Rec[MAX_DSP_SESS_REC];
+		u32 MagRec[MAX_DSP_SESS_REC/2];
+	} DSPSess;
 	unsigned short tempbuf[32];
 	char netdevname[IFNAMSIZ];
 	struct proc_dir_entry *ft1000_proc_dir; //mbelian
-- 
1.7.9.5

