Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab1HSTmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:42:54 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:55640 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab1HSTka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:40:30 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] staging: xgifb: delete duplicate #defines
Date: Fri, 19 Aug 2011 22:40:21 +0300
Message-Id: <1313782830-31461-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete duplicate identical #defines.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_def.h     |   94 ------------------------------------
 drivers/staging/xgifb/vb_setmode.c |    3 -
 drivers/staging/xgifb/vb_struct.h  |    1 -
 3 files changed, 0 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index d7358d8..8528871 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -17,13 +17,7 @@
 /* ~shampoo */
 
 
-#define VB_XGI301       0x0001 /*301b*/
-#define VB_XGI301B      0x0002
-#define VB_XGI302B      0x0004
-#define VB_XGI301LV     0x0008 /*301lv*/
-#define VB_XGI302LV     0x0010
 #define VB_XGI301C      0x0020 /* for 301C */
-#define  VB_NoLCD       0x8000
 /*end 301b*/
 
 #define VB_YPbPrInfo    0x07   /*301lv*/
@@ -51,29 +45,8 @@
 /* #define MemoryInfoFlag 0x1E0 */
 /* #define MemorySizeShift 0x05 */
 
-#define Charx8Dot               0x0200
-#define LineCompareOff          0x0400
-#define CRT2Mode                0x0800
-#define HalfDCLK                0x1000
-#define NoSupportSimuTV         0x2000
-#define DoubleScanMode          0x8000
-
-#define SupportAllCRT2          0x0078
-#define SupportTV               0x0008
-#define SupportHiVisionTV       0x0010
-#define SupportLCD              0x0020
-#define SupportRAMDAC2          0x0040
-#define NoSupportTV             0x0070
-#define NoSupportHiVisionTV     0x0060
-#define NoSupportLCD            0x0058
 #define SupportCHTV             0x0800
 #define SupportCRT2in301C       0x0100  /* for 301C */
-#define SupportTV1024           0x0800  /*301b*/
-#define SupportYPbPr            0x1000  /*301lv*/
-#define InterlaceMode           0x0080
-#define SyncPP                  0x0000
-#define SyncPN                  0x4000
-#define SyncNP                  0x8000
 /* #define SyncNN 0xc000 */
 #define ECLKindex0              0x0000
 #define ECLKindex1              0x0100
@@ -81,35 +54,16 @@
 #define ECLKindex3              0x0300
 #define ECLKindex4              0x0400
 
-#define SetSimuScanMode         0x0001
-#define SwitchToCRT2            0x0002
 /* #define SetCRT2ToTV 0x009C */
-#define SetCRT2ToAVIDEO         0x0004
-#define SetCRT2ToSVIDEO         0x0008
-#define SetCRT2ToSCART          0x0010
-#define SetCRT2ToLCD            0x0020
-#define SetCRT2ToRAMDAC         0x0040
-#define SetCRT2ToHiVisionTV     0x0080
-#define SetNTSCTV               0x0000
 /* #define SetPALTV 0x0100 */
-#define SetInSlaveMode          0x0200
-#define SetNotSimuMode          0x0400
 #define SetNotSimuTVMode        0x0400
 #define SetDispDevSwitch        0x0800
-#define LoadDACFlag             0x1000
-#define DisableCRT2Display      0x2000
-#define DriverMode              0x4000
-#define HotKeySwitch            0x8000
 #define SetCHTVOverScan         0x8000
 /* #define SetCRT2ToLCDA 0x8000 301b */
 #define PanelRGB18Bit           0x0100
 #define PanelRGB24Bit           0x0000
 
-#define TVOverScan              0x10
-#define TVOverScanShift         4
 #define ClearBufferFlag         0x20
-#define EnableDualEdge          0x01 /*301b*/
-#define SetToLCDA               0x02
 
 #define YPbPrModeInfo           0x38
 /* #define YPbPrMode525i 0x00 */
@@ -117,8 +71,6 @@
 /* #define YPbPrMode750p 0x10 */
 /* #define YPbPrMode1080i 0x18 */
 
-#define SetSCARTOutput          0x01
-#define BoardTVType             0x02
 #define  EnablePALMN            0x40
 /* #define ProgrammingCRT2 0x01 */
 /* #define TVSimuMode 0x02 */
@@ -149,16 +101,10 @@
 
 #define PanelRef60Hz            0x00
 #define PanelRef75Hz            0x20
-#define LCDRGB18Bit             0x01
 
 #define ExtChipTrumpion         0x06
 #define ExtChipCH7005           0x08
 #define ExtChipMitacTV          0x0a
-#define LCDNonExpanding         0x10
-#define LCDNonExpandingShift    4
-#define LCDSync                 0x20
-#define LCDSyncBit              0xe0
-#define LCDSyncShift            6
 
 /* #define DDC2DelayTime 300 */
 
@@ -167,17 +113,6 @@
 /* #define HiTVDataLen 12 */
 /* #define TVDataLen 16 */
 /* #define SetPALTV 0x0100 */
-#define HalfDCLK                0x1000
-#define NTSCHT                  1716
-#define NTSCVT                  525
-#define PALHT                   1728
-#define PALVT                   625
-#define StHiTVHT                892
-#define StHiTVVT                1126
-#define StHiTextTVHT            1000
-#define StHiTextTVVT            1126
-#define ExtHiTVHT               2100
-#define ExtHiTVVT               1125
 
 #define St750pTVHT              1716
 #define St750pTVVT               525
@@ -194,33 +129,15 @@
 
 #define VCLKStartFreq           25
 #define SoftDramType            0x80
-#define VCLK40                  0x04
 
-#define VCLK162                 0x21
-
-#define LCDRGB18Bit             0x01
-#define LoadDACFlag             0x1000
 #define AfterLockCRT2           0x4000
-#define SetCRT2ToAVIDEO         0x0004
-#define SetCRT2ToSCART          0x0010
 #define Ext2StructSize          5
 
 
 #define YPbPr525iVCLK           0x03B
 #define YPbPr525iVCLK_2         0x03A
 
-#define SwitchToCRT2            0x0002
 /* #define LCDVESATiming 0x08 */
-#define SetSCARTOutput          0x01
-#define AVIDEOSense             0x01
-#define SVIDEOSense             0x02
-#define SCARTSense              0x04
-#define LCDSense                0x08
-#define Monitor1Sense           0x20
-#define Monitor2Sense           0x10
-#define HiTVSense               0x40
-#define BoardTVType             0x02
-#define HotPlugFunction         0x08
 #define StStructSize            0x06
 
 
@@ -231,7 +148,6 @@
 #define XGI_CRT2_PORT_14        (0x14 - 0x30)
 
 
-#define LCDNonExpanding         0x10
 #define ADR_CRT2PtrData         0x20E
 #define offset_Zurac            0x210
 #define ADR_LVDSDesPtrData      0x212
@@ -239,7 +155,6 @@
 #define ADR_CHTVVCLKPtr         0x216
 #define ADR_CHTVRegDataPtr      0x218
 
-#define LVDSDataLen             6
 /* #define EnableLVDSDDA 0x10 */
 /* #define LVDSDesDataLen 3 */
 #define ActiveNonExpanding      0x40
@@ -315,19 +230,10 @@
 
 /* #define LCDVESATiming 0x0001 //LCD Info CR37 */
 /* #define EnableLVDSDDA 0x0002 */
-#define EnableScalingLCD        0x0008
-#define SetPWDEnable            0x0004
-#define SetLCDtoNonExpanding    0x0010
 /* #define SetLCDPolarity 0x00E0 */
-#define SetLCDDualLink          0x0100
-#define SetLCDLowResolution     0x0200
-#define SetLCDStdMode           0x0400
-#define SetTVStdMode            0x0200
-#define SetTVLowResolution      0x0400
 /* =============================================================
    for 310
 ============================================================== */
-#define SoftDRAMType        0x80
 #define SoftSetting_OFFSET  0x52
 #define SR07_OFFSET  0x7C
 #define SR15_OFFSET  0x7D
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index dc4d6e6..845e036 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -14,9 +14,6 @@
 
 
 #define  IndexMask 0xff
-#ifndef XGI_MASK_DUAL_CHIP
-#define XGI_MASK_DUAL_CHIP	  0x04  /* SR3A */
-#endif
 
 static unsigned short XGINew_MDA_DAC[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index 377d27c..de02913 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -478,5 +478,4 @@ struct TimingInfo {
 	unsigned short Margin;
 };
 
-#define _VB_STRUCT_
 #endif /* _VB_STRUCT_ */
-- 
1.7.2.5

