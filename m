Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab1JVFsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:48:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JVFsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:48:12 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/36] Staging: cx25821: cx25821-medusa-video.c: Change line endings
Date: Sat, 22 Oct 2011 13:43:40 +0800
Message-Id: <1319262236-6498-21-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change obscure line endings to less obscure ones. (improve readability)

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-medusa-video.c |  400 ++++++++++--------------
 1 files changed, 159 insertions(+), 241 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index 1ae0e8a..298a68d 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -99,82 +99,67 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 
 	for (i = 0; i < MAX_DECODERS; i++) {
 		/* set video format NTSC-M */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0], MODE_CTRL + (0x200 * i),
-				     &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				MODE_CTRL + (0x200 * i), &tmp);
 		value &= 0xFFFFFFF0;
 		/* enable the fast locking mode bit[16] */
 		value |= 0x10001;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0], MODE_CTRL + (0x200 * i),
-				      value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				MODE_CTRL + (0x200 * i), value);
 
 		/* resolution NTSC 720x480 */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     HORIZ_TIM_CTRL + (0x200 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				HORIZ_TIM_CTRL + (0x200 * i), &tmp);
 		value &= 0x00C00C00;
 		value |= 0x612D0074;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      HORIZ_TIM_CTRL + (0x200 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				HORIZ_TIM_CTRL + (0x200 * i), value);
 
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     VERT_TIM_CTRL + (0x200 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				VERT_TIM_CTRL + (0x200 * i), &tmp);
 		value &= 0x00C00C00;
 		value |= 0x1C1E001A;	/* vblank_cnt + 2 to get camera ID */
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      VERT_TIM_CTRL + (0x200 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				VERT_TIM_CTRL + (0x200 * i), value);
 
 		/* chroma subcarrier step size */
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      SC_STEP_SIZE + (0x200 * i), 0x43E00000);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				SC_STEP_SIZE + (0x200 * i), 0x43E00000);
 
 		/* enable VIP optional active */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     OUT_CTRL_NS + (0x200 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				OUT_CTRL_NS + (0x200 * i), &tmp);
 		value &= 0xFFFBFFFF;
 		value |= 0x00040000;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      OUT_CTRL_NS + (0x200 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				OUT_CTRL_NS + (0x200 * i), value);
 
 		/* enable VIP optional active (VIP_OPT_AL) for direct output. */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0], OUT_CTRL1 + (0x200 * i),
-				     &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				OUT_CTRL1 + (0x200 * i), &tmp);
 		value &= 0xFFFBFFFF;
 		value |= 0x00040000;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0], OUT_CTRL1 + (0x200 * i),
-				      value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				OUT_CTRL1 + (0x200 * i), value);
 
 		/*
 		 * clear VPRES_VERT_EN bit, fixes the chroma run away problem
 		 * when the input switching rate < 16 fields
 		*/
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     MISC_TIM_CTRL + (0x200 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				MISC_TIM_CTRL + (0x200 * i), &tmp);
 		/* disable special play detection */
 		value = setBitAtPos(value, 14);
 		value = clearBitAtPos(value, 15);
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      MISC_TIM_CTRL + (0x200 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				MISC_TIM_CTRL + (0x200 * i), value);
 
 		/* set vbi_gate_en to 0 */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0], DFE_CTRL1 + (0x200 * i),
-				     &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DFE_CTRL1 + (0x200 * i), &tmp);
 		value = clearBitAtPos(value, 29);
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0], DFE_CTRL1 + (0x200 * i),
-				      value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DFE_CTRL1 + (0x200 * i), value);
 
 		/* Enable the generation of blue field output if no video */
 		medusa_enable_bluefield_output(dev, i, 1);
@@ -182,61 +167,49 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 
 	for (i = 0; i < MAX_ENCODERS; i++) {
 		/* NTSC hclock */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     DENC_A_REG_1 + (0x100 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DENC_A_REG_1 + (0x100 * i), &tmp);
 		value &= 0xF000FC00;
 		value |= 0x06B402D0;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_1 + (0x100 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_1 + (0x100 * i), value);
 
 		/* burst begin and burst end */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     DENC_A_REG_2 + (0x100 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DENC_A_REG_2 + (0x100 * i), &tmp);
 		value &= 0xFF000000;
 		value |= 0x007E9054;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_2 + (0x100 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_2 + (0x100 * i), value);
 
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     DENC_A_REG_3 + (0x100 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DENC_A_REG_3 + (0x100 * i), &tmp);
 		value &= 0xFC00FE00;
 		value |= 0x00EC00F0;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_3 + (0x100 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_3 + (0x100 * i), value);
 
 		/* set NTSC vblank, no phase alternation, 7.5 IRE pedestal */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     DENC_A_REG_4 + (0x100 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DENC_A_REG_4 + (0x100 * i), &tmp);
 		value &= 0x00FCFFFF;
 		value |= 0x13020000;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_4 + (0x100 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_4 + (0x100 * i), value);
 
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     DENC_A_REG_5 + (0x100 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DENC_A_REG_5 + (0x100 * i), &tmp);
 		value &= 0xFFFF0000;
 		value |= 0x0000E575;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_5 + (0x100 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_5 + (0x100 * i), value);
 
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_6 + (0x100 * i), 0x009A89C1);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_6 + (0x100 * i), 0x009A89C1);
 
 		/* Subcarrier Increment */
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_7 + (0x100 * i), 0x21F07C1F);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_7 + (0x100 * i), 0x21F07C1F);
 	}
 
 	/* set picture resolutions */
@@ -261,34 +234,27 @@ static int medusa_PALCombInit(struct cx25821_dev *dev, int dec)
 	u32 value = 0, tmp = 0;
 
 	/* Setup for 2D threshold */
-	ret_val =
-	    cx25821_i2c_write(&dev->i2c_bus[0], COMB_2D_HFS_CFG + (0x200 * dec),
-			      0x20002861);
-	ret_val =
-	    cx25821_i2c_write(&dev->i2c_bus[0], COMB_2D_HFD_CFG + (0x200 * dec),
-			      0x20002861);
-	ret_val =
-	    cx25821_i2c_write(&dev->i2c_bus[0], COMB_2D_LF_CFG + (0x200 * dec),
-			      0x200A1023);
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+			COMB_2D_HFS_CFG + (0x200 * dec), 0x20002861);
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+			COMB_2D_HFD_CFG + (0x200 * dec), 0x20002861);
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+			COMB_2D_LF_CFG + (0x200 * dec), 0x200A1023);
 
 	/* Setup flat chroma and luma thresholds */
-	value =
-	    cx25821_i2c_read(&dev->i2c_bus[0],
-			     COMB_FLAT_THRESH_CTRL + (0x200 * dec), &tmp);
+	value = cx25821_i2c_read(&dev->i2c_bus[0],
+			COMB_FLAT_THRESH_CTRL + (0x200 * dec), &tmp);
 	value &= 0x06230000;
-	ret_val =
-	    cx25821_i2c_write(&dev->i2c_bus[0],
-			      COMB_FLAT_THRESH_CTRL + (0x200 * dec), value);
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+			COMB_FLAT_THRESH_CTRL + (0x200 * dec), value);
 
 	/* set comb 2D blend */
-	ret_val =
-	    cx25821_i2c_write(&dev->i2c_bus[0], COMB_2D_BLEND + (0x200 * dec),
-			      0x210F0F0F);
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+			COMB_2D_BLEND + (0x200 * dec), 0x210F0F0F);
 
 	/* COMB MISC CONTROL */
-	ret_val =
-	    cx25821_i2c_write(&dev->i2c_bus[0], COMB_MISC_CTRL + (0x200 * dec),
-			      0x41120A7F);
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+			COMB_MISC_CTRL + (0x200 * dec), 0x41120A7F);
 
 	return ret_val;
 }
@@ -304,83 +270,68 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 
 	for (i = 0; i < MAX_DECODERS; i++) {
 		/* set video format PAL-BDGHI */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0], MODE_CTRL + (0x200 * i),
-				     &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				MODE_CTRL + (0x200 * i), &tmp);
 		value &= 0xFFFFFFF0;
 		/* enable the fast locking mode bit[16] */
 		value |= 0x10004;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0], MODE_CTRL + (0x200 * i),
-				      value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				MODE_CTRL + (0x200 * i), value);
 
 		/* resolution PAL 720x576 */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     HORIZ_TIM_CTRL + (0x200 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				HORIZ_TIM_CTRL + (0x200 * i), &tmp);
 		value &= 0x00C00C00;
 		value |= 0x632D007D;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      HORIZ_TIM_CTRL + (0x200 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				HORIZ_TIM_CTRL + (0x200 * i), value);
 
 		/* vblank656_cnt=x26, vactive_cnt=240h, vblank_cnt=x24 */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     VERT_TIM_CTRL + (0x200 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				VERT_TIM_CTRL + (0x200 * i), &tmp);
 		value &= 0x00C00C00;
 		value |= 0x28240026;	/* vblank_cnt + 2 to get camera ID */
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      VERT_TIM_CTRL + (0x200 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				VERT_TIM_CTRL + (0x200 * i), value);
 
 		/* chroma subcarrier step size */
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      SC_STEP_SIZE + (0x200 * i), 0x5411E2D0);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				SC_STEP_SIZE + (0x200 * i), 0x5411E2D0);
 
 		/* enable VIP optional active */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     OUT_CTRL_NS + (0x200 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				OUT_CTRL_NS + (0x200 * i), &tmp);
 		value &= 0xFFFBFFFF;
 		value |= 0x00040000;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      OUT_CTRL_NS + (0x200 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				OUT_CTRL_NS + (0x200 * i), value);
 
 		/* enable VIP optional active (VIP_OPT_AL) for direct output. */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0], OUT_CTRL1 + (0x200 * i),
-				     &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				OUT_CTRL1 + (0x200 * i), &tmp);
 		value &= 0xFFFBFFFF;
 		value |= 0x00040000;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0], OUT_CTRL1 + (0x200 * i),
-				      value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				OUT_CTRL1 + (0x200 * i), value);
 
 		/*
 		 * clear VPRES_VERT_EN bit, fixes the chroma run away problem
 		 * when the input switching rate < 16 fields
 		 */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     MISC_TIM_CTRL + (0x200 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				MISC_TIM_CTRL + (0x200 * i), &tmp);
 		/* disable special play detection */
 		value = setBitAtPos(value, 14);
 		value = clearBitAtPos(value, 15);
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      MISC_TIM_CTRL + (0x200 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				MISC_TIM_CTRL + (0x200 * i), value);
 
 		/* set vbi_gate_en to 0 */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0], DFE_CTRL1 + (0x200 * i),
-				     &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DFE_CTRL1 + (0x200 * i), &tmp);
 		value = clearBitAtPos(value, 29);
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0], DFE_CTRL1 + (0x200 * i),
-				      value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DFE_CTRL1 + (0x200 * i), value);
 
 		medusa_PALCombInit(dev, i);
 
@@ -390,62 +341,50 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 
 	for (i = 0; i < MAX_ENCODERS; i++) {
 		/* PAL hclock */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     DENC_A_REG_1 + (0x100 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DENC_A_REG_1 + (0x100 * i), &tmp);
 		value &= 0xF000FC00;
 		value |= 0x06C002D0;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_1 + (0x100 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_1 + (0x100 * i), value);
 
 		/* burst begin and burst end */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     DENC_A_REG_2 + (0x100 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DENC_A_REG_2 + (0x100 * i), &tmp);
 		value &= 0xFF000000;
 		value |= 0x007E9754;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_2 + (0x100 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_2 + (0x100 * i), value);
 
 		/* hblank and vactive */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     DENC_A_REG_3 + (0x100 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DENC_A_REG_3 + (0x100 * i), &tmp);
 		value &= 0xFC00FE00;
 		value |= 0x00FC0120;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_3 + (0x100 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_3 + (0x100 * i), value);
 
 		/* set PAL vblank, phase alternation, 0 IRE pedestal */
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     DENC_A_REG_4 + (0x100 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DENC_A_REG_4 + (0x100 * i), &tmp);
 		value &= 0x00FCFFFF;
 		value |= 0x14010000;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_4 + (0x100 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_4 + (0x100 * i), value);
 
-		value =
-		    cx25821_i2c_read(&dev->i2c_bus[0],
-				     DENC_A_REG_5 + (0x100 * i), &tmp);
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+				DENC_A_REG_5 + (0x100 * i), &tmp);
 		value &= 0xFFFF0000;
 		value |= 0x0000F078;
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_5 + (0x100 * i), value);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_5 + (0x100 * i), value);
 
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_6 + (0x100 * i), 0x00A493CF);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_6 + (0x100 * i), 0x00A493CF);
 
 		/* Subcarrier Increment */
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      DENC_A_REG_7 + (0x100 * i), 0x2A098ACB);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				DENC_A_REG_7 + (0x100 * i), 0x2A098ACB);
 	}
 
 	/* set picture resolutions */
@@ -543,12 +482,10 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 
 	for (; decoder < decoder_count; decoder++) {
 		/* write scaling values for each decoder */
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      HSCALE_CTRL + (0x200 * decoder), hscale);
-		ret_val =
-		    cx25821_i2c_write(&dev->i2c_bus[0],
-				      VSCALE_CTRL + (0x200 * decoder), vscale);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				HSCALE_CTRL + (0x200 * decoder), hscale);
+		ret_val = cx25821_i2c_write(&dev->i2c_bus[0],
+				VSCALE_CTRL + (0x200 * decoder), vscale);
 	}
 
 	mutex_unlock(&dev->lock);
@@ -606,8 +543,8 @@ static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 }
 
 /* Map to Medusa register setting */
-static int mapM(int srcMin,
-		int srcMax, int srcVal, int dstMin, int dstMax, int *dstVal)
+static int mapM(int srcMin, int srcMax, int srcVal, int dstMin, int dstMax,
+		int *dstVal)
 {
 	int numerator;
 	int denominator;
@@ -659,18 +596,14 @@ int medusa_set_brightness(struct cx25821_dev *dev, int brightness, int decoder)
 		mutex_unlock(&dev->lock);
 		return -1;
 	}
-	ret_val =
-	    mapM(VIDEO_PROCAMP_MIN, VIDEO_PROCAMP_MAX, brightness,
-		 SIGNED_BYTE_MIN, SIGNED_BYTE_MAX, &value);
+	ret_val = mapM(VIDEO_PROCAMP_MIN, VIDEO_PROCAMP_MAX, brightness,
+			SIGNED_BYTE_MIN, SIGNED_BYTE_MAX, &value);
 	value = convert_to_twos(value, 8);
-	val =
-	    cx25821_i2c_read(&dev->i2c_bus[0],
-			     VDEC_A_BRITE_CTRL + (0x200 * decoder), &tmp);
+	val = cx25821_i2c_read(&dev->i2c_bus[0],
+			VDEC_A_BRITE_CTRL + (0x200 * decoder), &tmp);
 	val &= 0xFFFFFF00;
-	ret_val |=
-	    cx25821_i2c_write(&dev->i2c_bus[0],
-			      VDEC_A_BRITE_CTRL + (0x200 * decoder),
-			      val | value);
+	ret_val |= cx25821_i2c_write(&dev->i2c_bus[0],
+			VDEC_A_BRITE_CTRL + (0x200 * decoder), val | value);
 	mutex_unlock(&dev->lock);
 	return ret_val;
 }
@@ -688,17 +621,13 @@ int medusa_set_contrast(struct cx25821_dev *dev, int contrast, int decoder)
 		return -1;
 	}
 
-	ret_val =
-	    mapM(VIDEO_PROCAMP_MIN, VIDEO_PROCAMP_MAX, contrast,
-		 UNSIGNED_BYTE_MIN, UNSIGNED_BYTE_MAX, &value);
-	val =
-	    cx25821_i2c_read(&dev->i2c_bus[0],
-			     VDEC_A_CNTRST_CTRL + (0x200 * decoder), &tmp);
+	ret_val = mapM(VIDEO_PROCAMP_MIN, VIDEO_PROCAMP_MAX, contrast,
+			UNSIGNED_BYTE_MIN, UNSIGNED_BYTE_MAX, &value);
+	val = cx25821_i2c_read(&dev->i2c_bus[0],
+			VDEC_A_CNTRST_CTRL + (0x200 * decoder), &tmp);
 	val &= 0xFFFFFF00;
-	ret_val |=
-	    cx25821_i2c_write(&dev->i2c_bus[0],
-			      VDEC_A_CNTRST_CTRL + (0x200 * decoder),
-			      val | value);
+	ret_val |= cx25821_i2c_write(&dev->i2c_bus[0],
+			VDEC_A_CNTRST_CTRL + (0x200 * decoder), val | value);
 
 	mutex_unlock(&dev->lock);
 	return ret_val;
@@ -717,19 +646,16 @@ int medusa_set_hue(struct cx25821_dev *dev, int hue, int decoder)
 		return -1;
 	}
 
-	ret_val =
-	    mapM(VIDEO_PROCAMP_MIN, VIDEO_PROCAMP_MAX, hue, SIGNED_BYTE_MIN,
-		 SIGNED_BYTE_MAX, &value);
+	ret_val = mapM(VIDEO_PROCAMP_MIN, VIDEO_PROCAMP_MAX, hue,
+			SIGNED_BYTE_MIN, SIGNED_BYTE_MAX, &value);
 
 	value = convert_to_twos(value, 8);
-	val =
-	    cx25821_i2c_read(&dev->i2c_bus[0],
-			     VDEC_A_HUE_CTRL + (0x200 * decoder), &tmp);
+	val = cx25821_i2c_read(&dev->i2c_bus[0],
+			VDEC_A_HUE_CTRL + (0x200 * decoder), &tmp);
 	val &= 0xFFFFFF00;
 
-	ret_val |=
-	    cx25821_i2c_write(&dev->i2c_bus[0],
-			      VDEC_A_HUE_CTRL + (0x200 * decoder), val | value);
+	ret_val |= cx25821_i2c_write(&dev->i2c_bus[0],
+			VDEC_A_HUE_CTRL + (0x200 * decoder), val | value);
 
 	mutex_unlock(&dev->lock);
 	return ret_val;
@@ -749,27 +675,20 @@ int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)
 		return -1;
 	}
 
-	ret_val =
-	    mapM(VIDEO_PROCAMP_MIN, VIDEO_PROCAMP_MAX, saturation,
-		 UNSIGNED_BYTE_MIN, UNSIGNED_BYTE_MAX, &value);
+	ret_val = mapM(VIDEO_PROCAMP_MIN, VIDEO_PROCAMP_MAX, saturation,
+			UNSIGNED_BYTE_MIN, UNSIGNED_BYTE_MAX, &value);
 
-	val =
-	    cx25821_i2c_read(&dev->i2c_bus[0],
-			     VDEC_A_USAT_CTRL + (0x200 * decoder), &tmp);
+	val = cx25821_i2c_read(&dev->i2c_bus[0],
+			VDEC_A_USAT_CTRL + (0x200 * decoder), &tmp);
 	val &= 0xFFFFFF00;
-	ret_val |=
-	    cx25821_i2c_write(&dev->i2c_bus[0],
-			      VDEC_A_USAT_CTRL + (0x200 * decoder),
-			      val | value);
-
-	val =
-	    cx25821_i2c_read(&dev->i2c_bus[0],
-			     VDEC_A_VSAT_CTRL + (0x200 * decoder), &tmp);
+	ret_val |= cx25821_i2c_write(&dev->i2c_bus[0],
+			VDEC_A_USAT_CTRL + (0x200 * decoder), val | value);
+
+	val = cx25821_i2c_read(&dev->i2c_bus[0],
+			VDEC_A_VSAT_CTRL + (0x200 * decoder), &tmp);
 	val &= 0xFFFFFF00;
-	ret_val |=
-	    cx25821_i2c_write(&dev->i2c_bus[0],
-			      VDEC_A_VSAT_CTRL + (0x200 * decoder),
-			      val | value);
+	ret_val |= cx25821_i2c_write(&dev->i2c_bus[0],
+			VDEC_A_VSAT_CTRL + (0x200 * decoder), val | value);
 
 	mutex_unlock(&dev->lock);
 	return ret_val;
@@ -830,9 +749,8 @@ int medusa_video_init(struct cx25821_dev *dev)
 	/* select AFE clock to output mode */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL, &tmp);
 	value &= 0x83FFFFFF;
-	ret_val =
-	   cx25821_i2c_write(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL,
-			     value | 0x10000000);
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL,
+			value | 0x10000000);
 
 	if (ret_val < 0)
 		goto error;
-- 
1.7.0.4

