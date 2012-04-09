Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab2DIOmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 10:42:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62936 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2DIOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 10:41:59 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Fix typo in various drivers
Date: Mon,  9 Apr 2012 23:41:40 +0900
Message-Id: <1333982500-14261-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in various debug messages witin
various drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/firewire/ohci.c                   |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    2 +-
 drivers/media/video/uvc/uvc_driver.c      |    2 +-
 drivers/mtd/tests/mtd_oobtest.c           |    2 +-
 drivers/mtd/tests/mtd_pagetest.c          |    2 +-
 drivers/mtd/tests/mtd_readtest.c          |    2 +-
 drivers/mtd/tests/mtd_speedtest.c         |    2 +-
 drivers/mtd/tests/mtd_stresstest.c        |    2 +-
 drivers/mtd/tests/mtd_subpagetest.c       |    2 +-
 drivers/mtd/tests/mtd_torturetest.c       |    2 +-
 drivers/remoteproc/remoteproc_core.c      |    4 ++--
 drivers/usb/host/ohci-ppc-of.c            |    2 +-
 drivers/video/aty/atyfb_base.c            |    2 +-
 drivers/video/au1100fb.c                  |    2 +-
 drivers/video/au1200fb.c                  |    2 +-
 drivers/video/grvga.c                     |    2 +-
 drivers/video/nuc900fb.c                  |    2 +-
 drivers/video/sm501fb.c                   |    2 +-
 drivers/video/smscufx.c                   |    2 +-
 scripts/basic/fixdep.c                    |    2 +-
 20 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 2b54600..233ba97 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -328,7 +328,7 @@ module_param_named(quirks, param_quirks, int, 0644);
 MODULE_PARM_DESC(quirks, "Chip quirks (default = 0"
 	", nonatomic cycle timer = "	__stringify(QUIRK_CYCLE_TIMER)
 	", reset packet generation = "	__stringify(QUIRK_RESET_PACKET)
-	", AR/selfID endianess = "	__stringify(QUIRK_BE_HEADERS)
+	", AR/selfID endianness = "	__stringify(QUIRK_BE_HEADERS)
 	", no 1394a enhancements = "	__stringify(QUIRK_NO_1394A)
 	", disable MSI = "		__stringify(QUIRK_NO_MSI)
 	", TI SLLZ059 erratum = "	__stringify(QUIRK_TI_SLLZ059)
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index c25ec02..670c437 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -792,7 +792,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[0] = ctx->dec_src_buf_size;
 		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
 	} else {
-		mfc_err("This video node is dedicated to decoding. Decoding not initalised\n");
+		mfc_err("This video node is dedicated to decoding. Decoding not initialised\n");
 		return -EINVAL;
 	}
 	return 0;
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 1d13172..0c236b0 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1785,7 +1785,7 @@ static int uvc_register_chains(struct uvc_device *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 		ret = uvc_mc_register_entities(chain);
 		if (ret < 0) {
-			uvc_printk(KERN_INFO, "Failed to register entites "
+			uvc_printk(KERN_INFO, "Failed to register entities "
 				"(%d).\n", ret);
 		}
 #endif
diff --git a/drivers/mtd/tests/mtd_oobtest.c b/drivers/mtd/tests/mtd_oobtest.c
index ed9b628..0ac0443 100644
--- a/drivers/mtd/tests/mtd_oobtest.c
+++ b/drivers/mtd/tests/mtd_oobtest.c
@@ -368,7 +368,7 @@ static int __init mtd_oobtest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		printk(PRINT_PREF "Please specify a valid mtd-device via module paramter\n");
+		printk(PRINT_PREF "Please specify a valid mtd-device via module parameter\n");
 		printk(KERN_CRIT "CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/mtd/tests/mtd_pagetest.c b/drivers/mtd/tests/mtd_pagetest.c
index 252ddb0..877bfdf 100644
--- a/drivers/mtd/tests/mtd_pagetest.c
+++ b/drivers/mtd/tests/mtd_pagetest.c
@@ -499,7 +499,7 @@ static int __init mtd_pagetest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		printk(PRINT_PREF "Please specify a valid mtd-device via module paramter\n");
+		printk(PRINT_PREF "Please specify a valid mtd-device via module parameter\n");
 		printk(KERN_CRIT "CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/mtd/tests/mtd_readtest.c b/drivers/mtd/tests/mtd_readtest.c
index 121aba1..595ec88 100644
--- a/drivers/mtd/tests/mtd_readtest.c
+++ b/drivers/mtd/tests/mtd_readtest.c
@@ -171,7 +171,7 @@ static int __init mtd_readtest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		printk(PRINT_PREF "Please specify a valid mtd-device via module paramter\n");
+		printk(PRINT_PREF "Please specify a valid mtd-device via module parameter\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/mtd/tests/mtd_speedtest.c b/drivers/mtd/tests/mtd_speedtest.c
index 2aec4f3..6dfc3f4 100644
--- a/drivers/mtd/tests/mtd_speedtest.c
+++ b/drivers/mtd/tests/mtd_speedtest.c
@@ -362,7 +362,7 @@ static int __init mtd_speedtest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		printk(PRINT_PREF "Please specify a valid mtd-device via module paramter\n");
+		printk(PRINT_PREF "Please specify a valid mtd-device via module parameter\n");
 		printk(KERN_CRIT "CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/mtd/tests/mtd_stresstest.c b/drivers/mtd/tests/mtd_stresstest.c
index 7b33f22..3278803 100644
--- a/drivers/mtd/tests/mtd_stresstest.c
+++ b/drivers/mtd/tests/mtd_stresstest.c
@@ -251,7 +251,7 @@ static int __init mtd_stresstest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		printk(PRINT_PREF "Please specify a valid mtd-device via module paramter\n");
+		printk(PRINT_PREF "Please specify a valid mtd-device via module parameter\n");
 		printk(KERN_CRIT "CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/mtd/tests/mtd_subpagetest.c b/drivers/mtd/tests/mtd_subpagetest.c
index 9667bf5..ab86d1e 100644
--- a/drivers/mtd/tests/mtd_subpagetest.c
+++ b/drivers/mtd/tests/mtd_subpagetest.c
@@ -377,7 +377,7 @@ static int __init mtd_subpagetest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		printk(PRINT_PREF "Please specify a valid mtd-device via module paramter\n");
+		printk(PRINT_PREF "Please specify a valid mtd-device via module parameter\n");
 		printk(KERN_CRIT "CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/mtd/tests/mtd_torturetest.c b/drivers/mtd/tests/mtd_torturetest.c
index b65861b..62225f2 100644
--- a/drivers/mtd/tests/mtd_torturetest.c
+++ b/drivers/mtd/tests/mtd_torturetest.c
@@ -215,7 +215,7 @@ static int __init tort_init(void)
 	       "flash, stop it if this is not wanted.\n");
 
 	if (dev < 0) {
-		printk(PRINT_PREF "Please specify a valid mtd-device via module paramter\n");
+		printk(PRINT_PREF "Please specify a valid mtd-device via module parameter\n");
 		printk(KERN_CRIT "CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index ee15c68..ed2c24d 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -970,13 +970,13 @@ static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
 		return -EINVAL;
 	}
 
-	/* We assume the firmware has the same endianess as the host */
+	/* We assume the firmware has the same endianness as the host */
 # ifdef __LITTLE_ENDIAN
 	if (ehdr->e_ident[EI_DATA] != ELFDATA2LSB) {
 # else /* BIG ENDIAN */
 	if (ehdr->e_ident[EI_DATA] != ELFDATA2MSB) {
 # endif
-		dev_err(dev, "Unsupported firmware endianess\n");
+		dev_err(dev, "Unsupported firmware endianness\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index d24cc89d..b2b5767 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -236,7 +236,7 @@ MODULE_DEVICE_TABLE(of, ohci_hcd_ppc_of_match);
 
 #if	!defined(CONFIG_USB_OHCI_HCD_PPC_OF_BE) && \
 	!defined(CONFIG_USB_OHCI_HCD_PPC_OF_LE)
-#error "No endianess selected for ppc-of-ohci"
+#error "No endianness selected for ppc-of-ohci"
 #endif
 
 
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
diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index befcbd8..061d2c1 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -520,7 +520,7 @@ static int __devinit au1100fb_drv_probe(struct platform_device *dev)
 					    PAGE_ALIGN(fbdev->fb_len),
 					    &fbdev->fb_phys, GFP_KERNEL);
 	if (!fbdev->fb_mem) {
-		print_err("fail to allocate frambuffer (size: %dK))",
+		print_err("fail to allocate framebuffer (size: %dK))",
 			  fbdev->fb_len / 1024);
 		return -ENOMEM;
 	}
diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
index 3e9a773..30d2c93 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1728,7 +1728,7 @@ static int __devinit au1200fb_drv_probe(struct platform_device *dev)
 				PAGE_ALIGN(fbdev->fb_len),
 				&fbdev->fb_phys, GFP_KERNEL);
 		if (!fbdev->fb_mem) {
-			print_err("fail to allocate frambuffer (size: %dK))",
+			print_err("fail to allocate framebuffer (size: %dK))",
 				  fbdev->fb_len / 1024);
 			return -ENOMEM;
 		}
diff --git a/drivers/video/grvga.c b/drivers/video/grvga.c
index da066c2..09547fe 100644
--- a/drivers/video/grvga.c
+++ b/drivers/video/grvga.c
@@ -440,7 +440,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
 			retval = -ENOMEM;
 			goto err4;
 		}
-	} else {	/* Allocate frambuffer memory */
+	} else {	/* Allocate framebuffer memory */
 
 		unsigned long page;
 
diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index e10f551..94160f0 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -56,7 +56,7 @@ static void nuc900fb_set_lcdaddr(struct fb_info *info)
 	vbaddr2  = info->fix.smem_start;
 	vbaddr2 += info->fix.line_length * info->var.yres;
 
-	/* set frambuffer start phy addr*/
+	/* set framebuffer start phy addr*/
 	writel(vbaddr1, regs + REG_LCM_VA_BADDR0);
 	writel(vbaddr2, regs + REG_LCM_VA_BADDR1);
 
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index 3690eff..82790c2 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -80,7 +80,7 @@ struct sm501_mem {
 	void __iomem	*k_addr;
 };
 
-/* private data that is shared between all frambuffers* */
+/* private data that is shared between all framebuffers* */
 struct sm501fb_info {
 	struct device		*dev;
 	struct fb_info		*fb[2];		/* fb info for both heads */
diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
index ccbfef5..44fd854 100644
--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -1466,7 +1466,7 @@ static int ufx_read_edid(struct ufx_data *dev, u8 *edid, int edid_len)
 	/* all FF's in the first 16 bytes indicates nothing is connected */
 	for (i = 0; i < 16; i++) {
 		if (edid[i] != 0xFF) {
-			pr_debug("edid data read succesfully");
+			pr_debug("edid data read successfully");
 			return EDID_LENGTH;
 		}
 	}
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index cb1f50c..7f6425e 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -409,7 +409,7 @@ static void traps(void)
 	int *p = (int *)test;
 
 	if (*p != INT_CONF) {
-		fprintf(stderr, "fixdep: sizeof(int) != 4 or wrong endianess? %#x\n",
+		fprintf(stderr, "fixdep: sizeof(int) != 4 or wrong endianness? %#x\n",
 			*p);
 		exit(2);
 	}
-- 
1.7.10

