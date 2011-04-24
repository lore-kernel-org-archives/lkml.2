Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1DXF4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 01:56:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36924 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1DXF4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 01:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rASYFDV2rTTinHEgZsPDAUL8JqagmLMEVe6t8QA3YX7tECvh0+/8560w5kv5RgDOPI
         w4V6XIR2dSrWIJh8+Ux2R0hp/D/3bBjVfFncR1Z1jEPC0/8T4SuJE/ZWygv748H2Rgfz
         g8ndTfzijNIqsageXe5gKRpE2MyUPcfT7kgJ8=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de, aaro.koskinen@iki.fi, wfp5p@virginia.edu,
        apatard@mandriva.com, martinze.javier@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 10/10] Staging: xgifb: Fixed styles issues.
Date: Sun, 24 Apr 2011 13:55:49 +0800
Message-Id: <1303624549-2761-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the warnings about styles have been removed.

Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/xgifb/XGIfb.h |  142 ++++++++++++++++++++--------------------
 1 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/xgifb/XGIfb.h b/drivers/staging/xgifb/XGIfb.h
index b43a758..45b6015 100644
--- a/drivers/staging/xgifb/XGIfb.h
+++ b/drivers/staging/xgifb/XGIfb.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_XGIFB
 #define _LINUX_XGIFB
-#include <asm/ioctl.h>
-#include <asm/types.h>
+#include <linux/ioctl.h>
+#include <linux/types.h>
 
 #define DISPTYPE_CRT1       0x00000008L
 #define DISPTYPE_CRT2       0x00000004L
@@ -13,99 +13,99 @@
 #define DISPMODE_MIRROR	    0x00000010L
 #define DISPMODE_DUALVIEW   0x00000040L
 
-#define HASVB_NONE      	0x00
-#define HASVB_301       	0x01
-#define HASVB_LVDS      	0x02
-#define HASVB_TRUMPION  	0x04
-#define HASVB_LVDS_CHRONTEL	0x10
-#define HASVB_302       	0x20
-#define HASVB_303       	0x40
-#define HASVB_CHRONTEL  	0x80
+#define HASVB_NONE	    0x00
+#define HASVB_301	    0x01
+#define HASVB_LVDS	    0x02
+#define HASVB_TRUMPION	    0x04
+#define HASVB_LVDS_CHRONTEL 0x10
+#define HASVB_302	    0x20
+#define HASVB_303	    0x40
+#define HASVB_CHRONTEL	    0x80
 
 #ifndef XGIFB_ID
-#define XGIFB_ID          0x53495346    /* Identify myself with 'XGIF' */
+#define XGIFB_ID	0x53495346 /* Identify myself with 'XGIF' */
 #endif
 
 enum XGI_CHIP_TYPE {
-    XG40 = 32,
-    XG41,
-    XG42,
-    XG45,
-    XG20 = 48,
-    XG21,
-    XG27,
+	XG40 = 32,
+	XG41,
+	XG42,
+	XG45,
+	XG20 = 48,
+	XG21,
+	XG27,
 };
 
 enum xgi_tvtype {
 	TVMODE_NTSC = 0,
 	TVMODE_PAL,
 	TVMODE_HIVISION,
-	TVTYPE_PALM,	// vicki@030226
-    	TVTYPE_PALN,	// vicki@030226
-    	TVTYPE_NTSCJ,	// vicki@030226
+	TVTYPE_PALM,	/* vicki@030226 */
+	TVTYPE_PALN,	/* vicki@030226 */
+	TVTYPE_NTSCJ,	/* vicki@030226 */
 	TVMODE_TOTAL
 };
 
-enum xgi_tv_plug {	/* vicki@030226 */
-//	TVPLUG_Legacy = 0,
-//	TVPLUG_COMPOSITE,
-//	TVPLUG_SVIDEO,
-//	TVPLUG_SCART,
-//	TVPLUG_TOTAL
-    	TVPLUG_UNKNOWN = 0,
-    	TVPLUG_COMPOSITE = 1,
-    	TVPLUG_SVIDEO = 2,
-    	TVPLUG_COMPOSITE_AND_SVIDEO = 3,
-    	TVPLUG_SCART = 4,
-    	TVPLUG_YPBPR_525i = 5,
-    	TVPLUG_YPBPR_525P = 6,
-    	TVPLUG_YPBPR_750P = 7,
-    	TVPLUG_YPBPR_1080i = 8,
+enum xgi_tv_plug { /* vicki@030226 */
+/*	TVPLUG_Legacy = 0, */
+/*	TVPLUG_COMPOSITE,  */
+/*	TVPLUG_SVIDEO,	   */
+/*	TVPLUG_SCART,	   */
+/*	TVPLUG_TOTAL	   */
+	TVPLUG_UNKNOWN = 0,
+	TVPLUG_COMPOSITE = 1,
+	TVPLUG_SVIDEO = 2,
+	TVPLUG_COMPOSITE_AND_SVIDEO = 3,
+	TVPLUG_SCART = 4,
+	TVPLUG_YPBPR_525i = 5,
+	TVPLUG_YPBPR_525P = 6,
+	TVPLUG_YPBPR_750P = 7,
+	TVPLUG_YPBPR_1080i = 8,
 	TVPLUG_TOTAL
 };
 
-struct video_info{
-        int           chip_id;
-        unsigned int  video_size;
-        unsigned long video_base;
-        char  *       video_vbase;
-        unsigned long mmio_base;
+struct video_info {
+	int           chip_id;
+	unsigned int  video_size;
+	unsigned long video_base;
+	char	      *video_vbase;
+	unsigned long mmio_base;
 	unsigned long mmio_size;
-        char  *       mmio_vbase;
-        unsigned long vga_base;
-        unsigned long mtrr;
-
-        int    video_bpp;
-        int    video_cmap_len;
-        int    video_width;
-        int    video_height;
-        int    video_vwidth;
-        int    video_vheight;
-        int    org_x;
-        int    org_y;
-        int    video_linelength;
-        unsigned int refresh_rate;
-
-        unsigned long disp_state;
-        unsigned char hasVB;
-        unsigned char TV_type;
-        unsigned char TV_plug;
+	char	      *mmio_vbase;
+	unsigned long vga_base;
+	unsigned long mtrr;
+
+	int    video_bpp;
+	int    video_cmap_len;
+	int    video_width;
+	int    video_height;
+	int    video_vwidth;
+	int    video_vheight;
+	int    org_x;
+	int    org_y;
+	int    video_linelength;
+	unsigned int refresh_rate;
+
+	unsigned long disp_state;
+	unsigned char hasVB;
+	unsigned char TV_type;
+	unsigned char TV_plug;
 
 	enum XGI_CHIP_TYPE chip;
-        unsigned char revision_id;
+	unsigned char revision_id;
 
-        unsigned short DstColor;
-        unsigned long  XGI310_AccelDepth;
-        unsigned long  CommandReg;
+	unsigned short DstColor;
+	unsigned long  XGI310_AccelDepth;
+	unsigned long  CommandReg;
 
-        unsigned int   pcibus;
-        unsigned int   pcislot;
-        unsigned int   pcifunc;
+	unsigned int   pcibus;
+	unsigned int   pcislot;
+	unsigned int   pcifunc;
 
-        unsigned short subsysvendor;
-        unsigned short subsysdevice;
+	unsigned short subsysvendor;
+	unsigned short subsysdevice;
 
-        char reserved[236];
+	char reserved[236];
 };
 
 
-- 
1.7.1

