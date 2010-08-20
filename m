Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0HTVAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:00:21 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51737 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0HTVAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Q7xWVUnuKnLXapBK+7JMq4dkEROUDq9T+fLrTt2WqpIOKyTC+PWaP3pb59EQjPvP0w
         YKnPXSRL4RrUrEvruvu7PG11jZmhM2i7DzHrd3bfL/IwXBpkxjIIUznzNVNGze12tnMH
         ZaKjGFAF89VwDP0pZTe407TIz6oZc9u9pxGcc=
MIME-Version: 1.0
Date: Fri, 20 Aug 2010 17:00:13 -0400
Message-ID: <AANLkTimEdzcqEv1SCMWyftCwGU-==+vMH8-uuzAHLOM+@mail.gmail.com>
Subject: [PATCH 1/8] Staging: rtl8187se: r8180: fixed alot checkpatch.pl issues
From: T Dent <tdent48227@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, bzolnier@gmail.com, Larry.Finger@lwfinger.net,
        joe@perches.com, pshah.mumbai@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 73dfcd936fcacb6f1dce184e21b177c9fa4797d5 Mon Sep 17 00:00:00 2001
From: Tracey Dent <Tdent48227@gmail.com>
Date: Thu, 19 Aug 2010 16:13:48 -0400
Subject: [PATCH 1/8] Staging: rtl8187se: r8180: fixed alot checkpatch.pl issues

Fixed numerous coding style issues using checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/r8180.h |  537 ++++++++++++++++++-------------------
 1 files changed, 265 insertions(+), 272 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180.h
b/drivers/staging/rtl8187se/r8180.h
index d15bdf6..c5b1cba 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -1,18 +1,18 @@
 /*
-   This is part of rtl8180 OpenSource driver.
-   Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
-   Released under the terms of GPL (General Public Licence)
+	This is part of rtl8180 OpenSource driver.
+	Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+	Released under the terms of GPL (General Public Licence)

-   Parts of this driver are based on the GPL part of the
-   official realtek driver
+	Parts of this driver are based on the GPL part of the
+	official realtek driver

-   Parts of this driver are based on the rtl8180 driver skeleton
-   from Patric Schenke & Andres Salomon
+	Parts of this driver are based on the rtl8180 driver skeleton
+	from Patric Schenke & Andres Salomon

-   Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
+	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver

-   We want to tanks the Authors of those projects and the Ndiswrapper
-   project Authors.
+	We want to tanks the Authors of those projects and the Ndiswrapper
+	project Authors.
 */

 #ifndef R8180H
@@ -20,13 +20,13 @@


 #define RTL8180_MODULE_NAME "r8180"
-#define DMESG(x,a...) printk(KERN_INFO RTL8180_MODULE_NAME ": " x "\n", ## a)
-#define DMESGW(x,a...) printk(KERN_WARNING RTL8180_MODULE_NAME ":
WW:" x "\n", ## a)
-#define DMESGE(x,a...) printk(KERN_WARNING RTL8180_MODULE_NAME ":
EE:" x "\n", ## a)
+#define DMESG(x, a...) printk(KERN_INFO RTL8180_MODULE_NAME ": " x "\n", ## a)
+#define DMESGW(x, a...) printk(KERN_WARNING RTL8180_MODULE_NAME ":
WW:" x "\n", ## a)
+#define DMESGE(x, a...) printk(KERN_WARNING RTL8180_MODULE_NAME ":
EE:" x "\n", ## a)

 #include <linux/module.h>
 #include <linux/kernel.h>
-//#include <linux/config.h>
+/* #include <linux/config.h> */
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/sched.h>
@@ -36,19 +36,19 @@
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
-#include <linux/rtnetlink.h>	//for rtnl_lock()
+#include <linux/rtnetlink.h>	/* for rtnl_lock() */
 #include <linux/wireless.h>
 #include <linux/timer.h>
-#include <linux/proc_fs.h>	// Necessary because we use the proc fs
+#include <linux/proc_fs.h>	/* Necessary because we use the proc fs */
 #include <linux/if_arp.h>
 #include "ieee80211/ieee80211.h"
-#include <asm/io.h>
-//#include <asm/semaphore.h>
+#include <linux/io.h>
+/* #include <asm/semaphore.h> */

 #define EPROM_93c46 0
 #define EPROM_93c56 1

-#define RTL_IOCTL_WPA_SUPPLICANT		SIOCIWFIRSTPRIV+30
+#define RTL_IOCTL_WPA_SUPPLICANT		(SIOCIWFIRSTPRIV+30)

 #define DEFAULT_FRAG_THRESHOLD 2342U
 #define MIN_FRAG_THRESHOLD     256U
@@ -62,14 +62,14 @@

 #define BEACON_QUEUE					6

-#define aSifsTime 	10
+#define aSifsTime	10

 #define sCrcLng         4
-#define sAckCtsLng	112		// bits in ACK and CTS frames
-//+by amy 080312
+#define sAckCtsLng	112		/* bits in ACK and CTS frames */
+/* +by amy 080312 */
 #define RATE_ADAPTIVE_TIMER_PERIOD	300

-typedef enum _WIRELESS_MODE {
+enum _WIRELESS_MODE {
 	WIRELESS_MODE_UNKNOWN = 0x00,
 	WIRELESS_MODE_A = 0x01,
 	WIRELESS_MODE_B = 0x02,
@@ -77,71 +77,68 @@ typedef enum _WIRELESS_MODE {
 	WIRELESS_MODE_AUTO = 0x08,
 } WIRELESS_MODE;

-typedef struct 	ChnlAccessSetting {
+struct	ChnlAccessSetting {
 	u16 SIFS_Timer;
 	u16 DIFS_Timer;
 	u16 SlotTimeTimer;
 	u16 EIFS_Timer;
 	u16 CWminIndex;
 	u16 CWmaxIndex;
-}*PCHANNEL_ACCESS_SETTING,CHANNEL_ACCESS_SETTING;
+} *PCHANNEL_ACCESS_SETTING, CHANNEL_ACCESS_SETTING;

-typedef enum{
-        NIC_8185 = 1,
-        NIC_8185B
-        } nic_t;
+enum{
+		NIC_8185 = 1,
+		NIC_8185B
+		} nic_t;

 typedef u32 AC_CODING;
-#define AC0_BE	0		// ACI: 0x00	// Best Effort
-#define AC1_BK	1		// ACI: 0x01	// Background
-#define AC2_VI	2		// ACI: 0x10	// Video
-#define AC3_VO	3		// ACI: 0x11	// Voice
-#define AC_MAX	4		// Max: define total number; Should not to be used
as a real enum.
-
-//
-// ECWmin/ECWmax field.
-// Ref: WMM spec 2.2.2: WME Parameter Element, p.13.
-//
-typedef	union _ECW{
+#define AC0_BE	0		/* ACI: 0x00 */	/* Best Effort	*/
+#define AC1_BK	1		/* ACI: 0x01 */	/* Background	*/
+#define AC2_VI	2		/* ACI: 0x10 */	/* Video		*/
+#define AC3_VO	3		/* ACI: 0x11 */	/* Voice		*/
+#define AC_MAX	4		/* Max: define total number; Should not to be used
as a real enum.	*/
+
+/*
+	ECWmin/ECWmax field.
+	Ref: WMM spec 2.2.2: WME Parameter Element, p.13.
+*/
+union _ECW{
 	u8	charData;
-	struct
-	{
+	struct	{
 		u8	ECWmin:4;
 		u8	ECWmax:4;
-	}f;	// Field
-}ECW, *PECW;
-
-//
-// ACI/AIFSN Field.
-// Ref: WMM spec 2.2.2: WME Parameter Element, p.12.
-//
-typedef	union _ACI_AIFSN{
+	} f;	/*  Field */
+} ECW, *PECW;
+
+/*
+	ACI/AIFSN Field.
+	Ref: WMM spec 2.2.2: WME Parameter Element, p.12.
+*/
+union _ACI_AIFSN{
 	u8	charData;

-	struct
-	{
+	struct	{
 		u8	AIFSN:4;
 		u8	ACM:1;
 		u8	ACI:2;
 		u8	Reserved:1;
-	}f;	// Field
-}ACI_AIFSN, *PACI_AIFSN;
-
-//
-// AC Parameters Record Format.
-// Ref: WMM spec 2.2.2: WME Parameter Element, p.12.
-//
-typedef	union _AC_PARAM{
+	} f;	/* Field */
+} ACI_AIFSN, *PACI_AIFSN;
+
+/*
+	AC Parameters Record Format.
+	Ref: WMM spec 2.2.2: WME Parameter Element, p.12.
+*/
+union _AC_PARAM{
 	u32	longData;
 	u8	charData[4];

-	struct
-	{
+	struct	{
 		ACI_AIFSN	AciAifsn;
 		ECW		Ecw;
 		u16		TXOPLimit;
-	}f;	// Field
-}AC_PARAM, *PAC_PARAM;
+	} f;	/* Field */
+} AC_PARAM, *PAC_PARAM;

 /* it is a wrong definition. -xiong-2006-11-17
 typedef struct ThreeWireReg {
@@ -155,37 +152,35 @@ typedef struct ThreeWireReg {
 } ThreeWireReg;
 */

-typedef	union _ThreeWire{
+union _ThreeWire{
 	struct _ThreeWireStruc{
 		u16		data:1;
 		u16		clk:1;
 		u16		enableB:1;
 		u16		read_write:1;
 		u16		resv1:12;
-//		u2Byte	resv2:14;
-//		u2Byte	ThreeWireEnable:1;
-//		u2Byte	resv3:1;
-	}struc;
+/*		u2Byte	resv2:14;			*/
+/*		u2Byte	ThreeWireEnable:1;	*/
+/*		u2Byte	resv3:1;			*/
+	} struc;
 	u16			longData;
-}ThreeWireReg;
+} ThreeWireReg;


-typedef struct buffer
-{
+struct buffer	{
 	struct buffer *next;
 	u32 *buf;
 	dma_addr_t dma;
 } buffer;

-//YJ,modified,080828
-typedef struct Stats
-{
+/* YJ,modified,080828 */
+struct Stats	{
 	unsigned long txrdu;
 	unsigned long rxrdu;
 	unsigned long rxnolast;
 	unsigned long rxnodata;
-//	unsigned long rxreset;
-//	unsigned long rxwrkaround;
+/*	unsigned long rxreset;		*/
+/*	unsigned long rxwrkaround;	*/
 	unsigned long rxnopointer;
 	unsigned long txnperr;
 	unsigned long txresumed;
@@ -207,52 +202,53 @@ typedef struct Stats
 	unsigned long txbeaconerr;
 	unsigned long txlpokint;
 	unsigned long txlperr;
-	unsigned long txretry;//retry number  tony 20060601
-	unsigned long rxcrcerrmin;//crc error (0-500)
-	unsigned long rxcrcerrmid;//crc error (500-1000)
-	unsigned long rxcrcerrmax;//crc error (>1000)
-	unsigned long rxicverr;//ICV error
+	unsigned long txretry;/* retry number  tony 20060601	*/
+	unsigned long rxcrcerrmin;/* crc error (0-500)			*/
+	unsigned long rxcrcerrmid;/* crc error (500-1000)		*/
+	unsigned long rxcrcerrmax;/* crc error (>1000)			*/
+	unsigned long rxicverr;   /* ICV error					*/
 } Stats;

 #define MAX_LD_SLOT_NUM 10
-#define KEEP_ALIVE_INTERVAL 				20 // in seconds.
-#define CHECK_FOR_HANG_PERIOD			2 //be equal to watchdog check time
+#define KEEP_ALIVE_INTERVAL					20	/*  in seconds. */
+#define CHECK_FOR_HANG_PERIOD				2	/* be equal to watchdog check time	*/
 #define DEFAULT_KEEP_ALIVE_LEVEL			1
 #define DEFAULT_SLOT_NUM					2
 #define POWER_PROFILE_AC					0
-#define POWER_PROFILE_BATTERY			1
+#define POWER_PROFILE_BATTERY				1

-typedef struct _link_detect_t
-{
-	u32				RxFrameNum[MAX_LD_SLOT_NUM];	// number of Rx Frame /
CheckForHang_period  to determine link status
-	u16				SlotNum;	// number of CheckForHang period to determine link
status, default is 2
+struct _link_detect_t	{
+	u32				RxFrameNum[MAX_LD_SLOT_NUM];	/*  number of Rx Frame /
CheckForHang_period  to determine link status */
+	u16				SlotNum;	/*  number of CheckForHang period to determine link
status, default is 2 */
 	u16				SlotIndex;

-	u32				NumTxOkInPeriod;  //number of packet transmitted during CheckForHang
-	u32				NumRxOkInPeriod;  //number of packet received during CheckForHang
+	u32				NumTxOkInPeriod; /* number of packet transmitted during CheckForHang	*/
+	u32				NumRxOkInPeriod; /* number of packet received during CheckForHang		*/

-	u8				IdleCount;     // (KEEP_ALIVE_INTERVAL / CHECK_FOR_HANG_PERIOD)
+	u8				IdleCount;		/* (KEEP_ALIVE_INTERVAL / CHECK_FOR_HANG_PERIOD)		*/
 	u32				LastNumTxUnicast;
 	u32				LastNumRxUnicast;

-	bool				bBusyTraffic;    //when it is set to 1, UI cann't scan at will.
-}link_detect_t, *plink_detect_t;
+	bool			bBusyTraffic;	/* when it is set to 1, UI cann't scan at will.			*/
+} link_detect_t, *plink_detect_t;

-//YJ,modified,080828,end
+/* YJ,modified,080828,end */

-//by amy for led
-//================================================================================
-// LED customization.
-//================================================================================
+/*
+	by amy for led
+================================================================================
+	LED customization.
+================================================================================
+*/

-typedef	enum _LED_STRATEGY_8185{
-	SW_LED_MODE0, //
-	SW_LED_MODE1, //
-	HW_LED, // HW control 2 LEDs, LED0 and LED1 (there are 4 different
control modes)
-}LED_STRATEGY_8185, *PLED_STRATEGY_8185;
-//by amy for led
-//by amy for power save
-typedef	enum _LED_CTL_MODE{
+enum _LED_STRATEGY_8185{
+	SW_LED_MODE0,
+	SW_LED_MODE1,
+	HW_LED, /*  HW control 2 LEDs, LED0 and LED1 (there are 4 different
control modes) */
+} LED_STRATEGY_8185, *PLED_STRATEGY_8185;
+/* by amy for led			*/
+/* by amy for power save	*/
+enum _LED_CTL_MODE{
 	LED_CTL_POWER_ON = 1,
 	LED_CTL_LINK = 2,
 	LED_CTL_NO_LINK = 3,
@@ -260,14 +256,13 @@ typedef	enum _LED_CTL_MODE{
 	LED_CTL_RX = 5,
 	LED_CTL_SITE_SURVEY = 6,
 	LED_CTL_POWER_OFF = 7
-}LED_CTL_MODE;
+} LED_CTL_MODE;

-typedef	enum _RT_RF_POWER_STATE
-{
+enum _RT_RF_POWER_STATE	{
 	eRfOn,
 	eRfSleep,
 	eRfOff
-}RT_RF_POWER_STATE;
+} RT_RF_POWER_STATE;

 enum	_ReasonCode{
 	unspec_reason	= 0x1,
@@ -280,46 +275,44 @@ enum	_ReasonCode{
 	disas_lv_ss		= 0x8,
 	asoc_not_auth	= 0x9,

-	//----MIC_CHECK
+	/* ----MIC_CHECK */
 	mic_failure		= 0xe,
-	//----END MIC_CHECK
-
-	// Reason code defined in 802.11i D10.0 p.28.
-	invalid_IE		= 0x0d,
-	four_way_tmout	= 0x0f,
-	two_way_tmout	= 0x10,
-	IE_dismatch		= 0x11,
-	invalid_Gcipher	= 0x12,
-	invalid_Pcipher	= 0x13,
-	invalid_AKMP	= 0x14,
-	unsup_RSNIEver = 0x15,
-	invalid_RSNIE	= 0x16,
-	auth_802_1x_fail= 0x17,
+	/* ----END MIC_CHECK */
+
+	/* Reason code defined in 802.11i D10.0 p.28. */
+	invalid_IE			= 0x0d,
+	four_way_tmout		= 0x0f,
+	two_way_tmout		= 0x10,
+	IE_dismatch			= 0x11,
+	invalid_Gcipher		= 0x12,
+	invalid_Pcipher		= 0x13,
+	invalid_AKMP		= 0x14,
+	unsup_RSNIEver		= 0x15,
+	invalid_RSNIE		= 0x16,
+	auth_802_1x_fail	= 0x17,
 	ciper_reject		= 0x18,

-	// Reason code defined in 7.3.1.7, 802.1e D13.0, p.42. Added by
Annie, 2005-11-15.
-	QoS_unspec		= 0x20,	// 32
-	QAP_bandwidth	= 0x21,	// 33
-	poor_condition	= 0x22,	// 34
-	no_facility		= 0x23,	// 35
-							// Where is 36???
-	req_declined	= 0x25,	// 37
-	invalid_param	= 0x26,	// 38
-	req_not_honored= 0x27,	// 39
-	TS_not_created	= 0x2F,	// 47
-	DL_not_allowed	= 0x30,	// 48
-	dest_not_exist	= 0x31,	// 49
-	dest_not_QSTA	= 0x32,	// 50
+	/*  Reason code defined in 7.3.1.7, 802.1e D13.0, p.42. Added by
Annie, 2005-11-15. */
+	QoS_unspec		= 0x20,	/*  32				*/
+	QAP_bandwidth	= 0x21,	/*  33				*/
+	poor_condition	= 0x22,	/*  34				*/
+	no_facility		= 0x23,	/*  35				*/
+							/*  Where is 36???	*/
+	req_declined	= 0x25,	/*  37				*/
+	invalid_param	= 0x26,	/*  38				*/
+	req_not_honored = 0x27,	/*  39				*/
+	TS_not_created	= 0x2F,	/*  47				*/
+	DL_not_allowed	= 0x30,	/*  48				*/
+	dest_not_exist	= 0x31,	/*  49				*/
+	dest_not_QSTA	= 0x32,	/*  50				*/
 };
-typedef	enum _RT_PS_MODE
-{
-	eActive,	// Active/Continuous access.
-	eMaxPs,		// Max power save mode.
-	eFastPs		// Fast power save mode.
-}RT_PS_MODE;
-//by amy for power save
-typedef struct r8180_priv
-{
+enum _RT_PS_MODE	{
+	eActive,	/*  Active/Continuous access.	*/
+	eMaxPs,		/*  Max power save mode.		*/
+	eFastPs		/*  Fast power save mode.		*/
+} RT_PS_MODE;
+/* by amy for power save */
+struct r8180_priv	{
 	struct pci_dev *pdev;

 	short epromtype;
@@ -329,7 +322,7 @@ typedef struct r8180_priv
 	short phy_ver; /* meaningful for rtl8225 1:A 2:B 3:C */
 	short enable_gpio0;
 	short hw_plcp_len;
-	short plcp_preamble_mode; // 0:auto 1:short 2:long
+	short plcp_preamble_mode; /*  0:auto 1:short 2:long */

 	spinlock_t irq_lock;
 	spinlock_t irq_th_lock;
@@ -343,12 +336,12 @@ typedef struct r8180_priv
 	short chan;
 	short sens;
 	short max_sens;
-	u8 chtxpwr[15]; //channels from 1 to 14, 0 not used
-	u8 chtxpwr_ofdm[15]; //channels from 1 to 14, 0 not used
-	//u8 challow[15]; //channels from 1 to 14, 0 not used
-	u8 channel_plan;  // it's the channel plan index
+	u8 chtxpwr[15];			/* channels from 1 to 14, 0 not used */
+	u8 chtxpwr_ofdm[15];	/* channels from 1 to 14, 0 not used */
+	/* u8 challow[15]; */	/* channels from 1 to 14, 0 not used */
+	u8 channel_plan;		/* it's the channel plan index */
 	short up;
-	short crcmon; //if 1 allow bad crc frame reception in monitor mode
+	short crcmon;			/* if 1 allow bad crc frame reception in monitor mode */
 	short prism_hdr;

 	struct timer_list scan_timer;
@@ -356,7 +349,7 @@ typedef struct r8180_priv
 	short stopscan;*/
 	spinlock_t scan_lock;
 	u8 active_probe;
-	//u8 active_scan_num;
+	/* u8 active_scan_num; */
 	struct semaphore wx_sem;
 	struct semaphore rf_state;
 	short hw_wep;
@@ -367,21 +360,21 @@ typedef struct r8180_priv
 	u8 cs_treshold;
 	short rcr_csense;
 	u32 key0[4];
-	short (*rf_set_sens)(struct net_device *dev,short sens);
-	void (*rf_set_chan)(struct net_device *dev,short ch);
+	short (*rf_set_sens)(struct net_device *dev, short sens);
+	void (*rf_set_chan)(struct net_device *dev, short ch);
 	void (*rf_close)(struct net_device *dev);
 	void (*rf_init)(struct net_device *dev);
 	void (*rf_sleep)(struct net_device *dev);
 	void (*rf_wakeup)(struct net_device *dev);
-	//short rate;
+	/* short rate; */
 	short promisc;
-	/*stats*/
+	/* stats */
 	struct Stats stats;
-	struct _link_detect_t link_detect;  //YJ,add,080828
+	struct _link_detect_t link_detect;  /* YJ,add,080828 */
 	struct iw_statistics wstats;
 	struct proc_dir_entry *dir_dev;

-	/*RX stuff*/
+	/* RX stuff */
 	u32 *rxring;
 	u32 *rxringtail;
 	dma_addr_t rxringdma;
@@ -456,11 +449,11 @@ typedef struct r8180_priv

 	int txringcount;
 	int txbuffsize;
-	//struct tx_pendingbuf txnp_pending;
-	//struct tasklet_struct irq_tx_tasklet;
+	/* struct tx_pendingbuf txnp_pending;		*/
+	/* struct tasklet_struct irq_tx_tasklet;	*/
 	struct tasklet_struct irq_rx_tasklet;
 	u8 dma_poll_mask;
-	//short tx_suspend;
+	/* short tx_suspend;						*/

 	/* adhoc/master mode stuff */
 	u32 *txbeaconringtail;
@@ -469,20 +462,20 @@ typedef struct r8180_priv
 	int txbeaconcount;
 	struct buffer *txbeaconbufs;
 	struct buffer *txbeaconbufstail;
-	//char *master_essid;
-	//u16 master_beaconinterval;
-	//u32 master_beaconsize;
-	//u16 beacon_interval;
+	/* char *master_essid;			*/
+	/* u16 master_beaconinterval;	*/
+	/* u32 master_beaconsize;		*/
+	/* u16 beacon_interval;			*/

 	u8 retry_data;
 	u8 retry_rts;
 	u16 rts;

-//by amy for led
+/* by amy for led */
 	LED_STRATEGY_8185 LedStrategy;
-//by amy for led
+/* by amy for led */

-//by amy for power save
+/* by amy for power save */
 	struct timer_list watch_dog_timer;
 	bool bInactivePs;
 	bool bSwRfProcessing;
@@ -495,16 +488,16 @@ typedef struct r8180_priv
 	u8   RFProgType;
 	bool bLeisurePs;
 	RT_PS_MODE dot11PowerSaveMode;
-	//u32 NumRxOkInPeriod;   //YJ,del,080828
-	//u32 NumTxOkInPeriod;   //YJ,del,080828
+	/* u32 NumRxOkInPeriod; */  /* YJ,del,080828 */
+	/* u32 NumTxOkInPeriod; */  /* YJ,del,080828 */
 	u8   TxPollingTimes;

-	bool	bApBufOurFrame;// TRUE if AP buffer our unicast data , we will
keep eAwake until receive data or timeout.
+	bool	bApBufOurFrame;/*  TRUE if AP buffer our unicast data , we will
keep eAwake until receive data or timeout. */
 	u8	WaitBufDataBcnCount;
 	u8	WaitBufDataTimeOut;

-//by amy for power save
-//by amy for antenna
+/* by amy for power save	*/
+/* by amy for antenna		*/
 	u8 EEPROMSwAntennaDiversity;
 	bool EEPROMDefaultAntenna1;
 	u8 RegSwAntennaDiversityMechanism;
@@ -513,108 +506,108 @@ typedef struct r8180_priv
 	bool bDefaultAntenna1;
 	u8 SignalStrength;
 	long Stats_SignalStrength;
-	long LastSignalStrengthInPercent; // In percentange, used for
smoothing, e.g. Moving Average.
-	u8	 SignalQuality; // in 0-100 index.
+	long LastSignalStrengthInPercent; /*  In percentange, used for
smoothing, e.g. Moving Average. */
+	u8	SignalQuality;	/* in 0-100 index.	*/
 	long Stats_SignalQuality;
-	long RecvSignalPower; // in dBm.
+	long RecvSignalPower;	/* in dBm.		*/
 	long Stats_RecvSignalPower;
-	u8	 LastRxPktAntenna;	// +by amy 080312 Antenn which received the
lasted packet. 0: Aux, 1:Main. Added by Roger, 2008.01.25.
+	u8	 LastRxPktAntenna;	/*  +by amy 080312 Antenn which received the
lasted packet. 0: Aux, 1:Main. Added by Roger, 2008.01.25. */
 	u32 AdRxOkCnt;
 	long AdRxSignalStrength;
-	u8 CurrAntennaIndex;			// Index to current Antenna (both Tx and Rx).
-	u8 AdTickCount;				// Times of SwAntennaDiversityTimer happened.
-	u8 AdCheckPeriod;				// # of period SwAntennaDiversityTimer to check
Rx signal strength for SW Antenna Diversity.
-	u8 AdMinCheckPeriod;			// Min value of AdCheckPeriod.
-	u8 AdMaxCheckPeriod;			// Max value of AdCheckPeriod.
-	long AdRxSsThreshold;			// Signal strength threshold to switch antenna.
-	long AdMaxRxSsThreshold;			// Max value of AdRxSsThreshold.
-	bool bAdSwitchedChecking;		// TRUE if we shall shall check Rx signal
strength for last time switching antenna.
-	long AdRxSsBeforeSwitched;		// Rx signal strength before we swithed antenna.
+	u8 CurrAntennaIndex;			/* Index to current Antenna (both Tx and
Rx).													*/
+	u8 AdTickCount;					/* Times of SwAntennaDiversityTimer
happened.													*/
+	u8 AdCheckPeriod;				/* # of period SwAntennaDiversityTimer to check
Rx signal strength for SW Antenna Diversity.	*/
+	u8 AdMinCheckPeriod;			/* Min value of AdCheckPeriod.																	*/
+	u8 AdMaxCheckPeriod;			/* Max value of AdCheckPeriod.																	*/
+	long AdRxSsThreshold;			/* Signal strength threshold to switch
antenna.													*/
+	long AdMaxRxSsThreshold;		/* Max value of AdRxSsThreshold.																*/
+	bool bAdSwitchedChecking;		/* TRUE if we shall shall check Rx signal
strength for last time switching antenna.				*/
+	long AdRxSsBeforeSwitched;		/* Rx signal strength before we swithed
antenna.												*/
 	struct timer_list SwAntennaDiversityTimer;
-//by amy for antenna
-//{by amy 080312
-//
-	// Crystal calibration.
-	// Added by Roger, 2007.12.11.
-	//
-	bool		bXtalCalibration; // Crystal calibration.
-	u8			XtalCal_Xin; // Crystal calibration for Xin. 0~7.5pF
-	u8			XtalCal_Xout; // Crystal calibration for Xout. 0~7.5pF
-	//
-	// Tx power tracking with thermal meter indication.
-	// Added by Roger, 2007.12.11.
-	//
-	bool		bTxPowerTrack; // Tx Power tracking.
-	u8			ThermalMeter; // Thermal meter reference indication.
-	//
-	// Dynamic Initial Gain Adjustment Mechanism. Added by Bruce, 2007-02-14.
-	//
-	bool				bDigMechanism; // TRUE if DIG is enabled, FALSE ow.
-	bool				bRegHighPowerMechanism; // For High Power Mechanism. 061010,
by rcnjko.
+/* by amy for antenna				*/
+/* {by amy 080312					*/
+/*									*/
+	/* Crystal calibration.			*/
+	/* Added by Roger, 2007.12.11.	*/
+	/*								*/
+	bool	bXtalCalibration;	/* Crystal calibration.					*/
+	u8		XtalCal_Xin;		/* Crystal calibration for Xin. 0~7.5pF	*/
+	u8		XtalCal_Xout;		/* Crystal calibration for Xout. 0~7.5pF*/
+	/*														*/
+	/*  Tx power tracking with thermal meter indication.	*/
+	/*  Added by Roger, 2007.12.11.							*/
+	/*														*/
+	bool		bTxPowerTrack; /*  Tx Power tracking.					*/
+	u8			ThermalMeter;  /* Thermal meter reference indication.	*/
+	/*																		  */
+	/* Dynamic Initial Gain Adjustment Mechanism. Added by Bruce, 2007-02-14. */
+	/*																		  */
+	bool				bDigMechanism;			/*  TRUE if DIG is enabled, FALSE ow.	*/
+	bool				bRegHighPowerMechanism;	/*  For High Power Mechanism.
061010, by rcnjko. */
 	u32					FalseAlarmRegValue;
-	u8					RegDigOfdmFaUpTh; // Upper threhold of OFDM false alarm,
which is used in DIG.
+	u8					RegDigOfdmFaUpTh;		/*	Upper threhold of OFDM false alarm,
which is used in DIG. */
 	u8					DIG_NumberFallbackVote;
 	u8					DIG_NumberUpgradeVote;
-	// For HW antenna diversity, added by Roger, 2008.01.30.
-	u32			AdMainAntennaRxOkCnt;		// Main antenna Rx OK count.
-	u32			AdAuxAntennaRxOkCnt;		// Aux antenna Rx OK count.
-	bool		bHWAdSwitched;				// TRUE if we has switched default antenna
by HW evaluation.
-	// RF High Power upper/lower threshold.
+	/*  For HW antenna diversity, added by Roger, 2008.01.30.	*/
+	u32			AdMainAntennaRxOkCnt;		/* Main antenna Rx OK count.									*/
+	u32			AdAuxAntennaRxOkCnt;		/* Aux antenna Rx OK count.										*/
+	bool		bHWAdSwitched;				/* TRUE if we has switched default antenna
by HW evaluation.	*/
+	/* RF High Power upper/lower threshold.			*/
 	u8					RegHiPwrUpperTh;
 	u8					RegHiPwrLowerTh;
-	// RF RSSI High Power upper/lower Threshold.
+	/* RF RSSI High Power upper/lower Threshold.	*/
 	u8					RegRSSIHiPwrUpperTh;
 	u8					RegRSSIHiPwrLowerTh;
-	// Current CCK RSSI value to determine CCK high power, asked by SD3
DZ, by Bruce, 2007-04-12.
+	/* Current CCK RSSI value to determine CCK high power, asked by SD3
DZ, by Bruce, 2007-04-12. */
 	u8			CurCCKRSSI;
 	bool        bCurCCKPkt;
-	//
-	// High Power Mechanism. Added by amy, 080312.
-	//
+	/*												*/
+	/*  High Power Mechanism. Added by amy, 080312.	*/
+	/*												*/
 	bool					bToUpdateTxPwr;
 	long					UndecoratedSmoothedSS;
 	long					UndercorateSmoothedRxPower;
 	u8						RSSI;
 	char					RxPower;
-	 u8 InitialGain;
-	 //For adjust Dig Threshold during Legacy/Leisure Power Save Mode
+	u8 InitialGain;
+	/* For adjust Dig Threshold during Legacy/Leisure Power Save Mode	*/
 	u32				DozePeriodInPast2Sec;
-	 // Don't access BB/RF under disable PLL situation.
+	 /*  Don't access BB/RF under disable PLL situation.				*/
 	u8					InitialGainBackUp;
 	 u8 RegBModeGainStage;
-//by amy for rate adaptive
-    struct timer_list rateadapter_timer;
-	u32    RateAdaptivePeriod;
-	bool   bEnhanceTxPwr;
-	bool   bUpdateARFR;
-	int	   ForcedDataRate; // Force Data Rate. 0: Auto, 0x02: 1M ~ 0x6C: 54M.)
-	u32     NumTxUnicast; //YJ,add,080828,for keep alive
-	u8      keepAliveLevel; //YJ,add,080828,for KeepAlive
-	unsigned long 	NumTxOkTotal;
-	u16                                 LastRetryCnt;
-        u16                                     LastRetryRate;
-        unsigned long       LastTxokCnt;
-        unsigned long           LastRxokCnt;
-        u16                                     CurrRetryCnt;
-        unsigned long           LastTxOKBytes;
-	unsigned long 		    NumTxOkBytesTotal;
-        u8                          LastFailTxRate;
-        long                        LastFailTxRateSS;
-        u8                          FailTxRateCount;
-        u32                         LastTxThroughput;
-        //for up rate
-        unsigned short          bTryuping;
-        u8                                      CurrTxRate;     //the
rate before up
-        u16                                     CurrRetryRate;
-        u16                                     TryupingCount;
-        u8                                      TryDownCountLowData;
-        u8                                      TryupingCountNoData;
-
-        u8                  CurrentOperaRate;
-//by amy for rate adaptive
-//by amy 080312}
-//	short wq_hurryup;
-//	struct workqueue_struct *workqueue;
+/* by amy for rate adaptive */
+	struct timer_list rateadapter_timer;
+	u32	RateAdaptivePeriod;
+	bool	bEnhanceTxPwr;
+	bool	bUpdateARFR;
+	int		ForcedDataRate;	/*  Force Data Rate. 0: Auto, 0x02: 1M ~ 0x6C: 54M.)	*/
+	u32		NumTxUnicast;	/* YJ,add,080828,for keep alive							*/
+	u8		keepAliveLevel;	/* YJ,add,080828,for KeepAlive							*/
+	unsigned long	NumTxOkTotal;
+		u16									LastRetryCnt;
+		u16									LastRetryRate;
+		unsigned long		LastTxokCnt;
+		unsigned long		LastRxokCnt;
+		u16									CurrRetryCnt;
+		unsigned long			LastTxOKBytes;
+	unsigned long			NumTxOkBytesTotal;
+		u8							LastFailTxRate;
+		long						LastFailTxRateSS;
+		u8							FailTxRateCount;
+		u32							LastTxThroughput;
+		/* for up rate */
+		unsigned short							bTryuping;
+		u8										CurrTxRate; /* the rate before up */
+		u16										CurrRetryRate;
+		u16										TryupingCount;
+		u8										TryDownCountLowData;
+		u8										TryupingCountNoData;
+
+		u8                  CurrentOperaRate;
+/*	by amy for rate adaptive			*/
+/*	by amy 080312}						*/
+/*	short wq_hurryup;					*/
+/*	struct workqueue_struct *workqueue;	*/
 	struct work_struct reset_wq;
 	struct work_struct watch_dog_wq;
 	struct work_struct tx_irq_wq;
@@ -626,7 +619,7 @@ typedef struct r8180_priv
 	u8 ofdm_txpwr_base;
 	u8 dma_poll_stop_mask;

-	//u8 RegThreeWireMode;
+	/* u8 RegThreeWireMode; */
 	u8 MWIEnable;
 	u16 ShortRetryLimit;
 	u16 LongRetryLimit;
@@ -635,8 +628,8 @@ typedef struct r8180_priv
 	u32 ReceiveConfig;
 	u32 IntrMask;

-	struct 	ChnlAccessSetting  ChannelAccessSetting;
-}r8180_priv;
+	struct	ChnlAccessSetting	ChannelAccessSetting;
+} r8180_priv;

 #define MANAGE_PRIORITY 0
 #define BK_PRIORITY 1
@@ -648,21 +641,21 @@ typedef struct r8180_priv

 #define LOW_PRIORITY VI_PRIORITY
 #define NORM_PRIORITY VO_PRIORITY
-//AC2Queue mapping
+/* AC2Queue mapping */
 #define AC2Q(_ac) (((_ac) == WME_AC_VO) ? VO_PRIORITY : \
 		((_ac) == WME_AC_VI) ? VI_PRIORITY : \
 		((_ac) == WME_AC_BK) ? BK_PRIORITY : \
 		BE_PRIORITY)

-short rtl8180_tx(struct net_device *dev,u8* skbuf, int len,int priority,
-	short morefrag,short fragdesc,int rate);
+short rtl8180_tx(struct net_device *dev, u8* skbuf, int len, int priority,
+	short morefrag, short fragdesc, int rate);

 u8 read_nic_byte(struct net_device *dev, int x);
 u32 read_nic_dword(struct net_device *dev, int x);
 u16 read_nic_word(struct net_device *dev, int x) ;
-void write_nic_byte(struct net_device *dev, int x,u8 y);
-void write_nic_word(struct net_device *dev, int x,u16 y);
-void write_nic_dword(struct net_device *dev, int x,u32 y);
+void write_nic_byte(struct net_device *dev, int x, u8 y);
+void write_nic_word(struct net_device *dev, int x, u16 y);
+void write_nic_dword(struct net_device *dev, int x, u32 y);
 void force_pci_posting(struct net_device *dev);

 void rtl8180_rtx_disable(struct net_device *);
@@ -672,13 +665,13 @@ void rtl8180_start_scanning(struct net_device *dev);
 void rtl8180_start_scanning_s(struct net_device *dev);
 void rtl8180_stop_scanning(struct net_device *dev);
 void rtl8180_disassociate(struct net_device *dev);
-//void fix_rx_fifo(struct net_device *dev);
-void rtl8180_set_anaparam(struct net_device *dev,u32 a);
-void rtl8185_set_anaparam2(struct net_device *dev,u32 a);
+/* void fix_rx_fifo(struct net_device *dev); */
+void rtl8180_set_anaparam(struct net_device *dev, u32 a);
+void rtl8185_set_anaparam2(struct net_device *dev, u32 a);
 void rtl8180_set_hw_wep(struct net_device *dev);
 void rtl8180_no_hw_wep(struct net_device *dev);
 void rtl8180_update_msr(struct net_device *dev);
-//void rtl8180_BSS_create(struct net_device *dev);
+/* void rtl8180_BSS_create(struct net_device *dev); */
 void rtl8180_beacon_tx_disable(struct net_device *dev);
 void rtl8180_beacon_rx_disable(struct net_device *dev);
 void rtl8180_conttx_enable(struct net_device *dev);
@@ -686,8 +679,8 @@ void rtl8180_conttx_disable(struct net_device *dev);
 int rtl8180_down(struct net_device *dev);
 int rtl8180_up(struct net_device *dev);
 void rtl8180_commit(struct net_device *dev);
-void rtl8180_set_chan(struct net_device *dev,short ch);
-void rtl8180_set_master_essid(struct net_device *dev,char *essid);
+void rtl8180_set_chan(struct net_device *dev, short ch);
+void rtl8180_set_master_essid(struct net_device *dev, char *essid);
 void rtl8180_update_beacon_security(struct net_device *dev);
 void write_phy(struct net_device *dev, u8 adr, u8 data);
 void write_phy_cck(struct net_device *dev, u8 adr, u32 data);
@@ -701,7 +694,7 @@ int get_curr_tx_free_desc(struct net_device *dev,
int priority);
 void UpdateInitialGain(struct net_device *dev);
 bool SetAntennaConfig87SE(struct net_device *dev, u8  DefaultAnt,
bool bAntDiversity);

-//#ifdef CONFIG_RTL8185B
+/* #ifdef CONFIG_RTL8185B */
 void rtl8185b_adapter_start(struct net_device *dev);
 void rtl8185b_rx_enable(struct net_device *dev);
 void rtl8185b_tx_enable(struct net_device *dev);
@@ -711,7 +704,7 @@ void fix_rx_fifo(struct net_device *dev);
 void fix_tx_fifo(struct net_device *dev);
 void rtl8225z2_SetTXPowerLevel(struct net_device *dev, short ch);
 void rtl8180_rate_adapter(struct work_struct * work);
-//#endif
+/* #endif */
 bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE
StateToSet, u32 ChangeSource);

 #endif
-- 
1.7.2.1
