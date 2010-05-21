Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab0EUFWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 01:22:20 -0400
Received: from penguin.host-ns.co.uk ([213.229.84.196]:49603 "EHLO
	penguin.host-ns.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab0EUFWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 01:22:19 -0400
Subject: [PATCH] Staging: winbond: Fix for brace style, length and
 whitespace in mac_structures.h
From: Adam Latham <adam.latham@unisontorbay.org.uk>
Reply-To: adam.latham@unisontorbay.org.uk
To: gregkh@suse.de, sankar.curiosity@gmail.com, ruslan@rpisarev.org.ua,
       adam.latham@unisontorbay.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 06:22:09 +0100
Message-ID: <1274419329.2041.3.camel@ubuntu.ubuntu-domain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - penguin.host-ns.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - unisontorbay.org.uk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1f3a67ae30280ef42f3d3288dab0fb3e33c2c62b Mon Sep 17 00:00:00 2001
From: Adam Latham <adam.latham@unisontorbay.org.uk>
Date: Fri, 21 May 2010 06:07:40 +0100
Subject: [PATCH 2/2] Staging: winbond: Fix for brace style, length and whitespace in mac_structures.h

This patch fixes line length, brace style and whitespace issues in the
mac_structures.h file found by the checkpatch.pl tool

Signed-off-by: Adam Latham <adam.latham@unisontorbay.org.uk>
---
 drivers/staging/winbond/mac_structures.h |  122 ++++++++++++++---------------
 1 files changed, 59 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index a390adf..415256f 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -41,8 +41,10 @@
 #define DOT_11_MAC_HEADER_SIZE		24
 #define DOT_11_SNAP_SIZE			6
 #define DOT_11_DURATION_OFFSET		2
-#define DOT_11_SEQUENCE_OFFSET		22 /* Sequence control offset */
-#define DOT_11_TYPE_OFFSET			30 /* The start offset of 802.11 Frame// */
+/* Sequence control offset */
+#define DOT_11_SEQUENCE_OFFSET		22
+/* The start offset of 802.11 Frame// */
+#define DOT_11_TYPE_OFFSET			30
 #define DOT_11_DATA_OFFSET          24
 #define DOT_11_DA_OFFSET			4
 #define DOT_3_TYPE_ARP				0x80F3
@@ -385,9 +387,11 @@ struct Extended_Supported_Rates_Element {
 #ifdef _WPA2_
 #define VERSION_WPA2            1
 #endif /* end def  _WPA2_ */
-#define OUI_WPA					0x00F25000	/* WPA2.0 OUI=00:50:F2, the MSB is reserved for suite type */
+/* WPA2.0 OUI=00:50:F2, the MSB is reserved for suite type */
+#define OUI_WPA					0x00F25000
 #ifdef _WPA2_
-#define OUI_WPA2				0x00AC0F00	/* for wpa2 change to 0x00ACOF04 by Ws 26/04/04 */
+/* for wpa2 change to 0x00ACOF04 by Ws 26/04/04 */
+#define OUI_WPA2				0x00AC0F00
 #endif /* end def _WPA2_ */
 
 #define OUI_WPA_ADDITIONAL		0x01
@@ -400,8 +404,8 @@ struct Extended_Supported_Rates_Element {
 
 #define WPA_OUI_BIG    ((u32) 0x01F25000)/* added by ws 09/23/04 */
 #define WPA_OUI_LITTLE  ((u32) 0x01F25001)/* added by ws 09/23/04 */
-
-#define WPA_WPS_OUI				cpu_to_le32(0x04F25000) /* 20061108 For WPS. It's little endian. Big endian is 0x0050F204 */
+/* 20061108 For WPS. It's little endian. Big endian is 0x0050F204 */
+#define WPA_WPS_OUI				cpu_to_le32(0x04F25000)
 
 /* -----WPA2----- */
 #ifdef _WPA2_
@@ -420,75 +424,65 @@ struct Extended_Supported_Rates_Element {
 #define OUI_CIPHER_CCMP				0x04
 #define OUI_CIPHER_WEP_104			0x05
 
-struct suite_selector
-{
-	union
-	{
+struct suite_selector{
+	union{
 		u8	Value[4];
-		struct _SUIT_
-		{
+		struct _SUIT_ {
 			u8	OUI[3];
 			u8	Type;
-		}SuitSelector;
+		} SuitSelector;
 	};
 };
 
 /* --  WPA  -- */
-struct	RSN_Information_Element
-{
+struct	RSN_Information_Element{
 	u8					Element_ID;
 	u8					Length;
-	struct suite_selector	OuiWPAAdditional; /* WPA version 2.0 additional field, and should be 00:50:F2:01 */
+ /* WPA version 2.0 additional field, and should be 00:50:F2:01 */
+	struct suite_selector	OuiWPAAdditional;
 	u16					Version;
 	struct suite_selector		GroupKeySuite;
 	u16					PairwiseKeySuiteCount;
 	struct suite_selector		PairwiseKeySuite[1];
-}__attribute__ ((packed));
-struct RSN_Auth_Sub_Information_Element
-{
+} __attribute__ ((packed));
+struct RSN_Auth_Sub_Information_Element {
 	u16				AuthKeyMngtSuiteCount;
 	struct suite_selector	AuthKeyMngtSuite[1];
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
 /* --  WPA2  -- */
-struct RSN_Capability_Element
-{
-  union
-  {
+struct RSN_Capability_Element {
+  union {
 	u16	__attribute__ ((packed))	wValue;
     #ifdef _BIG_ENDIAN_	 /* 20060927 add by anson's endian */
-    struct _RSN_Capability
-    {
-    	u16   __attribute__ ((packed))  Reserved2 : 8; /* 20051201 */
-	u16   __attribute__ ((packed))  Reserved1 : 2;
-	u16   __attribute__ ((packed))  GTK_Replay_Counter : 2;
-	u16   __attribute__ ((packed))  PTK_Replay_Counter : 2;
-	u16   __attribute__ ((packed))  No_Pairwise : 1;
-        u16   __attribute__ ((packed))  Pre_Auth : 1;
-    }__attribute__ ((packed))  RSN_Capability;
+    struct _RSN_Capability {
+	u16   __attribute__ ((packed))  Reserved2:8; /* 20051201 */
+	u16   __attribute__ ((packed))  Reserved1:2;
+	u16   __attribute__ ((packed))  GTK_Replay_Counter:2;
+	u16   __attribute__ ((packed))  PTK_Replay_Counter:2;
+	u16   __attribute__ ((packed))  No_Pairwise:1;
+	u16   __attribute__ ((packed))  Pre_Auth:1;
+    } __attribute__ ((packed))  RSN_Capability;
     #else
-    struct _RSN_Capability
-    {
-        u16   __attribute__ ((packed))  Pre_Auth : 1;
-        u16   __attribute__ ((packed))  No_Pairwise : 1;
-        u16   __attribute__ ((packed))  PTK_Replay_Counter : 2;
-	    u16   __attribute__ ((packed))  GTK_Replay_Counter : 2;
-	    u16   __attribute__ ((packed))  Reserved1 : 2;
-	    u16   __attribute__ ((packed))  Reserved2 : 8; /* 20051201 */
-    }__attribute__ ((packed))  RSN_Capability;
+    struct _RSN_Capability {
+	u16   __attribute__ ((packed))  Pre_Auth:1;
+	u16   __attribute__ ((packed))  No_Pairwise:1;
+	u16   __attribute__ ((packed))  PTK_Replay_Counter:2;
+	u16   __attribute__ ((packed))  GTK_Replay_Counter:2;
+	u16   __attribute__ ((packed))  Reserved1:2;
+	u16   __attribute__ ((packed))  Reserved2:8; /* 20051201 */
+    } __attribute__ ((packed))  RSN_Capability;
     #endif
 
-  }__attribute__ ((packed)) ;
-}__attribute__ ((packed)) ;
+  } __attribute__ ((packed)) ;
+} __attribute__ ((packed)) ;
 
 #ifdef _WPA2_
-struct pmkid
-{
+struct pmkid {
   u8 pValue[16];
 };
 
-struct	WPA2_RSN_Information_Element
-{
+struct	WPA2_RSN_Information_Element {
 	u8					Element_ID;
 	u8					Length;
 	u16					Version;
@@ -496,29 +490,28 @@ struct	WPA2_RSN_Information_Element
 	u16					PairwiseKeySuiteCount;
 	struct suite_selector		PairwiseKeySuite[1];
 
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
-struct WPA2_RSN_Auth_Sub_Information_Element
-{
+struct WPA2_RSN_Auth_Sub_Information_Element {
 	u16				AuthKeyMngtSuiteCount;
 	struct suite_selector	AuthKeyMngtSuite[1];
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
 
-struct PMKID_Information_Element
-{
+struct PMKID_Information_Element {
 	u16				PMKID_Count;
 	struct pmkid pmkid[16];
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
 #endif /* enddef _WPA2_ */
 /*============================================================
 // MAC Frame structure (different type) and subfield structure
 //============================================================*/
-struct MAC_frame_control
-{
-    u8    mac_frame_info; /* a combination of the [Protocol Version, Control Type, Control Subtype]*/
-    #ifdef _BIG_ENDIAN_ /* 20060927 add by anson's endian */
+struct MAC_frame_control {
+/* a combination of the [Protocol Version, Control Type, Control Subtype]*/
+    u8    mac_frame_info;
+/* 20060927 add by anson's endian */
+    #ifdef _BIG_ENDIAN_
     u8    order:1;
     u8    WEP:1;
     u8    more_data:1;
@@ -540,7 +533,8 @@ struct MAC_frame_control
 } __attribute__ ((packed));
 
 struct Management_Frame {
-    struct MAC_frame_control frame_control; /* 2B, ToDS,FromDS,MoreFrag,MoreData,Order=0 */
+/* 2B, ToDS,FromDS,MoreFrag,MoreData,Order=0 */
+    struct MAC_frame_control frame_control;
     u16		duration;
     u8		DA[MAC_ADDR_LENGTH];			/* Addr1 */
     u8		SA[MAC_ADDR_LENGTH];			/* Addr2 */
@@ -552,7 +546,8 @@ struct Management_Frame {
 
 /* SW-MAC don't Tx/Rx Control-Frame, HW-MAC do it. */
 struct Control_Frame {
-    struct MAC_frame_control frame_control; /* ToDS,FromDS,MoreFrag,Retry,MoreData,WEP,Order=0 */
+/* ToDS,FromDS,MoreFrag,Retry,MoreData,WEP,Order=0 */
+    struct MAC_frame_control frame_control;
     u16		duration;
     u8		RA[MAC_ADDR_LENGTH];
     u8		TA[MAC_ADDR_LENGTH];
@@ -627,8 +622,9 @@ struct Authentication_Frame_Body {
     u16    algorithmNumber;
     u16    sequenceNumber;
     u16    statusCode;
-    /* NB: don't include ChallengeText in this structure
-	// struct Challenge_Text_Element sChallengeTextElement; // wkchen added */
+	/* NB: don't include ChallengeText in this structure
+	// struct Challenge_Text_Element sChallengeTextElement;
+	// wkchen added */
 } __attribute__ ((packed));
 
 
-- 
1.7.0.4



