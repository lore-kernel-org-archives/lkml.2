Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788Ab2LEUwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:52:50 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37430 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab2LEUva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:51:30 -0500
From: Sebastian Hahn <snsehahn@cip.cs.fau.de>
To: gregkh@linuxfoundation.org
Cc: Jennifer.Naumann@informatik.stud.uni-erlangen.de, dan.carpenter@oracle.com,
        standby24x7@gmail.com, Julia.Lawall@lip6.fr, jkosina@suse.cz,
        joe@perches.com, yongjun_wei@trendmicro.com.cn,
        adam.buchbinder@gmail.com, amwang@redhat.com, justinmattock@gmail.com,
        wfp5p@virginia.edu, jim.cromie@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/6] staging/rtl8192u: put { on same line as struct
Date: Wed,  5 Dec 2012 21:40:19 +0100
Message-Id: <1354740023-30849-3-git-send-email-snsehahn@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
References: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jennifer Naumann <Jennifer.Naumann@informatik.stud.uni-erlangen.de>

This fixes the checkpatch error "open brace '{' following struct go on the
same line" in staging/rtl8192u

Signed-off-by: Jennifer Naumann <Jennifer.Naumann@informatik.stud.uni-erlangen.de>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211.h   |   12 ++---
 drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h  |    3 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h |   51 ++++++++--------------
 drivers/staging/rtl8192u/r8192U.h                |   27 ++++--------
 drivers/staging/rtl8192u/r8192U_core.c           |    3 +-
 drivers/staging/rtl8192u/r8192U_dm.h             |    9 ++--
 drivers/staging/rtl8192u/r8192U_wx.c             |    3 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.h         |   18 +++-----
 8 files changed, 42 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index bb0e4fe..b85e3e3 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -1655,8 +1655,7 @@ typedef struct tx_pending_t{
 	struct ieee80211_txb *txb;
 }tx_pending_t;
 
-typedef struct _bandwidth_autoswitch
-{
+typedef struct _bandwidth_autoswitch {
 	long threshold_20Mhzto40Mhz;
 	long	threshold_40Mhzto20Mhz;
 	bool bforced_tx20Mhz;
@@ -1668,8 +1667,7 @@ typedef struct _bandwidth_autoswitch
 
 #define REORDER_WIN_SIZE	128
 #define REORDER_ENTRY_NUM	128
-typedef struct _RX_REORDER_ENTRY
-{
+typedef struct _RX_REORDER_ENTRY {
 	struct list_head	List;
 	u16			SeqNum;
 	struct ieee80211_rxb* prxb;
@@ -1709,15 +1707,13 @@ typedef struct _IbssParms{
 #define MAX_NUM_RATES	264 // Max num of support rates element: 8,  Max num of ext. support rate: 255. 061122, by rcnjko.
 
 // RF state.
-typedef	enum _RT_RF_POWER_STATE
-{
+typedef	enum _RT_RF_POWER_STATE {
 	eRfOn,
 	eRfSleep,
 	eRfOff
 }RT_RF_POWER_STATE;
 
-typedef struct _RT_POWER_SAVE_CONTROL
-{
+typedef struct _RT_POWER_SAVE_CONTROL {
 
 	//
 	// Inactive Power Save(IPS) : Disable RF when disconnected
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h b/drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h
index ffd1c0c..2c398ca 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h
@@ -28,8 +28,7 @@ struct ieee80211_ADDBA_Req{
 //Is this need?I put here just to make it easier to define structure BA_RECORD //WB
 typedef union _SEQUENCE_CONTROL{
 	u16 ShortData;
-	struct
-	{
+	struct {
 		u16	FragNum:4;
 		u16	SeqNum:12;
 	}field;
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h b/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h
index 2625cde..2348ccd 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h
@@ -81,8 +81,7 @@ typedef	union _QOS_CTRL_FIELD{
 	u16	shortData;
 
 	// WMM spec
-	struct
-	{
+	struct {
 		u8		UP:3;
 		u8		usRsvd1:1;
 		u8		EOSP:1;
@@ -92,8 +91,7 @@ typedef	union _QOS_CTRL_FIELD{
 	}WMM;
 
 	// 802.11e: QoS data type frame sent by non-AP QSTAs.
-	struct
-	{
+	struct {
 		u8		TID:4;
 		u8		bIsQsize:1;// 0: BIT[8:15] is TXOP Duration Requested, 1: BIT[8:15] is Queue Size.
 		u8		AckPolicy:2;
@@ -102,8 +100,7 @@ typedef	union _QOS_CTRL_FIELD{
 	}BySta;
 
 	// 802.11e: QoS data, QoS Null, and QoS Data+CF-Ack frames sent by HC.
-	struct
-	{
+	struct {
 		u8		TID:4;
 		u8		EOSP:1;
 		u8		AckPolicy:2;
@@ -112,8 +109,7 @@ typedef	union _QOS_CTRL_FIELD{
 	}ByHc_Data;
 
 	// 802.11e: QoS (+) CF-Poll frames sent by HC.
-	struct
-	{
+	struct {
 		u8		TID:4;
 		u8		EOSP:1;
 		u8		AckPolicy:2;
@@ -133,14 +129,12 @@ typedef	union _QOS_CTRL_FIELD{
 typedef	union _QOS_INFO_FIELD{
 	u8	charData;
 
-	struct
-	{
+	struct {
 		u8		ucParameterSetCount:4;
 		u8		ucReserved:4;
 	}WMM;
 
-	struct
-	{
+	struct {
 		//Ref WMM_Specification_1-1.pdf, 2006-06-13 Isaiah
 		u8		ucAC_VO_UAPSD:1;
 		u8		ucAC_VI_UAPSD:1;
@@ -152,16 +146,14 @@ typedef	union _QOS_INFO_FIELD{
 
 	}ByWmmPsSta;
 
-	struct
-	{
+	struct {
 		//Ref WMM_Specification_1-1.pdf, 2006-06-13 Isaiah
 		u8		ucParameterSetCount:4;
 		u8		ucReserved:3;
 		u8		ucApUapsd:1;
 	}ByWmmPsAp;
 
-	struct
-	{
+	struct {
 		u8		ucAC3_UAPSD:1;
 		u8		ucAC2_UAPSD:1;
 		u8		ucAC1_UAPSD:1;
@@ -171,8 +163,7 @@ typedef	union _QOS_INFO_FIELD{
 		u8		ucMoreDataAck:1;
 	} By11eSta;
 
-	struct
-	{
+	struct {
 		u8		ucParameterSetCount:4;
 		u8		ucQAck:1;
 		u8		ucQueueReq:1;
@@ -180,16 +171,14 @@ typedef	union _QOS_INFO_FIELD{
 		u8		ucReserved:1;
 	} By11eAp;
 
-	struct
-	{
+	struct {
 		u8		ucReserved1:4;
 		u8		ucQAck:1;
 		u8		ucReserved2:2;
 		u8		ucMoreDataAck:1;
 	} ByWmmsaSta;
 
-	struct
-	{
+	struct {
 		u8		ucReserved1:4;
 		u8		ucQAck:1;
 		u8		ucQueueReq:1;
@@ -197,8 +186,7 @@ typedef	union _QOS_INFO_FIELD{
 		u8		ucReserved2:1;
 	} ByWmmsaAp;
 
-	struct
-	{
+	struct {
 		u8		ucAC3_UAPSD:1;
 		u8		ucAC2_UAPSD:1;
 		u8		ucAC1_UAPSD:1;
@@ -208,8 +196,7 @@ typedef	union _QOS_INFO_FIELD{
 		u8		ucMoreDataAck:1;
 	} ByAllSta;
 
-	struct
-	{
+	struct {
 		u8		ucParameterSetCount:4;
 		u8		ucQAck:1;
 		u8		ucQueueReq:1;
@@ -246,8 +233,7 @@ typedef u32 AC_CODING;
 typedef	union _ACI_AIFSN{
 	u8	charData;
 
-	struct
-	{
+	struct {
 		u8	AIFSN:4;
 		u8	ACM:1;
 		u8	ACI:2;
@@ -261,8 +247,7 @@ typedef	union _ACI_AIFSN{
 //
 typedef	union _ECW{
 	u8	charData;
-	struct
-	{
+	struct {
 		u8	ECWmin:4;
 		u8	ECWmax:4;
 	}f;	// Field
@@ -276,8 +261,7 @@ typedef	union _AC_PARAM{
 	u32	longData;
 	u8	charData[4];
 
-	struct
-	{
+	struct {
 		ACI_AIFSN	AciAifsn;
 		ECW		Ecw;
 		u16		TXOPLimit;
@@ -336,8 +320,7 @@ typedef union _QOS_TSINFO{
 typedef union _TSPEC_BODY{
 	u8		charData[55];
 
-	struct
-	{
+	struct {
 		QOS_TSINFO	TSInfo;	//u8	TSInfo[3];
 		u16	NominalMSDUsize;
 		u16	MaxMSDUsize;
diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index 80ab937..837edb6 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -559,8 +559,7 @@ typedef enum _WIRELESS_MODE {
 
 #define RTL_IOCTL_WPA_SUPPLICANT		SIOCIWFIRSTPRIV+30
 
-typedef struct buffer
-{
+typedef struct buffer {
 	struct buffer *next;
 	u32 *buf;
 
@@ -600,8 +599,7 @@ typedef struct _RT_SMOOTH_DATA_4RF {
 
 #define MAX_8192U_RX_SIZE			8192    // This maybe changed for D-cut larger aggregation size
 //stats seems messed up, clean it ASAP
-typedef struct Stats
-{
+typedef struct Stats {
 	unsigned long txrdu;
 //	unsigned long rxrdu;
 	//unsigned long rxnolast;
@@ -748,8 +746,7 @@ typedef enum _RT_RF_TYPE_819xU{
         RF_PSEUDO_11N = 4,
 }RT_RF_TYPE_819xU, *PRT_RF_TYPE_819xU;
 
-typedef struct _rate_adaptive
-{
+typedef struct _rate_adaptive {
 	u8				rate_adaptive_disabled;
 	u8				ratr_state;
 	u16				reserve;
@@ -775,21 +772,18 @@ typedef struct _rate_adaptive
 #define TxBBGainTableLength 37
 #define	CCKTxBBGainTableLength 23
 
-typedef struct _txbbgain_struct
-{
+typedef struct _txbbgain_struct {
 	long	txbb_iq_amplifygain;
 	u32	txbbgain_value;
 } txbbgain_struct, *ptxbbgain_struct;
 
-typedef struct _ccktxbbgain_struct
-{
+typedef struct _ccktxbbgain_struct {
 	//The Value is from a22 to a29 one Byte one time is much Safer
 	u8	ccktxbb_valuearray[8];
 } ccktxbbgain_struct,*pccktxbbgain_struct;
 
 
-typedef struct _init_gain
-{
+typedef struct _init_gain {
 	u8				xaagccore1;
 	u8				xbagccore1;
 	u8				xcagccore1;
@@ -799,8 +793,7 @@ typedef struct _init_gain
 } init_gain, *pinit_gain;
 //by amy 0606
 
-typedef struct _phy_ofdm_rx_status_report_819xusb
-{
+typedef struct _phy_ofdm_rx_status_report_819xusb {
 	u8	trsw_gain_X[4];
 	u8	pwdb_all;
 	u8	cfosho_X[4];
@@ -816,8 +809,7 @@ typedef struct _phy_ofdm_rx_status_report_819xusb
 	u8  rxsc_sgien_exflg;
 }phy_sts_ofdm_819xusb_t;
 
-typedef struct _phy_cck_rx_status_report_819xusb
-{
+typedef struct _phy_cck_rx_status_report_819xusb {
 	/* For CCK rate descriptor. This is a unsigned 8:1 variable. LSB bit presend
 	   0.5. And MSB 7 bts presend a signed value. Range from -64~+63.5. */
 	u8	adc_pwdb_X[4];
@@ -881,8 +873,7 @@ typedef enum _tag_TxCmd_Config_Index{
 	TXCMD_XXXX_CTRL,
 }DCMD_TXCMD_OP;
 
-typedef struct r8192_priv
-{
+typedef struct r8192_priv {
 	struct usb_device *udev;
 	//added for maintain info from eeprom
 	short epromtype;
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 1887dde..abedae7 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -164,8 +164,7 @@ static struct usb_driver rtl8192_usb_driver = {
 };
 
 
-typedef struct _CHANNEL_LIST
-{
+typedef struct _CHANNEL_LIST {
 	u8	Channel[32];
 	u8	Len;
 }CHANNEL_LIST, *PCHANNEL_LIST;
diff --git a/drivers/staging/rtl8192u/r8192U_dm.h b/drivers/staging/rtl8192u/r8192U_dm.h
index 8a96e9f..ffb083c 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.h
+++ b/drivers/staging/rtl8192u/r8192U_dm.h
@@ -67,8 +67,7 @@
 
 /*------------------------------Define structure----------------------------*/
 /* 2007/10/04 MH Define upper and lower threshold of DIG enable or disable. */
-typedef struct _dynamic_initial_gain_threshold_
-{
+typedef struct _dynamic_initial_gain_threshold_ {
 	u8		dig_enable_flag;
 	u8		dig_algorithm;
 	u8		dbg_mode;
@@ -172,8 +171,7 @@ typedef enum tag_dig_cck_cs_ratio_state_definition
 	DIG_CS_RATIO_HIGHER = 1,
 	DIG_CS_MAX
 }dm_dig_cs_ratio_e;
-typedef struct _Dynamic_Rx_Path_Selection_
-{
+typedef struct _Dynamic_Rx_Path_Selection_ {
 	u8		Enable;
 	u8		DbgMode;
 	u8		cck_method;
@@ -203,8 +201,7 @@ typedef enum tag_DM_DbgMode_Definition
 	DM_DBG_MAX
 }DM_DBG_E;
 
-typedef struct tag_Tx_Config_Cmd_Format
-{
+typedef struct tag_Tx_Config_Cmd_Format {
 	u32	Op;										/* Command packet type. */
 	u32	Length;									/* Command packet length. */
 	u32	Value;
diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 6df5f75..c1ab5cf 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -354,8 +354,7 @@ static int r8192_wx_set_mode(struct net_device *dev, struct iw_request_info *a,
 	return ret;
 }
 
-struct  iw_range_with_scan_capa
-{
+struct  iw_range_with_scan_capa {
 	/* Informative stuff (to choose between different interface) */
 	__u32           throughput;     /* To give an idea... */
 	/* In theory this value should be the maximum benchmarked
diff --git a/drivers/staging/rtl8192u/r819xU_cmdpkt.h b/drivers/staging/rtl8192u/r819xU_cmdpkt.h
index fbbd270..59caa4e 100644
--- a/drivers/staging/rtl8192u/r819xU_cmdpkt.h
+++ b/drivers/staging/rtl8192u/r819xU_cmdpkt.h
@@ -19,8 +19,7 @@
 /*------------------------------Define structure----------------------------*/
 /* Define different command packet structure. */
 /* 1. RX side: TX feedback packet. */
-typedef struct tag_cmd_pkt_tx_feedback
-{
+typedef struct tag_cmd_pkt_tx_feedback {
 	// DWORD 0
 	u8	element_id;			/* Command packet type. */
 	u8	length;				/* Command packet length. */
@@ -57,8 +56,7 @@ typedef struct tag_cmd_pkt_tx_feedback
 
 /* 2. RX side: Interrupt status packet. It includes Beacon State,
 	  Beacon Timer Interrupt and other useful informations in MAC ISR Reg. */
-typedef struct tag_cmd_pkt_interrupt_status
-{
+typedef struct tag_cmd_pkt_interrupt_status {
 	u8	element_id;			/* Command packet type. */
 	u8	length;				/* Command packet length. */
 	u16	reserve;
@@ -67,8 +65,7 @@ typedef struct tag_cmd_pkt_interrupt_status
 
 
 /* 3. TX side: Set configuration packet. */
-typedef struct tag_cmd_pkt_set_configuration
-{
+typedef struct tag_cmd_pkt_set_configuration {
 	u8	element_id;			/* Command packet type. */
 	u8	length;				/* Command packet length. */
 	u16	reserve1;			/* */
@@ -89,8 +86,7 @@ typedef struct tag_cmd_pkt_set_configuration
 #define		cmpk_query_cfg_t	cmpk_set_cfg_t
 
 /* 5. Multi packet feedback status. */
-typedef struct tag_tx_stats_feedback // PJ quick rxcmd 09042007
-{
+typedef struct tag_tx_stats_feedback { // PJ quick rxcmd 09042007
 	// For endian transfer --> Driver will not the same as firmware structure.
 	// DW 0
 	u16	reserve1;
@@ -130,8 +126,7 @@ typedef struct tag_tx_stats_feedback // PJ quick rxcmd 09042007
 
 /* 6. Debug feedback message. */
 /* 2007/10/23 MH Define RX debug message  */
-typedef struct tag_rx_debug_message_feedback
-{
+typedef struct tag_rx_debug_message_feedback {
 	// For endian transfer --> for driver
 	// DW 0
 	u16	reserve1;
@@ -144,8 +139,7 @@ typedef struct tag_rx_debug_message_feedback
 }cmpk_rx_dbginfo_t;
 
 /* 2008/03/20 MH Define transmit rate history. For big endian format. */
-typedef struct tag_tx_rate_history
-{
+typedef struct tag_tx_rate_history {
 	// For endian transfer --> for driver
 	// DW 0
 	u8	element_id;			// Command packet type
-- 
1.7.10.4

