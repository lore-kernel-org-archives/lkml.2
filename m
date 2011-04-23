Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1DWIPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 04:15:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42642 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1DWIPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 04:15:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ojyoB1ICf2xXAQELUf/321qeOJqzPniGX/qqh/dkOEp49dUm2Miy71+kmR+qdOcCNU
         0OT/UkeAQl4yzbgy+/TBg4Km4WAk9ztwJECYyq0sCwlk8jSkaZi9fvAb+RvqQ6d0g3Hn
         wR2iMf+E8ZLK39EoM246lADBscefjX0riMV3Y=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, aaro.koskinen@iki.fi,
        apatard@mandriva.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 4/4] Staging: xgifb: Fixed coding style issues.
Date: Sat, 23 Apr 2011 16:14:34 +0800
Message-Id: <1303546474-32749-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the warnings in vb_setmode.h given by checkpatch.pl were removed.

Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/xgifb/vb_setmode.h |   97 ++++++++++++++++++++++++------------
 1 files changed, 65 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.h b/drivers/staging/xgifb/vb_setmode.h
index 7a2e564..1bd8667 100644
--- a/drivers/staging/xgifb/vb_setmode.h
+++ b/drivers/staging/xgifb/vb_setmode.h
@@ -1,38 +1,71 @@
-#ifndef  _VBSETMODE_
-#define  _VBSETMODE_
+#ifndef _VBSETMODE_
+#define _VBSETMODE_
 
-extern   void     InitTo330Pointer(unsigned char, struct vb_device_info *);
-extern   void     XGI_UnLockCRT2(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-extern   void     XGI_LockCRT2(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-extern   void     XGI_LongWait(struct vb_device_info *);
-extern   void     XGI_SetCRT2ModeRegs(unsigned short ModeNo,
-				      struct xgi_hw_device_info *,
-				      struct vb_device_info *);
-extern   void     XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-extern   void     XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-extern   void     XGI_DisplayOff(struct xgi_hw_device_info *, struct vb_device_info *);
-extern   void     XGI_DisplayOn(struct xgi_hw_device_info *, struct vb_device_info *);
-extern   void     XGI_GetVBType(struct vb_device_info *);
-extern   void     XGI_SenseCRT1(struct vb_device_info *);
-extern   void     XGI_GetVGAType(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-extern   void     XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-extern   void     XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *);
-extern   unsigned short   XGI_GetResInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+extern void InitTo330Pointer(unsigned char, struct vb_device_info *);
+extern void XGI_UnLockCRT2(struct xgi_hw_device_info *HwDeviceExtension,
+			   struct vb_device_info *);
+extern void XGI_LockCRT2(struct xgi_hw_device_info *HwDeviceExtension,
+			 struct vb_device_info *);
+extern void XGI_LongWait(struct vb_device_info *);
+extern void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
+				struct xgi_hw_device_info *,
+				struct vb_device_info *);
+extern void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
+			      struct vb_device_info *);
+extern void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
+			     struct vb_device_info *);
+extern void XGI_DisplayOff(struct xgi_hw_device_info *,
+			   struct vb_device_info *);
+extern void XGI_DisplayOn(struct xgi_hw_device_info *,
+			  struct vb_device_info *);
+extern void XGI_GetVBType(struct vb_device_info *);
+extern void XGI_SenseCRT1(struct vb_device_info *);
+extern void XGI_GetVGAType(struct xgi_hw_device_info *HwDeviceExtension,
+			   struct vb_device_info *);
+extern void XGI_GetVBInfo(unsigned short ModeNo,
+			  unsigned short ModeIdIndex,
+			  struct xgi_hw_device_info *HwDeviceExtension,
+			  struct vb_device_info *);
+extern void XGI_GetTVInfo(unsigned short ModeNo,
+			  unsigned short ModeIdIndex,
+			  struct vb_device_info *);
+extern unsigned short XGI_GetResInfo(unsigned short ModeNo,
+				     unsigned short ModeIdIndex,
+				     struct vb_device_info *pVBInfo);
+
+extern unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
+				   unsigned short ModeNo) ;
 
-extern   unsigned char  XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo) ;
+extern unsigned char XGI_SearchModeID(unsigned short ModeNo,
+				      unsigned short *ModeIdIndex,
+				      struct vb_device_info *);
+extern unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
+				    unsigned short ModeIdIndex,
+				    struct vb_device_info *);
+extern unsigned char XGI_BridgeIsOn(struct vb_device_info *);
 
-extern   unsigned char  XGI_SearchModeID(unsigned short ModeNo, unsigned short  *ModeIdIndex, struct vb_device_info *);
-extern   unsigned char  XGI_GetLCDInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *);
-extern   unsigned char  XGI_BridgeIsOn(struct vb_device_info *);
-extern   unsigned char  XGI_SetCRT2Group301(unsigned short ModeNo, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-extern   unsigned short   XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE, unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *);
+extern unsigned char
+XGI_SetCRT2Group301(unsigned short ModeNo,
+		    struct xgi_hw_device_info *HwDeviceExtension,
+		    struct vb_device_info *);
+extern unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
+					 unsigned short ModeNo,
+					 unsigned short ModeIdIndex,
+					 struct vb_device_info *);
 
-extern   void     XGI_SetXG21FPBits(struct vb_device_info *pVBInfo);
-extern   void     XGI_SetXG27FPBits(struct vb_device_info *pVBInfo);
-extern   void     XGI_XG21BLSignalVDD(unsigned short tempbh, unsigned short tempbl, struct vb_device_info *pVBInfo);
-extern   void     XGI_XG27BLSignalVDD(unsigned short tempbh, unsigned short tempbl, struct vb_device_info *pVBInfo);
-extern   void     XGI_XG21SetPanelDelay(unsigned short tempbl, struct vb_device_info *pVBInfo);
-extern   unsigned char  XGI_XG21CheckLVDSMode(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-extern   unsigned short XGI_GetLVDSOEMTableIndex(struct vb_device_info *pVBInfo);
+extern void XGI_SetXG21FPBits(struct vb_device_info *pVBInfo);
+extern void XGI_SetXG27FPBits(struct vb_device_info *pVBInfo);
+extern void XGI_XG21BLSignalVDD(unsigned short tempbh,
+				unsigned short tempbl,
+				struct vb_device_info *pVBInfo);
+extern void XGI_XG27BLSignalVDD(unsigned short tempbh,
+				unsigned short tempbl,
+				struct vb_device_info *pVBInfo);
+extern void XGI_XG21SetPanelDelay(unsigned short tempbl,
+				  struct vb_device_info *pVBInfo);
+extern unsigned char XGI_XG21CheckLVDSMode(unsigned short ModeNo,
+					   unsigned short ModeIdIndex,
+					   struct vb_device_info *pVBInfo);
+extern unsigned short XGI_GetLVDSOEMTableIndex(struct vb_device_info *pVBInfo);
 
 #endif
-- 
1.7.1

