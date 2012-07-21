Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab2GUPWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 11:22:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2GUPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 11:22:33 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] video: Fix typo in drivers/video
Date: Sun, 22 Jul 2012 00:23:15 +0900
Message-Id: <1342884195-6281-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.11.2.249.g31c7954
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in debug messages and comments
within drivers/video.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/video/arcfb.c                     | 4 ++--
 drivers/video/atmel_lcdfb.c               | 2 +-
 drivers/video/aty/atyfb_base.c            | 2 +-
 drivers/video/aty/radeon_base.c           | 2 +-
 drivers/video/auo_k190x.c                 | 2 +-
 drivers/video/bfin_adv7393fb.c            | 2 +-
 drivers/video/cirrusfb.c                  | 2 +-
 drivers/video/exynos/exynos_dp_reg.c      | 2 +-
 drivers/video/exynos/exynos_mipi_dsi.c    | 4 ++--
 drivers/video/i740fb.c                    | 6 +++---
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c | 2 +-
 drivers/video/s3c-fb.c                    | 2 +-
 drivers/video/savage/savagefb_driver.c    | 6 +++---
 drivers/video/smscufx.c                   | 4 ++--
 drivers/video/sunxvr500.c                 | 2 +-
 15 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
index c22e8d3..a1d58e9 100644
--- a/drivers/video/arcfb.c
+++ b/drivers/video/arcfb.c
@@ -336,8 +336,8 @@ static void arcfb_lcd_update_horiz(struct arcfb_par *par, unsigned int left,
 }
 
 /*
- * here we start the process of spliting out the fb update into
- * individual blocks of pixels. we end up spliting into 64x64 blocks
+ * here we start the process of splitting out the fb update into
+ * individual blocks of pixels. we end up splitting into 64x64 blocks
  * and finally down to 64x8 pages.
  */
 static void arcfb_lcd_update(struct arcfb_par *par, unsigned int dx,
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index d99505b..1505539 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -939,7 +939,7 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 		 * up a splash image.
 		 */
 	} else {
-		/* alocate memory buffer */
+		/* allocate memory buffer */
 		ret = atmel_lcdfb_alloc_video_memory(sinfo);
 		if (ret < 0) {
 			dev_err(dev, "cannot allocate framebuffer: %d\n", ret);
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 622f12b..3f2e8c1 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -863,7 +863,7 @@ static int aty_var_to_crtc(const struct fb_info *info,
 
 	if ((xres > 1600) || (yres > 1200)) {
 		FAIL("MACH64 chips are designed for max 1600x1200\n"
-		     "select anoter resolution.");
+		     "select another resolution.");
 	}
 	h_sync_strt = h_disp + var->right_margin;
 	h_sync_end = h_sync_strt + var->hsync_len;
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index ce1506b..9e279ee 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2018,7 +2018,7 @@ static void radeon_identify_vram(struct radeonfb_info *rinfo)
           if ((rinfo->family == CHIP_FAMILY_RS100) ||
               (rinfo->family == CHIP_FAMILY_RS200)) {
              /* This is to workaround the asic bug for RMX, some versions
-                of BIOS dosen't have this register initialized correctly.
+                of BIOS doesn't have this register initialized correctly.
              */
              OUTREGP(CRTC_MORE_CNTL, CRTC_H_CUTOFF_ACTIVE_EN,
                      ~CRTC_H_CUTOFF_ACTIVE_EN);
diff --git a/drivers/video/auo_k190x.c b/drivers/video/auo_k190x.c
index 77da6a2..5c5b1ce 100644
--- a/drivers/video/auo_k190x.c
+++ b/drivers/video/auo_k190x.c
@@ -934,7 +934,7 @@ int __devinit auok190x_common_probe(struct platform_device *pdev,
 		goto err_defio;
 	}
 
-	dev_dbg(info->device, "targetting %d frames per second\n", board->fps);
+	dev_dbg(info->device, "targeting %d frames per second\n", board->fps);
 	info->fbdefio->delay = HZ / board->fps;
 	info->fbdefio->first_io = auok190xfb_dpy_first_io,
 	info->fbdefio->deferred_io = auok190xfb_dpy_deferred_io,
diff --git a/drivers/video/bfin_adv7393fb.c b/drivers/video/bfin_adv7393fb.c
index 9bdd4b0..d0f121b 100644
--- a/drivers/video/bfin_adv7393fb.c
+++ b/drivers/video/bfin_adv7393fb.c
@@ -58,7 +58,7 @@ static const unsigned short ppi_pins[] = {
  */
 
 static struct bfin_adv7393_fb_par {
-	/* structure holding blackfin / adv7393 paramters when
+	/* structure holding blackfin / adv7393 parameters when
 	   screen is blanked */
 	struct {
 		u8 Mode;	/* ntsc/pal/? */
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 738c8ce..bc67d05 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -1611,7 +1611,7 @@ static void init_vgachip(struct fb_info *info)
 	/* ext. display controls: ext.adr. wrap */
 	vga_wcrt(cinfo->regbase, CL_CRT1B, 0x02);
 
-	/* Set/Reset registes: - */
+	/* Set/Reset registers: - */
 	vga_wgfx(cinfo->regbase, VGA_GFX_SR_VALUE, 0x00);
 	/* Set/Reset enable: - */
 	vga_wgfx(cinfo->regbase, VGA_GFX_SR_ENABLE, 0x00);
diff --git a/drivers/video/exynos/exynos_dp_reg.c b/drivers/video/exynos/exynos_dp_reg.c
index 6ce76d5..bcb0e3a 100644
--- a/drivers/video/exynos/exynos_dp_reg.c
+++ b/drivers/video/exynos/exynos_dp_reg.c
@@ -752,7 +752,7 @@ int exynos_dp_read_bytes_from_i2c(struct exynos_dp_device *dp,
 
 			/*
 			 * If Rx sends defer, Tx sends only reads
-			 * request without sending addres
+			 * request without sending address
 			 */
 			if (!defer)
 				retval = exynos_dp_select_i2c_device(dp,
diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
index 6c1f5c3..22bbe1c 100644
--- a/drivers/video/exynos/exynos_mipi_dsi.c
+++ b/drivers/video/exynos/exynos_mipi_dsi.c
@@ -106,7 +106,7 @@ static void exynos_mipi_update_cfg(struct mipi_dsim_device *dsim)
 
 	/*
 	 * data from Display controller(FIMD) is transferred in video mode
-	 * but in case of command mode, all settigs is updated to registers.
+	 * but in case of command mode, all settings are updated to registers.
 	 */
 	exynos_mipi_dsi_stand_by(dsim, 1);
 }
@@ -461,7 +461,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 done:
 	platform_set_drvdata(pdev, dsim);
 
-	dev_dbg(&pdev->dev, "%s() completed sucessfuly (%s mode)\n", __func__,
+	dev_dbg(&pdev->dev, "%s() completed sucessfully (%s mode)\n", __func__,
 		dsim_config->e_interface == DSIM_COMMAND ? "CPU" : "RGB");
 
 	return 0;
diff --git a/drivers/video/i740fb.c b/drivers/video/i740fb.c
index fe574d8..ff3f880 100644
--- a/drivers/video/i740fb.c
+++ b/drivers/video/i740fb.c
@@ -497,7 +497,7 @@ static int i740fb_decode_var(const struct fb_var_screeninfo *var,
 
 	mem = vxres * vyres * ((bpp + 1) / 8);
 	if (mem > info->screen_size) {
-		dev_err(info->device, "not enough video memory (%d KB requested, %ld KB avaliable)\n",
+		dev_err(info->device, "not enough video memory (%d KB requested, %ld KB available)\n",
 			mem >> 10, info->screen_size >> 10);
 		return -ENOMEM;
 	}
@@ -728,7 +728,7 @@ static void vga_protect(struct i740fb_par *par)
 	i740outreg_mask(par, VGA_SEQ_I, VGA_SEQ_CLOCK_MODE, 0x20, 0x20);
 
 	i740inb(par, 0x3DA);
-	i740outb(par, VGA_ATT_W, 0x00);	/* enable pallete access */
+	i740outb(par, VGA_ATT_W, 0x00);	/* enable palette access */
 }
 
 static void vga_unprotect(struct i740fb_par *par)
@@ -737,7 +737,7 @@ static void vga_unprotect(struct i740fb_par *par)
 	i740outreg_mask(par, VGA_SEQ_I, VGA_SEQ_CLOCK_MODE, 0, 0x20);
 
 	i740inb(par, 0x3DA);
-	i740outb(par, VGA_ATT_W, 0x20);	/* disable pallete access */
+	i740outb(par, VGA_ATT_W, 0x20);	/* disable palette access */
 }
 
 static int i740fb_set_par(struct fb_info *info)
diff --git a/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c b/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
index 4dae1b2..52bd3a2 100644
--- a/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
+++ b/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
@@ -1240,7 +1240,7 @@ int ti_hdmi_4xxx_audio_config(struct hdmi_ip_data *ip_data,
 	else
 		core.i2s_cfg.justification = HDMI_AUDIO_JUSTIFY_RIGHT;
 	/*
-	 * The I2S input word length is twice the lenght given in the IEC-60958
+	 * The I2S input word length is twice the length given in the IEC-60958
 	 * status word. If the word size is greater than
 	 * 20 bits, increment by one.
 	 */
diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 5f9d8e690..3305d95 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -189,7 +189,7 @@ struct s3c_fb_vsync {
 
 /**
  * struct s3c_fb - overall hardware state of the hardware
- * @slock: The spinlock protection for this data sturcture.
+ * @slock: The spinlock protection for this data sturucture.
  * @dev: The device that we bound to, for printing, etc.
  * @bus_clk: The clk (hclk) feeding our interface and possibly pixclk.
  * @lcd_clk: The clk (sclk) feeding pixclk.
diff --git a/drivers/video/savage/savagefb_driver.c b/drivers/video/savage/savagefb_driver.c
index cee7803..b4c2e21 100644
--- a/drivers/video/savage/savagefb_driver.c
+++ b/drivers/video/savage/savagefb_driver.c
@@ -662,7 +662,7 @@ static void savage_get_default_par(struct savagefb_par *par, struct savage_reg *
 	vga_out8(0x3c4, 0x18, par);
 	reg->SR18 = vga_in8(0x3c5, par);
 
-	/* Save flat panel expansion regsters. */
+	/* Save flat panel expansion registers. */
 	if (par->chip == S3_SAVAGE_MX) {
 		int i;
 
@@ -815,7 +815,7 @@ static void savage_set_default_par(struct savagefb_par *par,
 	vga_out8(0x3c4, 0x18, par);
 	vga_out8(0x3c5, reg->SR18, par);
 
-	/* Save flat panel expansion regsters. */
+	/* Save flat panel expansion registers. */
 	if (par->chip == S3_SAVAGE_MX) {
 		int i;
 
@@ -1318,7 +1318,7 @@ static void savagefb_set_par_int(struct savagefb_par  *par, struct savage_reg *r
 	vga_out8(0x3c4, 0x15, par);
 	vga_out8(0x3c5, reg->SR15, par);
 
-	/* Restore flat panel expansion regsters. */
+	/* Restore flat panel expansion registers. */
 	if (par->chip == S3_SAVAGE_MX) {
 		int i;
 
diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
index af3ef27..062aacd 100644
--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -1002,7 +1002,7 @@ static int ufx_ops_ioctl(struct fb_info *info, unsigned int cmd,
 	/* TODO: Help propose a standard fb.h ioctl to report mmap damage */
 	if (cmd == UFX_IOCTL_REPORT_DAMAGE) {
 		/* If we have a damage-aware client, turn fb_defio "off"
-		 * To avoid perf imact of unecessary page fault handling.
+		 * To avoid perf imact of unnecessary page fault handling.
 		 * Done by resetting the delay for this fb_info to a very
 		 * long period. Pages will become writable and stay that way.
 		 * Reset to normal value when all clients have closed this fb.
@@ -1466,7 +1466,7 @@ static int ufx_read_edid(struct ufx_data *dev, u8 *edid, int edid_len)
 	/* all FF's in the first 16 bytes indicates nothing is connected */
 	for (i = 0; i < 16; i++) {
 		if (edid[i] != 0xFF) {
-			pr_debug("edid data read succesfully");
+			pr_debug("edid data read successfully");
 			return EDID_LENGTH;
 		}
 	}
diff --git a/drivers/video/sunxvr500.c b/drivers/video/sunxvr500.c
index b9c2b94..eb931b8 100644
--- a/drivers/video/sunxvr500.c
+++ b/drivers/video/sunxvr500.c
@@ -12,7 +12,7 @@
 
 #include <asm/io.h>
 
-/* XXX This device has a 'dev-comm' property which aparently is
+/* XXX This device has a 'dev-comm' property which apparently is
  * XXX a pointer into the openfirmware's address space which is
  * XXX a shared area the kernel driver can use to keep OBP
  * XXX informed about the current resolution setting.  The idea
-- 
1.7.11.2.249.g31c7954

