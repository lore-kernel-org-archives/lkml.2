Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890Ab2GLVwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:52:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34468 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964852Ab2GLVvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:51:10 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 7/8] staging: ft1000-usb: Replace all C99 comments with regular in ft1000_usb.h.
Date: Thu, 12 Jul 2012 23:50:49 +0200
Message-Id: <1342129850-32209-7-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
References: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |   35 ++++++++++++------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 60071f0..58cc54b 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -14,16 +14,16 @@
 #define  SUCCESS             0x00
 
 struct app_info_block {
-	u32 nTxMsg;                    // DPRAM msg sent to DSP with app_id
-	u32 nRxMsg;                    // DPRAM msg rcv from dsp with app_id
-	u32 nTxMsgReject;              // DPRAM msg rejected due to DSP doorbell set
-	u32 nRxMsgMiss;                // DPRAM msg dropped due to overflow
-	struct fown_struct *fileobject;// Application's file object
-	u16 app_id;                    // Application id
+	u32 nTxMsg;                    /* DPRAM msg sent to DSP with app_id */
+	u32 nRxMsg;                    /* DPRAM msg rcv from dsp with app_id */
+	u32 nTxMsgReject;              /* DPRAM msg rejected due to DSP doorbell set */
+	u32 nRxMsgMiss;                /* DPRAM msg dropped due to overflow */
+	struct fown_struct *fileobject;/* Application's file object */
+	u16 app_id;                    /* Application id */
 	int DspBCMsgFlag;
-	int NumOfMsg;                   // number of messages queued up
+	int NumOfMsg;                   /* number of messages queued up */
 	wait_queue_head_t wait_dpram_msg;
-	struct list_head app_sqlist;   // link list of msgs for applicaton on slow queue
+	struct list_head app_sqlist;   /* link list of msgs for applicaton on slow queue */
 } __attribute__((packed));
 
 #define DEBUG(args...) printk(KERN_INFO args)
@@ -45,14 +45,14 @@ struct app_info_block {
 #undef FT1000_DPRAM_RX_BASE
 #define FT1000_DPRAM_RX_BASE	0x1800	/* RX AREA (SlowQ) */
 
-// MEMORY MAP FOR MAGNEMITE
+/* MEMORY MAP FOR MAGNEMITE */
 /* the indexes are swapped comparing to PCMCIA - is it OK or a bug? */
 #undef FT1000_MAG_DSP_LED_INDX
 #define FT1000_MAG_DSP_LED_INDX		0x1	/* dsp led status for PAD device */
 #undef FT1000_MAG_DSP_CON_STATE_INDX
 #define FT1000_MAG_DSP_CON_STATE_INDX	0x0	/* DSP Connection Status Info */
 
-// Maximum times trying to get ASIC out of reset
+/* Maximum times trying to get ASIC out of reset */
 #define MAX_ASIC_RESET_CNT      20
 
 #define MAX_BUF_SIZE            4096
@@ -106,15 +106,15 @@ struct ft1000_info {
 	struct ft1000_debug_dirs nodes;
 	int registered;
 	int mediastate;
-	u8 squeseqnum;                 // sequence number on slow queue
+	u8 squeseqnum;                 /* sequence number on slow queue */
 	spinlock_t dpram_lock;
 	spinlock_t fifo_lock;
 	u16 fifo_cnt;
-	u8 DspVer[DSPVERSZ];        // DSP version number
-	u8 HwSerNum[HWSERNUMSZ];    // Hardware Serial Number
-	u8 Sku[SKUSZ];              // SKU
-	u8 eui64[EUISZ];            // EUI64
-	time_t ConTm;               // Connection Time
+	u8 DspVer[DSPVERSZ];        /* DSP version number */
+	u8 HwSerNum[HWSERNUMSZ];    /* Hardware Serial Number */
+	u8 Sku[SKUSZ];              /* SKU */
+	u8 eui64[EUISZ];            /* EUI64 */
+	time_t ConTm;               /* Connection Time */
 	u8 ProductMode[MODESZ];
 	u8 RfCalVer[CALVERSZ];
 	u8 RfCalDate[CALDATESZ];
@@ -170,7 +170,8 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 		u32  FileLength);
 
 extern struct list_head freercvpool;
-extern spinlock_t free_buff_lock;   // lock to arbitrate free buffer list for receive command data
+
+extern spinlock_t free_buff_lock;   /* lock to arbitrate free buffer list for receive command data */
 
 int ft1000_create_dev(struct ft1000_device *dev);
 void ft1000_destroy_dev(struct net_device *dev);
-- 
1.7.9.5

