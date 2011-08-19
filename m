Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1HSTlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:41:42 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:55649 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab1HSTkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:40:32 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] staging: xgifb: delete unused structs
Date: Fri, 19 Aug 2011 22:40:24 +0300
Message-Id: <1313782830-31461-7-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused struct declarations.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_ext.h    |   20 -----------
 drivers/staging/xgifb/vb_struct.h |   64 -------------------------------------
 drivers/staging/xgifb/vgatypes.h  |    5 ---
 3 files changed, 0 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.h b/drivers/staging/xgifb/vb_ext.h
index 814a446..0b1f55b 100644
--- a/drivers/staging/xgifb/vb_ext.h
+++ b/drivers/staging/xgifb/vb_ext.h
@@ -1,26 +1,6 @@
 #ifndef _VBEXT_
 #define _VBEXT_
 
-struct DWORDREGS {
-	unsigned long Eax, Ebx, Ecx, Edx, Esi, Edi, Ebp;
-};
-
-struct WORDREGS {
-	unsigned short  ax, hi_ax, bx, hi_bx, cx, hi_cx, dx, hi_dx, si,
-			hi_si, di, hi_di, bp, hi_bp;
-};
-
-struct BYTEREGS {
-	unsigned char   al, ah, hi_al, hi_ah, bl, bh, hi_bl, hi_bh, cl, ch,
-			hi_cl, hi_ch, dl, dh, hi_dl, hi_dh;
-};
-
-typedef union _X86_REGS {
-	struct  DWORDREGS e;
-	struct  WORDREGS x;
-	struct  BYTEREGS h;
-} X86_REGS, *PX86_REGS;
-
 extern void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
 			       struct vb_device_info *pVBInfo);
 extern unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *,
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index c40d9d8..3ef79e0 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -1,10 +1,6 @@
 #ifndef _VB_STRUCT_
 #define _VB_STRUCT_
 
-struct XGI_PanelDelayTblStruct {
-	unsigned char timer[2];
-};
-
 struct XGI_LCDDataStruct {
 	unsigned short RVBHCMAX;
 	unsigned short RVBHCFACT;
@@ -39,24 +35,6 @@ struct XGI_TVDataStruct {
 	unsigned char RY4COE;
 };
 
-struct XGI_LVDSDataStruct {
-	unsigned short VGAHT;
-	unsigned short VGAVT;
-	unsigned short LCDHT;
-	unsigned short LCDVT;
-};
-
-struct XGI_LVDSDesStruct {
-	unsigned short LCDHDES;
-	unsigned short LCDVDES;
-};
-
-struct XGI_LVDSCRT1DataStruct {
-	unsigned char CR[15];
-};
-
-/*add for LCDA*/
-
 struct XGI_StStruct {
 	unsigned char St_ModeID;
 	unsigned short St_ModeFlag;
@@ -140,10 +118,6 @@ struct XGI_ModeResInfoStruct {
 	unsigned char  YChar;
 };
 
-struct XGI_LCDNBDesStruct {
-	unsigned char NB[12];
-};
-
 /*add for new UNIVGABIOS*/
 struct XGI_LCDDesStruct {
 	unsigned short LCDHDES;
@@ -159,12 +133,6 @@ struct XGI_LCDDataTablStruct {
 	unsigned short DATAPTR;
 };
 
-struct XGI_TVTablDataStruct {
-	unsigned short MASK;
-	unsigned short CAP;
-	unsigned short DATAPTR;
-};
-
 struct XGI330_LCDDataDesStruct {
 	unsigned short LCDHDES;
 	unsigned short LCDHRS;
@@ -252,10 +220,6 @@ struct XGI_XG21CRT1Struct {
 	unsigned char ModeID, CR02, CR03, CR15, CR16;
 };
 
-struct XGI330_CHTVRegDataStruct {
-	unsigned char Reg[16];
-};
-
 struct XGI330_LCDCapStruct {
 	unsigned char	LCD_ID;
 	unsigned short	LCD_Capability;
@@ -318,18 +282,6 @@ struct XGI301C_Tap4TimingStruct {
 	unsigned char  Reg[64];   /* C0-FF */
 };
 
-struct XGI_New_StandTableStruct {
-	unsigned char  CRT_COLS;
-	unsigned char  ROWS;
-	unsigned char  CHAR_HEIGHT;
-	unsigned short CRT_LEN;
-	unsigned char  SR[4];
-	unsigned char  MISC;
-	unsigned char  CRTC[0x19];
-	unsigned char  ATTR[0x14];
-	unsigned char  GRC[9];
-};
-
 struct vb_device_info {
 	unsigned char  ISXPDOS;
 	unsigned long   P3c4, P3d4, P3c0, P3ce, P3c2, P3cc;
@@ -456,20 +408,4 @@ struct vb_device_info {
 	struct XGI_XG21CRT1Struct	  *UpdateCRT1;
 };  /* _struct vb_device_info */
 
-
-struct TimingInfo {
-	unsigned short Horizontal_ACTIVE;
-	unsigned short Horizontal_FP;
-	unsigned short Horizontal_SYNC;
-	unsigned short Horizontal_BP;
-	unsigned short Vertical_ACTIVE;
-	unsigned short Vertical_FP;
-	unsigned short Vertical_SYNC;
-	unsigned short Vertical_BP;
-	double	       DCLK;
-	unsigned char  FrameRate;
-	unsigned char  Interlace;
-	unsigned short Margin;
-};
-
 #endif /* _VB_STRUCT_ */
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 5aeb3a4..7f911f1 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -47,11 +47,6 @@ enum XGI_LCD_TYPE {
 };
 #endif
 
-struct XGI_DSReg {
-	unsigned char jIdx;
-	unsigned char jVal;
-};
-
 struct xgi_hw_device_info {
 	unsigned long ulExternalChip; /* NO VB or other video bridge*/
 				      /* if ujVBChipID = VB_CHIP_UNKNOWN, */
-- 
1.7.2.5

