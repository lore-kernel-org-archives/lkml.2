Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0KHVlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:41:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41741 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab0KHVlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Mzeo86ATc69av+iDEJkwlEUGAUNxsJ7h6YkeyxYGOqSb5HjJiqGMPGySRgm0MWmS9Y
         sXi82A0y9ve7B7Is5NVfdZKo45mXMyEE94mFxdflJiBFAUgu/bBo2pokn4E93u7u47Id
         qXJWb/ErgV4JuXg1uliQOgm9REArKmPcNy4BE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]staging: Fix typos in rt2860
Date: Mon,  8 Nov 2010 13:41:46 -0800
Message-Id: <1289252506-5797-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch that fixes some typos, and comments in  drivers/staging/rt2860

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rt2860/chip/mac_pci.h  |    7 ++-
 drivers/staging/rt2860/chip/mac_usb.h  |    5 +-
 drivers/staging/rt2860/chip/rtmp_mac.h |   19 +++++----
 drivers/staging/rt2860/chips/rt3090.c  |    5 +-
 drivers/staging/rt2860/chips/rt30xx.c  |    9 ++--
 drivers/staging/rt2860/mlme.h          |   41 ++++++++++---------
 drivers/staging/rt2860/oid.h           |   13 +++---
 drivers/staging/rt2860/pci_main_dev.c  |   17 ++++----
 drivers/staging/rt2860/rt_linux.c      |   12 +++---
 drivers/staging/rt2860/rt_linux.h      |    5 +-
 drivers/staging/rt2860/rt_main_dev.c   |    9 ++--
 drivers/staging/rt2860/rt_pci_rbus.c   |    7 ++-
 drivers/staging/rt2860/rt_usb.c        |   13 +++---
 drivers/staging/rt2860/rtmp.h          |   69 ++++++++++++++++----------------
 drivers/staging/rt2860/rtmp_def.h      |   37 +++++++++--------
 drivers/staging/rt2860/rtmp_timer.h    |   13 +++---
 drivers/staging/rt2860/spectrum.h      |   12 +++---
 drivers/staging/rt2860/sta/assoc.c     |   13 +++---
 drivers/staging/rt2860/sta/auth.c      |    7 ++-
 drivers/staging/rt2860/sta/connect.c   |   35 ++++++++--------
 drivers/staging/rt2860/sta/rtmp_data.c |   33 ++++++++-------
 drivers/staging/rt2860/sta/sanity.c    |    5 +-
 drivers/staging/rt2860/sta/sync.c      |   19 +++++----
 drivers/staging/rt2860/sta/wpa.c       |    5 +-
 drivers/staging/rt2860/sta_ioctl.c     |   25 ++++++------
 drivers/staging/rt2860/usb_main_dev.c  |    8 ++--
 drivers/staging/rt2860/wpa.h           |    5 +-
 27 files changed, 236 insertions(+), 212 deletions(-)

diff --git a/drivers/staging/rt2860/chip/mac_pci.h b/drivers/staging/rt2860/chip/mac_pci.h
index 9f25ef0..b8868a5 100644
--- a/drivers/staging/rt2860/chip/mac_pci.h
+++ b/drivers/staging/rt2860/chip/mac_pci.h
@@ -30,7 +30,8 @@
     Abstract:
 
     Revision History:
-    Who          When          What
+    Who          	When            What
+    Justin P. Mattock	11/07/2010	Fix some typos
     ---------    ----------    ----------------------------------------------
  */
 
@@ -45,7 +46,7 @@
 
 /* */
 /* Device ID & Vendor ID related definitions, */
-/* NOTE: you should not add the new VendorID/DeviceID here unless you not sure it belongs to what chip. */
+/* NOTE: you should not add the new VendorID/DeviceID here unless you know for sure what chip it belongs too. */
 /* */
 #define NIC_PCI_VENDOR_ID		0x1814
 #define PCIBUS_INTEL_VENDOR	0x8086
@@ -83,7 +84,7 @@ struct PACKED rt_txd {
 	u32 SDPtr1;
 	/*Word3 */
 	u32 rsv2:24;
-	u32 WIV:1;		/* Wireless Info Valid. 1 if Driver already fill WI,  o if DMA needs to copy WI to correctposition */
+	u32 WIV:1;		/* Wireless Info Valid. 1 if Driver already fill WI,  o if DMA needs to copy WI to correct position */
 	u32 QSEL:2;		/* select on-chip FIFO ID for 2nd-stage output scheduler.0:MGMT, 1:HCCA 2:EDCA */
 	u32 rsv:2;
 	u32 TCO:1;		/* */
diff --git a/drivers/staging/rt2860/chip/mac_usb.h b/drivers/staging/rt2860/chip/mac_usb.h
index ed0c0b4..e8158fb 100644
--- a/drivers/staging/rt2860/chip/mac_usb.h
+++ b/drivers/staging/rt2860/chip/mac_usb.h
@@ -30,7 +30,8 @@
     Abstract:
 
     Revision History:
-    Who          When          What
+    Who          	When            What
+    Justin P. Mattock	11/07/2010	Fix a typo
     ---------    ----------    ----------------------------------------------
  */
 
@@ -93,7 +94,7 @@ struct rt_txinfo {
 	/* Word 0 */
 	u32 USBDMATxPktLen:16;	/*used ONLY in USB bulk Aggregation,  Total byte counts of all sub-frame. */
 	u32 rsv:8;
-	u32 WIV:1;		/* Wireless Info Valid. 1 if Driver already fill WI,  o if DMA needs to copy WI to correctposition */
+	u32 WIV:1;		/* Wireless Info Valid. 1 if Driver already fill WI,  o if DMA needs to copy WI to correct position */
 	u32 QSEL:2;		/* select on-chip FIFO ID for 2nd-stage output scheduler.0:MGMT, 1:HCCA 2:EDCA */
 	u32 SwUseLastRound:1;	/* Software use. */
 	u32 rsv2:2;		/* Software use. */
diff --git a/drivers/staging/rt2860/chip/rtmp_mac.h b/drivers/staging/rt2860/chip/rtmp_mac.h
index e8f7172..3d1e491 100644
--- a/drivers/staging/rt2860/chip/rtmp_mac.h
+++ b/drivers/staging/rt2860/chip/rtmp_mac.h
@@ -32,6 +32,7 @@
 
 	Revision History:
 	Who			When		  What
+	Justin P. Mattock	11/07/2010	  Fix a comments, and typos
 	--------	----------	  ----------------------------------------------
 */
 
@@ -43,7 +44,7 @@
 /* ================================================================================= */
 
 /* the first 24-byte in TXD is called TXINFO and will be DMAed to MAC block through TXFIFO. */
-/* MAC block use this TXINFO to control the transmission behavior of this frame. */
+/* MAC block uses this TXINFO to control the transmission behavior of this frame. */
 #define FIFO_MGMT                 0
 #define FIFO_HCCA                 1
 #define FIFO_EDCA                 2
@@ -458,8 +459,8 @@ typedef union _BBP_CSR_CFG_STRUC {
 /* */
 typedef union _RF_CSR_CFG0_STRUC {
 	struct {
-		u32 RegIdAndContent:24;	/* Register     value to program into BBP */
-		u32 bitwidth:5;	/* Selected     BBP     register */
+		u32 RegIdAndContent:24;	/* Register value to program into BBP */
+		u32 bitwidth:5;	/* Selected BBP register */
 		u32 StandbyMode:1;	/* 0: high when stand by 1: low when standby */
 		u32 Sel:1;	/* 0:RF_LE0 activate  1:RF_LE1 activate */
 		u32 Busy:1;	/* 0: idle 1: 8busy */
@@ -469,7 +470,7 @@ typedef union _RF_CSR_CFG0_STRUC {
 #define RF_CSR_CFG1			0x1024
 typedef union _RF_CSR_CFG1_STRUC {
 	struct {
-		u32 RegIdAndContent:24;	/* Register     value to program into BBP */
+		u32 RegIdAndContent:24;	/* Register value to program into BBP */
 		u32 RFGap:5;	/* Gap between BB_CONTROL_RF and RF_LE. 0: 3 system clock cycle (37.5usec) 1: 5 system clock cycle (62.5usec) */
 		u32 rsv:7;	/* 0: idle 1: 8busy */
 	} field;
@@ -478,7 +479,7 @@ typedef union _RF_CSR_CFG1_STRUC {
 #define RF_CSR_CFG2			0x1028	/* */
 typedef union _RF_CSR_CFG2_STRUC {
 	struct {
-		u32 RegIdAndContent:24;	/* Register     value to program into BBP */
+		u32 RegIdAndContent:24;	/* Register value to program into BBP */
 		u32 rsv:8;	/* 0: idle 1: 8busy */
 	} field;
 	u32 word;
@@ -490,7 +491,7 @@ typedef union _LED_CFG_STRUC {
 		u32 OffPeriod:8;	/* blinking off period unit 1ms */
 		u32 SlowBlinkPeriod:6;	/* slow blinking period. unit:1ms */
 		u32 rsv:2;
-		u32 RLedMode:2;	/* red Led Mode    0: off1: blinking upon TX2: periodic slow blinking3: always on */
+		u32 RLedMode:2;	/* red Led Mode 0: off1: blinking upon TX2: periodic slow blinking3: always on */
 		u32 GLedMode:2;	/* green Led Mode */
 		u32 YLedMode:2;	/* yellow Led Mode */
 		u32 LedPolar:1;	/* Led Polarity.  0: active low1: active high */
@@ -621,9 +622,9 @@ typedef union _TX_TIMEOUT_CFG_STRUC {
 #define TX_RTY_CFG	0x134c
 typedef union PACKED _TX_RTY_CFG_STRUC {
 	struct {
-		u32 ShortRtyLimit:8;	/*  short retry limit */
-		u32 LongRtyLimit:8;	/*long retry limit */
-		u32 LongRtyThre:12;	/* Long retry threshoold */
+		u32 ShortRtyLimit:8;	/* short retry limit */
+		u32 LongRtyLimit:8;	/* long retry limit */
+		u32 LongRtyThre:12;	/* Long retry threshold */
 		u32 NonAggRtyMode:1;	/* Non-Aggregate MPDU retry mode.  0:expired by retry limit, 1: expired by mpdu life timer */
 		u32 AggRtyMode:1;	/* Aggregate MPDU retry mode.  0:expired by retry limit, 1: expired by mpdu life timer */
 		u32 TxautoFBEnable:1;	/* Tx retry PHY rate auto fallback enable */
diff --git a/drivers/staging/rt2860/chips/rt3090.c b/drivers/staging/rt2860/chips/rt3090.c
index c2933c6..156eb36 100644
--- a/drivers/staging/rt2860/chips/rt3090.c
+++ b/drivers/staging/rt2860/chips/rt3090.c
@@ -28,10 +28,11 @@
 	rt3090.c
 
 	Abstract:
-	Specific funcitons and variables for RT3070
+	Specific functions and variables for RT3070
 
 	Revision History:
-	Who         When          What
+	Who         		When            What
+	Justin P. Mattock	11/07/2010	Fix a typo
 	--------    ----------    ----------------------------------------------
 */
 
diff --git a/drivers/staging/rt2860/chips/rt30xx.c b/drivers/staging/rt2860/chips/rt30xx.c
index 4367a19..c8f7282 100644
--- a/drivers/staging/rt2860/chips/rt30xx.c
+++ b/drivers/staging/rt2860/chips/rt30xx.c
@@ -28,10 +28,11 @@
 	rt30xx.c
 
 	Abstract:
-	Specific funcitons and variables for RT30xx.
+	Specific functions and variables for RT30xx.
 
 	Revision History:
-	Who         When          What
+	Who         		When            What
+	Justin P. Mattock	11/07/2010	Fix some typos
 	--------    ----------    ----------------------------------------------
 */
 
@@ -89,7 +90,7 @@ struct rt_reg_pair RT30xx_RFRegTable[] = {
 
 u8 NUM_RF_REG_PARMS = (sizeof(RT30xx_RFRegTable) / sizeof(struct rt_reg_pair));
 
-/* Antenna divesity use GPIO3 and EESK pin for control */
+/* Antenna diversity use GPIO3 and EESK pin for control */
 /* Antenna and EEPROM access are both using EESK pin, */
 /* Therefor we should avoid accessing EESK at the same time */
 /* Then restore antenna after EEPROM access */
@@ -243,7 +244,7 @@ void RTMPFilterCalibration(struct rt_rtmp_adapter *pAd)
 				break;
 			}
 
-			/* prevent infinite loop cause driver hang. */
+			/* prevent infinite loop; causes driver hang. */
 			if (loopcnt++ > 100) {
 				DBGPRINT(RT_DEBUG_ERROR,
 					 ("RTMPFilterCalibration - can't find a valid value, loopcnt=%d stop calibrating",
diff --git a/drivers/staging/rt2860/mlme.h b/drivers/staging/rt2860/mlme.h
index 01414c3..cd1ee3d 100644
--- a/drivers/staging/rt2860/mlme.h
+++ b/drivers/staging/rt2860/mlme.h
@@ -32,8 +32,9 @@
 	Revision History:
 	Who			When			What
 	--------	----------		------------------------------
-	John Chang	2003-08-28		Created
-	John Chang  2004-09-06      modified for RT2600
+	John Chang		2003-08-28		Created
+	John Chang  		2004-09-06      	modified for RT2600
+	Justin P. Mattock	11/07/2010		Fix typos in comments
 
 */
 #ifndef __MLME_H__
@@ -41,7 +42,7 @@
 
 #include "rtmp_dot11.h"
 
-/* maximum supported capability information - */
+/* maximum supported capability information */
 /* ESS, IBSS, Privacy, Short Preamble, Spectrum mgmt, Short Slot */
 #define SUPPORTED_CAPABILITY_INFO   0x0533
 
@@ -77,7 +78,7 @@
 #define CW_MAX_IN_BITS              10	/* actual CwMax = 2^CW_MAX_IN_BITS - 1 */
 
 /* Note: RSSI_TO_DBM_OFFSET has been changed to variable for new RF (2004-0720). */
-/* SHould not refer to this constant anymore */
+/* Should not refer to this constant anymore */
 /*#define RSSI_TO_DBM_OFFSET          120 // for RT2530 RSSI-115 = dBm */
 #define RSSI_FOR_MID_TX_POWER       -55	/* -55 db is considered mid-distance */
 #define RSSI_FOR_LOW_TX_POWER       -45	/* -45 db is considered very short distance and */
@@ -123,7 +124,7 @@
 #define TID_MAC_HASH_INDEX(Addr, TID)      (TID_MAC_HASH(Addr, TID) % HASH_TABLE_SIZE)
 
 /* LED Control */
-/* assoiation ON. one LED ON. another blinking when TX, OFF when idle */
+/* association ON. one LED ON. another blinking when TX, OFF when idle */
 /* no association, both LED off */
 #define ASIC_LED_ACT_ON(pAd)        RTMP_IO_WRITE32(pAd, MAC_CSR14, 0x00031e46)
 #define ASIC_LED_ACT_OFF(pAd)       RTMP_IO_WRITE32(pAd, MAC_CSR14, 0x00001e46)
@@ -284,8 +285,8 @@ struct PACKED rt_ht_capability_ie {
 
 /* 802.11n draft3 related structure definitions. */
 /* 7.3.2.60 */
-#define dot11OBSSScanPassiveDwell							20	/* in TU. min amount of time that the STA continously scans each channel when performing an active OBSS scan. */
-#define dot11OBSSScanActiveDwell							10	/* in TU.min amount of time that the STA continously scans each channel when performing an passive OBSS scan. */
+#define dot11OBSSScanPassiveDwell							20	/* in TU. min amount of time that the STA continuously scans each channel when performing an active OBSS scan. */
+#define dot11OBSSScanActiveDwell							10	/* in TU.min amount of time that the STA continuously scans each channel when performing an passive OBSS scan. */
 #define dot11BSSWidthTriggerScanInterval					300	/* in sec. max interval between scan operations to be performed to detect BSS channel width trigger events. */
 #define dot11OBSSScanPassiveTotalPerChannel					200	/* in TU. min total amount of time that the STA scans each channel when performing a passive OBSS scan. */
 #define dot11OBSSScanActiveTotalPerChannel					20	/*in TU. min total amount of time that the STA scans each channel when performing a active OBSS scan */
@@ -325,7 +326,7 @@ struct rt_trigger_eventa {
 };
 
 /* 20/40 trigger event table */
-/* If one Event A delete or created, or if Event B is detected or not detected, STA should send 2040BSSCoexistence to AP. */
+/* If one Event (A) is deleted or created, or if Event (B) is detected or not detected, STA should send 2040BSSCoexistence to AP. */
 #define MAX_TRIGGER_EVENT		64
 struct rt_trigger_event_tab {
 	u8 EventANo;
@@ -357,14 +358,14 @@ struct PACKED rt_bss_2040_intolerant_ch_report {
 	u8 ChList[0];
 };
 
-/* The structure for channel switch annoucement IE. This is in 802.11n D3.03 */
+/* The structure for channel switch announcement IE. This is in 802.11n D3.03 */
 struct PACKED rt_cha_switch_announce_ie {
 	u8 SwitchMode;	/*channel switch mode */
 	u8 NewChannel;	/* */
 	u8 SwitchCount;	/* */
 };
 
-/* The structure for channel switch annoucement IE. This is in 802.11n D3.03 */
+/* The structure for channel switch announcement IE. This is in 802.11n D3.03 */
 struct PACKED rt_sec_cha_offset_ie {
 	u8 SecondaryChannelOffset;	/* 1: Secondary above, 3: Secondary below, 0: no Secondary */
 };
@@ -377,7 +378,7 @@ struct rt_ht_phy_info {
 	u8 MCSSet[16];
 };
 
-/*This structure substracts ralink supports from all 802.11n-related features. */
+/*This structure subtracts ralink supports from all 802.11n-related features. */
 /*Features not listed here but contained in 802.11n spec are not supported in rt2860. */
 struct rt_ht_capability {
 	u16 ChannelWidth:1;
@@ -387,14 +388,14 @@ struct rt_ht_capability {
 	u16 ShortGIfor40:1;	/*for40MHz */
 	u16 TxSTBC:1;
 	u16 RxSTBC:2;	/* 2 bits */
-	u16 AmsduEnable:1;	/* Enable to transmit A-MSDU. Suggest disable. We should use A-MPDU to gain best benifit of 802.11n */
+	u16 AmsduEnable:1;	/* Enable to transmit A-MSDU. Suggest disable. We should use A-MPDU to gain best benefit of 802.11n */
 	u16 AmsduSize:1;	/* Max receiving A-MSDU size */
 	u16 rsv:5;
 
 	/*Substract from Addiont HT INFO IE */
 	u8 MaxRAmpduFactor:2;
 	u8 MpduDensity:3;
-	u8 ExtChanOffset:2;	/* Please not the difference with following     u8   NewExtChannelOffset; from 802.11n */
+	u8 ExtChanOffset:2;	/* Please note the difference with following     u8   NewExtChannelOffset; from 802.11n */
 	u8 RecomWidth:1;
 
 	u16 OperaionMode:2;
@@ -481,7 +482,7 @@ struct PACKED rt_ba_parm {
 	u16 AMSDUSupported:1;	/* 0: not permitted             1: permitted */
 	u16 BAPolicy:1;	/* 1: immediately BA    0:delayed BA */
 	u16 TID:4;		/* value of TC os TS */
-	u16 BufSize:10;	/* number of buffe of size 2304 octetsr */
+	u16 BufSize:10;	/* number of buffer of size 2304 octetsr */
 };
 
 /* 2-byte BA Starting Seq CONTROL field */
@@ -551,7 +552,7 @@ struct PACKED rt_frame_mtba_req {
 	BASEQ_CONTROL BAStartingSeq;
 };
 
-/* Compressed format is mandantory in HT STA */
+/* Compressed format is mandatory in HT STA */
 struct PACKED rt_frame_mtba {
 	struct rt_frame_control FC;
 	u16 Duration;
@@ -647,7 +648,7 @@ struct PACKED rt_frame_ba {
 	u8 bitmask[8];
 };
 
-/* Radio Measuement Request Frame Format */
+/* Radio Measurement Request Frame Format */
 struct PACKED rt_frame_rm_req_action {
 	struct rt_header_802_11 Hdr;
 	u8 Category;
@@ -709,7 +710,7 @@ struct rt_edca_parm {
 	u8 Cwmin[4];
 	u8 Cwmax[4];
 	u16 Txop[4];		/* in unit of 32-us */
-	BOOLEAN bACM[4];	/* 1: Admission Control of AC_BK is mandattory */
+	BOOLEAN bACM[4];	/* 1: Admission Control of AC_BK is mandatory */
 };
 
 /* QBSS LOAD information from QAP's BEACON/ProbeRsp */
@@ -757,7 +758,7 @@ struct rt_wpa_ie {
 struct rt_bss_entry {
 	u8 Bssid[MAC_ADDR_LEN];
 	u8 Channel;
-	u8 CentralChannel;	/*Store the wide-band central channel for 40MHz.  .used in 40MHz AP. Or this is the same as Channel. */
+	u8 CentralChannel;	/*Store the wide-band central channel for 40MHz. used in 40MHz AP. Or this is the same as Channel. */
 	u8 BssType;
 	u16 AtimWin;
 	u16 BeaconPeriod;
@@ -855,7 +856,7 @@ struct rt_state_machine {
 	STATE_MACHINE_FUNC *TransFunc;
 };
 
-/* MLME AUX data structure that hold temporarliy settings during a connection attempt. */
+/* MLME AUX data structure that holds temporarliy settings during a connection attempt. */
 /* Once this attemp succeeds, all settings will be copy to pAd->StaActive. */
 /* A connection attempt (user set OID, roaming, CCX fast roaming,..) consists of */
 /* several steps (JOIN, AUTH, ASSOC or REASSOC) and may fail at any step. We purposely */
@@ -996,7 +997,7 @@ struct PACKED rt_rtmp_tx_rate_switch {
 #define MAC_TABLE_ASSOC_TIMEOUT			5	/* unit: sec */
 #define MAC_TABLE_FULL(Tab)				((Tab).size == MAX_LEN_OF_MAC_TABLE)
 
-/* AP shall drop the sta if contine Tx fail count reach it. */
+/* AP shall drop the sta if continue Tx fail count reach it. */
 #define MAC_ENTRY_LIFE_CHECK_CNT		20	/* packet cnt. */
 
 /* Value domain of pMacEntry->Sst */
diff --git a/drivers/staging/rt2860/oid.h b/drivers/staging/rt2860/oid.h
index 1704c27..eaa3fe0 100644
--- a/drivers/staging/rt2860/oid.h
+++ b/drivers/staging/rt2860/oid.h
@@ -32,7 +32,8 @@
 	Revision History:
 	Who			When			What
 	--------	----------		----------------------------------------------
-	Name		Date			Modification logs
+	Name			Date			Modification logs
+	Justin P. Mattock 	11/07/2010	Fix typos in comments
 */
 #ifndef _OID_H_
 #define _OID_H_
@@ -78,7 +79,7 @@
 #define NDIS_802_11_LENGTH_RATES        8
 #define NDIS_802_11_LENGTH_RATES_EX     16
 #define MAC_ADDR_LENGTH                 6
-/*#define MAX_NUM_OF_CHS                                        49 // 14 channels @2.4G +  12@UNII + 4 @MMAC + 11 @HiperLAN2 + 7 @Japan + 1 as NULL terminationc */
+/*#define MAX_NUM_OF_CHS                                        49 // 14 channels @2.4G +  12@UNII + 4 @MMAC + 11 @HiperLAN2 + 7 @Japan + 1 as NULL termination */
 #define MAX_NUM_OF_CHS				54	/* 14 channels @2.4G +  12@UNII(lower/middle) + 16@HiperLAN2 + 11@UNII(upper) + 0 @Japan + 1 as NULL termination */
 #define MAX_NUMBER_OF_EVENT				10	/* entry # in EVENT table */
 #define MAX_NUMBER_OF_MAC				32	/* if MAX_MBSSID_NUM is 8, this value can't be larger than 211 */
@@ -610,7 +611,7 @@ struct rt_802_11_event_log {
 
 struct rt_802_11_event_table {
 	unsigned long Num;
-	unsigned long Rsv;		/* to align Log[] at LARGE_INEGER boundary */
+	unsigned long Rsv;		/* to align Log[] at LARGE_INTEGER boundary */
 	struct rt_802_11_event_log Log[MAX_NUMBER_OF_EVENT];
 };
 
@@ -721,9 +722,9 @@ struct rt_802_11_tx_rates {
 #define	AUTH_FAIL				0x4	/* Open authentication fail */
 #define	AUTH_FAIL_KEYS			0x5	/* Shared authentication fail */
 #define	ASSOC_FAIL				0x6	/* Association failed */
-#define	EAP_MIC_FAILURE			0x7	/* Deauthencation because MIC failure */
-#define	EAP_4WAY_TIMEOUT		0x8	/* Deauthencation on 4-way handshake timeout */
-#define	EAP_GROUP_KEY_TIMEOUT	0x9	/* Deauthencation on group key handshake timeout */
+#define	EAP_MIC_FAILURE			0x7	/* Deauthentication because MIC failure */
+#define	EAP_4WAY_TIMEOUT		0x8	/* Deauthentication on 4-way handshake timeout */
+#define	EAP_GROUP_KEY_TIMEOUT	0x9	/* Deauthentication on group key handshake timeout */
 #define	EAP_SUCCESS				0xa	/* EAP succeed */
 #define	DETECT_RADAR_SIGNAL		0xb	/* Radar signal occur in current channel */
 #define EXTRA_INFO_MAX			0xb	/* Indicate Last OID */
diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
index 321facd..c35c804 100644
--- a/drivers/staging/rt2860/pci_main_dev.c
+++ b/drivers/staging/rt2860/pci_main_dev.c
@@ -31,7 +31,8 @@
     Create and register network interface for PCI based chipsets in Linux platform.
 
     Revision History:
-    Who         When            What
+    Who         	When            What
+    Justin P. Mattock	11/07/2010	Fix typos in some comments
     --------    ----------      ----------------------------------------------
 */
 
@@ -40,8 +41,8 @@
 #include <linux/slab.h>
 
 /* Following information will be show when you run 'modinfo' */
-/* *** If you have a solution for the bug in current version of driver, please mail to me. */
-/* Otherwise post to forum in ralinktech's web site(www.ralinktech.com) and let all users help you. *** */
+/* If you have a solution for a bug in current version of driver, please e-mail me. */
+/* Otherwise post to forum in ralinktech's web site(www.ralinktech.com) and let all users help you. */
 MODULE_AUTHOR("Jett Chen <jett_chen@ralinktech.com>");
 MODULE_DESCRIPTION("RT2860/RT3090 Wireless Lan Linux Driver");
 MODULE_LICENSE("GPL");
@@ -599,7 +600,7 @@ void RTMPInitPCIeLinkCtrlValue(struct rt_rtmp_adapter *pAd)
 		DBGPRINT_RAW(RT_DEBUG_ERROR,
 			     (" AUX_CTRL = 0x%32x\n", MacValue));
 
-		/* for RT30xx F and after, PCIe infterface, and for power solution 3 */
+		/* for RT30xx F and after, PCIe interface, and for power solution 3 */
 		if ((IS_VERSION_AFTER_F(pAd))
 		    && (pAd->StaCfg.PSControl.field.rt30xxPowerMode >= 2)
 		    && (pAd->StaCfg.PSControl.field.rt30xxPowerMode <= 3)) {
@@ -902,7 +903,7 @@ void RTMPPCIeLinkCtrlValueRestore(struct rt_rtmp_adapter *pAd, u8 Level)
 				  Configuration);
 		if ((Configuration != 0) && (Configuration != 0xFFFF)) {
 			Configuration &= 0xfefc;
-			/* If call from interface down, restore to orginial setting. */
+			/* If call from interface down, restore to original setting. */
 			if (Level == RESTORE_CLOSE)
 				Configuration |= pAd->HostLnkCtrlConfiguration;
 			else
@@ -924,7 +925,7 @@ void RTMPPCIeLinkCtrlValueRestore(struct rt_rtmp_adapter *pAd, u8 Level)
 				  Configuration);
 		if ((Configuration != 0) && (Configuration != 0xFFFF)) {
 			Configuration &= 0xfefc;
-			/* If call from interface down, restore to orginial setting. */
+			/* If call from interface down, restore to original setting. */
 			if (Level == RESTORE_CLOSE)
 				Configuration |= pAd->RLnkCtrlConfiguration;
 			else
@@ -1106,12 +1107,12 @@ void RTMPrt3xSetPCIePowerLinkCtrl(struct rt_rtmp_adapter *pAd)
 		if (pos != 0)
 			pAd->HostLnkCtrlOffset = pos + PCI_EXP_LNKCTL;
 
-		/* If configurared to turn on L1. */
+		/* If configured to turn on L1. */
 		HostConfiguration = 0;
 		if (pAd->StaCfg.PSControl.field.rt30xxForceASPMTest == 1) {
 			DBGPRINT(RT_DEBUG_TRACE, ("Enter,PSM : Force ASPM\n"));
 
-			/* Skip non-exist deice right away */
+			/* Skip non-exist device right away */
 			if ((pAd->HostLnkCtrlOffset != 0)) {
 				PCI_REG_READ_WORD(pObj->parent_pci_dev,
 						  pAd->HostLnkCtrlOffset,
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index abfeea1..e680b0d 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -767,13 +767,13 @@ void send_monitor_packets(struct rt_rtmp_adapter *pAd, struct rt_rx_blk *pRxBlk)
 		/* QOS */
 		if (pRxBlk->pHeader->FC.SubType & 0x08) {
 			header_len += 2;
-			/* Data skip QOS contorl field */
+			/* Data skip QOS control field */
 			pRxBlk->DataSize -= 2;
 		}
 		/* Order bit: A-Ralink or HTC+ */
 		if (pRxBlk->pHeader->FC.Order) {
 			header_len += 4;
-			/* Data skip HTC contorl field */
+			/* Data skip HTC control field */
 			pRxBlk->DataSize -= 4;
 		}
 		/* Copy Header */
@@ -1175,7 +1175,7 @@ int RtmpOSNetDevAddrSet(struct net_device *pNetDev, u8 *pMacAddr)
 	net_dev = pNetDev;
 	GET_PAD_FROM_NET_DEV(pAd, net_dev);
 
-	/* work-around for the SuSE due to it has it's own interface name management system. */
+	/* work-around for SuSE, due to them having their own interface name management system. */
 	{
 		NdisZeroMemory(pAd->StaCfg.dev_name, 16);
 		NdisMoveMemory(pAd->StaCfg.dev_name, net_dev->name,
@@ -1300,7 +1300,7 @@ int RtmpOSNetDevAttach(struct net_device *pNetDev,
 	int ret, rtnl_locked = FALSE;
 
 	DBGPRINT(RT_DEBUG_TRACE, ("RtmpOSNetDevAttach()--->\n"));
-	/* If we need hook some callback function to the net device structrue, now do it. */
+	/* If we need hook some callback function to the net device structure, now do it. */
 	if (pDevOpHook) {
 		struct rt_rtmp_adapter *pAd = NULL;
 
@@ -1351,10 +1351,10 @@ struct net_device *RtmpOSNetDevCreate(struct rt_rtmp_adapter *pAd,
 		return NULL;
 	}
 
-	/* find a available interface name, max 32 interfaces */
+	/* find an available interface name, max 32 interfaces */
 	status = RtmpOSNetDevRequestName(pAd, pNetDev, pNamePrefix, devNum);
 	if (status != NDIS_STATUS_SUCCESS) {
-		/* error! no any available ra name can be used! */
+		/* error! no available ra name can be used! */
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("Assign interface name (%s with suffix 0~32) failed...\n",
 			  pNamePrefix));
diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index 5acedf1..a449b0b 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -30,7 +30,8 @@
     Abstract:
 
     Revision History:
-    Who          When          What
+    Who          	When         	What
+    Justin P. Mattock	11/07/2010 	Fix typo in a comment
     ---------    ----------    ----------------------------------------------
 */
 
@@ -726,7 +727,7 @@ void linux_pci_unmap_single(struct rt_rtmp_adapter *pAd, dma_addr_t dma_addr,
 #define RTMP_GET_PACKET_MOREDATA(_p)				(RTPKT_TO_OSPKT(_p)->cb[CB_OFF+7])
 
 /* */
-/*      Sepcific Pakcet Type definition */
+/*      Specific Packet Type definition */
 /* */
 #define RTMP_PACKET_SPECIFIC_CB_OFFSET	11
 
diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index ad60cea..19e9bc6 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -31,7 +31,8 @@
     Create and register network interface.
 
     Revision History:
-    Who         When            What
+    Who         	When            What
+    Justin P. Mattock	11/07/2010	Fix typos in comments
     --------    ----------      ----------------------------------------------
 */
 
@@ -234,7 +235,7 @@ int rt28xx_close(struct net_device *dev)
 		RTMPPCIeLinkCtrlValueRestore(pAd, RESTORE_CLOSE);
 #endif /* RTMP_MAC_PCI // */
 
-		/* If dirver doesn't wake up firmware here, */
+		/* If driver doesn't wake up firmware here, */
 		/* NICLoadFirmware will hang forever when interface is up again. */
 		if (OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_DOZE)) {
 			AsicForceWakeup(pAd, TRUE);
@@ -310,8 +311,8 @@ int rt28xx_close(struct net_device *dev)
 			RTMP_ASIC_INTERRUPT_DISABLE(pAd);
 		}
 		/* Receive packets to clear DMA index after disable interrupt. */
-		/*RTMPHandleRxDoneInterrupt(pAd); */
-		/* put to radio off to save power when driver unload.  After radiooff, can't write /read register.  So need to finish all */
+		/* RTMPHandleRxDoneInterrupt(pAd); */
+		/* put radio off to save power when driver unloads.  After radiooff, can't write/read register, so need to finish all. */
 		/* register access before Radio off. */
 
 		brc = RT28xxPciAsicRadioOff(pAd, RTMP_HALT, 0);
diff --git a/drivers/staging/rt2860/rt_pci_rbus.c b/drivers/staging/rt2860/rt_pci_rbus.c
index 3004be6..e5fb67c 100644
--- a/drivers/staging/rt2860/rt_pci_rbus.c
+++ b/drivers/staging/rt2860/rt_pci_rbus.c
@@ -31,7 +31,8 @@
     Create and register network interface.
 
     Revision History:
-    Who         When            What
+    Who         	When            What
+    Justin P. Mattock	11/07/2010	Fix a typo
     --------    ----------      ----------------------------------------------
 */
 
@@ -356,7 +357,7 @@ static void mgmt_dma_done_tasklet(unsigned long data)
 
 	RTMPHandleMgmtRingDmaDoneInterrupt(pAd);
 
-	/* if you use RTMP_SEM_LOCK, sometimes kernel will hang up, no any */
+	/* if you use RTMP_SEM_LOCK, sometimes kernel will hang up, without any */
 	/* bug report output */
 	RTMP_INT_LOCK(&pAd->irq_lock, flags);
 	/*
@@ -787,7 +788,7 @@ IRQ_HANDLE_TYPE rt2860_interrupt(int irq, void *dev_instance)
 }
 
 /*
- * invaild or writeback cache
+ * invalid or writeback cache
  * and convert virtual address to physical address
  */
 dma_addr_t linux_pci_map_single(struct rt_rtmp_adapter *pAd, void *ptr,
diff --git a/drivers/staging/rt2860/rt_usb.c b/drivers/staging/rt2860/rt_usb.c
index bcfc0f5..580a20d 100644
--- a/drivers/staging/rt2860/rt_usb.c
+++ b/drivers/staging/rt2860/rt_usb.c
@@ -32,7 +32,8 @@
 	Revision History:
 	Who			When		What
 	--------	----------	----------------------------------------------
-	Name		Date		Modification logs
+	Name			Date		Modification logs
+	Justin P. Mattock	11/07/2010	Fix some typos.
 
 */
 
@@ -279,7 +280,7 @@ static void rtusb_dataout_complete(unsigned long data)
 	    && !RTUSB_TEST_BULK_FLAG(pAd,
 				     (fRTUSB_BULK_OUT_DATA_FRAG <<
 				      BulkOutPipeId))) {
-		/* Indicate There is data avaliable */
+		/* Indicate There is data available */
 		RTUSB_SET_BULK_FLAG(pAd,
 				    (fRTUSB_BULK_OUT_DATA_NORMAL <<
 				     BulkOutPipeId));
@@ -335,7 +336,7 @@ static void rtusb_null_frame_done_tasklet(unsigned long data)
 	}
 
 	/* Always call Bulk routine, even reset bulk. */
-	/* The protectioon of rest bulk should be in BulkOut routine */
+	/* The protection of rest bulk should be in BulkOut routine */
 	RTUSBKickBulkOut(pAd);
 }
 
@@ -383,7 +384,7 @@ static void rtusb_rts_frame_done_tasklet(unsigned long data)
 	RTMP_SEM_UNLOCK(&pAd->BulkOutLock[pRTSContext->BulkOutPipeId]);
 
 	/* Always call Bulk routine, even reset bulk. */
-	/* The protectioon of rest bulk should be in BulkOut routine */
+	/* The protection of rest bulk should be in BulkOut routine */
 	RTUSBKickBulkOut(pAd);
 
 }
@@ -427,7 +428,7 @@ static void rtusb_pspoll_frame_done_tasklet(unsigned long data)
 	RTMP_SEM_UNLOCK(&pAd->BulkOutLock[0]);
 
 	/* Always call Bulk routine, even reset bulk. */
-	/* The protectioon of rest bulk should be in BulkOut routine */
+	/* The protection of rest bulk should be in BulkOut routine */
 	RTUSBKickBulkOut(pAd);
 
 }
@@ -575,7 +576,7 @@ static void rtusb_mgmt_dma_done_tasklet(unsigned long data)
 		} else {
 
 			/* Always call Bulk routine, even reset bulk. */
-			/* The protectioon of rest bulk should be in BulkOut routine */
+			/* The protection of rest bulk should be in BulkOut routine */
 			if (pAd->MgmtRing.TxSwFreeIdx <
 			    MGMT_RING_SIZE
 			    /* pMLMEContext->bWaitingBulkOut == TRUE */) {
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index ca54e53..caf4662 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -31,11 +31,12 @@
     Miniport generic portion header file
 
     Revision History:
-    Who         When          What
+    Who         	When          	What
     --------    ----------    ----------------------------------------------
-    Paul Lin    2002-08-01    created
-    James Tan   2002-09-06    modified (Revise NTCRegTable)
-    John Chang  2004-09-06    modified for RT2600
+    Paul Lin    	2002-08-01    	created
+    James Tan   	2002-09-06    	modified (Revise NTCRegTable)
+    John Chang  	2004-09-06    	modified for RT2600
+    Justin P. Mattock	11/07/2010	Fix some typos
 */
 #ifndef __RTMP_H__
 #define __RTMP_H__
@@ -337,7 +338,7 @@ struct rt_rtmp_sg_list {
 #define LEAP_ON(_p)                 (((_p)->StaCfg.LeapAuthMode) == CISCO_AuthModeLEAP)
 #define LEAP_CCKM_ON(_p)            ((((_p)->StaCfg.LeapAuthMode) == CISCO_AuthModeLEAP) && ((_p)->StaCfg.LeapAuthInfo.CCKM == TRUE))
 
-/* if orginal Ethernet frame contains no LLC/SNAP, then an extra LLC/SNAP encap is required */
+/* if original Ethernet frame contains no LLC/SNAP, then an extra LLC/SNAP encap is required */
 #define EXTRA_LLCSNAP_ENCAP_FROM_PKT_START(_pBufVA, _pExtraLlcSnapEncap)		\
 {																\
 	if (((*(_pBufVA + 12) << 8) + *(_pBufVA + 13)) > 1500) {	\
@@ -466,7 +467,7 @@ struct rt_rtmp_dmabuf {
 /* Control block (Descriptor) for all ring descriptor DMA operation, buffer must be */
 /* contiguous physical memory. char stored the binding Rx packet descriptor */
 /* which won't be released, driver has to wait until upper layer return the packet */
-/* before giveing up this rx ring descriptor to ASIC. NDIS_BUFFER is assocaited pair */
+/* before giving up this rx ring descriptor to ASIC. NDIS_BUFFER is associated pair */
 /* to describe the packet buffer. For Tx, char stored the tx packet descriptor */
 /* which driver should ACK upper layer when the tx is physically done or failed. */
 /* */
@@ -602,7 +603,7 @@ struct rt_counter_ralink {
 };
 
 struct rt_counter_drs {
-	/* to record the each TX rate's quality. 0 is best, the bigger the worse. */
+	/* record each TX rate's quality. 0 is best, the bigger the worse. */
 	u16 TxQuality[MAX_STEP_OF_TX_RATE_SWITCH];
 	u8 PER[MAX_STEP_OF_TX_RATE_SWITCH];
 	u8 TxRateUpPenalty;	/* extra # of second penalty due to last unstable condition */
@@ -719,7 +720,7 @@ struct rt_fragment_frame {
 /* Packet information for NdisQueryPacket */
 /* */
 struct rt_packet_info {
-	u32 PhysicalBufferCount;	/* Physical breaks of buffer descripor chained */
+	u32 PhysicalBufferCount;	/* Physical breaks of buffer descriptor chained */
 	u32 BufferCount;	/* Number of Buffer descriptor chained */
 	u32 TotalPacketLength;	/* Self explained */
 	char *pFirstBuffer;	/* Pointer to first buffer descriptor */
@@ -846,8 +847,8 @@ typedef enum _ABGBAND_STATE_ {
 /* Power save method control */
 typedef union _PS_CONTROL {
 	struct {
-		unsigned long EnablePSinIdle:1;	/* Enable radio off when not connect to AP. radio on only when sitesurvey, */
-		unsigned long EnableNewPS:1;	/* Enable new  Chip power save fucntion . New method can only be applied in chip version after 2872. and PCIe. */
+		unsigned long EnablePSinIdle:1;	/* Enable radio off when not connected to AP. radio on only when sitesurvey, */
+		unsigned long EnableNewPS:1;	/* Enable new  Chip power save function . New method can only be applied in chip version after 2872. and PCIe. */
 		unsigned long rt30xxPowerMode:2;	/* Power Level Mode for rt30xx chip */
 		unsigned long rt30xxFollowHostASPM:1;	/* Card Follows Host's setting for rt30xx chip. */
 		unsigned long rt30xxForceASPMTest:1;	/* Force enable L1 for rt30xx chip. This has higher priority than rt30xxFollowHostASPM Mode. */
@@ -1117,8 +1118,8 @@ struct rt_beacon_sync {
 	unsigned long TimIELocationInBeacon[HW_BEACON_MAX_COUNT];
 	unsigned long CapabilityInfoLocationInBeacon[HW_BEACON_MAX_COUNT];
 	BOOLEAN EnableBeacon;	/* trigger to enable beacon transmission. */
-	u8 BeaconBitMap;	/* NOTE: If the MAX_MBSSID_NUM is larger than 8, this parameter need to change. */
-	u8 DtimBitOn;	/* NOTE: If the MAX_MBSSID_NUM is larger than 8, this parameter need to change. */
+	u8 BeaconBitMap;	/* NOTE: If the MAX_MBSSID_NUM is larger than 8, this parameter needs to change. */
+	u8 DtimBitOn;	/* NOTE: If the MAX_MBSSID_NUM is larger than 8, this parameter needs to change. */
 };
 #endif /* RTMP_MAC_USB // */
 
@@ -1211,7 +1212,7 @@ struct rt_common_config {
 	/*BOOLEAN               bAutoTxRateSwitch; */
 	u8 MinTxRate;	/* RATE_1, RATE_2, RATE_5_5, RATE_11 */
 	u8 RtsRate;		/* RATE_xxx */
-	HTTRANSMIT_SETTING MlmeTransmit;	/* MGMT frame PHY rate setting when operatin at Ht rate. */
+	HTTRANSMIT_SETTING MlmeTransmit;	/* MGMT frame PHY rate setting when operation at Ht rate. */
 	u8 MlmeRate;		/* RATE_xxx, used to send MLME frames */
 	u8 BasicMlmeRate;	/* Default Rate for sending MLME frames */
 
@@ -1264,7 +1265,7 @@ struct rt_common_config {
 	struct rt_ht_capability_ie HtCapability;
 	struct rt_add_ht_info_ie AddHTInfo;	/* Useful as AP. */
 	/*This IE is used with channel switch announcement element when changing to a new 40MHz. */
-	/*This IE is included in channel switch ammouncement frames 7.4.1.5, beacons, probe Rsp. */
+	/*This IE is included in channel switch announcement frames 7.4.1.5, beacons, probe Rsp. */
 	struct rt_new_ext_chan_ie NewExtChanOffset;	/*7.3.2.20A, 1 if extension channel is above the control channel, 3 if below, 0 if not present */
 
 	BOOLEAN bHTProtect;
@@ -1329,7 +1330,7 @@ struct rt_sta_admin_config {
 	/* GROUP 1 - */
 	/*   User configuration loaded from Registry, E2PROM or OID_xxx. These settings describe */
 	/*   the user intended configuration, but not necessary fully equal to the final */
-	/*   settings in ACTIVE BSS after negotiation/compromize with the BSS holder (either */
+	/*   settings in ACTIVE BSS after negotiation/compromise with the BSS holder (either */
 	/*   AP or IBSS holder). */
 	/*   Once initialized, user configuration can only be changed via OID_xxx */
 	u8 BssType;		/* BSS_INFRA or BSS_ADHOC */
@@ -1386,12 +1387,12 @@ struct rt_sta_admin_config {
 
 	/* For WPA countermeasures */
 	unsigned long LastMicErrorTime;	/* record last MIC error time */
-	unsigned long MicErrCnt;	/* Should be 0, 1, 2, then reset to zero (after disassoiciation). */
+	unsigned long MicErrCnt;	/* Should be 0, 1, 2, then reset to zero (after disassociation). */
 	BOOLEAN bBlockAssoc;	/* Block associate attempt for 60 seconds after counter measure occurred. */
 	/* For WPA-PSK supplicant state */
 	WPA_STATE WpaState;	/* Default is SS_NOTUSE and handled by microsoft 802.1x */
 	u8 ReplayCounter[8];
-	u8 ANonce[32];	/* ANonce for WPA-PSK from aurhenticator */
+	u8 ANonce[32];	/* ANonce for WPA-PSK from auhenticator */
 	u8 SNonce[32];	/* SNonce for WPA-PSK */
 
 	u8 LastSNR0;		/* last received BEACON's SNR */
@@ -1423,7 +1424,7 @@ struct rt_sta_admin_config {
 	u8 RSNIE_Len;
 	u8 RSN_IE[MAX_LEN_OF_RSNIE];	/* The content saved here should be little-endian format. */
 
-	unsigned long CLBusyBytes;	/* Save the total bytes received durning channel load scan time */
+	unsigned long CLBusyBytes;	/* Save the total bytes received during channel load scan time */
 	u16 RPIDensity[8];	/* Array for RPI density collection */
 
 	u8 RMReqCnt;		/* Number of measurement request saved. */
@@ -1489,9 +1490,9 @@ struct rt_sta_admin_config {
 	BOOLEAN bForceTxBurst;	/* 1: force enble TX PACKET BURST, 0: disable */
 };
 
-/* This data structure keep the current active BSS/IBSS's configuration that this STA */
+/* This data structure keeps the current active BSS/IBSS's configuration that this STA */
 /* had agreed upon joining the network. Which means these parameters are usually decided */
-/* by the BSS/IBSS creator instead of user configuration. Data in this data structurre */
+/* by the BSS/IBSS creator instead of user configuration. Data in this data structure */
 /* is valid only when either ADHOC_ON(pAd) or INFRA_ON(pAd) is TRUE. */
 /* Normally, after SCAN or failed roaming attempts, we need to recover back to */
 /* the current active settings. */
@@ -1519,7 +1520,7 @@ struct rt_mac_table_entry {
 	/*Choose 1 from ValidAsWDS and ValidAsCLI  to validize. */
 	BOOLEAN ValidAsCLI;	/* Sta mode, set this TRUE after Linkup,too. */
 	BOOLEAN ValidAsWDS;	/* This is WDS Entry. only for AP mode. */
-	BOOLEAN ValidAsApCli;	/*This is a AP-Client entry, only for AP mode which enable AP-Client functions. */
+	BOOLEAN ValidAsApCli;	/* This is a AP-Client entry, only for AP mode which enable AP-Client functions. */
 	BOOLEAN ValidAsMesh;
 	BOOLEAN ValidAsDls;	/* This is DLS Entry. only for STA mode. */
 	BOOLEAN isCached;
@@ -1527,7 +1528,7 @@ struct rt_mac_table_entry {
 
 	u8 EnqueueEapolStartTimerRunning;	/* Enqueue EAPoL-Start for triggering EAP SM */
 	/*jan for wpa */
-	/* record which entry revoke MIC Failure , if it leaves the BSS itself, AP won't update aMICFailTime MIB */
+	/* record which entry revoke MIC Failure, if it leaves the BSS itself, AP won't update aMICFailTime MIB */
 	u8 CMTimerRunning;
 	u8 apidx;		/* MBSS number */
 	u8 RSNIE_Len;
@@ -1722,7 +1723,7 @@ struct rt_rtmp_adapter {
 	unsigned long Rt3xxRalinkLinkCtrl;	/* USed for 3090F chip */
 	u16 DeviceID;	/* Read from PCI config */
 	unsigned long AccessBBPFailCount;
-	BOOLEAN bPCIclkOff;	/* flag that indicate if the PICE power status in Configuration SPace.. */
+	BOOLEAN bPCIclkOff;	/* flag that indicates if the PICE power status in Configuration Space.. */
 	BOOLEAN bPCIclkOffDisableTx;	/* */
 
 	BOOLEAN brt30xxBanMcuCmd;	/*when = 0xff means all commands are ok to set . */
@@ -1871,9 +1872,9 @@ struct rt_rtmp_adapter {
 	/* ---------------------------- */
 	u8 RfIcType;		/* RFIC_xxx */
 	unsigned long RfFreqOffset;	/* Frequency offset for channel switching */
-	struct rt_rtmp_rf_regs LatchRfRegs;	/* latch th latest RF programming value since RF IC doesn't support READ */
+	struct rt_rtmp_rf_regs LatchRfRegs;	/* latch the latest RF programming value since RF IC doesn't support READ */
 
-	EEPROM_ANTENNA_STRUC Antenna;	/* Since ANtenna definition is different for a & g. We need to save it for future reference. */
+	EEPROM_ANTENNA_STRUC Antenna;	/* Since Antenna definition is different for a & g. We need to save it for future reference. */
 	EEPROM_NIC_CONFIG2_STRUC NicConfig2;
 
 	/* This soft Rx Antenna Diversity mechanism is used only when user set */
@@ -1990,7 +1991,7 @@ struct rt_rtmp_adapter {
 	struct rt_common_config CommonCfg;
 	struct rt_mlme Mlme;
 
-	/* AP needs those vaiables for site survey feature. */
+	/* AP needs those variables for site survey feature. */
 	struct rt_mlme_aux MlmeAux;	/* temporary settings used during MLME state machine */
 	struct rt_bss_table ScanTab;	/* store the latest SCAN result */
 
@@ -2012,7 +2013,7 @@ struct rt_rtmp_adapter {
 	/* various Counters */
 	struct rt_counter_802_3 Counters8023;	/* 802.3 counters */
 	struct rt_counter_802_11 WlanCounters;	/* 802.11 MIB counters */
-	struct rt_counter_ralink RalinkCounters;	/* Ralink propriety counters */
+	struct rt_counter_ralink RalinkCounters;	/* Ralink proprietary counters */
 	struct rt_counter_drs DrsCounters;	/* counters for Dynamic TX Rate Switching */
 	struct rt_private PrivateInfo;	/* Private information & counters */
 
@@ -2024,7 +2025,7 @@ struct rt_rtmp_adapter {
 	u16 Sequence;
 
 	/* Control disconnect / connect event generation */
-	/*+++Didn't used anymore */
+	/*+++Not used anymore */
 	unsigned long LinkDownTime;
 	/*--- */
 	unsigned long LastRxRate;
@@ -2036,7 +2037,7 @@ struct rt_rtmp_adapter {
 	unsigned long ExtraInfo;	/* Extra information for displaying status */
 	unsigned long SystemErrorBitmap;	/* b0: E2PROM version error */
 
-	/*+++Didn't used anymore */
+	/*+++Not used anymore */
 	unsigned long MacIcVersion;	/* MAC/BBP serial interface issue solved after ver.D */
 	/*--- */
 
@@ -2089,7 +2090,7 @@ struct rt_rtmp_adapter {
 	unsigned long BulkOutReq;
 	unsigned long BulkOutComplete;
 	unsigned long BulkOutCompleteOther;
-	unsigned long BulkOutCompleteCancel;	/* seems not use now? */
+	unsigned long BulkOutCompleteCancel;	/* seems not used now? */
 	unsigned long BulkInReq;
 	unsigned long BulkInComplete;
 	unsigned long BulkInCompleteFail;
@@ -2196,9 +2197,9 @@ struct rt_rx_blk {
 struct rt_tx_blk {
 	u8 QueIdx;
 	u8 TxFrameType;	/* Indicate the Transmission type of the all frames in one batch */
-	u8 TotalFrameNum;	/* Total frame number want to send-out in one batch */
+	u8 TotalFrameNum;	/* Total frame number that wants to send-out in one batch */
 	u16 TotalFragNum;	/* Total frame fragments required in one batch */
-	u16 TotalFrameLen;	/* Total length of all frames want to send-out in one batch */
+	u16 TotalFrameLen;	/* Total length of all frames that wants to send-out in one batch */
 
 	struct rt_queue_header TxPacketList;
 	struct rt_mac_table_entry *pMacEntry;	/* NULL: packet with 802.11 RA field is multicast/broadcast address */
@@ -2207,7 +2208,7 @@ struct rt_tx_blk {
 	/* Following structure used for the characteristics of a specific packet. */
 	void *pPacket;
 	u8 *pSrcBufHeader;	/* Reference to the head of sk_buff->data */
-	u8 *pSrcBufData;	/* Reference to the sk_buff->data, will changed depends on hanlding progresss */
+	u8 *pSrcBufData;	/* Reference to the sk_buff->data, will change depending on the handling progresss */
 	u32 SrcBufLen;		/* Length of packet payload which not including Layer 2 header */
 	u8 *pExtraLlcSnapEncap;	/* NULL means no extra LLC/SNAP is required */
 	u8 HeaderBuf[128];	/* TempBuffer for TX_INFO + TX_WI + 802.11 Header + padding + AMSDU SubHeader + LLC/SNAP */
@@ -2219,7 +2220,7 @@ struct rt_tx_blk {
 	u8 apidx;		/* The interface associated to this packet */
 	u8 Wcid;		/* The MAC entry associated to this packet */
 	u8 UserPriority;	/* priority class of packet */
-	u8 FrameGap;		/* what kind of IFS this packet use */
+	u8 FrameGap;		/* what kind of IFS does this packet use */
 	u8 MpduReqNum;	/* number of fragments of this frame */
 	u8 TxRate;		/* TODO: Obsoleted? Should change to MCS? */
 	u8 CipherAlg;	/* cipher alogrithm */
diff --git a/drivers/staging/rt2860/rtmp_def.h b/drivers/staging/rt2860/rtmp_def.h
index 9c54bac..6ac617e 100644
--- a/drivers/staging/rt2860/rtmp_def.h
+++ b/drivers/staging/rt2860/rtmp_def.h
@@ -31,10 +31,11 @@
     Miniport related definition header
 
     Revision History:
-    Who         When          What
+    Who        	 	When          	What
     --------    ----------    ----------------------------------------------
-    Paul Lin    08-01-2002    created
-    John Chang  08-05-2003    add definition for 11g & other drafts
+    Paul Lin    	08-01-2002    	created
+    John Chang  	08-05-2003    	add definition for 11g & other drafts
+    Justin P. Mattock	11/07/2010	Fix some typos
 */
 #ifndef __RTMP_DEF_H__
 #define __RTMP_DEF_H__
@@ -111,11 +112,11 @@
 	WMM Note: If memory of your system is not much, please reduce the definition;
 	or when you do WMM test, the queue for low priority AC will be full, i.e.
 	TX_RING_SIZE + MAX_PACKETS_IN_QUEUE packets for the AC will be buffered in
-	WLAN, maybe no any packet buffer can be got in Ethernet driver.
+	WLAN, maybe no packet buffers can get into the Ethernet driver.
 
-	Sometimes no packet buffer can be got in Ethernet driver, the system will
+	Sometimes no packet buffer can be get into the Ethernet driver, the system will
 	send flow control packet to the sender to slow down its sending rate.
-	So no WMM can be saw in the air.
+	So no WMM can be seen in the air.
 */
 
 /*
@@ -125,7 +126,7 @@
 	And in rt_main_end.c, clConfig.clNum = RX_RING_SIZE * 3; is changed to
 	clConfig.clNum = RX_RING_SIZE * 4;
 */
-/* TODO: For VxWorks the size is 256. Shall we cahnge the value as 256 for all OS????? */
+/* TODO: For VxWorks the size is 256. Shall we change the value as 256 for all OS? */
 #define MAX_PACKETS_IN_QUEUE				(512)	/*(512)    // to pass WMM A5-WPAPSK */
 
 #define MAX_PACKETS_IN_MCAST_PS_QUEUE		32
@@ -171,7 +172,7 @@
 #define fRTMP_ADAPTER_SCAN_2040 			0x04000000
 #define	fRTMP_ADAPTER_RADIO_MEASUREMENT		0x08000000
 
-#define fRTMP_ADAPTER_START_UP         		0x10000000	/*Devive already initialized and enabled Tx/Rx. */
+#define fRTMP_ADAPTER_START_UP         		0x10000000	/*Device already initialized and enabled Tx/Rx. */
 #define fRTMP_ADAPTER_MEDIA_STATE_CHANGE    0x20000000
 #define fRTMP_ADAPTER_IDLE_RADIO_OFF        0x40000000
 
@@ -205,8 +206,8 @@
 #define fRTMP_PS_SET_PCI_CLK_OFF_COMMAND          0x00000002
 /* Indicate driver should disable kick off hardware to send packets from now. */
 #define fRTMP_PS_DISABLE_TX         0x00000004
-/* Indicate driver should IMMEDIATELY fo to sleep after receiving AP's beacon in which  doesn't indicate unicate nor multicast packets for me */
-/*. This flag is used ONLY in RTMPHandleRxDoneInterrupt routine. */
+/* Indicate driver should IMMEDIATELY go to sleep after receiving AP's beacon in which doesn't indicate unicate nor multicast packets for me */
+/* This flag is used ONLY in RTMPHandleRxDoneInterrupt routine. */
 #define fRTMP_PS_GO_TO_SLEEP_NOW         0x00000008
 #define fRTMP_PS_TOGGLE_L1		0x00000010	/* Use Toggle L1 mechanism for rt28xx PCIe */
 
@@ -303,7 +304,7 @@
 
 /* WDS definition */
 #define	MAX_WDS_ENTRY               4
-#define WDS_PAIRWISE_KEY_OFFSET     60	/* WDS links uses pairwise key#60 ~ 63 in ASIC pairwise key table */
+#define WDS_PAIRWISE_KEY_OFFSET     60	/* WDS links use pairwise key#60 ~ 63 in ASIC pairwise key table */
 
 #define	WDS_DISABLE_MODE            0
 #define	WDS_RESTRICT_MODE           1
@@ -559,7 +560,7 @@
 #define IE_ADD_HT2                        53	/* 802.11n d1. ADDITIONAL HT CAPABILITY. ELEMENT ID TBD */
 
 /* For 802.11n D3.03 */
-/*#define IE_NEW_EXT_CHA_OFFSET             62    // 802.11n d1. New extension channel offset elemet */
+/*#define IE_NEW_EXT_CHA_OFFSET             62    // 802.11n d1. New extension channel offset element */
 #define IE_SECONDARY_CH_OFFSET		62	/* 802.11n D3.03        Secondary Channel Offset element */
 #define IE_WAPI							68	/* WAPI information element */
 #define IE_2040_BSS_COEXIST               72	/* 802.11n D3.0.3 */
@@ -678,7 +679,7 @@
 
 #define ACT_MACHINE_BASE              0
 
-/*Those PEER_xx_CATE number is based on real Categary value in IEEE spec. Please don'es modify it by your self. */
+/*Those PEER_xx_CATE number is based on real Categary value in IEEE spec. Please do not modify it by your self. */
 /*Category */
 #define MT2_PEER_SPECTRUM_CATE              0
 #define MT2_PEER_QOS_CATE              1
@@ -748,7 +749,7 @@
 
 #define ACT_FUNC_SIZE                 (MAX_ACT_STATE * MAX_ACT_MSG)
 /* */
-/* STA's AUTHENTICATION state machine: states, evvents, total function # */
+/* STA's AUTHENTICATION state machine: states, events, total function # */
 /* */
 #define AUTH_REQ_IDLE                   0
 #define AUTH_WAIT_SEQ2                  1
@@ -948,7 +949,7 @@
 #define BLOCK_ACK                   0x60	/* b6:5 = 11 */
 
 /* */
-/* rtmp_data.c use these definition */
+/* rtmp_data.c uses this definition */
 /* */
 #define LENGTH_802_11               24
 #define LENGTH_802_11_AND_H         30
@@ -1288,7 +1289,7 @@
 #define IW_STA_LINKDOWN_EVENT_FLAG					0x0210
 #define IW_SCAN_COMPLETED_EVENT_FLAG				0x0211
 #define IW_SCAN_ENQUEUE_FAIL_EVENT_FLAG				0x0212
-/* if add new system event flag, please upadte the IW_SYS_EVENT_FLAG_END */
+/* if add new system event flag, please update the IW_SYS_EVENT_FLAG_END */
 #define	IW_SYS_EVENT_FLAG_END                       0x0212
 #define	IW_SYS_EVENT_TYPE_NUM						(IW_SYS_EVENT_FLAG_END - IW_SYS_EVENT_FLAG_START + 1)
 /* For system event - end */
@@ -1305,7 +1306,7 @@
 #define IW_SPOOF_DEAUTH_EVENT_FLAG					0x0307
 #define IW_SPOOF_UNKNOWN_MGMT_EVENT_FLAG			0x0308
 #define IW_REPLAY_ATTACK_EVENT_FLAG					0x0309
-/* if add new spoof attack event flag, please upadte the IW_SPOOF_EVENT_FLAG_END */
+/* if add new spoof attack event flag, please update the IW_SPOOF_EVENT_FLAG_END */
 #define	IW_SPOOF_EVENT_FLAG_END                     0x0309
 #define	IW_SPOOF_EVENT_TYPE_NUM						(IW_SPOOF_EVENT_FLAG_END - IW_SPOOF_EVENT_FLAG_START + 1)
 /* For spoof attack event - end */
@@ -1319,7 +1320,7 @@
 #define IW_FLOOD_DISASSOC_EVENT_FLAG				0x0404
 #define IW_FLOOD_DEAUTH_EVENT_FLAG					0x0405
 #define IW_FLOOD_EAP_REQ_EVENT_FLAG					0x0406
-/* if add new flooding attack event flag, please upadte the IW_FLOOD_EVENT_FLAG_END */
+/* if add new flooding attack event flag, please update the IW_FLOOD_EVENT_FLAG_END */
 #define	IW_FLOOD_EVENT_FLAG_END                   	0x0406
 #define	IW_FLOOD_EVENT_TYPE_NUM						(IW_FLOOD_EVENT_FLAG_END - IW_FLOOD_EVENT_FLAG_START + 1)
 /* For flooding attack - end */
diff --git a/drivers/staging/rt2860/rtmp_timer.h b/drivers/staging/rt2860/rtmp_timer.h
index 28b8ac6..15b6287 100644
--- a/drivers/staging/rt2860/rtmp_timer.h
+++ b/drivers/staging/rt2860/rtmp_timer.h
@@ -28,13 +28,14 @@
 	rtmp_timer.h
 
     Abstract:
-	Ralink Wireless Driver timer related data structures and delcarations
+	Ralink Wireless Driver timer related data structures and declarations 
 
     Revision History:
-	Who           When                What
+	Who          		When                 What
 	--------    ----------      ----------------------------------------------
-	Name          Date                 Modification logs
-	Shiang Tu    Aug-28-2008	init version
+	Name          		Date                 Modification logs
+	Shiang Tu    		Aug-28-2008 	     init version
+	Justin P. Mattock	11/07/2010	     Fix a typo
 
 */
 
@@ -51,8 +52,8 @@
 
 /* ----------------- Timer Related MARCO ---------------*/
 /* In some os or chipset, we have a lot of timer functions and will read/write register, */
-/*   it's not allowed in Linux USB sub-system to do it ( because of sleep issue when */
-/*  submit to ctrl pipe). So we need a wrapper function to take care it. */
+/* it's not allowed in Linux USB sub-system to do it ( because of sleep issue when */
+/* submit to ctrl pipe). So we need a wrapper function to take care it. */
 
 #ifdef RTMP_TIMER_TASK_SUPPORT
 typedef void(*RTMP_TIMER_TASK_HANDLE) (void *SystemSpecific1,
diff --git a/drivers/staging/rt2860/spectrum.h b/drivers/staging/rt2860/spectrum.h
index 648fd63..4c325ba 100644
--- a/drivers/staging/rt2860/spectrum.h
+++ b/drivers/staging/rt2860/spectrum.h
@@ -37,7 +37,7 @@ char RTMP_GetTxPwr(struct rt_rtmp_adapter *pAd, IN HTTRANSMIT_SETTING HTTxMode);
 	==========================================================================
 	Description:
 		Prepare Measurement request action frame and enqueue it into
-		management queue waiting for transmition.
+		management queue waiting for transmission.
 
 	Parametrs:
 		1. the destination mac address of the frame.
@@ -60,7 +60,7 @@ void MakeMeasurementReqFrame(struct rt_rtmp_adapter *pAd,
 	==========================================================================
 	Description:
 		Prepare Measurement report action frame and enqueue it into
-		management queue waiting for transmition.
+		management queue waiting for transmission.
 
 	Parametrs:
 		1. the destination mac address of the frame.
@@ -80,7 +80,7 @@ void EnqueueMeasurementRep(struct rt_rtmp_adapter *pAd,
 	==========================================================================
 	Description:
 		Prepare TPC Request action frame and enqueue it into
-		management queue waiting for transmition.
+		management queue waiting for transmission.
 
 	Parametrs:
 		1. the destination mac address of the frame.
@@ -94,7 +94,7 @@ void EnqueueTPCReq(struct rt_rtmp_adapter *pAd, u8 *pDA, u8 DialogToken);
 	==========================================================================
 	Description:
 		Prepare TPC Report action frame and enqueue it into
-		management queue waiting for transmition.
+		management queue waiting for transmission.
 
 	Parametrs:
 		1. the destination mac address of the frame.
@@ -110,7 +110,7 @@ void EnqueueTPCRep(struct rt_rtmp_adapter *pAd,
 	==========================================================================
 	Description:
 		Prepare Channel Switch Announcement action frame and enqueue it into
-		management queue waiting for transmition.
+		management queue waiting for transmission.
 
 	Parametrs:
 		1. the destination mac address of the frame.
@@ -126,7 +126,7 @@ void EnqueueChSwAnn(struct rt_rtmp_adapter *pAd,
 /*
 	==========================================================================
 	Description:
-		Spectrun action frames Handler such as channel switch annoucement,
+		Spectrun action frames Handler such as channel switch announcement,
 		measurement report, measurement request actions frames.
 
 	Parametrs:
diff --git a/drivers/staging/rt2860/sta/assoc.c b/drivers/staging/rt2860/sta/assoc.c
index b7efb0b..ab0a83b 100644
--- a/drivers/staging/rt2860/sta/assoc.c
+++ b/drivers/staging/rt2860/sta/assoc.c
@@ -32,7 +32,8 @@
 	Revision History:
 	Who			When			What
 	--------	----------		----------------------------------------------
-	John		2004-9-3		porting from RT2500
+	John			2004-9-3		porting from RT2500
+	Justin P. Mattock	11/07/2010		Fix typos
 */
 #include "../rt_config.h"
 
@@ -277,10 +278,10 @@ void MlmeAssocReqAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *
 	u16 VarIesOffset;
 	u16 Status;
 
-	/* Block all authentication request durning WPA block period */
+	/* Block all authentication request during WPA block period */
 	if (pAd->StaCfg.bBlockAssoc == TRUE) {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("ASSOC - Block Assoc request durning WPA block period!\n"));
+			 ("ASSOC - Block Assoc request during WPA block period!\n"));
 		pAd->Mlme.AssocMachine.CurrState = ASSOC_IDLE;
 		Status = MLME_STATE_MACHINE_REJECT;
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_ASSOC_CONF, 2,
@@ -605,10 +606,10 @@ void MlmeReassocReqAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem
 	u8 *pOutBuffer = NULL;
 	u16 Status;
 
-	/* Block all authentication request durning WPA block period */
+	/* Block all authentication request during WPA block period */
 	if (pAd->StaCfg.bBlockAssoc == TRUE) {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("ASSOC - Block ReAssoc request durning WPA block period!\n"));
+			 ("ASSOC - Block ReAssoc request during WPA block period!\n"));
 		pAd->Mlme.AssocMachine.CurrState = ASSOC_IDLE;
 		Status = MLME_STATE_MACHINE_REJECT;
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_REASSOC_CONF, 2,
@@ -1001,7 +1002,7 @@ void AssocPostProc(struct rt_rtmp_adapter *pAd, u8 *pAddr2, u16 CapabilityInfo,
 	pAd->MlmeAux.CapabilityInfo =
 	    CapabilityInfo & SUPPORTED_CAPABILITY_INFO;
 
-	/* Some HT AP might lost WMM IE. We add WMM ourselves. beacuase HT requires QoS on. */
+	/* Some HT AP might lost WMM IE. We add WMM ourselves. because HT requires QoS on. */
 	if ((HtCapabilityLen > 0) && (pEdcaParm->bValid == FALSE)) {
 		pEdcaParm->bValid = TRUE;
 		pEdcaParm->Aifsn[0] = 3;
diff --git a/drivers/staging/rt2860/sta/auth.c b/drivers/staging/rt2860/sta/auth.c
index 404bd22..a2bfafd 100644
--- a/drivers/staging/rt2860/sta/auth.c
+++ b/drivers/staging/rt2860/sta/auth.c
@@ -32,7 +32,8 @@
 	Revision History:
 	Who			When			What
 	--------	----------		----------------------------------------------
-	John		2004-9-3		porting from RT2500
+	John			2004-9-3		porting from RT2500
+	Justin P. Mattock	11/07/2010		Fix typos
 */
 #include "../rt_config.h"
 
@@ -455,10 +456,10 @@ BOOLEAN AUTH_ReqSend(struct rt_rtmp_adapter *pAd,
 	u8 *pOutBuffer = NULL;
 	unsigned long FrameLen = 0, tmp = 0;
 
-	/* Block all authentication request durning WPA block period */
+	/* Block all authentication request during WPA block period */
 	if (pAd->StaCfg.bBlockAssoc == TRUE) {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("%s - Block Auth request durning WPA block period!\n",
+			 ("%s - Block Auth request during WPA block period!\n",
 			  pSMName));
 		pAd->Mlme.AuthMachine.CurrState = AUTH_REQ_IDLE;
 		Status = MLME_STATE_MACHINE_REJECT;
diff --git a/drivers/staging/rt2860/sta/connect.c b/drivers/staging/rt2860/sta/connect.c
index c380551..4b2c84e 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -32,7 +32,8 @@
 	Revision History:
 	Who			When			What
 	--------	----------		----------------------------------------------
-	John			2004-08-08			Major modification from RT2560
+	John			2004-08-08		Major modification from RT2560
+	Justin P. Mattock	11/07/2010		Fix typos
 */
 #include "../rt_config.h"
 
@@ -64,7 +65,7 @@ u8 CipherSuiteWpaNoneAesLen =
 
 /* The following MACRO is called after 1. starting an new IBSS, 2. successfully JOIN an IBSS, */
 /* or 3. successfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS */
-/* All settings successfuly negotiated furing MLME state machines become final settings */
+/* All settings successfuly negotiated firing MLME state machines become final settings */
 /* and are copied to pAd->StaActive */
 #define COPY_SETTINGS_FROM_MLME_AUX_TO_ACTIVE_CFG(_pAd)                                 \
 {                                                                                       \
@@ -553,7 +554,7 @@ void CntlOidRTBssidProc(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *
 	NdisMoveMemory(&pAd->MlmeAux.SsidBssTab.BssEntry[0],
 		       &pAd->ScanTab.BssEntry[BssIdx], sizeof(struct rt_bss_entry));
 
-	/* Add SSID into MlmeAux for site surey joining hidden SSID */
+	/* Add SSID into MlmeAux for site survey joining hidden SSID */
 	pAd->MlmeAux.SsidLen = pAd->ScanTab.BssEntry[BssIdx].SsidLen;
 	NdisMoveMemory(pAd->MlmeAux.Ssid, pAd->ScanTab.BssEntry[BssIdx].Ssid,
 		       pAd->MlmeAux.SsidLen);
@@ -666,7 +667,7 @@ void CntlOidRTBssidProc(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *
 }
 
 /* Roaming is the only external request triggering CNTL state machine */
-/* despite of other "SET OID" operation. All "SET OID" related oerations */
+/* despite of other "SET OID" operation. All "SET OID" related operations */
 /* happen in sequence, because no other SET OID will be sent to this device */
 /* until the the previous SET operation is complete (successful o failed). */
 /* So, how do we quarantee this ROAMING request won't corrupt other "SET OID"? */
@@ -1224,7 +1225,7 @@ void LinkUp(struct rt_rtmp_adapter *pAd, u8 BssType)
 	/* Change to AP channel */
 	if ((pAd->CommonCfg.CentralChannel > pAd->CommonCfg.Channel)
 	    && (pAd->MlmeAux.HtCapability.HtCapInfo.ChannelWidth == BW_40)) {
-		/* Must using 40MHz. */
+		/* Must use 40MHz. */
 		pAd->CommonCfg.BBPCurrentBW = BW_40;
 		AsicSwitchChannel(pAd, pAd->CommonCfg.CentralChannel, FALSE);
 		AsicLockChannel(pAd, pAd->CommonCfg.CentralChannel);
@@ -1259,7 +1260,7 @@ void LinkUp(struct rt_rtmp_adapter *pAd, u8 BssType)
 	} else if ((pAd->CommonCfg.CentralChannel < pAd->CommonCfg.Channel)
 		   && (pAd->MlmeAux.HtCapability.HtCapInfo.ChannelWidth ==
 		       BW_40)) {
-		/* Must using 40MHz. */
+		/* Must use 40MHz. */
 		pAd->CommonCfg.BBPCurrentBW = BW_40;
 		AsicSwitchChannel(pAd, pAd->CommonCfg.CentralChannel, FALSE);
 		AsicLockChannel(pAd, pAd->CommonCfg.CentralChannel);
@@ -1343,12 +1344,12 @@ void LinkUp(struct rt_rtmp_adapter *pAd, u8 BssType)
 	AsicSetSlotTime(pAd, TRUE);
 	AsicSetEdcaParm(pAd, &pAd->CommonCfg.APEdcaParm);
 
-	/* Call this for RTS protectionfor legacy rate, we will always enable RTS threshold, but normally it will not hit */
+	/* Call this for RTS protection for legacy rate, we will always enable RTS threshold, but normally it will not hit */
 	AsicUpdateProtect(pAd, 0, (OFDMSETPROTECT | CCKSETPROTECT), TRUE,
 			  FALSE);
 
 	if ((pAd->StaActive.SupportedPhyInfo.bHtEnable == TRUE)) {
-		/* Update HT protectionfor based on AP's operating mode. */
+		/* Update HT protection for based on AP's operating mode. */
 		if (pAd->MlmeAux.AddHtInfo.AddHtInfo2.NonGfPresent == 1) {
 			AsicUpdateProtect(pAd,
 					  pAd->MlmeAux.AddHtInfo.AddHtInfo2.
@@ -1530,7 +1531,7 @@ void LinkUp(struct rt_rtmp_adapter *pAd, u8 BssType)
 		/* Add BSSID to WCID search table */
 		AsicUpdateRxWCIDTable(pAd, BSSID_WCID, pAd->CommonCfg.Bssid);
 
-		/* If WEP is enabled, add paiewise and shared key */
+		/* If WEP is enabled, add pairwise and shared key */
 		if (((pAd->StaCfg.WpaSupplicantUP) &&
 		     (pAd->StaCfg.WepStatus == Ndis802_11WEPEnabled) &&
 		     (pAd->StaCfg.PortSecured == WPA_802_1X_PORT_SECURED)) ||
@@ -1681,9 +1682,9 @@ void LinkUp(struct rt_rtmp_adapter *pAd, u8 BssType)
 	pAd->Mlme.PeriodicRound = 0;
 	pAd->Mlme.OneSecPeriodicRound = 0;
 	pAd->bConfigChanged = FALSE;	/* Reset config flag */
-	pAd->ExtraInfo = GENERAL_LINK_UP;	/* Update extra information to link is up */
+	pAd->ExtraInfo = GENERAL_LINK_UP;	/* Update extra information after link is up */
 
-	/* Set asic auto fall back */
+	/* Set basic auto fall back */
 	{
 		u8 *pTable;
 		u8 TableSize = 0;
@@ -1854,8 +1855,8 @@ void LinkUp(struct rt_rtmp_adapter *pAd, u8 BssType)
 	Note:
 		We need more information to know it's this requst from AP.
 		If yes! we need to do extra handling, for example, remove the WPA key.
-		Otherwise on 4-way handshaking will faied, since the WPA key didn't be
-		remove while auto reconnect.
+		Otherwise on 4-way handshaking will fail, since the WPA key didn't get
+		removed while auto reconnect.
 		Disconnect request from AP, it means we will start afresh 4-way handshaking
 		on WPA mode.
 
@@ -1870,9 +1871,9 @@ void LinkDown(struct rt_rtmp_adapter *pAd, IN BOOLEAN IsReqFromAP)
 		return;
 
 	RTMP_CLEAR_PSFLAG(pAd, fRTMP_PS_GO_TO_SLEEP_NOW);
-	/*Comment the codes, beasue the line 2291 call the same function. */
-	/*RTMPCancelTimer(&pAd->Mlme.PsPollTimer,               &Cancelled); */
-	/* Not allow go to sleep within linkdown function. */
+	/* Comment the codes, because the line 2291 call the same function. */
+	/* RTMPCancelTimer(&pAd->Mlme.PsPollTimer, &Cancelled); */
+	/* Not allowed go to sleep within the linkdown function. */
 	RTMP_CLEAR_PSFLAG(pAd, fRTMP_PS_CAN_GO_SLEEP);
 
 	if (pAd->CommonCfg.bWirelessEvent) {
@@ -1970,7 +1971,7 @@ void LinkDown(struct rt_rtmp_adapter *pAd, IN BOOLEAN IsReqFromAP)
 	/* Set LED */
 	RTMPSetLED(pAd, LED_LINK_DOWN);
 	pAd->LedIndicatorStrength = 0xF0;
-	RTMPSetSignalLED(pAd, -100);	/* Force signal strength Led to be turned off, firmware is not done it. */
+	RTMPSetSignalLED(pAd, -100);	/* Force signal strength Led to be turned off, firmware has not done it. */
 
 	AsicDisableSync(pAd);
 
diff --git a/drivers/staging/rt2860/sta/rtmp_data.c b/drivers/staging/rt2860/sta/rtmp_data.c
index 23879b7..d7c2012 100644
--- a/drivers/staging/rt2860/sta/rtmp_data.c
+++ b/drivers/staging/rt2860/sta/rtmp_data.c
@@ -31,7 +31,8 @@
 	Data path subroutines
 
 	Revision History:
-	Who 		When			What
+	Who 	  		When		What
+	Justin P. Mattock	11/07/2010	Fix typos
 	--------	----------		----------------------------------------------
 */
 #include "../rt_config.h"
@@ -257,8 +258,8 @@ void STARxDataFrameAnnounce(struct rt_rtmp_adapter *pAd,
 		    && (pAd->CommonCfg.bDisableReordering == 0)) {
 			Indicate_AMPDU_Packet(pAd, pRxBlk, FromWhichBSSID);
 		} else {
-			/* Determin the destination of the EAP frame */
-			/*  to WPA state machine or upper layer */
+			/* Determine the destination of the EAP frame */
+			/* to WPA state machine or upper layer */
 			STARxEAPOLFrameIndicate(pAd, pEntry, pRxBlk,
 						FromWhichBSSID);
 		}
@@ -853,7 +854,7 @@ Return Value:
 	NONE
 
 Note:
-	This function do early checking and classification for send-out packet.
+	This function does early checking and classification for send-out packet.
 	You only can put OS-depened & STA related code in here.
 ========================================================================
 */
@@ -943,7 +944,7 @@ int STASendPacket(struct rt_rtmp_adapter *pAd, void *pPacket)
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("STASendPacket --> pSrcBufVA == NULL !SrcBufLen=%x\n",
 			  SrcBufLen));
-		/* Resourece is low, system did not allocate virtual address */
+		/* Resource is low, system did not allocate virtual address */
 		/* return NDIS_STATUS_FAILURE directly to upper layer */
 		RELEASE_NDIS_PACKET(pAd, pPacket, NDIS_STATUS_FAILURE);
 		return NDIS_STATUS_FAILURE;
@@ -979,7 +980,7 @@ int STASendPacket(struct rt_rtmp_adapter *pAd, void *pPacket)
 		DBGPRINT(RT_DEBUG_ERROR,
 			("STASendPacket->Cannot find pEntry(%pM) in MacTab!\n",
 				pSrcBufVA));
-		/* Resourece is low, system did not allocate virtual address */
+		/* Resource is low, system did not allocate virtual address */
 		/* return NDIS_STATUS_FAILURE directly to upper layer */
 		RELEASE_NDIS_PACKET(pAd, pPacket, NDIS_STATUS_FAILURE);
 		return NDIS_STATUS_FAILURE;
@@ -1057,9 +1058,9 @@ int STASendPacket(struct rt_rtmp_adapter *pAd, void *pPacket)
 
 	/* STEP 2. Check the requirement of RTS: */
 	/*         If multiple fragment required, RTS is required only for the first fragment */
-	/*         if the fragment size large than RTS threshold */
+	/*         if the fragment size is larger than RTS threshold */
 	/*     For RT28xx, Let ASIC send RTS/CTS */
-/*      RTMP_SET_PACKET_RTS(pPacket, 0); */
+	/*      RTMP_SET_PACKET_RTS(pPacket, 0); */
 	if (NumberOfFrag > 1)
 		RTSRequired =
 		    (pAd->CommonCfg.FragmentThreshold >
@@ -1171,8 +1172,8 @@ int STASendPacket(struct rt_rtmp_adapter *pAd, void *pPacket)
 	========================================================================
 
 	Routine Description:
-		This subroutine will scan through releative ring descriptor to find
-		out avaliable free ring descriptor and compare with request size.
+		This subroutine will scan through relative ring descriptor to find
+		out available free ring descriptor and compare with request size.
 
 	Arguments:
 		pAd Pointer to our adapter
@@ -1588,7 +1589,7 @@ static inline u8 *STA_Build_ARalink_Frame_Header(struct rt_rtmp_adapter *pAd,
 		pHeaderBufPtr += 2;
 		pTxBlk->MpduHeaderLen += 2;
 	}
-	/* padding at front of LLC header. LLC header should at 4-bytes aligment. */
+	/* padding at front of LLC header. LLC header should at 4-bytes alignment. */
 	pTxBlk->HdrPadLen = (unsigned long)pHeaderBufPtr;
 	pHeaderBufPtr = (u8 *)ROUND_UP(pHeaderBufPtr, 4);
 	pTxBlk->HdrPadLen = (unsigned long)(pHeaderBufPtr - pTxBlk->HdrPadLen);
@@ -2014,7 +2015,7 @@ void STA_Legacy_Frame_Tx(struct rt_rtmp_adapter *pAd, struct rt_tx_blk *pTxBlk)
 		pHeaderBufPtr += 2;
 		pTxBlk->MpduHeaderLen += 2;
 	}
-	/* The remaining content of MPDU header should locate at 4-octets aligment */
+	/* The remaining content of MPDU header should locate at 4-octets alignment */
 	pTxBlk->HdrPadLen = (unsigned long)pHeaderBufPtr;
 	pHeaderBufPtr = (u8 *)ROUND_UP(pHeaderBufPtr, 4);
 	pTxBlk->HdrPadLen = (unsigned long)(pHeaderBufPtr - pTxBlk->HdrPadLen);
@@ -2114,7 +2115,7 @@ void STA_ARalink_Frame_Tx(struct rt_rtmp_adapter *pAd, struct rt_tx_blk *pTxBlk)
 			    STA_Build_ARalink_Frame_Header(pAd, pTxBlk);
 
 			/* It's ok write the TxWI here, because the TxWI->MPDUtotalByteCount */
-			/*      will be updated after final frame was handled. */
+			/* will be updated after final frame was handled. */
 			RTMPWriteTxWI_Data(pAd,
 					   (struct rt_txwi *) (&pTxBlk->
 							  HeaderBuf
@@ -2291,8 +2292,8 @@ void STA_Fragment_Frame_Tx(struct rt_rtmp_adapter *pAd, struct rt_tx_blk *pTxBlk
 				      pTxBlk->pExtraLlcSnapEncap, pTxBlk->pKey,
 				      0);
 
-		/* NOTE: DON'T refer the skb->len directly after following copy. Becasue the length is not adjust */
-		/*                      to correct lenght, refer to pTxBlk->SrcBufLen for the packet length in following progress. */
+		/* NOTE: DON'T refer the skb->len directly after following copy. Because the length is not adjusted */
+		/*                      to correct length, refer to pTxBlk->SrcBufLen for the packet length in following progress. */
 		NdisMoveMemory(pTxBlk->pSrcBufData + pTxBlk->SrcBufLen,
 			       &pAd->PrivateInfo.Tx.MIC[0], 8);
 		/*skb_put((RTPKT_TO_OSPKT(pTxBlk->pPacket))->tail, 8); */
@@ -2301,7 +2302,7 @@ void STA_Fragment_Frame_Tx(struct rt_rtmp_adapter *pAd, struct rt_tx_blk *pTxBlk
 		pTxBlk->CipherAlg = CIPHER_TKIP_NO_MIC;
 	}
 	/* */
-	/* calcuate the overhead bytes that encryption algorithm may add. This */
+	/* calculate the overhead bytes that encryption algorithm may add. This */
 	/* affects the calculate of "duration" field */
 	/* */
 	if ((pTxBlk->CipherAlg == CIPHER_WEP64)
diff --git a/drivers/staging/rt2860/sta/sanity.c b/drivers/staging/rt2860/sta/sanity.c
index 8f9fd19..0c32604 100644
--- a/drivers/staging/rt2860/sta/sanity.c
+++ b/drivers/staging/rt2860/sta/sanity.c
@@ -32,7 +32,8 @@
 	Revision History:
 	Who			When			What
 	--------	----------		----------------------------------------------
-	John Chang  2004-09-01      add WMM support
+	John Chang  		2004-09-01      add WMM support
+	Justin P. Mattock	11/07/2010	Fix typos
 */
 #include "../rt_config.h"
 
@@ -118,7 +119,7 @@ BOOLEAN PeerAssocRspSanity(struct rt_rtmp_adapter *pAd, void * pMsg, unsigned lo
 	NdisMoveMemory(pAid, &pFrame->Octet[4], 2);
 	Length += 2;
 
-	/* Aid already swaped byte order in RTMPFrameEndianChange() for big endian platform */
+	/* Aid already swapped byte order in RTMPFrameEndianChange() for big endian platform */
 	*pAid = (*pAid) & 0x3fff;	/* AID is low 14-bit */
 
 	/* -- get supported rates from payload and advance the pointer */
diff --git a/drivers/staging/rt2860/sta/sync.c b/drivers/staging/rt2860/sta/sync.c
index 747d3c6..05007d9 100644
--- a/drivers/staging/rt2860/sta/sync.c
+++ b/drivers/staging/rt2860/sta/sync.c
@@ -32,8 +32,9 @@
 	Revision History:
 	Who			When			What
 	--------	----------		----------------------------------------------
-	John Chang	2004-09-01      modified for rt2561/2661
-	Jan Lee		2006-08-01      modified for rt2860 for 802.11n
+	John Chang		2004-09-01      	modified for rt2561/2661
+	Jan Lee			2006-08-01      	modified for rt2860 for 802.11n
+	Justin P. Mattock	11/07/2010		Fix typos
 */
 #include "../rt_config.h"
 
@@ -233,9 +234,9 @@ void MlmeScanReqAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *E
 		RTMPSuspendMsduTransmission(pAd);
 
 		/* */
-		/* To prevent data lost. */
-		/* Send an NULL data with turned PSM bit on to current associated AP before SCAN progress. */
-		/* And should send an NULL data with turned PSM bit off to AP, when scan progress done */
+		/* To prevent data loss. */
+		/* Send a NULL data with turned PSM bit on to current associated AP before SCAN progress. */
+		/* And should send a NULL data with turned PSM bit off to AP, when scan progress done */
 		/* */
 		if (OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_MEDIA_STATE_CONNECTED)
 		    && (INFRA_ON(pAd))) {
@@ -750,9 +751,9 @@ void PeerBeaconAtJoinAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_el
 
 		/* BEACON from desired BSS/IBSS found. We should be able to decide most */
 		/* BSS parameters here. */
-		/* Q. But what happen if this JOIN doesn't conclude a successful ASSOCIATEION? */
-		/*    Do we need to receover back all parameters belonging to previous BSS? */
-		/* A. Should be not. There's no back-door recover to previous AP. It still need */
+		/* Q. But what happen if this JOIN doesn't conclude a successful ASSOCIATION? */
+		/*    Do we need to recover back all parameters belonging to previous BSS? */
+		/* A. Should be not. There's no back-door recover to previous AP. It still needs */
 		/*    a new JOIN-AUTH-ASSOC sequence. */
 		if (MAC_ADDR_EQUAL(pAd->MlmeAux.Bssid, Bssid)) {
 			DBGPRINT(RT_DEBUG_TRACE,
@@ -876,7 +877,7 @@ void PeerBeaconAtJoinAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_el
 			pAd->MlmeAux.CfpMaxDuration = Cf.CfpMaxDuration;
 			pAd->MlmeAux.APRalinkIe = RalinkIe;
 
-			/* Copy AP's supported rate to MlmeAux for creating assoication request */
+			/* Copy AP's supported rate to MlmeAux for creating association request */
 			/* Also filter out not supported rate */
 			pAd->MlmeAux.SupRateLen = SupRateLen;
 			NdisMoveMemory(pAd->MlmeAux.SupRate, SupRate,
diff --git a/drivers/staging/rt2860/sta/wpa.c b/drivers/staging/rt2860/sta/wpa.c
index 69b8a24..ff34832 100644
--- a/drivers/staging/rt2860/sta/wpa.c
+++ b/drivers/staging/rt2860/sta/wpa.c
@@ -33,7 +33,8 @@
 	Who			When			What
 	--------	----------		----------------------------------------------
 	Jan	Lee		03-07-22		Initial
-	Paul Lin	03-11-28		Modify for supplicant
+	Paul Lin		03-11-28		Modify for supplicant
+	Justin P. Mattock	11/07/2010		Fix typos
 */
 #include "../rt_config.h"
 
@@ -86,7 +87,7 @@ void RTMPReportMicError(struct rt_rtmp_adapter *pAd, struct rt_cipher_key *pWpaK
 			/* Violate MIC error counts, MIC countermeasures kicks in */
 			pAd->StaCfg.MicErrCnt++;
 			/* We shall block all reception */
-			/* We shall clean all Tx ring and disassoicate from AP after next EAPOL frame */
+			/* We shall clean all Tx ring and disassociate from AP after next EAPOL frame */
 			/* */
 			/* No necessary to clean all Tx ring, on RTMPHardTransmit will stop sending non-802.1X EAPOL packets */
 			/* if pAd->StaCfg.MicErrCnt greater than 2. */
diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index e095a44..5717e12 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -31,10 +31,11 @@
     IOCTL related subroutines
 
     Revision History:
-    Who         When          What
+    	Who        		 When          What
     --------    ----------    ----------------------------------------------
-    Rory Chen   01-03-2003    created
-	Rory Chen   02-14-2005    modify to support RT61
+   	Rory Chen   		01-03-2003    	created
+	Rory Chen   		02-14-2005    	modify to support RT61
+	Justin P. Mattock	11/07/2010	Fix typos
 */
 
 #include	"rt_config.h"
@@ -851,7 +852,7 @@ int rt_ioctl_giwscan(struct net_device *dev,
 
 		/*
 		   Protocol:
-		   it will show scanned AP's WirelessMode .
+		   it will show scanned AP's WirelessMode.
 		   it might be
 		   802.11a
 		   802.11a/n
@@ -875,13 +876,13 @@ int rt_ioctl_giwscan(struct net_device *dev,
 					strcpy(iwe.u.name, "802.11a");
 			} else {
 				/*
-				   if one of non B mode rate is set supported rate . it mean G only.
+				   if one of non B mode rate is set supported rate, it means G only.
 				 */
 				for (rateCnt = 0;
 				     rateCnt < pBssEntry->SupRateLen;
 				     rateCnt++) {
 					/*
-					   6Mbps(140) 9Mbps(146) and >=12Mbps(152) are supported rate , it mean G only.
+					   6Mbps(140) 9Mbps(146) and >=12Mbps(152) are supported rate, it means G only.
 					 */
 					if (pBssEntry->SupRate[rateCnt] == 140
 					    || pBssEntry->SupRate[rateCnt] ==
@@ -1417,7 +1418,7 @@ int rt_ioctl_siwencode(struct net_device *dev,
 		if ((index >= 0) && (index < 4)) {
 			pAdapter->StaCfg.DefaultKeyId = index;
 		} else
-			/* Don't complain if only change the mode */
+			/* Don't complain if the mode is only changed */
 		if (!(erq->flags & IW_ENCODE_MODE))
 			return -EINVAL;
 	}
@@ -2732,8 +2733,8 @@ int Set_NetworkType_Proc(struct rt_rtmp_adapter *pAdapter, char *arg)
 			}
 			if (INFRA_ON(pAdapter)) {
 				/*BOOLEAN Cancelled; */
-				/* Set the AutoReconnectSsid to prevent it reconnect to old SSID */
-				/* Since calling this indicate user don't want to connect to that SSID anymore. */
+				/* Set the AutoReconnectSsid to prevent it from reconnecting to the old SSID */
+				/* Since calling this indicates users don't want to connect to that SSID anymore. */
 				pAdapter->MlmeAux.AutoReconnectSsidLen = 32;
 				NdisZeroMemory(pAdapter->MlmeAux.
 					       AutoReconnectSsid,
@@ -2766,8 +2767,8 @@ int Set_NetworkType_Proc(struct rt_rtmp_adapter *pAdapter, char *arg)
 				LinkDown(pAdapter, FALSE);
 			}
 			if (ADHOC_ON(pAdapter)) {
-				/* Set the AutoReconnectSsid to prevent it reconnect to old SSID */
-				/* Since calling this indicate user don't want to connect to that SSID anymore. */
+				/* Set the AutoReconnectSsid to prevent it from reconnecting to the old SSID */
+				/* Since calling this indicates users don't want to connect to that SSID anymore. */
 				pAdapter->MlmeAux.AutoReconnectSsidLen = 32;
 				NdisZeroMemory(pAdapter->MlmeAux.
 					       AutoReconnectSsid,
@@ -2884,7 +2885,7 @@ int Set_NetworkType_Proc(struct rt_rtmp_adapter *pAdapter, char *arg)
 		}
 		/* Enable Rx with promiscuous reception */
 		RTMP_IO_WRITE32(pAdapter, RX_FILTR_CFG, 0x3);
-		/* ASIC supporsts sniffer function with replacing RSSI with timestamp. */
+		/* ASIC supports sniffer function with replacing RSSI with timestamp. */
 		/*RTMP_IO_READ32(pAdapter, MAC_SYS_CTRL, &Value); */
 		/*Value |= (0x80); */
 		/*RTMP_IO_WRITE32(pAdapter, MAC_SYS_CTRL, Value); */
diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
index ebf9074..a8820d3 100644
--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -27,8 +27,8 @@
 #include "rt_config.h"
 
 /* Following information will be show when you run 'modinfo' */
-/* *** If you have a solution for the bug in current version of driver, please mail to me. */
-/* Otherwise post to forum in ralinktech's web site(www.ralinktech.com) and let all users help you. *** */
+/* If you have a solution for the bug in current version of driver, please e-mail me. */
+/* Otherwise post to the forum at ralinktech's web site(www.ralinktech.com) and let all users help you. */
 MODULE_AUTHOR("Paul Lin <paul_lin@ralinktech.com>");
 MODULE_DESCRIPTION("RT2870/RT3070 Wireless Lan Linux Driver");
 MODULE_LICENSE("GPL");
@@ -882,8 +882,8 @@ static int __devinit rt2870_probe(IN struct usb_interface *intf,
 	if (net_dev == NULL)
 		goto err_out_free_radev;
 
-	/* Here are the net_device structure with usb specific parameters. */
-	/* for supporting Network Manager.
+	/* Here are the net_device structure with usb specific parameters. 
+	 * for supporting Network Manager.
 	 * Set the sysfs physical device reference for the network logical device if set prior to registration will
 	 * cause a symlink during initialization.
 	 */
diff --git a/drivers/staging/rt2860/wpa.h b/drivers/staging/rt2860/wpa.h
index 6199ae6..116fc2c 100644
--- a/drivers/staging/rt2860/wpa.h
+++ b/drivers/staging/rt2860/wpa.h
@@ -32,13 +32,14 @@
 	Revision History:
 	Who			When			What
 	--------	----------		----------------------------------------------
-	Name		Date			Modification logs
+	Name			Date			Modification logs
+	Justin P. Mattock	11/07/2010		Fix a typo
 */
 
 #ifndef	__WPA_H__
 #define	__WPA_H__
 
-/* EAPOL Key descripter frame format related length */
+/* EAPOL Key descriptor frame format related length */
 #define LEN_KEY_DESC_NONCE			32
 #define LEN_KEY_DESC_IV				16
 #define LEN_KEY_DESC_RSC			8
-- 
1.7.1

