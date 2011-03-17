Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab1CQEX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 00:23:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43388 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1CQEXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 00:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TB+RATA7NZkORa/RaKCM7kbxH+kOa5qdJM9BtXutCTWaYX/wutc8hAjyBS2ijryYxF
         g0W8ee8JinGnWOhhONKgfgNYtzhnC/Hpf0WsjblwSlx9OSTJewXFXAOaqpqIFrv4Fg/B
         yhgjNLMggC8ztB7PjNYq8yfSE7GFX8KHucvJI=
From: Darek Iwanski <darekiwanski13@gmail.com>
To: gregkh@suse.de, apatard@mandriva.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Darek Iwanski <darekiwanski13@gmail.com>
Subject: [PATCH] Staging: xgifb: fixed spaces coding style issue in vb_ext.h
Date: Thu, 17 Mar 2011 00:23:04 -0400
Message-Id: <1300335784-23495-1-git-send-email-darekiwanski13@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the vb_ext.h file that fixes up spaces warning
found by the checkpatch.pl tool. It still has a typedef warning that I
do not understand how to fix.

Signed-off-by: Darek Iwanski <darekiwanski13$Gmail.com>
---
 drivers/staging/xgifb/vb_ext.h |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.h b/drivers/staging/xgifb/vb_ext.h
index 5cc4d12..a3ec4ee 100644
--- a/drivers/staging/xgifb/vb_ext.h
+++ b/drivers/staging/xgifb/vb_ext.h
@@ -1,34 +1,37 @@
-#ifndef  _VBEXT_
-#define  _VBEXT_
+#ifndef _VBEXT_
+#define _VBEXT_
 
 struct DWORDREGS {
-    unsigned long    Eax, Ebx, Ecx, Edx, Esi, Edi, Ebp;
+	unsigned long Eax, Ebx, Ecx, Edx, Esi, Edi, Ebp;
 };
 
 struct WORDREGS {
-    unsigned short ax, hi_ax, bx, hi_bx, cx, hi_cx, dx, hi_dx, si,
-	    hi_si, di, hi_di, bp, hi_bp;
+	unsigned short ax, hi_ax, bx, hi_bx, cx, hi_cx, dx, hi_dx, si,
+		hi_si, di, hi_di, bp, hi_bp;
 };
 
 struct BYTEREGS {
-     unsigned char al, ah, hi_al, hi_ah, bl, bh, hi_bl, hi_bh, cl, ch,
-	     hi_cl, hi_ch, dl, dh, hi_dl, hi_dh;
+	unsigned char al, ah, hi_al, hi_ah, bl, bh, hi_bl, hi_bh, cl, ch,
+		hi_cl, hi_ch, dl, dh, hi_dl, hi_dh;
 };
 
-typedef union   _X86_REGS    {
-    struct  DWORDREGS e;
-    struct  WORDREGS x;
-    struct  BYTEREGS h;
+typedef union _X86_REGS {
+	struct DWORDREGS e;
+	struct WORDREGS x;
+	struct BYTEREGS h;
 } X86_REGS, *PX86_REGS;
 
-extern   void     XGI_XG21Fun14(struct xgi_hw_device_info *pXGIHWDE, PX86_REGS pBiosArguments);
+extern void XGI_XG21Fun14(struct xgi_hw_device_info *pXGIHWDE,
+	PX86_REGS pBiosArguments);
 extern void XGISetDPMS(struct xgi_hw_device_info *pXGIHWDE,
-		       unsigned long VESA_POWER_STATE);
-extern   void     XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-extern   void     XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
+	unsigned long VESA_POWER_STATE);
+extern void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
+	struct vb_device_info *pVBInfo);
+extern void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
+	struct vb_device_info *pVBInfo) ;
 extern void ReadVBIOSTablData(unsigned char ChipType,
-			      struct vb_device_info *pVBInfo);
+	struct vb_device_info *pVBInfo);
 extern unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *,
-				      struct vb_device_info *pVBInfo);
+	struct vb_device_info *pVBInfo);
 
 #endif
-- 
1.7.4.1

