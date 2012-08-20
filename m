Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2HTPnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:43:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48601 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2HTPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:43:31 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/3]NEXT:staging: "vt6655" Typo change *Embeded to *Embedded. 
Date: Mon, 20 Aug 2012 08:43:14 -0700
Message-Id: <1345477395-24263-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345477395-24263-1-git-send-email-justinmattock@gmail.com>
References: <1345477395-24263-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
The below patch changes *Embeded to *Embedded in comments and code.
Note: I am grepping but grepping is being difficult, if I missed any let me know
and I will resubmit.

 drivers/staging/vt6655/baseband.c    |  162 +++++++++++++++++-----------------
 drivers/staging/vt6655/baseband.h    |    8 +-
 drivers/staging/vt6655/card.c        |   36 ++++----
 drivers/staging/vt6655/device_main.c |    2 +-
 drivers/staging/vt6655/rf.c          |   80 ++++++++---------
 drivers/staging/vt6655/rf.h          |    2 +-
 6 files changed, 145 insertions(+), 145 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 6a06f64..9a039ea 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -28,8 +28,8 @@
  * Functions:
  *      BBuGetFrameTime        - Calculate data frame transmitting time
  *      BBvCaculateParameter   - Caculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
- *      BBbReadEmbeded         - Embedded read baseband register via MAC
- *      BBbWriteEmbeded        - Embedded write baseband register via MAC
+ *      BBbReadEmbedded         - Embedded read baseband register via MAC
+ *      BBbWriteEmbedded        - Embedded write baseband register via MAC
  *      BBbIsRegBitsOn         - Test if baseband register bits on
  *      BBbIsRegBitsOff        - Test if baseband register bits off
  *      BBbVT3253Init          - VIA VT3253 baseband chip init code
@@ -2013,7 +2013,7 @@ BBvCaculateParameter (
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool BBbReadEmbeded (unsigned long dwIoBase, unsigned char byBBAddr, unsigned char *pbyData)
+bool BBbReadEmbedded (unsigned long dwIoBase, unsigned char byBBAddr, unsigned char *pbyData)
 {
     unsigned short ww;
     unsigned char byValue;
@@ -2056,7 +2056,7 @@ bool BBbReadEmbeded (unsigned long dwIoBase, unsigned char byBBAddr, unsigned ch
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool BBbWriteEmbeded (unsigned long dwIoBase, unsigned char byBBAddr, unsigned char byData)
+bool BBbWriteEmbedded (unsigned long dwIoBase, unsigned char byBBAddr, unsigned char byData)
 {
     unsigned short ww;
     unsigned char byValue;
@@ -2102,7 +2102,7 @@ bool BBbIsRegBitsOn (unsigned long dwIoBase, unsigned char byBBAddr, unsigned ch
 {
     unsigned char byOrgData;
 
-    BBbReadEmbeded(dwIoBase, byBBAddr, &byOrgData);
+    BBbReadEmbedded(dwIoBase, byBBAddr, &byOrgData);
     return (byOrgData & byTestBits) == byTestBits;
 }
 
@@ -2125,7 +2125,7 @@ bool BBbIsRegBitsOff (unsigned long dwIoBase, unsigned char byBBAddr, unsigned c
 {
     unsigned char byOrgData;
 
-    BBbReadEmbeded(dwIoBase, byBBAddr, &byOrgData);
+    BBbReadEmbedded(dwIoBase, byBBAddr, &byOrgData);
     return (byOrgData & byTestBits) == 0;
 }
 
@@ -2155,14 +2155,14 @@ bool BBbVT3253Init (PSDevice pDevice)
     if (byRFType == RF_RFMD2959) {
         if (byLocalID <= REV_ID_VT3253_A1) {
             for (ii = 0; ii < CB_VT3253_INIT_FOR_RFMD; ii++) {
-                bResult &= BBbWriteEmbeded(dwIoBase,byVT3253InitTab_RFMD[ii][0],byVT3253InitTab_RFMD[ii][1]);
+                bResult &= BBbWriteEmbedded(dwIoBase,byVT3253InitTab_RFMD[ii][0],byVT3253InitTab_RFMD[ii][1]);
             }
         } else {
             for (ii = 0; ii < CB_VT3253B0_INIT_FOR_RFMD; ii++) {
-                bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_RFMD[ii][0],byVT3253B0_RFMD[ii][1]);
+                bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_RFMD[ii][0],byVT3253B0_RFMD[ii][1]);
             }
             for (ii = 0; ii < CB_VT3253B0_AGC_FOR_RFMD2959; ii++) {
-        	    bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_AGC4_RFMD2959[ii][0],byVT3253B0_AGC4_RFMD2959[ii][1]);
+        	    bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_AGC4_RFMD2959[ii][0],byVT3253B0_AGC4_RFMD2959[ii][1]);
             }
             VNSvOutPortD(dwIoBase + MAC_REG_ITRTMSET, 0x23);
             MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT0);
@@ -2177,10 +2177,10 @@ bool BBbVT3253Init (PSDevice pDevice)
         pDevice->ldBmThreshold[3] = 0;
     } else if ((byRFType == RF_AIROHA) || (byRFType == RF_AL2230S) ) {
         for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++) {
-    	    bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_AIROHA2230[ii][0],byVT3253B0_AIROHA2230[ii][1]);
+    	    bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_AIROHA2230[ii][0],byVT3253B0_AIROHA2230[ii][1]);
     	}
         for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
-    	    bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_AGC[ii][0],byVT3253B0_AGC[ii][1]);
+    	    bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_AGC[ii][0],byVT3253B0_AGC[ii][1]);
     	}
         pDevice->abyBBVGA[0] = 0x1C;
         pDevice->abyBBVGA[1] = 0x10;
@@ -2192,10 +2192,10 @@ bool BBbVT3253Init (PSDevice pDevice)
         pDevice->ldBmThreshold[3] = 0;
     } else if (byRFType == RF_UW2451) {
         for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++) {
-    	        bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_UW2451[ii][0],byVT3253B0_UW2451[ii][1]);
+    	        bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_UW2451[ii][0],byVT3253B0_UW2451[ii][1]);
     	}
         for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
-    	    bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_AGC[ii][0],byVT3253B0_AGC[ii][1]);
+    	    bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_AGC[ii][0],byVT3253B0_AGC[ii][1]);
     	}
         VNSvOutPortB(dwIoBase + MAC_REG_ITRTMSET, 0x23);
         MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT0);
@@ -2210,28 +2210,28 @@ bool BBbVT3253Init (PSDevice pDevice)
         pDevice->ldBmThreshold[3] = 0;
     } else if (byRFType == RF_UW2452) {
         for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++) {
-            bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_UW2451[ii][0],byVT3253B0_UW2451[ii][1]);
+            bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_UW2451[ii][0],byVT3253B0_UW2451[ii][1]);
     	}
         // Init ANT B select,TX Config CR09 = 0x61->0x45, 0x45->0x41(VC1/VC2 define, make the ANT_A, ANT_B inverted)
-        //bResult &= BBbWriteEmbeded(dwIoBase,0x09,0x41);
+        //bResult &= BBbWriteEmbedded(dwIoBase,0x09,0x41);
         // Init ANT B select,RX Config CR10 = 0x28->0x2A, 0x2A->0x28(VC1/VC2 define, make the ANT_A, ANT_B inverted)
-        //bResult &= BBbWriteEmbeded(dwIoBase,0x0a,0x28);
+        //bResult &= BBbWriteEmbedded(dwIoBase,0x0a,0x28);
         // Select VC1/VC2, CR215 = 0x02->0x06
-        bResult &= BBbWriteEmbeded(dwIoBase,0xd7,0x06);
+        bResult &= BBbWriteEmbedded(dwIoBase,0xd7,0x06);
 
         //{{RobertYu:20050125, request by Jack
-        bResult &= BBbWriteEmbeded(dwIoBase,0x90,0x20);
-        bResult &= BBbWriteEmbeded(dwIoBase,0x97,0xeb);
+        bResult &= BBbWriteEmbedded(dwIoBase,0x90,0x20);
+        bResult &= BBbWriteEmbedded(dwIoBase,0x97,0xeb);
         //}}
 
         //{{RobertYu:20050221, request by Jack
-        bResult &= BBbWriteEmbeded(dwIoBase,0xa6,0x00);
-        bResult &= BBbWriteEmbeded(dwIoBase,0xa8,0x30);
+        bResult &= BBbWriteEmbedded(dwIoBase,0xa6,0x00);
+        bResult &= BBbWriteEmbedded(dwIoBase,0xa8,0x30);
         //}}
-        bResult &= BBbWriteEmbeded(dwIoBase,0xb0,0x58);
+        bResult &= BBbWriteEmbedded(dwIoBase,0xb0,0x58);
 
         for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
-    	    bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_AGC[ii][0],byVT3253B0_AGC[ii][1]);
+    	    bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_AGC[ii][0],byVT3253B0_AGC[ii][1]);
     	}
         //VNSvOutPortB(dwIoBase + MAC_REG_ITRTMSET, 0x23); // RobertYu: 20050104, 20050131 disable PA_Delay
         //MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT0); // RobertYu: 20050104, 20050131 disable PA_Delay
@@ -2248,10 +2248,10 @@ bool BBbVT3253Init (PSDevice pDevice)
 
     } else if (byRFType == RF_VT3226) {
         for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++) {
-    	    bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_AIROHA2230[ii][0],byVT3253B0_AIROHA2230[ii][1]);
+    	    bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_AIROHA2230[ii][0],byVT3253B0_AIROHA2230[ii][1]);
     	}
         for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
-    	    bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_AGC[ii][0],byVT3253B0_AGC[ii][1]);
+    	    bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_AGC[ii][0],byVT3253B0_AGC[ii][1]);
     	}
         pDevice->abyBBVGA[0] = 0x1C;
         pDevice->abyBBVGA[1] = 0x10;
@@ -2266,20 +2266,20 @@ bool BBbVT3253Init (PSDevice pDevice)
          //{{ RobertYu: 20050104
     } else if (byRFType == RF_AIROHA7230) {
         for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++) {
-    	    bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_AIROHA2230[ii][0],byVT3253B0_AIROHA2230[ii][1]);
+    	    bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_AIROHA2230[ii][0],byVT3253B0_AIROHA2230[ii][1]);
     	}
 
         //{{ RobertYu:20050223, request by JerryChung
         // Init ANT B select,TX Config CR09 = 0x61->0x45, 0x45->0x41(VC1/VC2 define, make the ANT_A, ANT_B inverted)
-        //bResult &= BBbWriteEmbeded(dwIoBase,0x09,0x41);
+        //bResult &= BBbWriteEmbedded(dwIoBase,0x09,0x41);
         // Init ANT B select,RX Config CR10 = 0x28->0x2A, 0x2A->0x28(VC1/VC2 define, make the ANT_A, ANT_B inverted)
-        //bResult &= BBbWriteEmbeded(dwIoBase,0x0a,0x28);
+        //bResult &= BBbWriteEmbedded(dwIoBase,0x0a,0x28);
         // Select VC1/VC2, CR215 = 0x02->0x06
-        bResult &= BBbWriteEmbeded(dwIoBase,0xd7,0x06);
+        bResult &= BBbWriteEmbedded(dwIoBase,0xd7,0x06);
         //}}
 
         for (ii = 0; ii < CB_VT3253B0_AGC; ii++) {
-    	    bResult &= BBbWriteEmbeded(dwIoBase,byVT3253B0_AGC[ii][0],byVT3253B0_AGC[ii][1]);
+    	    bResult &= BBbWriteEmbedded(dwIoBase,byVT3253B0_AGC[ii][0],byVT3253B0_AGC[ii][1]);
     	}
         pDevice->abyBBVGA[0] = 0x1C;
         pDevice->abyBBVGA[1] = 0x10;
@@ -2297,8 +2297,8 @@ bool BBbVT3253Init (PSDevice pDevice)
     }
 
     if (byLocalID > REV_ID_VT3253_A1) {
-        BBbWriteEmbeded(dwIoBase, 0x04, 0x7F);
-        BBbWriteEmbeded(dwIoBase, 0x0D, 0x01);
+        BBbWriteEmbedded(dwIoBase, 0x04, 0x7F);
+        BBbWriteEmbedded(dwIoBase, 0x0D, 0x01);
     }
 
     return bResult;
@@ -2324,7 +2324,7 @@ void BBvReadAllRegs (unsigned long dwIoBase, unsigned char *pbyBBRegs)
     int  ii;
     unsigned char byBase = 1;
     for (ii = 0; ii < BB_MAX_CONTEXT_SIZE; ii++) {
-        BBbReadEmbeded(dwIoBase, (unsigned char)(ii*byBase), pbyBBRegs);
+        BBbReadEmbedded(dwIoBase, (unsigned char)(ii*byBase), pbyBBRegs);
         pbyBBRegs += byBase;
     }
 }
@@ -2350,39 +2350,39 @@ void BBvLoopbackOn (PSDevice pDevice)
     unsigned long dwIoBase = pDevice->PortOffset;
 
     //CR C9 = 0x00
-    BBbReadEmbeded(dwIoBase, 0xC9, &pDevice->byBBCRc9);//CR201
-    BBbWriteEmbeded(dwIoBase, 0xC9, 0);
-    BBbReadEmbeded(dwIoBase, 0x4D, &pDevice->byBBCR4d);//CR77
-    BBbWriteEmbeded(dwIoBase, 0x4D, 0x90);
+    BBbReadEmbedded(dwIoBase, 0xC9, &pDevice->byBBCRc9);//CR201
+    BBbWriteEmbedded(dwIoBase, 0xC9, 0);
+    BBbReadEmbedded(dwIoBase, 0x4D, &pDevice->byBBCR4d);//CR77
+    BBbWriteEmbedded(dwIoBase, 0x4D, 0x90);
 
     //CR 88 = 0x02(CCK), 0x03(OFDM)
-    BBbReadEmbeded(dwIoBase, 0x88, &pDevice->byBBCR88);//CR136
+    BBbReadEmbedded(dwIoBase, 0x88, &pDevice->byBBCR88);//CR136
 
     if (pDevice->uConnectionRate <= RATE_11M) { //CCK
         // Enable internal digital loopback: CR33 |= 0000 0001
-        BBbReadEmbeded(dwIoBase, 0x21, &byData);//CR33
-        BBbWriteEmbeded(dwIoBase, 0x21, (unsigned char)(byData | 0x01));//CR33
+        BBbReadEmbedded(dwIoBase, 0x21, &byData);//CR33
+        BBbWriteEmbedded(dwIoBase, 0x21, (unsigned char)(byData | 0x01));//CR33
         // CR154 = 0x00
-        BBbWriteEmbeded(dwIoBase, 0x9A, 0);   //CR154
+        BBbWriteEmbedded(dwIoBase, 0x9A, 0);   //CR154
 
-        BBbWriteEmbeded(dwIoBase, 0x88, 0x02);//CR239
+        BBbWriteEmbedded(dwIoBase, 0x88, 0x02);//CR239
     }
     else { //OFDM
         // Enable internal digital loopback:CR154 |= 0000 0001
-        BBbReadEmbeded(dwIoBase, 0x9A, &byData);//CR154
-        BBbWriteEmbeded(dwIoBase, 0x9A, (unsigned char)(byData | 0x01));//CR154
+        BBbReadEmbedded(dwIoBase, 0x9A, &byData);//CR154
+        BBbWriteEmbedded(dwIoBase, 0x9A, (unsigned char)(byData | 0x01));//CR154
         // CR33 = 0x00
-        BBbWriteEmbeded(dwIoBase, 0x21, 0);   //CR33
+        BBbWriteEmbedded(dwIoBase, 0x21, 0);   //CR33
 
-        BBbWriteEmbeded(dwIoBase, 0x88, 0x03);//CR239
+        BBbWriteEmbedded(dwIoBase, 0x88, 0x03);//CR239
     }
 
     //CR14 = 0x00
-    BBbWriteEmbeded(dwIoBase, 0x0E, 0);//CR14
+    BBbWriteEmbedded(dwIoBase, 0x0E, 0);//CR14
 
     // Disable TX_IQUN
-    BBbReadEmbeded(pDevice->PortOffset, 0x09, &pDevice->byBBCR09);
-    BBbWriteEmbeded(pDevice->PortOffset, 0x09, (unsigned char)(pDevice->byBBCR09 & 0xDE));
+    BBbReadEmbedded(pDevice->PortOffset, 0x09, &pDevice->byBBCR09);
+    BBbWriteEmbedded(pDevice->PortOffset, 0x09, (unsigned char)(pDevice->byBBCR09 & 0xDE));
 }
 
 /*
@@ -2403,22 +2403,22 @@ void BBvLoopbackOff (PSDevice pDevice)
     unsigned char byData;
     unsigned long dwIoBase = pDevice->PortOffset;
 
-    BBbWriteEmbeded(dwIoBase, 0xC9, pDevice->byBBCRc9);//CR201
-    BBbWriteEmbeded(dwIoBase, 0x88, pDevice->byBBCR88);//CR136
-    BBbWriteEmbeded(dwIoBase, 0x09, pDevice->byBBCR09);//CR136
-    BBbWriteEmbeded(dwIoBase, 0x4D, pDevice->byBBCR4d);//CR77
+    BBbWriteEmbedded(dwIoBase, 0xC9, pDevice->byBBCRc9);//CR201
+    BBbWriteEmbedded(dwIoBase, 0x88, pDevice->byBBCR88);//CR136
+    BBbWriteEmbedded(dwIoBase, 0x09, pDevice->byBBCR09);//CR136
+    BBbWriteEmbedded(dwIoBase, 0x4D, pDevice->byBBCR4d);//CR77
 
     if (pDevice->uConnectionRate <= RATE_11M) { // CCK
         // Set the CR33 Bit2 to disable internal Loopback.
-        BBbReadEmbeded(dwIoBase, 0x21, &byData);//CR33
-        BBbWriteEmbeded(dwIoBase, 0x21, (unsigned char)(byData & 0xFE));//CR33
+        BBbReadEmbedded(dwIoBase, 0x21, &byData);//CR33
+        BBbWriteEmbedded(dwIoBase, 0x21, (unsigned char)(byData & 0xFE));//CR33
     }
     else { // OFDM
-        BBbReadEmbeded(dwIoBase, 0x9A, &byData);//CR154
-        BBbWriteEmbeded(dwIoBase, 0x9A, (unsigned char)(byData & 0xFE));//CR154
+        BBbReadEmbedded(dwIoBase, 0x9A, &byData);//CR154
+        BBbWriteEmbedded(dwIoBase, 0x9A, (unsigned char)(byData & 0xFE));//CR154
     }
-    BBbReadEmbeded(dwIoBase, 0x0E, &byData);//CR14
-    BBbWriteEmbeded(dwIoBase, 0x0E, (unsigned char)(byData | 0x80));//CR14
+    BBbReadEmbedded(dwIoBase, 0x0E, &byData);//CR14
+    BBbWriteEmbedded(dwIoBase, 0x0E, (unsigned char)(byData | 0x80));//CR14
 
 }
 
@@ -2442,7 +2442,7 @@ BBvSetShortSlotTime (PSDevice pDevice)
     unsigned char byBBRxConf=0;
     unsigned char byBBVGA=0;
 
-    BBbReadEmbeded(pDevice->PortOffset, 0x0A, &byBBRxConf);//CR10
+    BBbReadEmbedded(pDevice->PortOffset, 0x0A, &byBBRxConf);//CR10
 
     if (pDevice->bShortSlotTime) {
         byBBRxConf &= 0xDF;//1101 1111
@@ -2451,12 +2451,12 @@ BBvSetShortSlotTime (PSDevice pDevice)
     }
 
     // patch for 3253B0 Baseband with Cardbus module
-    BBbReadEmbeded(pDevice->PortOffset, 0xE7, &byBBVGA);
+    BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byBBVGA);
     if (byBBVGA == pDevice->abyBBVGA[0]) {
         byBBRxConf |= 0x20;//0010 0000
     }
 
-    BBbWriteEmbeded(pDevice->PortOffset, 0x0A, byBBRxConf);//CR10
+    BBbWriteEmbedded(pDevice->PortOffset, 0x0A, byBBRxConf);//CR10
 
 }
 
@@ -2464,9 +2464,9 @@ void BBvSetVGAGainOffset(PSDevice pDevice, unsigned char byData)
 {
     unsigned char byBBRxConf=0;
 
-    BBbWriteEmbeded(pDevice->PortOffset, 0xE7, byData);
+    BBbWriteEmbedded(pDevice->PortOffset, 0xE7, byData);
 
-    BBbReadEmbeded(pDevice->PortOffset, 0x0A, &byBBRxConf);//CR10
+    BBbReadEmbedded(pDevice->PortOffset, 0x0A, &byBBRxConf);//CR10
     // patch for 3253B0 Baseband with Cardbus module
     if (byData == pDevice->abyBBVGA[0]) {
         byBBRxConf |= 0x20;//0010 0000
@@ -2476,7 +2476,7 @@ void BBvSetVGAGainOffset(PSDevice pDevice, unsigned char byData)
         byBBRxConf |= 0x20;//0010 0000
     }
     pDevice->byBBVGACurrent = byData;
-    BBbWriteEmbeded(pDevice->PortOffset, 0x0A, byBBRxConf);//CR10
+    BBbWriteEmbedded(pDevice->PortOffset, 0x0A, byBBRxConf);//CR10
 }
 
 
@@ -2495,10 +2495,10 @@ void BBvSetVGAGainOffset(PSDevice pDevice, unsigned char byData)
 void
 BBvSoftwareReset (unsigned long dwIoBase)
 {
-    BBbWriteEmbeded(dwIoBase, 0x50, 0x40);
-    BBbWriteEmbeded(dwIoBase, 0x50, 0);
-    BBbWriteEmbeded(dwIoBase, 0x9C, 0x01);
-    BBbWriteEmbeded(dwIoBase, 0x9C, 0);
+    BBbWriteEmbedded(dwIoBase, 0x50, 0x40);
+    BBbWriteEmbedded(dwIoBase, 0x50, 0);
+    BBbWriteEmbedded(dwIoBase, 0x9C, 0x01);
+    BBbWriteEmbedded(dwIoBase, 0x9C, 0);
 }
 
 /*
@@ -2518,9 +2518,9 @@ BBvPowerSaveModeON (unsigned long dwIoBase)
 {
     unsigned char byOrgData;
 
-    BBbReadEmbeded(dwIoBase, 0x0D, &byOrgData);
+    BBbReadEmbedded(dwIoBase, 0x0D, &byOrgData);
     byOrgData |= BIT0;
-    BBbWriteEmbeded(dwIoBase, 0x0D, byOrgData);
+    BBbWriteEmbedded(dwIoBase, 0x0D, byOrgData);
 }
 
 /*
@@ -2540,9 +2540,9 @@ BBvPowerSaveModeOFF (unsigned long dwIoBase)
 {
     unsigned char byOrgData;
 
-    BBbReadEmbeded(dwIoBase, 0x0D, &byOrgData);
+    BBbReadEmbedded(dwIoBase, 0x0D, &byOrgData);
     byOrgData &= ~(BIT0);
-    BBbWriteEmbeded(dwIoBase, 0x0D, byOrgData);
+    BBbWriteEmbedded(dwIoBase, 0x0D, byOrgData);
 }
 
 /*
@@ -2567,7 +2567,7 @@ BBvSetTxAntennaMode (unsigned long dwIoBase, unsigned char byAntennaMode)
 #ifdef	PLICE_DEBUG
 	//printk("Enter BBvSetTxAntennaMode\n");
 #endif
-    BBbReadEmbeded(dwIoBase, 0x09, &byBBTxConf);//CR09
+    BBbReadEmbedded(dwIoBase, 0x09, &byBBTxConf);//CR09
     if (byAntennaMode == ANT_DIVERSITY) {
         // bit 1 is diversity
         byBBTxConf |= 0x02;
@@ -2581,7 +2581,7 @@ BBvSetTxAntennaMode (unsigned long dwIoBase, unsigned char byAntennaMode)
         byBBTxConf &= 0xFD; // 1111 1101
         byBBTxConf |= 0x04;
     }
-    BBbWriteEmbeded(dwIoBase, 0x09, byBBTxConf);//CR09
+    BBbWriteEmbedded(dwIoBase, 0x09, byBBTxConf);//CR09
 }
 
 
@@ -2606,7 +2606,7 @@ BBvSetRxAntennaMode (unsigned long dwIoBase, unsigned char byAntennaMode)
 {
     unsigned char byBBRxConf;
 
-    BBbReadEmbeded(dwIoBase, 0x0A, &byBBRxConf);//CR10
+    BBbReadEmbedded(dwIoBase, 0x0A, &byBBRxConf);//CR10
     if (byAntennaMode == ANT_DIVERSITY) {
         byBBRxConf |= 0x01;
 
@@ -2616,7 +2616,7 @@ BBvSetRxAntennaMode (unsigned long dwIoBase, unsigned char byAntennaMode)
         byBBRxConf &= 0xFE; // 1111 1110
         byBBRxConf |= 0x02;
     }
-    BBbWriteEmbeded(dwIoBase, 0x0A, byBBRxConf);//CR10
+    BBbWriteEmbedded(dwIoBase, 0x0A, byBBRxConf);//CR10
 }
 
 
@@ -2635,15 +2635,15 @@ BBvSetRxAntennaMode (unsigned long dwIoBase, unsigned char byAntennaMode)
 void
 BBvSetDeepSleep (unsigned long dwIoBase, unsigned char byLocalID)
 {
-    BBbWriteEmbeded(dwIoBase, 0x0C, 0x17);//CR12
-    BBbWriteEmbeded(dwIoBase, 0x0D, 0xB9);//CR13
+    BBbWriteEmbedded(dwIoBase, 0x0C, 0x17);//CR12
+    BBbWriteEmbedded(dwIoBase, 0x0D, 0xB9);//CR13
 }
 
 void
 BBvExitDeepSleep (unsigned long dwIoBase, unsigned char byLocalID)
 {
-    BBbWriteEmbeded(dwIoBase, 0x0C, 0x00);//CR12
-    BBbWriteEmbeded(dwIoBase, 0x0D, 0x01);//CR13
+    BBbWriteEmbedded(dwIoBase, 0x0C, 0x00);//CR12
+    BBbWriteEmbedded(dwIoBase, 0x0D, 0x01);//CR13
 }
 
 
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index be2d689..c6909fa 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -73,12 +73,12 @@
 
 #define BBvClearFOE(dwIoBase)                               \
 {                                                           \
-    BBbWriteEmbeded(dwIoBase, 0xB1, 0);                     \
+    BBbWriteEmbedded(dwIoBase, 0xB1, 0);                     \
 }
 
 #define BBvSetFOE(dwIoBase)                                 \
 {                                                           \
-    BBbWriteEmbeded(dwIoBase, 0xB1, 0x0C);                  \
+    BBbWriteEmbedded(dwIoBase, 0xB1, 0x0C);                  \
 }
 
 
@@ -107,8 +107,8 @@ BBvCaculateParameter (
     unsigned char *pbyPhySgn
     );
 
-bool BBbReadEmbeded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char *pbyData);
-bool BBbWriteEmbeded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char byData);
+bool BBbReadEmbedded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char *pbyData);
+bool BBbWriteEmbedded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char byData);
 
 void BBvReadAllRegs(unsigned long dwIoBase, unsigned char *pbyBBRegs);
 void BBvLoopbackOn(PSDevice pDevice);
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index e2785c3..b740cf2 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -461,22 +461,22 @@ bool CARDbSetPhyParameter (void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigne
             pDevice->abyBBVGA[0] = 0x20;
             pDevice->abyBBVGA[2] = 0x10;
             pDevice->abyBBVGA[3] = 0x10;
-            BBbReadEmbeded(pDevice->PortOffset, 0xE7, &byData);
+            BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
             if (byData == 0x1C) {
-                BBbWriteEmbeded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
+                BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
             }
         } else if (pDevice->byRFType == RF_UW2452) {
             MACvSetBBType(pDevice->PortOffset, BB_TYPE_11A);
             pDevice->abyBBVGA[0] = 0x18;
-            BBbReadEmbeded(pDevice->PortOffset, 0xE7, &byData);
+            BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
             if (byData == 0x14) {
-                BBbWriteEmbeded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
-                BBbWriteEmbeded(pDevice->PortOffset, 0xE1, 0x57);
+                BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
+                BBbWriteEmbedded(pDevice->PortOffset, 0xE1, 0x57);
             }
         } else {
             MACvSetBBType(pDevice->PortOffset, BB_TYPE_11A);
         }
-        BBbWriteEmbeded(pDevice->PortOffset, 0x88, 0x03);
+        BBbWriteEmbedded(pDevice->PortOffset, 0x88, 0x03);
         bySlot = C_SLOT_SHORT;
         bySIFS = C_SIFS_A;
         byDIFS = C_SIFS_A + 2*C_SLOT_SHORT;
@@ -490,19 +490,19 @@ bool CARDbSetPhyParameter (void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigne
             pDevice->abyBBVGA[0] = 0x1C;
             pDevice->abyBBVGA[2] = 0x00;
             pDevice->abyBBVGA[3] = 0x00;
-            BBbReadEmbeded(pDevice->PortOffset, 0xE7, &byData);
+            BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
             if (byData == 0x20) {
-                BBbWriteEmbeded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
+                BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
             }
         } else if (pDevice->byRFType == RF_UW2452) {
             pDevice->abyBBVGA[0] = 0x14;
-            BBbReadEmbeded(pDevice->PortOffset, 0xE7, &byData);
+            BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
             if (byData == 0x18) {
-                BBbWriteEmbeded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
-                BBbWriteEmbeded(pDevice->PortOffset, 0xE1, 0xD3);
+                BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
+                BBbWriteEmbedded(pDevice->PortOffset, 0xE1, 0xD3);
             }
         }
-        BBbWriteEmbeded(pDevice->PortOffset, 0x88, 0x02);
+        BBbWriteEmbedded(pDevice->PortOffset, 0x88, 0x02);
         bySlot = C_SLOT_LONG;
         bySIFS = C_SIFS_BG;
         byDIFS = C_SIFS_BG + 2*C_SLOT_LONG;
@@ -517,19 +517,19 @@ bool CARDbSetPhyParameter (void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigne
             pDevice->abyBBVGA[0] = 0x1C;
             pDevice->abyBBVGA[2] = 0x00;
             pDevice->abyBBVGA[3] = 0x00;
-            BBbReadEmbeded(pDevice->PortOffset, 0xE7, &byData);
+            BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
             if (byData == 0x20) {
-                BBbWriteEmbeded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
+                BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
             }
         } else if (pDevice->byRFType == RF_UW2452) {
             pDevice->abyBBVGA[0] = 0x14;
-            BBbReadEmbeded(pDevice->PortOffset, 0xE7, &byData);
+            BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
             if (byData == 0x18) {
-                BBbWriteEmbeded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
-                BBbWriteEmbeded(pDevice->PortOffset, 0xE1, 0xD3);
+                BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
+                BBbWriteEmbedded(pDevice->PortOffset, 0xE1, 0xD3);
             }
         }
-        BBbWriteEmbeded(pDevice->PortOffset, 0x88, 0x08);
+        BBbWriteEmbedded(pDevice->PortOffset, 0x88, 0x08);
         bySIFS = C_SIFS_BG;
         if(VNTWIFIbIsShortSlotTime(wCapInfo)) {
             bySlot = C_SLOT_SHORT;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index ee4fb16..697617f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2660,7 +2660,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
         (pDevice->byLocalID != REV_ID_VT3253_B0) &&
         (pDevice->bBSSIDFilter == true)) {
         // update RSSI
-        //BBbReadEmbeded(pDevice->PortOffset, 0x3E, &byRSSI);
+        //BBbReadEmbedded(pDevice->PortOffset, 0x3E, &byRSSI);
         //pDevice->uCurrRSSI = byRSSI;
     }
     */
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 537a190..aaa231a 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -26,7 +26,7 @@
  * Date: Feb. 19, 2004
  *
  * Functions:
- *      IFRFbWriteEmbeded      - Embedded write RF register via MAC
+ *      IFRFbWriteEmbedded      - Embedded write RF register via MAC
  *
  * Revision History:
  *
@@ -453,18 +453,18 @@ bool s_bAL7230Init (unsigned long dwIoBase)
     BBvPowerSaveModeOFF(dwIoBase); //RobertYu:20050106, have DC value for Calibration
 
     for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++)
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[ii]);
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[ii]);
 
     // PLL On
     MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
     //Calibration
     MACvTimer0MicroSDelay(dwIoBase, 150);//150us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:active, RCK:disable
+    bResult &= IFRFbWriteEmbedded(dwIoBase, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:active, RCK:disable
     MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:disable, RCK:active
+    bResult &= IFRFbWriteEmbedded(dwIoBase, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:disable, RCK:active
     MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]); //TXDCOC:disable, RCK:disable
+    bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]); //TXDCOC:disable, RCK:disable
 
     MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE3    |
                                                      SOFTPWRCTL_SWPE2    |
@@ -490,9 +490,9 @@ bool s_bAL7230SelectChannel (unsigned long dwIoBase, unsigned char byChannel)
     // PLLON Off
     MACvWordRegBitsOff(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
-    bResult &= IFRFbWriteEmbeded (dwIoBase, dwAL7230ChannelTable0[byChannel-1]); //Reg0
-    bResult &= IFRFbWriteEmbeded (dwIoBase, dwAL7230ChannelTable1[byChannel-1]); //Reg1
-    bResult &= IFRFbWriteEmbeded (dwIoBase, dwAL7230ChannelTable2[byChannel-1]); //Reg4
+    bResult &= IFRFbWriteEmbedded (dwIoBase, dwAL7230ChannelTable0[byChannel-1]); //Reg0
+    bResult &= IFRFbWriteEmbedded (dwIoBase, dwAL7230ChannelTable1[byChannel-1]); //Reg1
+    bResult &= IFRFbWriteEmbedded (dwIoBase, dwAL7230ChannelTable2[byChannel-1]); //Reg4
 
     // PLLOn On
     MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
@@ -586,7 +586,7 @@ bool s_bAL7230SelectChannel (unsigned long dwIoBase, unsigned char byChannel)
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool IFRFbWriteEmbeded (unsigned long dwIoBase, unsigned long dwData)
+bool IFRFbWriteEmbedded (unsigned long dwIoBase, unsigned long dwData)
 {
     unsigned short ww;
     unsigned long dwValue;
@@ -669,11 +669,11 @@ bool RFbAL2230Init (unsigned long dwIoBase)
 
     //patch abnormal AL2230 frequency output
 //2008-8-21 chester <add>
-    IFRFbWriteEmbeded(dwIoBase, (0x07168700+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
+    IFRFbWriteEmbedded(dwIoBase, (0x07168700+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
 
 
     for (ii = 0; ii < CB_AL2230_INIT_SEQ; ii++)
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL2230InitTable[ii]);
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL2230InitTable[ii]);
 //2008-8-21 chester <add>
 MACvTimer0MicroSDelay(dwIoBase, 30); //delay 30 us
 
@@ -681,11 +681,11 @@ MACvTimer0MicroSDelay(dwIoBase, 30); //delay 30 us
     MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
     MACvTimer0MicroSDelay(dwIoBase, 150);//150us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x00d80f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
+    bResult &= IFRFbWriteEmbedded(dwIoBase, (0x00d80f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
     MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x00780f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
+    bResult &= IFRFbWriteEmbedded(dwIoBase, (0x00780f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
     MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL2230InitTable[CB_AL2230_INIT_SEQ-1]);
+    bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL2230InitTable[CB_AL2230_INIT_SEQ-1]);
 
     MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE3    |
                                                      SOFTPWRCTL_SWPE2    |
@@ -704,8 +704,8 @@ bool RFbAL2230SelectChannel (unsigned long dwIoBase, unsigned char byChannel)
 
     bResult = true;
 
-    bResult &= IFRFbWriteEmbeded (dwIoBase, dwAL2230ChannelTable0[byChannel-1]);
-    bResult &= IFRFbWriteEmbeded (dwIoBase, dwAL2230ChannelTable1[byChannel-1]);
+    bResult &= IFRFbWriteEmbedded (dwIoBase, dwAL2230ChannelTable0[byChannel-1]);
+    bResult &= IFRFbWriteEmbedded (dwIoBase, dwAL2230ChannelTable1[byChannel-1]);
 
     // Set Channel[7] = 0 to tell H/W channel is changing now.
     VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel & 0x7F));
@@ -817,7 +817,7 @@ bool bResult = true;
 
     switch (pDevice->byRFType) {
         case RF_AIROHA7230 :
-            bResult = IFRFbWriteEmbeded (pDevice->PortOffset, 0x1ABAEF00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW);
+            bResult = IFRFbWriteEmbedded (pDevice->PortOffset, 0x1ABAEF00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW);
             break;
         default :
             bResult = true;
@@ -1072,23 +1072,23 @@ unsigned long dwMax7230Pwr = 0;
     switch (pDevice->byRFType) {
 
         case RF_AIROHA :
-            bResult &= IFRFbWriteEmbeded(pDevice->PortOffset, dwAL2230PowerTable[byPwr]);
+            bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, dwAL2230PowerTable[byPwr]);
             if (uRATE <= RATE_11M) {
-                bResult &= IFRFbWriteEmbeded(pDevice->PortOffset, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
             } else {
-                bResult &= IFRFbWriteEmbeded(pDevice->PortOffset, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
             }
             break;
 
 
         case RF_AL2230S :
-            bResult &= IFRFbWriteEmbeded(pDevice->PortOffset, dwAL2230PowerTable[byPwr]);
+            bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, dwAL2230PowerTable[byPwr]);
             if (uRATE <= RATE_11M) {
-                bResult &= IFRFbWriteEmbeded(pDevice->PortOffset, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-                bResult &= IFRFbWriteEmbeded(pDevice->PortOffset, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
             }else {
-                bResult &= IFRFbWriteEmbeded(pDevice->PortOffset, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-                bResult &= IFRFbWriteEmbeded(pDevice->PortOffset, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+                bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
             }
 
             break;
@@ -1098,7 +1098,7 @@ unsigned long dwMax7230Pwr = 0;
             dwMax7230Pwr = 0x080C0B00 | ( (byPwr) << 12 ) |
                            (BY_AL7230_REG_LEN << 3 )  | IFREGCTL_REGW;
 
-            bResult &= IFRFbWriteEmbeded(pDevice->PortOffset, dwMax7230Pwr);
+            bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, dwMax7230Pwr);
             break;
 
 
@@ -1166,24 +1166,24 @@ bool RFbAL7230SelectChannelPostProcess (unsigned long dwIoBase, unsigned char by
     if( (byOldChannel <= CB_MAX_CHANNEL_24G) && (byNewChannel > CB_MAX_CHANNEL_24G) )
     {
         // Change from 2.4G to 5G
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTableAMode[2]); //Reg2
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTableAMode[3]); //Reg3
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTableAMode[5]); //Reg5
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTableAMode[7]); //Reg7
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTableAMode[10]);//Reg10
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTableAMode[12]);//Reg12
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTableAMode[15]);//Reg15
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[2]); //Reg2
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[3]); //Reg3
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[5]); //Reg5
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[7]); //Reg7
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[10]);//Reg10
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[12]);//Reg12
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[15]);//Reg15
     }
     else if( (byOldChannel > CB_MAX_CHANNEL_24G) && (byNewChannel <= CB_MAX_CHANNEL_24G) )
     {
         // change from 5G to 2.4G
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[2]); //Reg2
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[3]); //Reg3
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[5]); //Reg5
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[7]); //Reg7
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[10]);//Reg10
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[12]);//Reg12
-        bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[15]);//Reg15
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[2]); //Reg2
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[3]); //Reg3
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[5]); //Reg5
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[7]); //Reg7
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[10]);//Reg10
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[12]);//Reg12
+        bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[15]);//Reg15
     }
 
     return bResult;
diff --git a/drivers/staging/vt6655/rf.h b/drivers/staging/vt6655/rf.h
index 73f0969..1da0fde 100644
--- a/drivers/staging/vt6655/rf.h
+++ b/drivers/staging/vt6655/rf.h
@@ -75,7 +75,7 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-bool IFRFbWriteEmbeded(unsigned long dwIoBase, unsigned long dwData);
+bool IFRFbWriteEmbedded(unsigned long dwIoBase, unsigned long dwData);
 bool RFbSelectChannel(unsigned long dwIoBase, unsigned char byRFType, unsigned char byChannel);
 bool RFbInit (
     PSDevice  pDevice
-- 
1.7.9.5

