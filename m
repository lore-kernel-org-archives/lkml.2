Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1DXFqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 01:46:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54778 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1DXFqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 01:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=d6VI8YIb34qg6jQZLahNpG3gulIYgbz/r8Dp55OfS+ofbhbXqGDi/fww5bxnG/PBK9
         pURGqKPERhmXvuTKeSR7adT7yJCt8qnYPdbdJhX9X1VbqMaNdhjUSdNJRlUJESvLZIGc
         BTsMxOa+weHzZsFMBtVi4uvFWXZqN2Gk/zXwY=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, aaro.koskinen@iki.fi
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 9/9] Staging: xgifb: Fixed style issues.
Date: Sun, 24 Apr 2011 13:46:25 +0800
Message-Id: <1303623985-2657-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now checkpatch.pl doesn't complain about vgatypes.h.

Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/xgifb/vgatypes.h |  113 ++++++++++++++++++-------------------
 1 files changed, 55 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index d613e84..5aeb3a4 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -1,4 +1,3 @@
-
 #ifndef _VGATYPES_
 #define _VGATYPES_
 
@@ -6,79 +5,79 @@
 
 #ifndef XGI_VB_CHIP_TYPE
 enum XGI_VB_CHIP_TYPE {
-    VB_CHIP_Legacy = 0,
-    VB_CHIP_301,
-    VB_CHIP_301B,
-    VB_CHIP_301LV,
-    VB_CHIP_302,
-    VB_CHIP_302B,
-    VB_CHIP_302LV,
-    VB_CHIP_301C,
-    VB_CHIP_302ELV,
-    VB_CHIP_UNKNOWN, /* other video bridge or no video bridge */
-    MAX_VB_CHIP
+	VB_CHIP_Legacy = 0,
+	VB_CHIP_301,
+	VB_CHIP_301B,
+	VB_CHIP_301LV,
+	VB_CHIP_302,
+	VB_CHIP_302B,
+	VB_CHIP_302LV,
+	VB_CHIP_301C,
+	VB_CHIP_302ELV,
+	VB_CHIP_UNKNOWN, /* other video bridge or no video bridge */
+	MAX_VB_CHIP
 };
 #endif
 
 #ifndef XGI_LCD_TYPE
 enum XGI_LCD_TYPE {
-    LCD_INVALID = 0,
-    LCD_320x480,       /* FSTN, DSTN */
-    LCD_640x480,
-    LCD_640x480_2,     /* FSTN, DSTN */
-    LCD_640x480_3,     /* FSTN, DSTN */
-    LCD_800x600,
-    LCD_848x480,
-    LCD_1024x600,
-    LCD_1024x768,
-    LCD_1152x768,
-    LCD_1152x864,
-    LCD_1280x720,
-    LCD_1280x768,
-    LCD_1280x800,
-    LCD_1280x960,
-    LCD_1280x1024,
-    LCD_1400x1050,
-    LCD_1600x1200,
-    LCD_1680x1050,
-    LCD_1920x1440,
-    LCD_2048x1536,
-    LCD_CUSTOM,
-    LCD_UNKNOWN
+	LCD_INVALID = 0,
+	LCD_320x480,       /* FSTN, DSTN */
+	LCD_640x480,
+	LCD_640x480_2,     /* FSTN, DSTN */
+	LCD_640x480_3,     /* FSTN, DSTN */
+	LCD_800x600,
+	LCD_848x480,
+	LCD_1024x600,
+	LCD_1024x768,
+	LCD_1152x768,
+	LCD_1152x864,
+	LCD_1280x720,
+	LCD_1280x768,
+	LCD_1280x800,
+	LCD_1280x960,
+	LCD_1280x1024,
+	LCD_1400x1050,
+	LCD_1600x1200,
+	LCD_1680x1050,
+	LCD_1920x1440,
+	LCD_2048x1536,
+	LCD_CUSTOM,
+	LCD_UNKNOWN
 };
 #endif
 
-struct XGI_DSReg
-{
-  unsigned char  jIdx;
-  unsigned char  jVal;
+struct XGI_DSReg {
+	unsigned char jIdx;
+	unsigned char jVal;
 };
 
-struct xgi_hw_device_info
-{
-    unsigned long  ulExternalChip;       /* NO VB or other video bridge*/
-                                 /* if ujVBChipID = VB_CHIP_UNKNOWN, */
+struct xgi_hw_device_info {
+	unsigned long ulExternalChip; /* NO VB or other video bridge*/
+				      /* if ujVBChipID = VB_CHIP_UNKNOWN, */
 
-    unsigned char *pjVirtualRomBase;    /* ROM image */
+	unsigned char *pjVirtualRomBase; /* ROM image */
 
-    unsigned char *pjVideoMemoryAddress;/* base virtual memory address */
-                                 /* of Linear VGA memory */
+	unsigned char *pjVideoMemoryAddress;/* base virtual memory address */
+					    /* of Linear VGA memory */
 
-    unsigned long  ulVideoMemorySize;    /* size, in bytes, of the memory on the board */
+	unsigned long ulVideoMemorySize; /* size, in bytes, of the
+					    memory on the board */
 
-    unsigned char *pjIOAddress;          /* base I/O address of VGA ports (0x3B0) */
+	unsigned char *pjIOAddress; /* base I/O address of VGA ports (0x3B0) */
 
-    unsigned char  jChipType;            /* Used to Identify Graphics Chip */
-                                 /* defined in the data structure type  */
-                                 /* "XGI_CHIP_TYPE" */
+	unsigned char jChipType; /* Used to Identify Graphics Chip */
+				 /* defined in the data structure type  */
+				 /* "XGI_CHIP_TYPE" */
 
-    unsigned char  jChipRevision;        /* Used to Identify Graphics Chip Revision */
+	unsigned char jChipRevision; /* Used to Identify Graphics
+					Chip Revision */
 
-    unsigned char  ujVBChipID;           /* the ID of video bridge */
-                                 /* defined in the data structure type */
-                                 /* "XGI_VB_CHIP_TYPE" */
+	unsigned char ujVBChipID; /* the ID of video bridge */
+				  /* defined in the data structure type */
+				  /* "XGI_VB_CHIP_TYPE" */
 
-    unsigned long  ulCRT2LCDType;        /* defined in the data structure type */
+	unsigned long ulCRT2LCDType; /* defined in the data structure type */
 
 	unsigned char(*pQueryVGAConfigSpace)(struct xgi_hw_device_info *,
 					    unsigned long, unsigned long,
@@ -87,7 +86,5 @@ struct xgi_hw_device_info
 
 /* Additional IOCTL for communication xgifb <> X driver        */
 /* If changing this, xgifb.h must also be changed (for xgifb) */
-
-
 #endif
 
-- 
1.7.1

