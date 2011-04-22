Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab1DVXEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:04:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60518 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab1DVXEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WLLJ//nw78YOlLKy4YiVGDeNz9r0mlrprLgGWUkFtYoN2P0LIMmWrOCfCqiGmmvCaD
         2Oeff0J2UH0sHyX6AKCLuw/ylych82zbApajaLQVmqIYw8bbh6VXI4NU1omOSUbKKaaS
         hbNlH0VqB2TDiVoz06KIhjd4hz/Y7Z+F2gYFA=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edua, apatard@mandriva.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH] Staging: xgifb: Fixed coding style issues.
Date: Sat, 23 Apr 2011 07:02:49 +0800
Message-Id: <1303513369-28908-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've removed all the warnings given by checkpatch.pl in vb_def.h and
also changed the indentation of pretty much the entire file so that it
is more consistent.

Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/xgifb/vb_def.h | 1269 ++++++++++++++++++++--------------------
 1 files changed, 637 insertions(+), 632 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index 4de182b..339c071 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -1,4 +1,5 @@
-/* $XFree86: xc/programs/Xserver/hw/xfree86/drivers/xgi/initdef.h,v 1.4 2000/12/02 01:16:17 dawes Exp $ */
+/* $XFree86: xc/programs/Xserver/hw/xfree86/drivers/xgi/initdef.h
+ * ,v 1.4 2000/12/02 01:16:17 dawes Exp $*/
 #ifndef _INITDEF_
 #define _INITDEF_
 
@@ -7,38 +8,38 @@
 #endif
 /* shampoo */
 
-#define SEQ_ADDRESS_PORT	  0x0014
-#define SEQ_DATA_PORT		  0x0015
-#define MISC_OUTPUT_REG_READ_PORT 0x001C
-#define MISC_OUTPUT_REG_WRITE_PORT 0x0012
-#define GRAPH_DATA_PORT		  0x1F
-#define GRAPH_ADDRESS_PORT	  0x1E
-#define XGI_MASK_DUAL_CHIP	  0x04  /* SR3A */
-#define CRTC_ADDRESS_PORT_COLOR   0x0024
+#define SEQ_ADDRESS_PORT            0x0014
+#define SEQ_DATA_PORT               0x0015
+#define MISC_OUTPUT_REG_READ_PORT   0x001C
+#define MISC_OUTPUT_REG_WRITE_PORT  0x0012
+#define GRAPH_DATA_PORT             0x1F
+#define GRAPH_ADDRESS_PORT          0x1E
+#define XGI_MASK_DUAL_CHIP          0x04  /* SR3A */
+#define CRTC_ADDRESS_PORT_COLOR     0x0024
 #define VIDEO_SUBSYSTEM_ENABLE_PORT 0x0013
-#define PCI_COMMAND		0x04
+#define PCI_COMMAND                 0x04
 
 /* ~shampoo */
 
 
-#define VB_XGI301	      0x0001  /*301b*/
-#define VB_XGI301B        0x0002
-#define VB_XGI302B        0x0004
+#define VB_XGI301       0x0001 /*301b*/
+#define VB_XGI301B      0x0002
+#define VB_XGI302B      0x0004
 #define VB_XGI301LV     0x0008 /*301lv*/
 #define VB_XGI302LV     0x0010
-#define VB_XGI301C      0x0020       /* for 301C */
-#define  VB_NoLCD        0x8000
+#define VB_XGI301C      0x0020 /* for 301C */
+#define  VB_NoLCD       0x8000
 /*end 301b*/
 
-#define VB_YPbPrInfo     0x07          /*301lv*/
-#define VB_YPbPr525i     0x00
-#define VB_YPbPr525p     0x01
-#define VB_YPbPr750p     0x02
-#define VB_YPbPr1080i    0x03
+#define VB_YPbPrInfo    0x07   /*301lv*/
+#define VB_YPbPr525i    0x00
+#define VB_YPbPr525p    0x01
+#define VB_YPbPr750p    0x02
+#define VB_YPbPr1080i   0x03
 
 /* #define CRT1Len 17 */
-#define LVDSCRT1Len             15
-#define CHTVRegDataLen          5
+#define LVDSCRT1Len     15
+#define CHTVRegDataLen  5
 
 /* #define ModeInfoFlag 0x07 */
 /* #define IsTextMode 0x07 */
@@ -70,8 +71,8 @@
 #define NoSupportTV             0x0070
 #define NoSupportHiVisionTV     0x0060
 #define NoSupportLCD            0x0058
-#define SupportCHTV 		0x0800
-#define SupportCRT2in301C       0x0100       /* for 301C */
+#define SupportCHTV             0x0800
+#define SupportCRT2in301C       0x0100  /* for 301C */
 #define SupportTV1024           0x0800  /*301b*/
 #define SupportYPbPr            0x1000  /*301lv*/
 #define InterlaceMode           0x0080
@@ -104,7 +105,7 @@
 #define DisableCRT2Display      0x2000
 #define DriverMode              0x4000
 #define HotKeySwitch            0x8000
-#define SetCHTVOverScan  	0x8000
+#define SetCHTVOverScan         0x8000
 /* #define SetCRT2ToLCDA 0x8000 301b */
 #define PanelRGB18Bit           0x0100
 #define PanelRGB24Bit           0x0000
@@ -112,8 +113,8 @@
 #define TVOverScan              0x10
 #define TVOverScanShift         4
 #define ClearBufferFlag         0x20
-#define EnableDualEdge 		0x01		/*301b*/
-#define SetToLCDA		0x02
+#define EnableDualEdge          0x01 /*301b*/
+#define SetToLCDA               0x02
 
 #define YPbPrModeInfo           0x38
 /* #define YPbPrMode525i 0x00 */
@@ -123,7 +124,7 @@
 
 #define SetSCARTOutput          0x01
 #define BoardTVType             0x02
-#define  EnablePALMN           0x40
+#define  EnablePALMN            0x40
 /* #define ProgrammingCRT2 0x01 */
 /* #define TVSimuMode 0x02 */
 /* #define RPLLDIV2XO 0x04 */
@@ -133,9 +134,9 @@
 #define CheckWinDos             0x40
 #define SetJDOSMode             0x80
 
-#define Panel320x480              0x07/*fstn*/
+#define Panel320x480            0x07 /*fstn*/
 /* [ycchen] 02/12/03 Modify for Multi-Sync. LCD Support */
-#define PanelResInfo            0x1F	/* CR36 Panel Type/LCDResInfo */
+#define PanelResInfo            0x1F /* CR36 Panel Type/LCDResInfo */
 #define PanelRefInfo            0x60
 #define Panel800x600            0x01
 #define Panel1024x768           0x02
@@ -200,7 +201,7 @@
 #define SoftDramType            0x80
 #define VCLK40                  0x04
 
-#define VCLK162             	0x21
+#define VCLK162                 0x21
 
 #define LCDRGB18Bit             0x01
 #define LoadDACFlag             0x1000
@@ -228,11 +229,11 @@
 #define StStructSize            0x06
 
 
-#define XGI_CRT2_PORT_00        0x00 - 0x030
-#define XGI_CRT2_PORT_04        0x04 - 0x030
-#define XGI_CRT2_PORT_10        0x10 - 0x30
-#define XGI_CRT2_PORT_12        0x12 - 0x30
-#define XGI_CRT2_PORT_14        0x14 - 0x30
+#define XGI_CRT2_PORT_00        (0x00 - 0x030)
+#define XGI_CRT2_PORT_04        (0x04 - 0x030)
+#define XGI_CRT2_PORT_10        (0x10 - 0x30)
+#define XGI_CRT2_PORT_12        (0x12 - 0x30)
+#define XGI_CRT2_PORT_14        (0x14 - 0x30)
 
 
 #define LCDNonExpanding         0x10
@@ -274,8 +275,8 @@
 #define _PanelType0E             0x70
 #define _PanelType0F             0x78
 
-
-#define PRIMARY_VGA       0     /* 1: XGI is primary vga 0:XGI is secondary vga */
+/* 1: XGI is primary vga 0:XGI is secondary vga */
+#define PRIMARY_VGA             0
 #define BIOSIDCodeAddr          0x235
 #define OEMUtilIDCodeAddr       0x237
 #define VBModeIDTableAddr       0x239
@@ -362,656 +363,660 @@
 #define VideoSenseDataOffset  0xC1
 #define OutputSelectOffset    0xF3
 
-#define ECLK_MCLK_DISTANCE  0x14
+#define ECLK_MCLK_DISTANCE        0x14
 #define VBIOSTablePointerStart    0x200
-#define StandTablePtrOffset       VBIOSTablePointerStart+0x02
-#define EModeIDTablePtrOffset     VBIOSTablePointerStart+0x04
-#define CRT1TablePtrOffset        VBIOSTablePointerStart+0x06
-#define ScreenOffsetPtrOffset     VBIOSTablePointerStart+0x08
-#define VCLKDataPtrOffset         VBIOSTablePointerStart+0x0A
-#define MCLKDataPtrOffset         VBIOSTablePointerStart+0x0E
-#define CRT2PtrDataPtrOffset      VBIOSTablePointerStart+0x10
-#define TVAntiFlickPtrOffset      VBIOSTablePointerStart+0x12
-#define TVDelayPtr1Offset         VBIOSTablePointerStart+0x14
-#define TVPhaseIncrPtr1Offset     VBIOSTablePointerStart+0x16
-#define TVYFilterPtr1Offset       VBIOSTablePointerStart+0x18
-#define LCDDelayPtr1Offset        VBIOSTablePointerStart+0x20
-#define TVEdgePtr1Offset          VBIOSTablePointerStart+0x24
-#define CRT2Delay1Offset          VBIOSTablePointerStart+0x28
-#define LCDDataDesOffset     VBIOSTablePointerStart-0x02
-#define LCDDataPtrOffset          VBIOSTablePointerStart+0x2A
-#define LCDDesDataPtrOffset     VBIOSTablePointerStart+0x2C
-#define LCDDataList		VBIOSTablePointerStart+0x22	/* add for GetLCDPtr */
-#define TVDataList		VBIOSTablePointerStart+0x36	/* add for GetTVPtr */
+#define StandTablePtrOffset       (VBIOSTablePointerStart+0x02)
+#define EModeIDTablePtrOffset     (VBIOSTablePointerStart+0x04)
+#define CRT1TablePtrOffset        (VBIOSTablePointerStart+0x06)
+#define ScreenOffsetPtrOffset     (VBIOSTablePointerStart+0x08)
+#define VCLKDataPtrOffset         (VBIOSTablePointerStart+0x0A)
+#define MCLKDataPtrOffset         (VBIOSTablePointerStart+0x0E)
+#define CRT2PtrDataPtrOffset      (VBIOSTablePointerStart+0x10)
+#define TVAntiFlickPtrOffset      (VBIOSTablePointerStart+0x12)
+#define TVDelayPtr1Offset         (VBIOSTablePointerStart+0x14)
+#define TVPhaseIncrPtr1Offset     (VBIOSTablePointerStart+0x16)
+#define TVYFilterPtr1Offset       (VBIOSTablePointerStart+0x18)
+#define LCDDelayPtr1Offset        (VBIOSTablePointerStart+0x20)
+#define TVEdgePtr1Offset          (VBIOSTablePointerStart+0x24)
+#define CRT2Delay1Offset          (VBIOSTablePointerStart+0x28)
+#define LCDDataDesOffset          (VBIOSTablePointerStart-0x02)
+#define LCDDataPtrOffset          (VBIOSTablePointerStart+0x2A)
+#define LCDDesDataPtrOffset       (VBIOSTablePointerStart+0x2C)
+/* add LCDDataList for GetLCDPtr */
+#define LCDDataList               (VBIOSTablePointerStart+0x22)
+/* add TVDataList for GetTVPtr */
+#define TVDataList                (VBIOSTablePointerStart+0x36)
 /*  */
 /* Modify from 310.inc */
 /*  */
 /*  */
 
 
-#define		ShowMsgFlag                  0x20               /* SoftSetting */
-#define		ShowVESAFlag                 0x10
-#define		HotPlugFunction              0x08
-#define		ModeSoftSetting              0x04
-#define		TVSoftSetting                0x02
-#define		LCDSoftSetting               0x01
+#define ShowMsgFlag                  0x20    /* SoftSetting */
+#define ShowVESAFlag                 0x10
+#define HotPlugFunction              0x08
+#define ModeSoftSetting              0x04
+#define TVSoftSetting                0x02
+#define LCDSoftSetting               0x01
 
-#define		GatingCRTinLCDA              0x10
-#define		SetHiTVOutput                0x08
-#define		SetYPbPrOutput               0x04
-#define		BoardTVType                  0x02
-#define		SetSCARTOutput               0x01
+#define GatingCRTinLCDA              0x10
+#define SetHiTVOutput                0x08
+#define SetYPbPrOutput               0x04
+#define BoardTVType                  0x02
+#define SetSCARTOutput               0x01
 
-#define		ModeSettingYPbPr             0x02               /* TVModeSetting, Others as same as CR30 */
+/* TVModeSetting, Others as same as CR30 */
+#define ModeSettingYPbPr             0x02
 
 /* TVModeSetting same as CR35 */
 
 /* LCDModeSetting same as CR37 */
 
-#define		EnableNewTVFont              0x10               /* MiscCapability */
+#define EnableNewTVFont              0x10    /* MiscCapability */
 
-#define		EnableLCDOutput              0x80               /* LCDCfgSetting */
+#define EnableLCDOutput              0x80    /* LCDCfgSetting */
 
-#define		SoftDRAMType                 0x80               /* DRAMSetting */
-#define		SoftDRAMConfig               0x40
-#define		MosSelDRAMType               0x20
-#define		SDRAM                        000h
-#define		SGRAM                        0x01
-#define		ESDRAM                       0x02
+#define SoftDRAMType                 0x80    /* DRAMSetting */
+#define SoftDRAMConfig               0x40
+#define MosSelDRAMType               0x20
+#define SDRAM                        000h
+#define SGRAM                        0x01
+#define ESDRAM                       0x02
 
-#define		EnableAGPCfgSetting          0x01               /* AGPCfgSetting */
+#define EnableAGPCfgSetting          0x01    /* AGPCfgSetting */
 
 /* ---------------- SetMode Stack */
-#define		CRT1Len                      15
-#define		VCLKLen                      4
-#define		DefThreshold                 0x0100
-#define		ExtRegsSize                  (57+8+37+70+63+28+768+1)/64+1
-
-#define		VGA_XGI315                   0x0001       /* VGA Type Info */
-#define		VGA_SNewis315e                  0x0002       /* 315 series */
-#define		VGA_XGI550                   0x0004
-#define		VGA_XGI640                   0x0008
-#define		VGA_XGI740                   0x0010
-#define		VGA_XGI650                   0x0020
-#define		VGA_XGI650M                  0x0040
-#define		VGA_XGI651                   0x0080
-#define		VGA_XGI340                   0x0001       /* 340 series */
-#define		VGA_XGI330                   0x0001       /* 330 series */
-#define		VGA_XGI660                   0x0001       /* 660 series */
-
-#define		VB_XGI301                    0x0001       /* VB Type Info */
-#define		VB_XGI301B                   0x0002       /* 301 series */
-#define		VB_XGI302B                   0x0004
-#define		VB_NoLCD                     0x8000
-#define		VB_XGI301LV                  0x0008
-#define		VB_XGI302LV                  0x0010
-#define		VB_LVDS_NS                   0x0001       /* 3rd party chip */
-#define		VB_CH7017                    0x0002
-#define         VB_CH7007                    0x0080       /* [Billy] 07/05/03 */
+#define CRT1Len           15
+#define VCLKLen           4
+#define DefThreshold      0x0100
+#define ExtRegsSize       ((57+8+37+70+63+28+768+1)/64+1)
+
+#define VGA_XGI315        0x0001       /* VGA Type Info */
+#define VGA_SNewis315e    0x0002       /* 315 series */
+#define VGA_XGI550        0x0004
+#define VGA_XGI640        0x0008
+#define VGA_XGI740        0x0010
+#define VGA_XGI650        0x0020
+#define VGA_XGI650M       0x0040
+#define VGA_XGI651        0x0080
+#define VGA_XGI340        0x0001       /* 340 series */
+#define VGA_XGI330        0x0001       /* 330 series */
+#define VGA_XGI660        0x0001       /* 660 series */
+
+#define VB_XGI301         0x0001       /* VB Type Info */
+#define VB_XGI301B        0x0002       /* 301 series */
+#define VB_XGI302B        0x0004
+#define VB_NoLCD          0x8000
+#define VB_XGI301LV       0x0008
+#define VB_XGI302LV       0x0010
+#define VB_LVDS_NS        0x0001       /* 3rd party chip */
+#define VB_CH7017         0x0002
+#define VB_CH7007         0x0080       /* [Billy] 07/05/03 */
 /* #define VB_LVDS_SI 0x0004 */
 
-#define		ModeInfoFlag                 0x0007
-#define		IsTextMode                   0x0007
-#define		ModeText                     0x0000
-#define		ModeCGA                      0x0001
-#define		ModeEGA                      0x0002       /* 16 colors mode */
-#define		ModeVGA                      0x0003       /* 256 colors mode */
-#define		Mode15Bpp                    0x0004       /* 15 Bpp Color Mode */
-#define		Mode16Bpp                    0x0005       /* 16 Bpp Color Mode */
-#define		Mode24Bpp                    0x0006       /* 24 Bpp Color Mode */
-#define		Mode32Bpp                    0x0007       /* 32 Bpp Color Mode */
-
-#define		DACInfoFlag                  0x0018
-#define		MONODAC                      0x0000
-#define		CGADAC                       0x0008
-#define		EGADAC                       0x0010
-#define		VGADAC                       0x0018
-
-#define		MemoryInfoFlag               0x01e0
-#define		MemorySizeShift              5
-#define		Need1MSize                   0x0000
-#define		Need2MSize                   0x0020
-#define		Need4MSize                   0x0060
-#define		Need8MSize                   0x00e0
-#define		Need16MSize                  0x01e0
-
-#define		Charx8Dot                    0x0200
-#define		LineCompareOff               0x0400
-#define		CRT2Mode                     0x0800
-#define		HalfDCLK                     0x1000
-#define		NoSupportSimuTV              0x2000
-#define		DoubleScanMode               0x8000
+#define ModeInfoFlag      0x0007
+#define IsTextMode        0x0007
+#define ModeText          0x0000
+#define ModeCGA           0x0001
+#define ModeEGA           0x0002    /* 16 colors mode */
+#define ModeVGA           0x0003    /* 256 colors mode */
+#define Mode15Bpp         0x0004    /* 15 Bpp Color Mode */
+#define Mode16Bpp         0x0005    /* 16 Bpp Color Mode */
+#define Mode24Bpp         0x0006    /* 24 Bpp Color Mode */
+#define Mode32Bpp         0x0007    /* 32 Bpp Color Mode */
+
+#define DACInfoFlag       0x0018
+#define MONODAC           0x0000
+#define CGADAC            0x0008
+#define EGADAC            0x0010
+#define VGADAC            0x0018
+
+#define MemoryInfoFlag    0x01e0
+#define MemorySizeShift   5
+#define Need1MSize        0x0000
+#define Need2MSize        0x0020
+#define Need4MSize        0x0060
+#define Need8MSize        0x00e0
+#define Need16MSize       0x01e0
+
+#define Charx8Dot         0x0200
+#define LineCompareOff    0x0400
+#define CRT2Mode          0x0800
+#define HalfDCLK          0x1000
+#define NoSupportSimuTV   0x2000
+#define DoubleScanMode    0x8000
 
 /* -------------- Ext_InfoFlag */
-#define		SupportModeInfo              0x0007
-#define		Support256                   0x0003
-#define		Support15Bpp                 0x0004
-#define		Support16Bpp                 0x0005
-#define		Support24Bpp                 0x0006
-#define		Support32Bpp                 0x0007
-
-#define		SupportAllCRT2               0x0078
-#define		SupportTV                    0x0008
-#define		SupportHiVisionTV            0x0010
-#define		SupportLCD                   0x0020
-#define		SupportRAMDAC2               0x0040
-#define		NoSupportTV                  0x0070
-#define		NoSupportHiVisionTV          0x0060
-#define		NoSupportLCD                 0x0058
-#define		SupportTV1024                0x0800       /* 301btest */
-#define		SupportYPbPr                 0x1000       /* 301lv */
-#define		InterlaceMode                0x0080
-#define		SyncPP                       0x0000
-#define		SyncPN                       0x4000
-#define		SyncNP                       0x8000
-#define		SyncNN                       0xC000
+#define SupportModeInfo     0x0007
+#define Support256          0x0003
+#define Support15Bpp        0x0004
+#define Support16Bpp        0x0005
+#define Support24Bpp        0x0006
+#define Support32Bpp        0x0007
+
+#define SupportAllCRT2      0x0078
+#define SupportTV           0x0008
+#define SupportHiVisionTV   0x0010
+#define SupportLCD          0x0020
+#define SupportRAMDAC2      0x0040
+#define NoSupportTV         0x0070
+#define NoSupportHiVisionTV 0x0060
+#define NoSupportLCD        0x0058
+#define SupportTV1024       0x0800 /* 301btest */
+#define SupportYPbPr        0x1000 /* 301lv */
+#define InterlaceMode       0x0080
+#define SyncPP              0x0000
+#define SyncPN              0x4000
+#define SyncNP              0x8000
+#define SyncNN              0xC000
 
 /* -------------- SetMode Stack/Scratch */
-#define		SetSimuScanMode              0x0001       /* VBInfo/CR30 & CR31 */
-#define		SwitchToCRT2                 0x0002
-#define		SetCRT2ToTV1                 0x009C
-#define		SetCRT2ToTV                  0x089C
-#define		SetCRT2ToAVIDEO              0x0004
-#define		SetCRT2ToSVIDEO              0x0008
-#define		SetCRT2ToSCART               0x0010
-#define		SetCRT2ToLCD                 0x0020
-#define		SetCRT2ToRAMDAC              0x0040
-#define		SetCRT2ToHiVisionTV          0x0080
-#define		SetCRT2ToLCDA                0x0100
-#define		SetInSlaveMode               0x0200
-#define		SetNotSimuMode               0x0400
-#define		HKEventMode                  0x0800
-#define		SetCRT2ToYPbPr               0x0800
-#define		LoadDACFlag                  0x1000
-#define		DisableCRT2Display           0x2000
-#define		DriverMode                   0x4000
-#define		SetCRT2ToDualEdge            0x8000
-#define		HotKeySwitch                 0x8000
-
-#define		ProgrammingCRT2              0x0001       /* Set Flag */
-#define		EnableVCMode                 0x0002
-#define		SetHKEventMode               0x0004
-#define		ReserveTVOption              0x0008
-#define		DisableRelocateIO            0x0010
-#define		Win9xDOSMode                 0x0020
-#define		JDOSMode                     0x0040
+#define SetSimuScanMode     0x0001    /* VBInfo/CR30 & CR31 */
+#define SwitchToCRT2        0x0002
+#define SetCRT2ToTV1        0x009C
+#define SetCRT2ToTV         0x089C
+#define SetCRT2ToAVIDEO     0x0004
+#define SetCRT2ToSVIDEO     0x0008
+#define SetCRT2ToSCART      0x0010
+#define SetCRT2ToLCD        0x0020
+#define SetCRT2ToRAMDAC     0x0040
+#define SetCRT2ToHiVisionTV 0x0080
+#define SetCRT2ToLCDA       0x0100
+#define SetInSlaveMode      0x0200
+#define SetNotSimuMode      0x0400
+#define HKEventMode         0x0800
+#define SetCRT2ToYPbPr      0x0800
+#define LoadDACFlag         0x1000
+#define DisableCRT2Display  0x2000
+#define DriverMode          0x4000
+#define SetCRT2ToDualEdge   0x8000
+#define HotKeySwitch        0x8000
+
+#define ProgrammingCRT2     0x0001       /* Set Flag */
+#define EnableVCMode        0x0002
+#define SetHKEventMode      0x0004
+#define ReserveTVOption     0x0008
+#define DisableRelocateIO   0x0010
+#define Win9xDOSMode        0x0020
+#define JDOSMode            0x0040
 /* #define SetWin9xforJap 0x0080 // not used now */
 /* #define SetWin9xforKorea 0x0100 // not used now */
-#define		GatingCRT                    0x0800
-#define		DisableChB                   0x1000
-#define		EnableChB                    0x2000
-#define		DisableChA                   0x4000
-#define		EnableChA                    0x8000
-
-#define		SetNTSCTV                    0x0000       /* TV Info */
-#define		SetPALTV                     0x0001
-#define		SetNTSCJ                     0x0002
-#define		SetPALMTV                    0x0004
-#define		SetPALNTV                    0x0008
-#define		SetCHTVUnderScan             0x0000
+#define GatingCRT           0x0800
+#define DisableChB          0x1000
+#define EnableChB           0x2000
+#define DisableChA          0x4000
+#define EnableChA           0x8000
+
+#define SetNTSCTV           0x0000 /* TV Info */
+#define SetPALTV            0x0001
+#define SetNTSCJ            0x0002
+#define SetPALMTV           0x0004
+#define SetPALNTV           0x0008
+#define SetCHTVUnderScan    0x0000
 /* #define SetCHTVOverScan 0x0010 */
-#define		SetYPbPrMode525i             0x0020
-#define		SetYPbPrMode525p             0x0040
-#define		SetYPbPrMode750p             0x0080
-#define		SetYPbPrMode1080i            0x0100
-#define		SetTVStdMode                 0x0200
-#define		SetTVLowResolution           0x0400
-#define		SetTVSimuMode                0x0800
-#define		TVSimuMode                   0x0800
-#define		RPLLDIV2XO                   0x1000
-#define		NTSC1024x768                 0x2000
-#define		SetTVLockMode                0x4000
-
-#define		LCDVESATiming                0x0001       /* LCD Info/CR37 */
-#define		EnableLVDSDDA                0x0002
-#define		EnableScalingLCD             0x0008
-#define		SetPWDEnable                 0x0004
-#define		SetLCDtoNonExpanding         0x0010
-#define		SetLCDPolarity               0x00e0
-#define		SetLCDDualLink               0x0100
-#define		SetLCDLowResolution          0x0200
-#define		SetLCDStdMode                0x0400
-
-#define		DefaultLCDCap                0x80ea       /* LCD Capability shampoo */
-#define		RLVDSDHL00                   0x0000
-#define		RLVDSDHL01                   0x0001
-#define		RLVDSDHL10                   0x0002       /* default */
-#define		RLVDSDHL11                   0x0003
-#define		EnableLCD24bpp               0x0004       /* default */
-#define		DisableLCD24bpp              0x0000
-#define		RLVDSClkSFT0                 0x0000
-#define		RLVDSClkSFT1                 0x0008       /* default */
-#define		EnableLVDSDCBal              0x0010
-#define		DisableLVDSDCBal             0x0000       /* default */
-#define		SinglePolarity               0x0020       /* default */
-#define		MultiPolarity                0x0000
-#define		LCDPolarity                  0x00c0       /* default: SyncNN */
-#define		LCDSingleLink                0x0000       /* default */
-#define		LCDDualLink                  0x0100
-#define		EnableSpectrum               0x0200
-#define		DisableSpectrum              0x0000       /* default */
-#define		PWDEnable                    0x0400
-#define		PWDDisable                   0x0000       /* default */
-#define		PWMEnable                    0x0800
-#define		PWMDisable                   0x0000       /* default */
-#define		EnableVBCLKDRVLOW            0x4000
-#define		EnableVBCLKDRVHigh           0x0000       /* default */
-#define		EnablePLLSPLOW               0x8000
-#define		EnablePLLSPHigh              0x0000       /* default */
-
-#define		LCDBToA                      0x20               /* LCD SetFlag */
-#define		StLCDBToA                    0x40
-#define		LockLCDBToA                  0x80
-#define 	LCDToFull             	     0x10
-#define		AVIDEOSense                  0x01               /* CR32 */
-#define		SVIDEOSense                  0x02
-#define		SCARTSense                   0x04
-#define		LCDSense                     0x08
-#define		Monitor2Sense                0x10
-#define		Monitor1Sense                0x20
-#define		HiTVSense                    0x40
-
-#ifdef                   NewScratch
-#define		YPbPrSense                   0x80    /* NEW SCRATCH */
+#define SetYPbPrMode525i     0x0020
+#define SetYPbPrMode525p     0x0040
+#define SetYPbPrMode750p     0x0080
+#define SetYPbPrMode1080i    0x0100
+#define SetTVStdMode         0x0200
+#define SetTVLowResolution   0x0400
+#define SetTVSimuMode        0x0800
+#define TVSimuMode           0x0800
+#define RPLLDIV2XO           0x1000
+#define NTSC1024x768         0x2000
+#define SetTVLockMode        0x4000
+
+#define LCDVESATiming        0x0001 /* LCD Info/CR37 */
+#define EnableLVDSDDA        0x0002
+#define EnableScalingLCD     0x0008
+#define SetPWDEnable         0x0004
+#define SetLCDtoNonExpanding 0x0010
+#define SetLCDPolarity       0x00e0
+#define SetLCDDualLink       0x0100
+#define SetLCDLowResolution  0x0200
+#define SetLCDStdMode        0x0400
+
+/* LCD Capability shampoo */
+#define DefaultLCDCap        0x80ea
+#define RLVDSDHL00           0x0000
+#define RLVDSDHL01           0x0001
+#define RLVDSDHL10           0x0002 /* default */
+#define RLVDSDHL11           0x0003
+#define EnableLCD24bpp       0x0004 /* default */
+#define DisableLCD24bpp      0x0000
+#define RLVDSClkSFT0         0x0000
+#define RLVDSClkSFT1         0x0008 /* default */
+#define EnableLVDSDCBal      0x0010
+#define DisableLVDSDCBal     0x0000 /* default */
+#define SinglePolarity       0x0020 /* default */
+#define MultiPolarity        0x0000
+#define LCDPolarity          0x00c0 /* default: SyncNN */
+#define LCDSingleLink        0x0000 /* default */
+#define LCDDualLink          0x0100
+#define EnableSpectrum       0x0200
+#define DisableSpectrum      0x0000 /* default */
+#define PWDEnable            0x0400
+#define PWDDisable           0x0000 /* default */
+#define PWMEnable            0x0800
+#define PWMDisable           0x0000 /* default */
+#define EnableVBCLKDRVLOW    0x4000
+#define EnableVBCLKDRVHigh   0x0000 /* default */
+#define EnablePLLSPLOW       0x8000
+#define EnablePLLSPHigh      0x0000 /* default */
+
+#define LCDBToA              0x20   /* LCD SetFlag */
+#define StLCDBToA            0x40
+#define LockLCDBToA          0x80
+#define   LCDToFull          0x10
+#define AVIDEOSense          0x01   /* CR32 */
+#define SVIDEOSense          0x02
+#define SCARTSense           0x04
+#define LCDSense             0x08
+#define Monitor2Sense        0x10
+#define Monitor1Sense        0x20
+#define HiTVSense            0x40
+
+#ifdef NewScratch
+#define YPbPrSense           0x80   /* NEW SCRATCH */
 #endif
 
-#define		TVSense                      0xc7
-
-#define		TVOverScan                   0x10               /* CR35 */
-#define		TVOverScanShift              4
-
-#ifdef                   NewScratch
-#define		NTSCMode                     0x00
-#define		PALMode                      0x00
-#define		NTSCJMode                    0x02
-#define		PALMNMode                    0x0c
-#define		YPbPrMode                    0xe0
-#define		YPbPrMode525i                0x00
-#define		YPbPrMode525p                0x20
-#define		YPbPrMode750p                0x40
-#define		YPbPrMode1080i               0x60
+#define TVSense              0xc7
+
+#define TVOverScan           0x10               /* CR35 */
+#define TVOverScanShift      4
+
+#ifdef NewScratch
+#define NTSCMode             0x00
+#define PALMode              0x00
+#define NTSCJMode            0x02
+#define PALMNMode            0x0c
+#define YPbPrMode            0xe0
+#define YPbPrMode525i        0x00
+#define YPbPrMode525p        0x20
+#define YPbPrMode750p        0x40
+#define YPbPrMode1080i       0x60
 #else                    /* Old Scratch */
-#define		ClearBufferFlag              0x20
+#define ClearBufferFlag      0x20
 #endif
 
 
-#define		LCDRGB18Bit                  0x01               /* CR37 */
-#define		LCDNonExpanding              0x10
-#define		LCDNonExpandingShift         4
-#define		LCDSync                      0x20
-#define		LCDSyncBit                   0xe0               /* H/V polarity & sync ID */
-#define		LCDSyncShift                 6
-
-#ifdef                   NewScratch
-#define		ScalingLCD                   0x08
-#else                    /* Old Scratch */
-#define		ExtChipType                  0x0e
-#define		ExtChip301                   0x02
-#define		ExtChipLVDS                  0x04
-#define		ExtChipCH7019                0x06
-#define		ScalingLCD                   0x10
+#define LCDRGB18Bit          0x01               /* CR37 */
+#define LCDNonExpanding      0x10
+#define LCDNonExpandingShift 4
+#define LCDSync              0x20
+#define LCDSyncBit           0xe0 /* H/V polarity & sync ID */
+#define LCDSyncShift         6
+
+#ifdef NewScratch
+#define ScalingLCD           0x08
+#else  /* Old Scratch */
+#define ExtChipType          0x0e
+#define ExtChip301           0x02
+#define ExtChipLVDS          0x04
+#define ExtChipCH7019        0x06
+#define ScalingLCD           0x10
 #endif
 
-#define		EnableDualEdge               0x01               /* CR38 */
-#define		SetToLCDA                    0x02
-#ifdef                   NewScratch
-#define		SetYPbPr                     0x04
-#define		DisableChannelA              0x08
-#define		DisableChannelB              0x10
-#define		ExtChipType                  0xe0
-#define		ExtChip301                   0x20
-#define		ExtChipLVDS                  0x40
-#define		ExtChipCH7019                0x60
+#define EnableDualEdge       0x01 /* CR38 */
+#define SetToLCDA            0x02
+#ifdef NewScratch
+#define SetYPbPr             0x04
+#define DisableChannelA      0x08
+#define DisableChannelB      0x10
+#define ExtChipType          0xe0
+#define ExtChip301           0x20
+#define ExtChipLVDS          0x40
+#define ExtChipCH7019        0x60
 #else                    /* Old Scratch */
-#define		YPbPrSense                   0x04
-#define		SetYPbPr                     0x08
-#define		YPbPrMode                    0x30
-#define		YPbPrMode525i                0x00
-#define		YPbPrMode525p                0x10
-#define		YPbPrMode750p                0x20
-#define		YPbPrMode1080i               0x30
-#define		PALMNMode                    0xc0
+#define YPbPrSense           0x04
+#define SetYPbPr             0x08
+#define YPbPrMode            0x30
+#define YPbPrMode525i        0x00
+#define YPbPrMode525p        0x10
+#define YPbPrMode750p        0x20
+#define YPbPrMode1080i       0x30
+#define PALMNMode            0xc0
 #endif
 
-#define		BacklightControlBit          0x01               /* CR3A */
-#define		Win9xforJap                  0x40
-#define		Win9xforKorea                0x80
-
-#define		ForceMDBits                  0x07               /* CR3B */
-#define		ForceMD_JDOS                 0x00
-#define		ForceMD_640x400T             0x01
-#define		ForceMD_640x350T             0x02
-#define		ForceMD_720x400T             0x03
-#define		ForceMD_640x480E             0x04
-#define		ForceMD_640x400E             0x05
-#define		ForceP1Bit                   0x10
-#define		ForceP2Bit                   0x20
-#define		EnableForceMDinBIOS          0x40
-#define		EnableForceMDinDrv           0x80
-
-#ifdef                   NewScratch                      /* New Scratch */
+#define BacklightControlBit  0x01 /* CR3A */
+#define Win9xforJap          0x40
+#define Win9xforKorea        0x80
+
+#define ForceMDBits          0x07 /* CR3B */
+#define ForceMD_JDOS         0x00
+#define ForceMD_640x400T     0x01
+#define ForceMD_640x350T     0x02
+#define ForceMD_720x400T     0x03
+#define ForceMD_640x480E     0x04
+#define ForceMD_640x400E     0x05
+#define ForceP1Bit           0x10
+#define ForceP2Bit           0x20
+#define EnableForceMDinBIOS  0x40
+#define EnableForceMDinDrv   0x80
+
+#ifdef NewScratch /* New Scratch */
 /* ---------------------- VUMA Information */
-#define		LCDSettingFromCMOS           0x04               /* CR3C */
-#define		TVSettingFromCMOS            0x08
-#define		DisplayDeviceFromCMOS        0x10
-#define		HKSupportInSBIOS             0x20
-#define		OSDSupportInSBIOS            0x40
-#define		DisableLogo                  0x80
+#define LCDSettingFromCMOS    0x04 /* CR3C */
+#define TVSettingFromCMOS     0x08
+#define DisplayDeviceFromCMOS 0x10
+#define HKSupportInSBIOS      0x20
+#define OSDSupportInSBIOS     0x40
+#define DisableLogo           0x80
 
 /* ---------------------- HK Evnet Definition */
-#define		HKEvent                      0x0f               /* CR3D */
-#define		HK_ModeSwitch                0x01
-#define		HK_Expanding                 0x02
-#define		HK_OverScan                  0x03
-#define		HK_Brightness                0x04
-#define		HK_Contrast                  0x05
-#define		HK_Mute                      0x06
-#define		HK_Volume                    0x07
-#define		ModeSwitchStatus             0xf0
-#define		ActiveCRT1                   0x10
-#define		ActiveLCD                    0x0020
-#define		ActiveTV                     0x40
-#define		ActiveCRT2                   0x80
-
-#define		TVSwitchStatus               0x1f               /* CR3E */
-#define		ActiveAVideo                 0x01
-#define		ActiveSVideo                 0x02
-#define		ActiveSCART                  0x04
-#define		ActiveHiTV                   0x08
-#define		ActiveYPbPr                  0x10
-
-#define		EnableHKEvent                0x01               /* CR3F */
-#define		EnableOSDEvent               0x02
-#define		StartOSDEvent                0x04
-#define		IgnoreHKEvent                0x08
-#define		IgnoreOSDEvent               0x10
+#define HKEvent               0x0f /* CR3D */
+#define HK_ModeSwitch         0x01
+#define HK_Expanding          0x02
+#define HK_OverScan           0x03
+#define HK_Brightness         0x04
+#define HK_Contrast           0x05
+#define HK_Mute               0x06
+#define HK_Volume             0x07
+#define ModeSwitchStatus      0xf0
+#define ActiveCRT1            0x10
+#define ActiveLCD             0x0020
+#define ActiveTV              0x40
+#define ActiveCRT2            0x80
+
+#define TVSwitchStatus        0x1f /* CR3E */
+#define ActiveAVideo          0x01
+#define ActiveSVideo          0x02
+#define ActiveSCART           0x04
+#define ActiveHiTV            0x08
+#define ActiveYPbPr           0x10
+
+#define EnableHKEvent         0x01 /* CR3F */
+#define EnableOSDEvent        0x02
+#define StartOSDEvent         0x04
+#define IgnoreHKEvent         0x08
+#define IgnoreOSDEvent        0x10
 #else                    /* Old Scratch */
-#define		OSD_SBIOS                    0x02       /* SR17 */
-#define		DisableLogo                  0x04
-#define		SelectKDOS                   0x08
-#define		KorWinMode                   0x10
-#define		KorMode3Bit                  0x0020
-#define		PSCCtrlBit                  0x40
-#define		NPSCCtrlBitShift             6
-#define		BlueScreenBit                0x80
-
-#define		HKEvent                      0x0f       /* CR79 */
-#define		HK_ModeSwitch                0x01
-#define		HK_Expanding                 0x02
-#define		HK_OverScan                  0x03
-#define		HK_Brightness                0x04
-#define		HK_Contrast                  0x05
-#define		HK_Mute                      0x06
-#define		HK_Volume                    0x07
-#define		ActivePAL                    0x0020
-#define		ActivePALShift               5
-#define		ActiveNonExpanding           0x40
-#define		ActiveNonExpandingShift      6
-#define		ActiveOverScan               0x80
-#define		ActiveOverScanShift          7
-
-#define		ModeSwitchStatus             0x0b       /* SR15 */
-#define		ActiveCRT1                   0x01
-#define		ActiveLCD                    0x02
-#define		ActiveCRT2                   0x08
-
-#define		TVSwitchStatus               0xf0       /* SR16 */
-#define		TVConfigShift                3
-#define		ActiveTV                     0x01
-#define		ActiveYPbPr                  0x04
-#define		ActiveAVideo                 0x10
-#define		ActiveSVideo                 0x0020
-#define		ActiveSCART                  0x40
-#define		ActiveHiTV                   0x80
-
-#define		EnableHKEvent                0x01       /* CR7A */
-#define		EnableOSDEvent               0x02
-#define		StartOSDEvent                0x04
-#define		CMOSSupport                  0x08
-#define		HotKeySupport                0x10
-#define		IngoreHKOSDEvent             0x20
+#define OSD_SBIOS               0x02 /* SR17 */
+#define DisableLogo             0x04
+#define SelectKDOS              0x08
+#define KorWinMode              0x10
+#define KorMode3Bit             0x0020
+#define PSCCtrlBit              0x40
+#define NPSCCtrlBitShift        6
+#define BlueScreenBit           0x80
+
+#define HKEvent                 0x0f /* CR79 */
+#define HK_ModeSwitch           0x01
+#define HK_Expanding            0x02
+#define HK_OverScan             0x03
+#define HK_Brightness           0x04
+#define HK_Contrast             0x05
+#define HK_Mute                 0x06
+#define HK_Volume               0x07
+#define ActivePAL               0x0020
+#define ActivePALShift          5
+#define ActiveNonExpanding      0x40
+#define ActiveNonExpandingShift 6
+#define ActiveOverScan          0x80
+#define ActiveOverScanShift     7
+
+#define ModeSwitchStatus        0x0b /* SR15 */
+#define ActiveCRT1              0x01
+#define ActiveLCD               0x02
+#define ActiveCRT2              0x08
+
+#define TVSwitchStatus          0xf0 /* SR16 */
+#define TVConfigShift           3
+#define ActiveTV                0x01
+#define ActiveYPbPr             0x04
+#define ActiveAVideo            0x10
+#define ActiveSVideo            0x0020
+#define ActiveSCART             0x40
+#define ActiveHiTV              0x80
+
+#define EnableHKEvent           0x01 /* CR7A */
+#define EnableOSDEvent          0x02
+#define StartOSDEvent           0x04
+#define CMOSSupport             0x08
+#define HotKeySupport           0x10
+#define IngoreHKOSDEvent        0x20
 #endif
 
 /* //------------- Misc. Definition */
-#define		SelectCRT1Rate               00h
+#define SelectCRT1Rate               00h
 /* #define SelectCRT2Rate 04h */
 
-#define		DDC1DelayTime                1000
-#ifdef           TRUMPION
-#define		DDC2DelayTime                15
+#define DDC1DelayTime           1000
+#ifdef TRUMPION
+#define DDC2DelayTime           15
 #else
-#define		DDC2DelayTime                150
+#define DDC2DelayTime           150
 #endif
 
-#define		R_FACTOR                     04Dh
-#define		G_FACTOR                     097h
-#define		B_FACTOR                     01Ch
+#define R_FACTOR                04Dh
+#define G_FACTOR                097h
+#define B_FACTOR                01Ch
 /* --------------------------------------------------------- */
 /* translated from asm code 301def.h */
 /*  */
 /* --------------------------------------------------------- */
-#define		LCDDataLen                   8
-#define		HiTVDataLen                  12
-#define		TVDataLen                    12
-#define		LVDSCRT1Len_H                8
-#define		LVDSCRT1Len_V                7
-#define		LVDSDataLen                  6
-#define		LVDSDesDataLen               6
-#define		LCDDesDataLen                6
-#define		LVDSDesDataLen2              8
-#define		LCDDesDataLen2               8
-#define		CHTVRegLen                   16
-#define		CHLVRegLen                   12
-
-#define		StHiTVHT                     892
-#define		StHiTVVT                     1126
-#define		StHiTextTVHT                 1000
-#define		StHiTextTVVT                 1126
-#define		ExtHiTVHT                    2100
-#define		ExtHiTVVT                    1125
-#define		NTSCHT                       1716
-#define		NTSCVT                        525
-#define		NTSC1024x768HT               1908
-#define		NTSC1024x768VT                525
-#define		PALHT                        1728
-#define		PALVT                         625
-
-#define		YPbPrTV525iHT                1716            /* YPbPr */
-#define		YPbPrTV525iVT                 525
-#define		YPbPrTV525pHT                1716
-#define		YPbPrTV525pVT                 525
-#define		YPbPrTV750pHT                1650
-#define		YPbPrTV750pVT                 750
-
-#define		CRT2VCLKSel                  0xc0
-
-#define		CRT2Delay1      	     0x04            /* XGI301 */
-#define		CRT2Delay2      	     0x0A            /* 301B,302 */
-
-
-#define		VCLK25_175           0x00
-#define		VCLK28_322           0x01
-#define		VCLK31_5             0x02
-#define		VCLK36               0x03
-#define		VCLK40               0x04
-#define		VCLK43_163           0x05
-#define		VCLK44_9             0x06
-#define		VCLK49_5             0x07
-#define		VCLK50               0x08
-#define		VCLK52_406           0x09
-#define		VCLK56_25            0x0A
-#define		VCLK65               0x0B
-#define		VCLK67_765           0x0C
-#define		VCLK68_179           0x0D
-#define		VCLK72_852           0x0E
-#define		VCLK75               0x0F
-#define		VCLK75_8             0x10
-#define		VCLK78_75            0x11
-#define		VCLK79_411           0x12
-#define		VCLK83_95            0x13
-#define		VCLK84_8             0x14
-#define		VCLK86_6             0x15
-#define		VCLK94_5             0x16
-#define		VCLK104_998          0x17
-#define		VCLK105_882          0x18
-#define		VCLK108_2            0x19
-#define		VCLK109_175          0x1A
-#define		VCLK113_309          0x1B
-#define		VCLK116_406          0x1C
-#define		VCLK132_258          0x1D
-#define		VCLK135_5            0x1E
-#define		VCLK139_054          0x1F
-#define		VCLK157_5            0x20
-#define		VCLK162              0x21
-#define		VCLK175              0x22
-#define		VCLK189              0x23
-#define		VCLK194_4            0x24
-#define		VCLK202_5            0x25
-#define		VCLK229_5            0x26
-#define		VCLK234              0x27
-#define		VCLK252_699          0x28
-#define		VCLK254_817          0x29
-#define		VCLK265_728          0x2A
-#define		VCLK266_952          0x2B
-#define		VCLK269_655          0x2C
-#define		VCLK272_042          0x2D
-#define		VCLK277_015          0x2E
-#define		VCLK286_359          0x2F
-#define		VCLK291_132          0x30
-#define		VCLK291_766          0x31
-#define		VCLK309_789          0x32
-#define		VCLK315_195          0x33
-#define		VCLK323_586          0x34
-#define		VCLK330_615          0x35
-#define		VCLK332_177          0x36
-#define		VCLK340_477          0x37
-#define		VCLK375_847          0x38
-#define		VCLK388_631          0x39
-#define		VCLK125_999          0x51
-#define		VCLK148_5            0x52
-#define		VCLK178_992          0x54
-#define		VCLK217_325          0x55
-#define		VCLK299_505          0x56
-#define		YPbPr750pVCLK        0x57
-
-#define		TVVCLKDIV2              0x3A
-#define		TVVCLK                  0x3B
-#define		HiTVVCLKDIV2          0x3C
-#define		HiTVVCLK              0x3D
-#define		HiTVSimuVCLK          0x3E
-#define		HiTVTextVCLK          0x3F
-#define		VCLK39_77              0x40
+#define LCDDataLen           8
+#define HiTVDataLen          12
+#define TVDataLen            12
+#define LVDSCRT1Len_H        8
+#define LVDSCRT1Len_V        7
+#define LVDSDataLen          6
+#define LVDSDesDataLen       6
+#define LCDDesDataLen        6
+#define LVDSDesDataLen2      8
+#define LCDDesDataLen2       8
+#define CHTVRegLen           16
+#define CHLVRegLen           12
+
+#define StHiTVHT             892
+#define StHiTVVT             1126
+#define StHiTextTVHT         1000
+#define StHiTextTVVT         1126
+#define ExtHiTVHT            2100
+#define ExtHiTVVT            1125
+#define NTSCHT               1716
+#define NTSCVT                525
+#define NTSC1024x768HT       1908
+#define NTSC1024x768VT        525
+#define PALHT                1728
+#define PALVT                 625
+
+#define YPbPrTV525iHT        1716 /* YPbPr */
+#define YPbPrTV525iVT         525
+#define YPbPrTV525pHT        1716
+#define YPbPrTV525pVT         525
+#define YPbPrTV750pHT        1650
+#define YPbPrTV750pVT         750
+
+#define CRT2VCLKSel          0xc0
+
+#define CRT2Delay1           0x04 /* XGI301 */
+#define CRT2Delay2           0x0A /* 301B,302 */
+
+
+#define VCLK25_175           0x00
+#define VCLK28_322           0x01
+#define VCLK31_5             0x02
+#define VCLK36               0x03
+#define VCLK40               0x04
+#define VCLK43_163           0x05
+#define VCLK44_9             0x06
+#define VCLK49_5             0x07
+#define VCLK50               0x08
+#define VCLK52_406           0x09
+#define VCLK56_25            0x0A
+#define VCLK65               0x0B
+#define VCLK67_765           0x0C
+#define VCLK68_179           0x0D
+#define VCLK72_852           0x0E
+#define VCLK75               0x0F
+#define VCLK75_8             0x10
+#define VCLK78_75            0x11
+#define VCLK79_411           0x12
+#define VCLK83_95            0x13
+#define VCLK84_8             0x14
+#define VCLK86_6             0x15
+#define VCLK94_5             0x16
+#define VCLK104_998          0x17
+#define VCLK105_882          0x18
+#define VCLK108_2            0x19
+#define VCLK109_175          0x1A
+#define VCLK113_309          0x1B
+#define VCLK116_406          0x1C
+#define VCLK132_258          0x1D
+#define VCLK135_5            0x1E
+#define VCLK139_054          0x1F
+#define VCLK157_5            0x20
+#define VCLK162              0x21
+#define VCLK175              0x22
+#define VCLK189              0x23
+#define VCLK194_4            0x24
+#define VCLK202_5            0x25
+#define VCLK229_5            0x26
+#define VCLK234              0x27
+#define VCLK252_699          0x28
+#define VCLK254_817          0x29
+#define VCLK265_728          0x2A
+#define VCLK266_952          0x2B
+#define VCLK269_655          0x2C
+#define VCLK272_042          0x2D
+#define VCLK277_015          0x2E
+#define VCLK286_359          0x2F
+#define VCLK291_132          0x30
+#define VCLK291_766          0x31
+#define VCLK309_789          0x32
+#define VCLK315_195          0x33
+#define VCLK323_586          0x34
+#define VCLK330_615          0x35
+#define VCLK332_177          0x36
+#define VCLK340_477          0x37
+#define VCLK375_847          0x38
+#define VCLK388_631          0x39
+#define VCLK125_999          0x51
+#define VCLK148_5            0x52
+#define VCLK178_992          0x54
+#define VCLK217_325          0x55
+#define VCLK299_505          0x56
+#define YPbPr750pVCLK        0x57
+
+#define TVVCLKDIV2           0x3A
+#define TVVCLK               0x3B
+#define HiTVVCLKDIV2         0x3C
+#define HiTVVCLK             0x3D
+#define HiTVSimuVCLK         0x3E
+#define HiTVTextVCLK         0x3F
+#define VCLK39_77            0x40
 /* #define YPbPr750pVCLK 0x0F */
-#define		YPbPr525pVCLK           0x3A
+#define YPbPr525pVCLK           0x3A
 /* #define ;;YPbPr525iVCLK 0x3B */
 /* #define ;;YPbPr525iVCLK_2 0x3A */
-#define		NTSC1024VCLK         0x41
-#define		VCLK25_175_41        0x42                  /* ; ScaleLCD */
-#define		VCLK25_175_42        0x43
-#define		VCLK28_322_43        0x44
-#define		VCLK40_44            0x45
-#define		VCLKQVGA_1           0x46                   /* ; QVGA */
-#define		VCLKQVGA_2           0x47
-#define		VCLKQVGA_3           0x48
-#define		VCLK35_2             0x49                    /* ; 800x480 */
-#define		VCLK122_61           0x4A
-#define		VCLK80_350           0x4B
-#define		VCLK107_385          0x4C
-
-#define		CHTVVCLK30_2         0x50                 /* ;;CHTV */
-#define		CHTVVCLK28_1         0x51
-#define		CHTVVCLK43_6         0x52
-#define		CHTVVCLK26_4         0x53
-#define		CHTVVCLK24_6         0x54
-#define		CHTVVCLK47_8         0x55
-#define		CHTVVCLK31_5         0x56
-#define		CHTVVCLK26_2         0x57
-#define		CHTVVCLK39           0x58
-#define		CHTVVCLK36           0x59
-
-#define		CH7007TVVCLK30_2     0x00                 /* [Billy] 2007/05/18 For CH7007 */
-#define		CH7007TVVCLK28_1     0x01
-#define		CH7007TVVCLK43_6     0x02
-#define		CH7007TVVCLK26_4     0x03
-#define		CH7007TVVCLK24_6     0x04
-#define		CH7007TVVCLK47_8     0x05
-#define		CH7007TVVCLK31_5     0x06
-#define		CH7007TVVCLK26_2     0x07
-#define		CH7007TVVCLK39       0x08
-#define		CH7007TVVCLK36       0x09
-
-#define		RES320x200                   0x00
-#define		RES320x240                   0x01
-#define		RES400x300                   0x02
-#define		RES512x384                   0x03
-#define		RES640x400                   0x04
-#define		RES640x480x60                0x05
-#define		RES640x480x72                0x06
-#define		RES640x480x75                0x07
-#define		RES640x480x85                0x08
-#define		RES640x480x100               0x09
-#define		RES640x480x120               0x0A
-#define		RES640x480x160               0x0B
-#define		RES640x480x200               0x0C
-#define		RES800x600x56                0x0D
-#define		RES800x600x60                0x0E
-#define		RES800x600x72                0x0F
-#define		RES800x600x75                0x10
-#define		RES800x600x85                0x11
-#define		RES800x600x100               0x12
-#define		RES800x600x120               0x13
-#define		RES800x600x160               0x14
-#define		RES1024x768x43               0x15
-#define		RES1024x768x60               0x16
-#define		RES1024x768x70               0x17
-#define		RES1024x768x75               0x18
-#define		RES1024x768x85               0x19
-#define		RES1024x768x100              0x1A
-#define		RES1024x768x120              0x1B
-#define		RES1280x1024x43              0x1C
-#define		RES1280x1024x60              0x1D
-#define		RES1280x1024x75              0x1E
-#define		RES1280x1024x85              0x1F
-#define		RES1600x1200x60              0x20
-#define		RES1600x1200x65              0x21
-#define		RES1600x1200x70              0x22
-#define		RES1600x1200x75              0x23
-#define		RES1600x1200x85              0x24
-#define		RES1600x1200x100             0x25
-#define		RES1600x1200x120             0x26
-#define		RES1920x1440x60              0x27
-#define		RES1920x1440x65              0x28
-#define		RES1920x1440x70              0x29
-#define		RES1920x1440x75              0x2A
-#define		RES1920x1440x85              0x2B
-#define		RES1920x1440x100             0x2C
-#define		RES2048x1536x60              0x2D
-#define		RES2048x1536x65              0x2E
-#define		RES2048x1536x70              0x2F
-#define		RES2048x1536x75              0x30
-#define		RES2048x1536x85              0x31
-#define		RES800x480x60                0x32
-#define		RES800x480x75                0x33
-#define		RES800x480x85                0x34
-#define		RES1024x576x60               0x35
-#define		RES1024x576x75               0x36
-#define		RES1024x576x85               0x37
-#define		RES1280x720x60               0x38
-#define		RES1280x720x75               0x39
-#define		RES1280x720x85               0x3A
-#define		RES1280x960x60               0x3B
-#define		RES720x480x60                0x3C
-#define		RES720x576x56                0x3D
-#define		RES856x480x79I               0x3E
-#define		RES856x480x60                0x3F
-#define		RES1280x768x60               0x40
-#define		RES1400x1050x60              0x41
-#define		RES1152x864x60               0x42
-#define		RES1152x864x75               0x43
-#define		RES1024x768x160              0x44
-#define		RES1280x960x75               0x45
-#define		RES1280x960x85               0x46
-#define		RES1280x960x120              0x47
-
-#define 	LFBDRAMTrap                  0x30
+#define NTSC1024VCLK         0x41
+#define VCLK25_175_41        0x42 /* ; ScaleLCD */
+#define VCLK25_175_42        0x43
+#define VCLK28_322_43        0x44
+#define VCLK40_44            0x45
+#define VCLKQVGA_1           0x46 /* ; QVGA */
+#define VCLKQVGA_2           0x47
+#define VCLKQVGA_3           0x48
+#define VCLK35_2             0x49 /* ; 800x480 */
+#define VCLK122_61           0x4A
+#define VCLK80_350           0x4B
+#define VCLK107_385          0x4C
+
+#define CHTVVCLK30_2         0x50 /* ;;CHTV */
+#define CHTVVCLK28_1         0x51
+#define CHTVVCLK43_6         0x52
+#define CHTVVCLK26_4         0x53
+#define CHTVVCLK24_6         0x54
+#define CHTVVCLK47_8         0x55
+#define CHTVVCLK31_5         0x56
+#define CHTVVCLK26_2         0x57
+#define CHTVVCLK39           0x58
+#define CHTVVCLK36           0x59
+
+#define CH7007TVVCLK30_2     0x00 /* [Billy] 2007/05/18 For CH7007 */
+#define CH7007TVVCLK28_1     0x01
+#define CH7007TVVCLK43_6     0x02
+#define CH7007TVVCLK26_4     0x03
+#define CH7007TVVCLK24_6     0x04
+#define CH7007TVVCLK47_8     0x05
+#define CH7007TVVCLK31_5     0x06
+#define CH7007TVVCLK26_2     0x07
+#define CH7007TVVCLK39       0x08
+#define CH7007TVVCLK36       0x09
+
+#define RES320x200           0x00
+#define RES320x240           0x01
+#define RES400x300           0x02
+#define RES512x384           0x03
+#define RES640x400           0x04
+#define RES640x480x60        0x05
+#define RES640x480x72        0x06
+#define RES640x480x75        0x07
+#define RES640x480x85        0x08
+#define RES640x480x100       0x09
+#define RES640x480x120       0x0A
+#define RES640x480x160       0x0B
+#define RES640x480x200       0x0C
+#define RES800x600x56        0x0D
+#define RES800x600x60        0x0E
+#define RES800x600x72        0x0F
+#define RES800x600x75        0x10
+#define RES800x600x85        0x11
+#define RES800x600x100       0x12
+#define RES800x600x120       0x13
+#define RES800x600x160       0x14
+#define RES1024x768x43       0x15
+#define RES1024x768x60       0x16
+#define RES1024x768x70       0x17
+#define RES1024x768x75       0x18
+#define RES1024x768x85       0x19
+#define RES1024x768x100      0x1A
+#define RES1024x768x120      0x1B
+#define RES1280x1024x43      0x1C
+#define RES1280x1024x60      0x1D
+#define RES1280x1024x75      0x1E
+#define RES1280x1024x85      0x1F
+#define RES1600x1200x60      0x20
+#define RES1600x1200x65      0x21
+#define RES1600x1200x70      0x22
+#define RES1600x1200x75      0x23
+#define RES1600x1200x85      0x24
+#define RES1600x1200x100     0x25
+#define RES1600x1200x120     0x26
+#define RES1920x1440x60      0x27
+#define RES1920x1440x65      0x28
+#define RES1920x1440x70      0x29
+#define RES1920x1440x75      0x2A
+#define RES1920x1440x85      0x2B
+#define RES1920x1440x100     0x2C
+#define RES2048x1536x60      0x2D
+#define RES2048x1536x65      0x2E
+#define RES2048x1536x70      0x2F
+#define RES2048x1536x75      0x30
+#define RES2048x1536x85      0x31
+#define RES800x480x60        0x32
+#define RES800x480x75        0x33
+#define RES800x480x85        0x34
+#define RES1024x576x60       0x35
+#define RES1024x576x75       0x36
+#define RES1024x576x85       0x37
+#define RES1280x720x60       0x38
+#define RES1280x720x75       0x39
+#define RES1280x720x85       0x3A
+#define RES1280x960x60       0x3B
+#define RES720x480x60        0x3C
+#define RES720x576x56        0x3D
+#define RES856x480x79I       0x3E
+#define RES856x480x60        0x3F
+#define RES1280x768x60       0x40
+#define RES1400x1050x60      0x41
+#define RES1152x864x60       0x42
+#define RES1152x864x75       0x43
+#define RES1024x768x160      0x44
+#define RES1280x960x75       0x45
+#define RES1280x960x85       0x46
+#define RES1280x960x120      0x47
+
+#define LFBDRAMTrap          0x30
 #endif
-- 
1.7.1

