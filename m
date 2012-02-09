Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2BIUMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:12:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58615 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932263Ab2BIUMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:12:31 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX188yYAGMPY8UUAFQ3IMHleZkTVPrq6Uf1PBlb26Db
	c056hf7uhRWo3M
From: Peter Huewe <peterhuewe@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 7/7] staging/xgifb: remove remaining duplicate initdef.h defines
Date: Thu,  9 Feb 2012 21:11:49 +0100
Message-Id: <1328818309-5103-8-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
References: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the remaining defines that are already defined
identically in the sis initdef.h header.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_def.h |  107 +---------------------------------------
 1 files changed, 1 insertions(+), 106 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index d2e0bcd..c731793 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -8,12 +8,8 @@
 #define VB_YPbPr1080i   0x03
 
 #define LVDSCRT1Len     15
-
-#define SupportCHTV             0x0800
 #define SupportCRT2in301C       0x0100  /* for 301C */
 #define SetCHTVOverScan         0x8000
-#define PanelRGB18Bit           0x0100
-#define PanelRGB24Bit           0x0000
 
 #define Panel_320x480            0x07 /*fstn*/
 /* [ycchen] 02/12/03 Modify for Multi-Sync. LCD Support */
@@ -29,94 +25,24 @@
 
 #define XGI_CRT2_PORT_00        (0x00 - 0x030)
 
-#define _PanelType00             0x00
-#define _PanelType01             0x08
-#define _PanelType02             0x10
-#define _PanelType03             0x18
-#define _PanelType04             0x20
-#define _PanelType05             0x28
-#define _PanelType06             0x30
-#define _PanelType07             0x38
-#define _PanelType08             0x40
-#define _PanelType09             0x48
-#define _PanelType0A             0x50
-#define _PanelType0B             0x58
-#define _PanelType0C             0x60
-#define _PanelType0D             0x68
-#define _PanelType0E             0x70
-#define _PanelType0F             0x78
-
 /* =============================================================
    for 310
 ============================================================== */
-/* add LCDDataList for GetLCDPtr */
-#define LCDDataList               (VBIOSTablePointerStart+0x22)
-/*  */
-/* Modify from 310.inc */
-/*  */
-/*  */
-
 #define ModeSoftSetting              0x04
 
-#define BoardTVType                  0x02
-
-#define SoftDRAMType                 0x80    /* DRAMSetting */
-
 /* ---------------- SetMode Stack */
 #define CRT1Len           15
 #define VCLKLen           4
-#define VGA_XGI340        0x0001       /* 340 series */
-
-#define VB_NoLCD          0x8000
-#define VB_LVDS_NS        0x0001       /* 3rd party chip */
 
-#define ModeText          0x0000
-#define ModeEGA           0x0002    /* 16 colors mode */
-#define ModeVGA           0x0003    /* 256 colors mode */
-
-#define DACInfoFlag       0x0018
-
-#define MemoryInfoFlag    0x01e0
-#define MemorySizeShift   5
-
-#define Charx8Dot         0x0200
-#define LineCompareOff    0x0400
-#define CRT2Mode          0x0800
-#define HalfDCLK          0x1000
-#define NoSupportSimuTV   0x2000
-#define DoubleScanMode    0x8000
-
-/* -------------- Ext_InfoFlag */
 #define SupportAllCRT2      0x0078
-#define SupportTV           0x0008
-#define SupportLCD          0x0020
-#define SupportRAMDAC2      0x0040
 #define NoSupportTV         0x0070
 #define NoSupportHiVisionTV 0x0060
 #define NoSupportLCD        0x0058
-#define SupportTV1024       0x0800 /* 301btest */
-#define InterlaceMode       0x0080
-#define SyncPP              0x0000
-#define SyncPN              0x4000
-#define SyncNP              0x8000
-#define SyncNN              0xC000
 
 /* -------------- SetMode Stack/Scratch */
-#define SetSimuScanMode     0x0001    /* VBInfo/CR30 & CR31 */
-#define SetCRT2ToTV         0x089C
-#define SetCRT2ToAVIDEO     0x0004
-#define SetCRT2ToSVIDEO     0x0008
-#define SetCRT2ToSCART      0x0010
-#define SetCRT2ToLCD        0x0020
-#define SetCRT2ToRAMDAC     0x0040
 #define XGI_SetCRT2ToLCDA   0x0100
-#define SetInSlaveMode      0x0200
-#define SetNotSimuMode      0x0400
-#define LoadDACFlag         0x1000
-#define DriverMode          0x4000
 #define SetCRT2ToDualEdge   0x8000
 
-#define ProgrammingCRT2     0x0001       /* Set Flag */
 #define ReserveTVOption     0x0008
 #define GatingCRT           0x0800
 #define DisableChB          0x1000
@@ -124,7 +50,6 @@
 #define DisableChA          0x4000
 #define EnableChA           0x8000
 
-#define SetNTSCTV           0x0000 /* TV Info */
 #define SetTVLowResolution   0x0400
 #define TVSimuMode           0x0800
 #define RPLLDIV2XO           0x1000
@@ -167,24 +92,14 @@
 
 #define TVSense              0xc7
 
-#define TVOverScan           0x10               /* CR35 */
-
 #define YPbPrMode            0xe0
 #define YPbPrMode525i        0x00
 #define YPbPrMode525p        0x20
 #define YPbPrMode750p        0x40
 #define YPbPrMode1080i       0x60
 
-
-#define LCDRGB18Bit          0x01               /* CR37 */
-#define LCDNonExpanding      0x10
-#define LCDSync              0x20
-#define LCDSyncBit           0xe0 /* H/V polarity & sync ID */
-
 #define ScalingLCD           0x08
 
-#define EnableDualEdge       0x01 /* CR38 */
-#define SetToLCDA            0x02
 #define SetYPbPr             0x04
 
 /* ---------------------- VUMA Information */
@@ -207,28 +122,13 @@
 /* translated from asm code 301def.h */
 /*  */
 /* --------------------------------------------------------- */
-#define LCDDataLen           8
-#define TVDataLen            12
 #define LVDSCRT1Len_H        8
 #define LVDSCRT1Len_V        7
-#define LVDSDataLen          6
-#define LVDSDesDataLen       6
 #define LCDDesDataLen        6
 #define LVDSDesDataLen2      8
 #define LCDDesDataLen2       8
-#define CHTVRegLen           16
 
-#define StHiTVHT             892
-#define StHiTVVT             1126
-#define StHiTextTVHT         1000
-#define StHiTextTVVT         1126
-#define ExtHiTVHT            2100
-#define ExtHiTVVT            1125
-#define NTSCHT               1716
-#define NTSCVT                525
 #define NTSC1024x768HT       1908
-#define PALHT                1728
-#define PALVT                 625
 
 #define YPbPrTV525iHT        1716 /* YPbPr */
 #define YPbPrTV525iVT         525
@@ -237,15 +137,10 @@
 #define YPbPrTV750pHT        1650
 #define YPbPrTV750pVT         750
 
-#define CRT2Delay1           0x04 /* XGI301 */
-#define CRT2Delay2           0x0A /* 301B,302 */
-
-
 #define VCLK25_175           0x00
 #define VCLK28_322           0x01
 #define VCLK31_5             0x02
 #define VCLK36               0x03
-#define VCLK40               0x04
 #define VCLK43_163           0x05
 #define VCLK44_9             0x06
 #define VCLK49_5             0x07
@@ -289,7 +184,7 @@
 #define XGI_YPbPr750pVCLK    0x57
 
 #define VCLK39_77            0x40
-#define YPbPr525pVCLK           0x3A
+#define YPbPr525pVCLK        0x3A
 #define NTSC1024VCLK         0x41
 #define VCLK35_2             0x49 /* ; 800x480 */
 #define VCLK122_61           0x4A
-- 
1.7.3.4

