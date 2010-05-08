Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab0EHMxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 08:53:54 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:59734 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab0EHMxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 08:53:51 -0400
X-SENDER-IP: [83.226.251.142]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApRNAAP85EtT4vuOPGdsb2JhbACBOIRCgXCWOgEBAQE1vgmCUIJFBA
X-IronPort-AV: E=Sophos;i="4.52,352,1270418400"; 
   d="scan'208";a="72164946"
Message-ID: <4BE55EE2.4000701@coyote.org>
Date: Sat, 08 May 2010 14:53:54 +0200
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100428 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, devel@driverdev.osuosl.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: winbond: localpara.h whitespace and indentation
 fixes.
References: <1268727716-20422-1-git-send-email-lindley@coyote.org> <4BA25348.1080308@cs.helsinki.fi> <4BA2B0AB.4070607@coyote.org> <20100428225010.GC24604@kroah.com> <4BDD3900.1000705@coyote.org> <20100503184533.GA10778@kroah.com>
In-Reply-To: <20100503184533.GA10778@kroah.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2010-05-03 20:45, Greg KH wrote:
> On Sun, May 02, 2010 at 10:34:08AM +0200, Lars Lindley wrote:
>> On 2010-04-29 00:50, Greg KH wrote:
>>> On Fri, Mar 19, 2010 at 12:00:59AM +0100, Lars Lindley wrote:
>>>> On 2010-03-18 17:22, Pekka Enberg wrote:
>>>>> Lars Lindley wrote:
>>>>>> +/* refer Bitmap2RateValue table */
>>>>>> +#define LOCAL_ALL_SUPPORTED_RATES_BITMAP    0x130c1a66 /*
>>>>>> +                                * the bitmap value
>>>>>> +                                * of all the H/W
>>>>>> +                                * supported rates:
>>>>>> +                                * 1, 2, 5.5, 11,
>>>>>> +                                * 6, 9, 12, 18,
>>>>>> +                                * 24, 36, 48, 54
>>>>>> +                                */
>>>>>
>>>>> The comments look funny. You might want to move them above the #defines.
>>>>>
>>>>>> +    u8    region;        /* real region setting of the device */
>>>>>> +    u8    Reserved_1[2];
>>>>>> +
>>>>>> +/* power-save variables */
>>>>>
>>>>> I think this wants to be moved one indentation level to the right.
>>>>>
>>>> Ok here's a patch that applies over the old one to fix this..
>>>> Hope it looks all right.. :)
>>>
>>> Can you merge the two of them together and resend?
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> I have somehow messed up my git tree so I can't get rebase to work but 
>> here's the diff for localpara.h and that combines the two patches..
>> Hope it works for you Greg.
> 
> Yes it did, but it lacked a change log entry showing what the patch did,
> as well as a signed-off-by: line allowing me to apply the patch :(
> 
> Care to resend it again with that required information?
> 
> thanks,
> 
> greg k-h
> 

Ok, sorry.
Here it comes.. :)

Regards
/Lars



[PATCH] staging: winbond: localpara.h whitespace and indentation fixes.

I fixed all problems found by checkpatch.pl except a number of long
lines that I didn't find a good way to break up and still keep it
readable. I added the () to #define MAX_IE_APPEND_SIZE	(256 + 4).
I also moved som comments around after pointers from Pekka.

Signed-off-by: Lars Lindley <lindley@coyote.org>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi> 
Acked-by: Pavel Machek <pavel@ucw.cz>


diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index fcf6a04..d798057 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -1,263 +1,267 @@
 #ifndef __WINBOND_LOCALPARA_H
 #define __WINBOND_LOCALPARA_H
 
-//=============================================================
-// LocalPara.h -
-//=============================================================
+/*
+ * =============================================================
+ * LocalPara.h -
+ * =============================================================
+ */
 
 #include "mac_structures.h"
 
-//Define the local ability
+/* Define the local ability */
 
-#define LOCAL_DEFAULT_BEACON_PERIOD			100		//ms
-#define LOCAL_DEFAULT_ATIM_WINDOW			0
-#define LOCAL_DEFAULT_ERP_CAPABILITY		0x0431	//0x0001:	ESS
-													//0x0010:	Privacy
-													//0x0020:	short preamble
-													//0x0400:	short slot time
-#define LOCAL_DEFAULT_LISTEN_INTERVAL		5
+#define LOCAL_DEFAULT_BEACON_PERIOD	100	/* ms */
+#define LOCAL_DEFAULT_ATIM_WINDOW	0
+#define LOCAL_DEFAULT_ERP_CAPABILITY	0x0431	/*
+						 * 0x0001: ESS
+						 * 0x0010: Privacy
+						 * 0x0020: short preamble
+						 * 0x0400: short slot time
+						 */
+#define LOCAL_DEFAULT_LISTEN_INTERVAL	5
 
-//#define LOCAL_DEFAULT_24_CHANNEL_NUM		11		// channel 1..11
-#define LOCAL_DEFAULT_24_CHANNEL_NUM		13		// channel 1..13
-#define LOCAL_DEFAULT_5_CHANNEL_NUM			8		// channel 36..64
+#define LOCAL_DEFAULT_24_CHANNEL_NUM	13	/* channel 1..13 */
+#define LOCAL_DEFAULT_5_CHANNEL_NUM	8	/* channel 36..64 */
 
-#define LOCAL_USA_24_CHANNEL_NUM			11
-#define LOCAL_USA_5_CHANNEL_NUM				12
-#define LOCAL_EUROPE_24_CHANNEL_NUM			13
-#define LOCAL_EUROPE_5_CHANNEL_NUM			19
-#define LOCAL_JAPAN_24_CHANNEL_NUM			14
-#define LOCAL_JAPAN_5_CHANNEL_NUM			11
-#define LOCAL_UNKNOWN_24_CHANNEL_NUM		14
-#define LOCAL_UNKNOWN_5_CHANNEL_NUM			34	//not include 165
+#define LOCAL_USA_24_CHANNEL_NUM	11
+#define LOCAL_USA_5_CHANNEL_NUM		12
+#define LOCAL_EUROPE_24_CHANNEL_NUM	13
+#define LOCAL_EUROPE_5_CHANNEL_NUM	19
+#define LOCAL_JAPAN_24_CHANNEL_NUM	14
+#define LOCAL_JAPAN_5_CHANNEL_NUM	11
+#define LOCAL_UNKNOWN_24_CHANNEL_NUM	14
+#define LOCAL_UNKNOWN_5_CHANNEL_NUM	34	/* not include 165 */
 
-
-#define psLOCAL			(&(adapter->sLocalPara))
+#define psLOCAL				(&(adapter->sLocalPara))
 
 #define MODE_802_11_BG			0
 #define MODE_802_11_A			1
 #define MODE_802_11_ABG			2
 #define MODE_802_11_BG_IBSS		3
 #define MODE_802_11_B			4
-#define MODE_AUTO				255
+#define MODE_AUTO			255
 
 #define BAND_TYPE_DSSS			0
 #define BAND_TYPE_OFDM_24		1
 #define BAND_TYPE_OFDM_5		2
 
-//refer Bitmap2RateValue table
-#define LOCAL_ALL_SUPPORTED_RATES_BITMAP		0x130c1a66	//the bitmap value of all the H/W supported rates
-															//1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54
-#define LOCAL_OFDM_SUPPORTED_RATES_BITMAP		0x130c1240	//the bitmap value of all the H/W supported rates
-															//except to non-OFDM rates
-															//6, 9, 12, 18, 24, 36, 48, 54
-
-#define LOCAL_11B_SUPPORTED_RATE_BITMAP			0x826
-#define LOCAL_11B_BASIC_RATE_BITMAP				0x826
-#define LOCAL_11B_OPERATION_RATE_BITMAP			0x826
-#define LOCAL_11G_BASIC_RATE_BITMAP				0x826		//1, 2, 5.5, 11
-#define LOCAL_11G_OPERATION_RATE_BITMAP			0x130c1240	//6, 9, 12, 18, 24, 36, 48, 54
-#define LOCAL_11A_BASIC_RATE_BITMAP				0x01001040	//6, 12, 24
-#define LOCAL_11A_OPERATION_RATE_BITMAP			0x120c0200	//9, 18, 36, 48, 54
-
-
-
-#define PWR_ACTIVE		0
-#define PWR_SAVE		1
+/* refer Bitmap2RateValue table */
+
+/* the bitmap value of all the H/W supported rates: */
+/* 1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54 */
+#define LOCAL_ALL_SUPPORTED_RATES_BITMAP	0x130c1a66
+/* the bitmap value of all the H/W supported rates except to non-OFDM rates: */
+/* 6, 9, 12, 18, 24, 36, 48, 54 */
+#define LOCAL_OFDM_SUPPORTED_RATES_BITMAP	0x130c1240
+#define LOCAL_11B_SUPPORTED_RATE_BITMAP		0x826
+#define LOCAL_11B_BASIC_RATE_BITMAP		0x826
+#define LOCAL_11B_OPERATION_RATE_BITMAP		0x826
+#define LOCAL_11G_BASIC_RATE_BITMAP		0x826	   /* 1, 2, 5.5, 11 */
+#define LOCAL_11G_OPERATION_RATE_BITMAP		0x130c1240 /* 6, 9, 12, 18, 24, 36, 48, 54 */
+#define LOCAL_11A_BASIC_RATE_BITMAP		0x01001040 /* 6, 12, 24 */
+#define LOCAL_11A_OPERATION_RATE_BITMAP		0x120c0200 /* 9, 18, 36, 48, 54 */
+
+
+#define PWR_ACTIVE				0
+#define PWR_SAVE				1
 #define PWR_TX_IDLE_CYCLE			6
 
-//bPreambleMode and bSlotTimeMode
-#define AUTO_MODE			0
-#define LONG_MODE			1
-
-//Region definition
-#define REGION_AUTO			0xff
-#define REGION_UNKNOWN		0
-#define REGION_EUROPE		1	//ETSI
-#define REGION_JAPAN		2	//MKK
-#define REGION_USA			3	//FCC
-#define	REGION_FRANCE		4	//FRANCE
-#define REGION_SPAIN		5	//SPAIN
-#define REGION_ISRAEL		6	//ISRAEL
-//#define REGION_CANADA		7	//IC
+/* bPreambleMode and bSlotTimeMode */
+#define AUTO_MODE				0
+#define LONG_MODE				1
+
+/* Region definition */
+#define REGION_AUTO				0xff
+#define REGION_UNKNOWN				0
+#define REGION_EUROPE				1	/* ETSI */
+#define REGION_JAPAN				2	/* MKK */
+#define REGION_USA				3	/* FCC */
+#define	REGION_FRANCE				4	/* FRANCE */
+#define REGION_SPAIN				5	/* SPAIN */
+#define REGION_ISRAEL				6	/* ISRAEL */
 
 #define MAX_BSS_DESCRIPT_ELEMENT		32
-#define MAX_PMKID_CandidateList         16
-
-//High byte : Event number,  low byte : reason
-//Event definition
-//-- SME/MLME event
-#define EVENT_RCV_DEAUTH					0x0100
-#define EVENT_JOIN_FAIL						0x0200
-#define EVENT_AUTH_FAIL						0x0300
-#define EVENT_ASSOC_FAIL					0x0400
-#define EVENT_LOST_SIGNAL					0x0500
-#define EVENT_BSS_DESCRIPT_LACK				0x0600
-#define EVENT_COUNTERMEASURE				0x0700
-#define EVENT_JOIN_FILTER					0x0800
-//-- TX/RX event
-#define EVENT_RX_BUFF_UNAVAILABLE			0x4100
-
-#define EVENT_CONNECT						0x8100
-#define EVENT_DISCONNECT					0x8200
-#define EVENT_SCAN_REQ						0x8300
-
-//Reason of Event
+#define MAX_PMKID_CandidateList			16
+
+/*
+ * High byte : Event number,  low byte : reason
+ * Event definition
+ * -- SME/MLME event
+ */
+#define EVENT_RCV_DEAUTH			0x0100
+#define EVENT_JOIN_FAIL				0x0200
+#define EVENT_AUTH_FAIL				0x0300
+#define EVENT_ASSOC_FAIL			0x0400
+#define EVENT_LOST_SIGNAL			0x0500
+#define EVENT_BSS_DESCRIPT_LACK			0x0600
+#define EVENT_COUNTERMEASURE			0x0700
+#define EVENT_JOIN_FILTER			0x0800
+/* -- TX/RX event */
+#define EVENT_RX_BUFF_UNAVAILABLE		0x4100
+
+#define EVENT_CONNECT				0x8100
+#define EVENT_DISCONNECT			0x8200
+#define EVENT_SCAN_REQ				0x8300
+
+/* Reason of Event */
 #define EVENT_REASON_FILTER_BASIC_RATE		0x0001
-#define EVENT_REASON_FILTER_PRIVACY			0x0002
+#define EVENT_REASON_FILTER_PRIVACY		0x0002
 #define EVENT_REASON_FILTER_AUTH_MODE		0x0003
-#define EVENT_REASON_TIMEOUT				0x00ff
+#define EVENT_REASON_TIMEOUT			0x00ff
 
-// 20061108 WPS IE buffer
-#define MAX_IE_APPEND_SIZE					256 + 4 // Due to [E id][Length][OUI][Data] may 257 bytes
+/* Due to[E id][Length][OUI][Data] may be 257 bytes */
+#define MAX_IE_APPEND_SIZE			(256 + 4)
 
-struct chan_info
-{
-	u8		band;
-	u8		ChanNo;
+struct chan_info {
+	u8	band;
+	u8	ChanNo;
 };
 
-struct radio_off
-{
-	u8			boHwRadioOff;
-	u8			boSwRadioOff;
+struct radio_off {
+	u8	boHwRadioOff;
+	u8	boSwRadioOff;
 };
 
-//===========================================================================
-struct wb_local_para
-{
-	u8			PermanentAddress[ MAC_ADDR_LENGTH + 2 ]; 	// read from EPROM, manufacture set for each NetCard
-    u8    		ThisMacAddress[ MAC_ADDR_LENGTH + 2 ];			// the driver will use actually.
-
-	u32			MTUsize;				// Ind to Uplayer, Max transmission unit size
-
-	u8			region_INF;	//region setting from INF
-	u8			region;		//real region setting of the device
-	u8			Reserved_1[2];
-
-    //// power-save variables
-    u8  		  	iPowerSaveMode;     // 0 indicates it is on, 1 indicates it is off
-	u8			ATIMmode;
-	u8			ExcludeUnencrypted;
-
-	u16			CheckCountForPS;	//Unit ime count for the decision to enter PS mode
-	u8			boHasTxActivity;	//tx activity has occurred
-	u8			boMacPsValid;		//Power save mode obtained from H/W is valid or not
-
-	//// Rate
-	u8			TxRateMode;				// Initial, input from Registry, may be updated by GUI
-											//Tx Rate Mode: auto(DTO on), max, 1M, 2M, ..
-	u8			CurrentTxRate;			// The current Tx rate
-	u8			CurrentTxRateForMng;	// The current Tx rate for management frames
-										// It will be decided before connection succeeds.
-	u8			CurrentTxFallbackRate;
-
-	//for Rate handler
-	u8			BRateSet[32];			//basic rate set
-	u8			SRateSet[32];			//support rate set
-
-	u8			NumOfBRate;
-	u8			NumOfSRate;
-	u8			NumOfDsssRateInSRate;	//number of DSSS rates in supported rate set
-	u8			reserved1;
-
-	u32			dwBasicRateBitmap;		//bit map of basic rates
-	u32			dwSupportRateBitmap;	//bit map of all support rates including
-										//basic and operational rates
-
-	////For SME/MLME handler
-	u16			wOldSTAindex;			// valid when boHandover=TRUE, store old connected STA index
-	u16			wConnectedSTAindex;		// Index of peerly connected AP or IBSS in
-										// the descriptionset.
-    u16			Association_ID;     	// The Association ID in the (Re)Association
-            	                    	// Response frame.
-    u16			ListenInterval;     	// The listen interval when SME invoking MLME_
-            	                    	// (Re)Associate_Request().
-
-	struct radio_off		RadioOffStatus;
-	u8			Reserved0[2];
-
-	u8			boMsRadioOff;			// Ndis demands to be true when set Disassoc. OID and be false when set SSID OID.
-	u8			bAntennaNo;				//which antenna
-	u8			bConnectFlag;			//the connect status flag for roaming task
-
-	u8			RoamStatus;
-	u8			reserved7[3];
-
-	struct chan_info	CurrentChan;			//Current channel no. and channel band. It may be changed by scanning.
-	u8			boHandover;				// Roaming, Hnadover to other AP.
-	u8			boCCAbusy;
-
-	u16			CWMax;					// It may not be the real value that H/W used
-	u8			CWMin;					// 255: set according to 802.11 spec.
-	u8			reserved2;
-
-	//11G:
-	u8			bMacOperationMode;		// operation in 802.11b or 802.11g
-	u8			bSlotTimeMode;			//AUTO, s32
-	u8			bPreambleMode;			//AUTO, s32
-	u8			boNonERPpresent;
-
-	u8			boProtectMechanism;	// H/W will take the necessary action based on this variable
-	u8			boShortPreamble;	// H/W will take the necessary action based on this variable
-	u8			boShortSlotTime;	// H/W will take the necessary action based on this variable
-	u8			reserved_3;
-
-	u32       	RSN_IE_Bitmap;		//added by WS
-	u32      		RSN_OUI_Type;		//added by WS
-
-	//For the BSSID
-	u8			HwBssid[MAC_ADDR_LENGTH + 2];
-	u32			HwBssidValid;
-
-	//For scan list
-	u8			BssListCount;							//Total count of valid descriptor indexes
-	u8			boReceiveUncorrectInfo;	//important settings in beacon/probe resp. have been changed
-	u8			NoOfJoinerInIbss;
-	u8			reserved_4;
-
-	u8			BssListIndex[ (MAX_BSS_DESCRIPT_ELEMENT+3) & ~0x03 ];	//Store the valid descriptor indexes obtained from scannings
-	u8			JoinerInIbss[ (MAX_BSS_DESCRIPT_ELEMENT+3) & ~0x03 ];	//save the BssDescriptor index in this
-														//IBSS. The index 0 is local descriptor
-														//(psLOCAL->wConnectedSTAindex).
-														//If CONNECTED : NoOfJoinerInIbss >=2
-														//		else   : NoOfJoinerInIbss <=1
-
-	//// General Statistics, count at Rx_handler or Tx_callback interrupt handler
-    u64 	GS_XMIT_OK;				// Good Frames Transmitted
-    u64 	GS_RCV_OK;				// Good Frames Received
-	u32		GS_RCV_ERROR;			// Frames received with crc error
-	u32		GS_XMIT_ERROR;			// Bad Frames Transmitted
-	u32		GS_RCV_NO_BUFFER;		// Receive Buffer underrun
-	u32		GS_XMIT_ONE_COLLISION;	// one collision
-	u32		GS_XMIT_MORE_COLLISIONS;// more collisions
-
-    //================================================================
-    // Statistics (no matter whether it had done successfully) -wkchen
-    //================================================================
-    u32		   	_NumRxMSDU;
-    u32	   		_NumTxMSDU;
-    u32	   		_dot11WEPExcludedCount;
-    u32	   		_dot11WEPUndecryptableCount;
-    u32	   		_dot11FrameDuplicateCount;
-
-	struct chan_info	IbssChanSetting;	// 2B. Start IBSS Channel setting by registry or WWU.
-	u8		reserved_5[2];		//It may not be used after considering RF type,
-									//region and modulation type.
-
-	u8		reserved_6[2];		//two variables are for wep key error detection added by ws 02/02/04
-
-    u32	      bWepKeyError;
-    u32         bToSelfPacketReceived;
-    u32         WepKeyDetectTimerCount;
-
-	u16		SignalLostTh;
-	u16		SignalRoamTh;
-
-	// 20061108 WPS IE Append
+struct wb_local_para {
+	/* read from EPROM, manufacture set for each NetCard */
+	u8	PermanentAddress[MAC_ADDR_LENGTH + 2];
+	/* the driver will use this one actually. */
+	u8	ThisMacAddress[MAC_ADDR_LENGTH + 2];
+	u32	MTUsize;	/* Ind to Uplayer, Max transmission unit size */
+	u8	region_INF;	/* region setting from INF */
+	u8	region;		/* real region setting of the device */
+	u8	Reserved_1[2];
+
+	/* power-save variables */
+	u8	iPowerSaveMode; /* 0 indicates on, 1 indicates off */
+	u8	ATIMmode;
+	u8	ExcludeUnencrypted;
+	/* Unit ime count for the decision to enter PS mode */
+	u16	CheckCountForPS;
+	u8	boHasTxActivity;/* tx activity has occurred */
+	u8	boMacPsValid;	/* Power save mode obtained from H/W is valid or not */
+
+	/* Rate */
+	u8	TxRateMode; /*
+			     * Initial, input from Registry,
+			     * may be updated by GUI
+			     * Tx Rate Mode: auto(DTO on), max, 1M, 2M, ..
+			     */
+	u8	CurrentTxRate;		/* The current Tx rate */
+	u8	CurrentTxRateForMng;	/*
+					 * The current Tx rate for management
+					 * frames. It will be decided before
+					 * connection succeeds.
+					 */
+	u8	CurrentTxFallbackRate;
+
+	/* for Rate handler */
+	u8	BRateSet[32];		/* basic rate set */
+	u8	SRateSet[32];		/* support rate set */
+
+	u8	NumOfBRate;
+	u8	NumOfSRate;
+	u8	NumOfDsssRateInSRate;	/* number of DSSS rates in supported rate set */
+	u8	reserved1;
+
+	u32	dwBasicRateBitmap;	/* bit map of basic rates */
+
+	u32	dwSupportRateBitmap;	/* bit map of all support rates including basic and operational rates */
+
+
+	/* For SME/MLME handler */
+
+	u16	wOldSTAindex;		/* valid when boHandover=TRUE, store old connected STA index */
+	u16	wConnectedSTAindex;	/* Index of peerly connected AP or IBSS in the descriptionset. */
+	u16	Association_ID;		/* The Association ID in the (Re)Association Response frame. */
+	u16	ListenInterval;		/* The listen interval when SME invoking MLME_ (Re)Associate_Request(). */
+
+	struct	radio_off RadioOffStatus;
+	u8	Reserved0[2];
+	u8	boMsRadioOff;		/* Ndis demands to be true when set Disassoc. OID and be false when set SSID OID. */
+	u8	bAntennaNo;		/* which antenna */
+	u8	bConnectFlag;		/* the connect status flag for roaming task */
+
+	u8	RoamStatus;
+	u8	reserved7[3];
+
+	struct	chan_info CurrentChan;	/* Current channel no. and channel band. It may be changed by scanning. */
+	u8	boHandover;		/* Roaming, Hnadover to other AP. */
+	u8	boCCAbusy;
+
+	u16	CWMax;			/* It may not be the real value that H/W used */
+	u8	CWMin;			/* 255: set according to 802.11 spec. */
+	u8	reserved2;
+
+	/* 11G: */
+	u8	bMacOperationMode;	/* operation in 802.11b or 802.11g */
+	u8	bSlotTimeMode;		/* AUTO, s32 */
+	u8	bPreambleMode;		/* AUTO, s32 */
+	u8	boNonERPpresent;
+
+	u8	boProtectMechanism;	/* H/W will take the necessary action based on this variable */
+	u8	boShortPreamble;	/* Same here */
+	u8	boShortSlotTime;	/* Same here */
+	u8	reserved_3;
+
+	u32	RSN_IE_Bitmap;
+	u32	RSN_OUI_Type;
+
+	/* For the BSSID */
+	u8	HwBssid[MAC_ADDR_LENGTH + 2];
+	u32	HwBssidValid;
+
+	/* For scan list */
+	u8	BssListCount;		/* Total count of valid descriptor indexes */
+	u8	boReceiveUncorrectInfo;	/* important settings in beacon/probe resp. have been changed */
+	u8	NoOfJoinerInIbss;
+	u8	reserved_4;
+
+	/* Store the valid descriptor indexes obtained from scannings */
+	u8	BssListIndex[(MAX_BSS_DESCRIPT_ELEMENT + 3) & ~0x03];
+	/*
+	 * Save the BssDescriptor index in this IBSS.
+	 * The index 0 is local descriptor (psLOCAL->wConnectedSTAindex).
+	 * If CONNECTED : NoOfJoinerInIbss >= 2
+	 * else		: NoOfJoinerInIbss <= 1
+	 */
+	u8	JoinerInIbss[(MAX_BSS_DESCRIPT_ELEMENT + 3) & ~0x03];
+
+	/* General Statistics, count at Rx_handler or Tx_callback interrupt handler */
+	u64	GS_XMIT_OK;		/* Good Frames Transmitted */
+	u64	GS_RCV_OK;		/* Good Frames Received */
+	u32	GS_RCV_ERROR;		/* Frames received with crc error */
+	u32	GS_XMIT_ERROR;		/* Bad Frames Transmitted */
+	u32	GS_RCV_NO_BUFFER;	/* Receive Buffer underrun */
+	u32	GS_XMIT_ONE_COLLISION;	/* one collision */
+	u32	GS_XMIT_MORE_COLLISIONS;/* more collisions */
+
+	/*
+	 * ================================================================
+	 * Statistics (no matter whether it had done successfully) -wkchen
+	 * ================================================================
+	 */
+	u32	_NumRxMSDU;
+	u32	_NumTxMSDU;
+	u32	_dot11WEPExcludedCount;
+	u32	_dot11WEPUndecryptableCount;
+	u32	_dot11FrameDuplicateCount;
+
+	struct	chan_info IbssChanSetting;	/* 2B. Start IBSS Channel setting by registry or WWU. */
+	u8	reserved_5[2];		/* It may not be used after considering RF type, region and modulation type. */
+
+	u8	reserved_6[2];		/* two variables are for wep key error detection */
+	u32	bWepKeyError;
+	u32	bToSelfPacketReceived;
+	u32	WepKeyDetectTimerCount;
+
+	u16	SignalLostTh;
+	u16	SignalRoamTh;
+
 	u8		IE_Append_data[MAX_IE_APPEND_SIZE];
 	u16		IE_Append_size;
 	u16		reserved_7;
-
 };
 
 #endif
