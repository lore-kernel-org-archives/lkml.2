Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1DRTO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:14:57 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48315 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab1DRTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:14:09 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 03/12] staging: xgifb: replace outXGIIDXREG() with xgifb_reg_set()
Date: Mon, 18 Apr 2011 22:13:59 +0300
Message-Id: <1303154048-21989-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace outXGIIDXREG() with xgifb_reg_set().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |  162 +++++++++++++++++-----------------
 1 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index fc7a042..d45d5aa 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -69,36 +69,36 @@ static void dumpVGAReg(void)
 {
 	u8 i, reg;
 
-	outXGIIDXREG(XGISR, 0x05, 0x86);
+	xgifb_reg_set(XGISR, 0x05, 0x86);
 	/*
-	outXGIIDXREG(XGISR, 0x08, 0x4f);
-	outXGIIDXREG(XGISR, 0x0f, 0x20);
-	outXGIIDXREG(XGISR, 0x11, 0x4f);
-	outXGIIDXREG(XGISR, 0x13, 0x45);
-	outXGIIDXREG(XGISR, 0x14, 0x51);
-	outXGIIDXREG(XGISR, 0x1e, 0x41);
-	outXGIIDXREG(XGISR, 0x1f, 0x0);
-	outXGIIDXREG(XGISR, 0x20, 0xa1);
-	outXGIIDXREG(XGISR, 0x22, 0xfb);
-	outXGIIDXREG(XGISR, 0x26, 0x22);
-	outXGIIDXREG(XGISR, 0x3e, 0x07);
+	xgifb_reg_set(XGISR, 0x08, 0x4f);
+	xgifb_reg_set(XGISR, 0x0f, 0x20);
+	xgifb_reg_set(XGISR, 0x11, 0x4f);
+	xgifb_reg_set(XGISR, 0x13, 0x45);
+	xgifb_reg_set(XGISR, 0x14, 0x51);
+	xgifb_reg_set(XGISR, 0x1e, 0x41);
+	xgifb_reg_set(XGISR, 0x1f, 0x0);
+	xgifb_reg_set(XGISR, 0x20, 0xa1);
+	xgifb_reg_set(XGISR, 0x22, 0xfb);
+	xgifb_reg_set(XGISR, 0x26, 0x22);
+	xgifb_reg_set(XGISR, 0x3e, 0x07);
 	*/
 
-	/* outXGIIDXREG(XGICR, 0x19, 0x00); */
-	/* outXGIIDXREG(XGICR, 0x1a, 0x3C); */
-	/* outXGIIDXREG(XGICR, 0x22, 0xff); */
-	/* outXGIIDXREG(XGICR, 0x3D, 0x10); */
+	/* xgifb_reg_set(XGICR, 0x19, 0x00); */
+	/* xgifb_reg_set(XGICR, 0x1a, 0x3C); */
+	/* xgifb_reg_set(XGICR, 0x22, 0xff); */
+	/* xgifb_reg_set(XGICR, 0x3D, 0x10); */
 
-	/* outXGIIDXREG(XGICR, 0x4a, 0xf3); */
+	/* xgifb_reg_set(XGICR, 0x4a, 0xf3); */
 
-	/* outXGIIDXREG(XGICR, 0x57, 0x0); */
-	/* outXGIIDXREG(XGICR, 0x7a, 0x2c); */
+	/* xgifb_reg_set(XGICR, 0x57, 0x0); */
+	/* xgifb_reg_set(XGICR, 0x7a, 0x2c); */
 
-	/* outXGIIDXREG(XGICR, 0x82, 0xcc); */
-	/* outXGIIDXREG(XGICR, 0x8c, 0x0); */
+	/* xgifb_reg_set(XGICR, 0x82, 0xcc); */
+	/* xgifb_reg_set(XGICR, 0x8c, 0x0); */
 	/*
-	outXGIIDXREG(XGICR, 0x99, 0x1);
-	outXGIIDXREG(XGICR, 0x41, 0x40);
+	xgifb_reg_set(XGICR, 0x99, 0x1);
+	xgifb_reg_set(XGICR, 0x41, 0x40);
 	*/
 
 	for (i = 0; i < 0x4f; i++) {
@@ -113,7 +113,7 @@ static void dumpVGAReg(void)
 		printk("\ni 3d5 => %x", reg);
 	}
 	/*
-	outXGIIDXREG(XGIPART1,0x2F,1);
+	xgifb_reg_set(XGIPART1,0x2F,1);
 	for (i=1; i < 0x50; i++) {
 		reg = xgifb_reg_get(XGIPART1, i);
 		printk("\no d004 %x", i);
@@ -570,7 +570,7 @@ static int XGIfb_GetXG21LVDSData(void)
 	int i, j, k;
 
 	tmp = xgifb_reg_get(XGISR, 0x1e);
-	outXGIIDXREG(XGISR, 0x1e, tmp | 4);
+	xgifb_reg_set(XGISR, 0x1e, tmp | 4);
 
 	pData = xgi_video_info.mmio_vbase + 0x20000;
 	if ((pData[0x0] == 0x55) && (pData[0x1] == 0xAA) && (pData[0x65] & 0x1)) {
@@ -1085,10 +1085,10 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		info->fix.line_length = ((info->var.xres_virtual
 				* info->var.bits_per_pixel) >> 6);
 
-		outXGIIDXREG(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
+		xgifb_reg_set(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
 
-		outXGIIDXREG(XGICR, 0x13, (info->fix.line_length & 0x00ff));
-		outXGIIDXREG(XGISR, 0x0E, (info->fix.line_length & 0xff00) >> 8);
+		xgifb_reg_set(XGICR, 0x13, (info->fix.line_length & 0x00ff));
+		xgifb_reg_set(XGISR, 0x0E, (info->fix.line_length & 0xff00) >> 8);
 
 		XGIfb_post_setmode();
 
@@ -1113,7 +1113,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 			xgi_video_info.video_cmap_len = 256;
 #if defined(__powerpc__)
 			cr_data = xgifb_reg_get(XGICR, 0x4D);
-			outXGIIDXREG(XGICR, 0x4D, (cr_data & 0xE0));
+			xgifb_reg_set(XGICR, 0x4D, (cr_data & 0xE0));
 #endif
 			break;
 		case 16:
@@ -1121,7 +1121,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 			xgi_video_info.XGI310_AccelDepth = 0x00010000;
 #if defined(__powerpc__)
 			cr_data = xgifb_reg_get(XGICR, 0x4D);
-			outXGIIDXREG(XGICR, 0x4D, ((cr_data & 0xE0) | 0x0B));
+			xgifb_reg_set(XGICR, 0x4D, ((cr_data & 0xE0) | 0x0B));
 #endif
 			xgi_video_info.video_cmap_len = 16;
 			break;
@@ -1131,7 +1131,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 			xgi_video_info.video_cmap_len = 16;
 #if defined(__powerpc__)
 			cr_data = xgifb_reg_get(XGICR, 0x4D);
-			outXGIIDXREG(XGICR, 0x4D, ((cr_data & 0xE0) | 0x15));
+			xgifb_reg_set(XGICR, 0x4D, ((cr_data & 0xE0) | 0x15));
 #endif
 			break;
 		default:
@@ -1179,19 +1179,19 @@ static int XGIfb_pan_var(struct fb_var_screeninfo *var)
 		break;
 	}
 
-	outXGIIDXREG(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
+	xgifb_reg_set(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
 
-	outXGIIDXREG(XGICR, 0x0D, base & 0xFF);
-	outXGIIDXREG(XGICR, 0x0C, (base >> 8) & 0xFF);
-	outXGIIDXREG(XGISR, 0x0D, (base >> 16) & 0xFF);
-	outXGIIDXREG(XGISR, 0x37, (base >> 24) & 0x03);
+	xgifb_reg_set(XGICR, 0x0D, base & 0xFF);
+	xgifb_reg_set(XGICR, 0x0C, (base >> 8) & 0xFF);
+	xgifb_reg_set(XGISR, 0x0D, (base >> 16) & 0xFF);
+	xgifb_reg_set(XGISR, 0x37, (base >> 24) & 0x03);
 	setXGIIDXREG(XGISR, 0x37, 0xDF, (base >> 21) & 0x04);
 
 	if (xgi_video_info.disp_state & DISPTYPE_DISP2) {
 		orXGIIDXREG(XGIPART1, XGIfb_CRT2_write_enable, 0x01);
-		outXGIIDXREG(XGIPART1, 0x06, (base & 0xFF));
-		outXGIIDXREG(XGIPART1, 0x05, ((base >> 8) & 0xFF));
-		outXGIIDXREG(XGIPART1, 0x04, ((base >> 16) & 0xFF));
+		xgifb_reg_set(XGIPART1, 0x06, (base & 0xFF));
+		xgifb_reg_set(XGIPART1, 0x05, ((base >> 8) & 0xFF));
+		xgifb_reg_set(XGIPART1, 0x04, ((base >> 16) & 0xFF));
 		setXGIIDXREG(XGIPART1, 0x02, 0x7F, ((base >> 24) & 0x01) << 7);
 	}
 	/* printk("End of pan_var"); */
@@ -1467,9 +1467,9 @@ static int XGIfb_blank(int blank, struct fb_info *info)
 	else
 		reg |= 0x80;
 
-	outXGIIDXREG(XGICR, 0x17, reg);
-	outXGIIDXREG(XGISR, 0x00, 0x01); /* Synchronous Reset */
-	outXGIIDXREG(XGISR, 0x00, 0x03); /* End Reset */
+	xgifb_reg_set(XGICR, 0x17, reg);
+	xgifb_reg_set(XGISR, 0x00, 0x01); /* Synchronous Reset */
+	xgifb_reg_set(XGISR, 0x00, 0x03); /* End Reset */
 	return 0;
 }
 
@@ -1537,7 +1537,7 @@ static int XGIfb_get_dram_size(void)
 
 	/* xorg driver sets 32MB * 1 channel */
 	if (xgi_video_info.chip == XG27)
-		outXGIIDXREG(XGISR, IND_XGI_DRAM_SIZE, 0x51);
+		xgifb_reg_set(XGISR, IND_XGI_DRAM_SIZE, 0x51);
 
 	reg = xgifb_reg_get(XGISR, IND_XGI_DRAM_SIZE);
 	switch ((reg & XGI_DRAM_SIZE_MASK) >> 4) {
@@ -1734,7 +1734,7 @@ int XGIDoSense(int tempbl, int tempbh, int tempcl, int tempch)
 {
 	int temp, i;
 
-	outXGIIDXREG(XGIPART4, 0x11, tempbl);
+	xgifb_reg_set(XGIPART4, 0x11, tempbl);
 	temp = tempbh | tempcl;
 	setXGIIDXREG(XGIPART4, 0x10, 0xe0, temp);
 	for (i = 0; i < 10; i++)
@@ -1758,7 +1758,7 @@ void XGI_Sense30x(void)
 	int myflag, result;
 
 	backupP4_0d = xgifb_reg_get(XGIPART4, 0x0d);
-	outXGIIDXREG(XGIPART4, 0x0d, (backupP4_0d | 0x04));
+	xgifb_reg_set(XGIPART4, 0x0d, (backupP4_0d | 0x04));
 
 	testvga2_tempbh = 0x00;
 	testvga2_tempbl = 0xd1;
@@ -1846,7 +1846,7 @@ void XGI_Sense30x(void)
 	}
 	XGIDoSense(0, 0, 0, 0);
 
-	outXGIIDXREG(XGIPART4, 0x0d, backupP4_0d);
+	xgifb_reg_set(XGIPART4, 0x0d, backupP4_0d);
 }
 
 /* --------------------- SetMode routines ------------------------- */
@@ -1892,9 +1892,9 @@ static void XGIfb_pre_setmode(void)
 		cr31 |= (XGI_DRIVER_MODE | XGI_VB_OUTPUT_DISABLE);
 	}
 
-	outXGIIDXREG(XGICR, IND_XGI_SCRATCH_REG_CR30, cr30);
-	outXGIIDXREG(XGICR, IND_XGI_SCRATCH_REG_CR31, cr31);
-	outXGIIDXREG(XGICR, IND_XGI_SCRATCH_REG_CR33, (XGIfb_rate_idx & 0x0F));
+	xgifb_reg_set(XGICR, IND_XGI_SCRATCH_REG_CR30, cr30);
+	xgifb_reg_set(XGICR, IND_XGI_SCRATCH_REG_CR31, cr31);
+	xgifb_reg_set(XGICR, IND_XGI_SCRATCH_REG_CR33, (XGIfb_rate_idx & 0x0F));
 }
 
 static void XGIfb_post_setmode(void)
@@ -1902,8 +1902,8 @@ static void XGIfb_post_setmode(void)
 	u8 reg;
 	unsigned char doit = 1;
 	/*
-	outXGIIDXREG(XGISR,IND_XGI_PASSWORD,XGI_PASSWORD);
-	outXGIIDXREG(XGICR, 0x13, 0x00);
+	xgifb_reg_set(XGISR,IND_XGI_PASSWORD,XGI_PASSWORD);
+	xgifb_reg_set(XGICR, 0x13, 0x00);
 	setXGIIDXREG(XGISR,0x0E, 0xF0, 0x01);
 	*test*
 	*/
@@ -1934,7 +1934,7 @@ static void XGIfb_post_setmode(void)
 		reg &= ~0x80;
 	else
 		reg |= 0x80;
-	outXGIIDXREG(XGICR, 0x17, reg);
+	xgifb_reg_set(XGICR, 0x17, reg);
 
 	andXGIIDXREG(XGISR, IND_XGI_RAMDAC_CONTROL, ~0x04);
 
@@ -1980,22 +1980,22 @@ static void XGIfb_post_setmode(void)
 
 					switch (xgi_video_info.video_width) {
 					case 640:
-						outXGIIDXREG(XGIPART2, 0x35, 0xEB);
-						outXGIIDXREG(XGIPART2, 0x36, 0x04);
-						outXGIIDXREG(XGIPART2, 0x37, 0x25);
-						outXGIIDXREG(XGIPART2, 0x38, 0x18);
+						xgifb_reg_set(XGIPART2, 0x35, 0xEB);
+						xgifb_reg_set(XGIPART2, 0x36, 0x04);
+						xgifb_reg_set(XGIPART2, 0x37, 0x25);
+						xgifb_reg_set(XGIPART2, 0x38, 0x18);
 						break;
 					case 720:
-						outXGIIDXREG(XGIPART2, 0x35, 0xEE);
-						outXGIIDXREG(XGIPART2, 0x36, 0x0C);
-						outXGIIDXREG(XGIPART2, 0x37, 0x22);
-						outXGIIDXREG(XGIPART2, 0x38, 0x08);
+						xgifb_reg_set(XGIPART2, 0x35, 0xEE);
+						xgifb_reg_set(XGIPART2, 0x36, 0x0C);
+						xgifb_reg_set(XGIPART2, 0x37, 0x22);
+						xgifb_reg_set(XGIPART2, 0x38, 0x08);
 						break;
 					case 800:
-						outXGIIDXREG(XGIPART2, 0x35, 0xEB);
-						outXGIIDXREG(XGIPART2, 0x36, 0x15);
-						outXGIIDXREG(XGIPART2, 0x37, 0x25);
-						outXGIIDXREG(XGIPART2, 0x38, 0xF6);
+						xgifb_reg_set(XGIPART2, 0x35, 0xEB);
+						xgifb_reg_set(XGIPART2, 0x36, 0x15);
+						xgifb_reg_set(XGIPART2, 0x37, 0x25);
+						xgifb_reg_set(XGIPART2, 0x38, 0xF6);
 						break;
 					}
 				}
@@ -2015,22 +2015,22 @@ static void XGIfb_post_setmode(void)
 
 					switch (xgi_video_info.video_width) {
 					case 640:
-						outXGIIDXREG(XGIPART2, 0x35, 0xF1);
-						outXGIIDXREG(XGIPART2, 0x36, 0xF7);
-						outXGIIDXREG(XGIPART2, 0x37, 0x1F);
-						outXGIIDXREG(XGIPART2, 0x38, 0x32);
+						xgifb_reg_set(XGIPART2, 0x35, 0xF1);
+						xgifb_reg_set(XGIPART2, 0x36, 0xF7);
+						xgifb_reg_set(XGIPART2, 0x37, 0x1F);
+						xgifb_reg_set(XGIPART2, 0x38, 0x32);
 						break;
 					case 720:
-						outXGIIDXREG(XGIPART2, 0x35, 0xF3);
-						outXGIIDXREG(XGIPART2, 0x36, 0x00);
-						outXGIIDXREG(XGIPART2, 0x37, 0x1D);
-						outXGIIDXREG(XGIPART2, 0x38, 0x20);
+						xgifb_reg_set(XGIPART2, 0x35, 0xF3);
+						xgifb_reg_set(XGIPART2, 0x36, 0x00);
+						xgifb_reg_set(XGIPART2, 0x37, 0x1D);
+						xgifb_reg_set(XGIPART2, 0x38, 0x20);
 						break;
 					case 800:
-						outXGIIDXREG(XGIPART2, 0x35, 0xFC);
-						outXGIIDXREG(XGIPART2, 0x36, 0xFB);
-						outXGIIDXREG(XGIPART2, 0x37, 0x14);
-						outXGIIDXREG(XGIPART2, 0x38, 0x2A);
+						xgifb_reg_set(XGIPART2, 0x35, 0xFC);
+						xgifb_reg_set(XGIPART2, 0x36, 0xFB);
+						xgifb_reg_set(XGIPART2, 0x37, 0x14);
+						xgifb_reg_set(XGIPART2, 0x38, 0x2A);
 						break;
 					}
 				}
@@ -2043,19 +2043,19 @@ static void XGIfb_post_setmode(void)
 						XGI_TV_filter[filter_tb].filter[filter][2],
 						XGI_TV_filter[filter_tb].filter[filter][3]
 				);
-				outXGIIDXREG(
+				xgifb_reg_set(
 						XGIPART2,
 						0x35,
 						(XGI_TV_filter[filter_tb].filter[filter][0]));
-				outXGIIDXREG(
+				xgifb_reg_set(
 						XGIPART2,
 						0x36,
 						(XGI_TV_filter[filter_tb].filter[filter][1]));
-				outXGIIDXREG(
+				xgifb_reg_set(
 						XGIPART2,
 						0x37,
 						(XGI_TV_filter[filter_tb].filter[filter][2]));
-				outXGIIDXREG(
+				xgifb_reg_set(
 						XGIPART2,
 						0x38,
 						(XGI_TV_filter[filter_tb].filter[filter][3]));
@@ -2203,7 +2203,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	XGIRegInit(&XGI_Pr, (unsigned long)XGIhw_ext.pjIOAddress);
 
-	outXGIIDXREG(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
+	xgifb_reg_set(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
 	reg1 = xgifb_reg_get(XGISR, IND_XGI_PASSWORD);
 
 	if (reg1 != 0xa1) { /*I/O error */
-- 
1.5.6.5

