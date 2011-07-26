Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1GZS0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:26:33 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38761 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1GZS00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:26:26 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]Remove extra semicolon's in the kernel.
Date: Tue, 26 Jul 2011 11:26:03 -0700
Message-Id: <1311704763-6682-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below removes extra semicolon's in various parts of the kernel.
I have compile tested most of the parts, but things like arm I'm not sure
(maybe I need to learn how to cross compile or something!) 
Anyways have a look, and let me know if something needs to be changed etc.. 

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/mach-nuc93x/time.c             |    2 +-
 arch/arm/mach-w90x900/cpu.c             |    2 +-
 arch/ia64/include/asm/mca_asm.h         |    6 +++---
 arch/ia64/include/asm/paravirt_patch.h  |    6 +++---
 arch/ia64/kernel/ftrace.c               |    8 ++++----
 drivers/block/rbd.c                     |    2 +-
 drivers/gpu/drm/radeon/radeon_fence.c   |    2 +-
 drivers/i2c/busses/i2c-designware.c     |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c |    2 +-
 drivers/scsi/isci/phy.c                 |    2 +-
 drivers/staging/iio/addac/adt7316-i2c.c |    2 +-
 drivers/staging/iio/dds/ad9832.c        |    2 +-
 drivers/usb/gadget/mv_udc_core.c        |    4 ++--
 scripts/checkpatch.pl                   |    4 ++--
 scripts/setlocalversion                 |    2 +-
 tools/testing/ktest/ktest.pl            |    2 +-
 16 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-nuc93x/time.c b/arch/arm/mach-nuc93x/time.c
index 2f90f9d..f9807c0 100644
--- a/arch/arm/mach-nuc93x/time.c
+++ b/arch/arm/mach-nuc93x/time.c
@@ -82,7 +82,7 @@ static void nuc93x_timer_setup(void)
 	timer0_load = (rate / TICKS_PER_SEC);
 	__raw_writel(timer0_load, REG_TICR0);
 
-	val |= (PERIOD | COUNTEN | INTEN | PRESCALE);;
+	val |= (PERIOD | COUNTEN | INTEN | PRESCALE);
 	__raw_writel(val, REG_TCSR0);
 
 }
diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
index 83c5632..0a235e5 100644
--- a/arch/arm/mach-w90x900/cpu.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -60,7 +60,7 @@ static DEFINE_CLK(emc, 7);
 static DEFINE_SUBCLK(rmii, 2);
 static DEFINE_CLK(usbd, 8);
 static DEFINE_CLK(usbh, 9);
-static DEFINE_CLK(g2d, 10);;
+static DEFINE_CLK(g2d, 10);
 static DEFINE_CLK(pwm, 18);
 static DEFINE_CLK(ps2, 24);
 static DEFINE_CLK(kpi, 25);
diff --git a/arch/ia64/include/asm/mca_asm.h b/arch/ia64/include/asm/mca_asm.h
index dd2a5b1..d57d3c0 100644
--- a/arch/ia64/include/asm/mca_asm.h
+++ b/arch/ia64/include/asm/mca_asm.h
@@ -46,11 +46,11 @@
  *	1. Put 0x7 in bits 61 thru 63.
  */
 #define DATA_PA_TO_VA(addr,temp)							\
-	mov	temp	= 0x7	;;							\
+	mov	temp	= 0x7;							\
 	dep	addr	= temp, addr, 61, 3
 
 #define GET_THIS_PADDR(reg, var)		\
-	mov	reg = IA64_KR(PER_CPU_DATA);;	\
+	mov	reg = IA64_KR(PER_CPU_DATA);	\
         addl	reg = THIS_CPU(var), reg
 
 /*
@@ -82,7 +82,7 @@
 	;;										\
 	dep	old_psr = 0, old_psr, 32, 32;						\
 											\
-	mov	ar.rsc = 0 ;								\
+	mov	ar.rsc = 0;								\
 	;;										\
 	srlz.d;										\
 	mov	temp2 = ar.bspstore;							\
diff --git a/arch/ia64/include/asm/paravirt_patch.h b/arch/ia64/include/asm/paravirt_patch.h
index 128ff5d..0a53f9a 100644
--- a/arch/ia64/include/asm/paravirt_patch.h
+++ b/arch/ia64/include/asm/paravirt_patch.h
@@ -28,10 +28,10 @@
 #define PARAVIRT_PATCH_SITE_BR(type)		\
 	{					\
 	[1:] ;					\
-	br.cond.sptk.many 2f ;			\
+	br.cond.sptk.many 2f;			\
 	nop.b 0 ;				\
-	nop.b 0;; ;				\
-	} ;					\
+	nop.b 0;				\
+	};					\
 	2:					\
 	.xdata8 ".paravirt_branches", 1b, type
 
diff --git a/arch/ia64/kernel/ftrace.c b/arch/ia64/kernel/ftrace.c
index 7fc8c96..8f6dc5b 100644
--- a/arch/ia64/kernel/ftrace.c
+++ b/arch/ia64/kernel/ftrace.c
@@ -21,11 +21,11 @@
 static unsigned char __attribute__((aligned(8)))
 ftrace_orig_code[MCOUNT_INSN_SIZE] = {
 	0x02, 0x40, 0x31, 0x10, 0x80, 0x05, /* alloc r40=ar.pfs,12,8,0 */
-	0xb0, 0x02, 0x00, 0x00, 0x42, 0x40, /* mov r43=r0;; */
+	0xb0, 0x02, 0x00, 0x00, 0x42, 0x40, /* mov r43=r0 */
 	0x05, 0x00, 0xc4, 0x00,             /* mov r42=b0 */
 	0x11, 0x48, 0x01, 0x02, 0x00, 0x21, /* mov r41=r1 */
 	0x00, 0x00, 0x00, 0x02, 0x00, 0x00, /* nop.i 0x0 */
-	0x08, 0x00, 0x00, 0x50              /* br.call.sptk.many b0 = _mcount;; */
+	0x08, 0x00, 0x00, 0x50              /* br.call.sptk.many b0 = _mcount */
 };
 
 struct ftrace_orig_insn {
@@ -43,7 +43,7 @@ static unsigned char ftrace_nop_code[MCOUNT_INSN_SIZE] = {
 	0x30, 0x00, 0x00, 0x60, 0x00, 0x00, /* mov r3=ip */
 	0x00, 0x00, 0x04, 0x00,             /* nop.i 0x0 */
 	0x05, 0x00, 0x00, 0x00, 0x01, 0x00, /* [MLX] nop.m 0x0 */
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* nop.x 0x0;; */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* nop.x 0x0 */
 	0x00, 0x00, 0x04, 0x00
 };
 
@@ -62,7 +62,7 @@ ftrace_call_code[MCOUNT_INSN_SIZE] = {
 	0x30, 0x00, 0x00, 0x60, 0x00, 0x00, /* mov r3=ip */
 	0x00, 0x00, 0x04, 0x00,             /* nop.i 0x0 */
 	0x05, 0x00, 0x00, 0x00, 0x01, 0x00, /* [MLX] nop.m 0x0 */
-	0xff, 0xff, 0xff, 0xff, 0x7f, 0x00, /* brl.many .;;*/
+	0xff, 0xff, 0xff, 0xff, 0x7f, 0x00, /* brl.many. */
 	0xf8, 0xff, 0xff, 0xc8
 };
 
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 1278098..2c09102 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -192,7 +192,7 @@ static ssize_t rbd_snap_add(struct device *dev,
 			    const char *buf,
 			    size_t count);
 static void __rbd_remove_snap_dev(struct rbd_device *rbd_dev,
-				  struct rbd_snap *snap);;
+				  struct rbd_snap *snap);
 
 
 static struct rbd_device *dev_to_rbd(struct device *dev)
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 021d2b6..9a9f9fc 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -48,7 +48,7 @@ static void radeon_fence_write(struct radeon_device *rdev, u32 seq)
 			scratch_index = R600_WB_EVENT_OFFSET + rdev->fence_drv.scratch_reg - rdev->scratch.reg_base;
 		else
 			scratch_index = RADEON_WB_SCRATCH_OFFSET + rdev->fence_drv.scratch_reg - rdev->scratch.reg_base;
-		rdev->wb.wb[scratch_index/4] = cpu_to_le32(seq);;
+		rdev->wb.wb[scratch_index/4] = cpu_to_le32(seq);
 	} else
 		WREG32(rdev->fence_drv.scratch_reg, seq);
 }
diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
index b7a51c4..1b42b50 100644
--- a/drivers/i2c/busses/i2c-designware.c
+++ b/drivers/i2c/busses/i2c-designware.c
@@ -390,7 +390,7 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 	int tx_limit, rx_limit;
 	u32 addr = msgs[dev->msg_write_idx].addr;
 	u32 buf_len = dev->tx_buf_len;
-	u8 *buf = dev->tx_buf;;
+	u8 *buf = dev->tx_buf;
 
 	intr_mask = DW_IC_INTR_DEFAULT_MASK;
 
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 8701072..a4f07f8 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -403,7 +403,7 @@ static int fm_v4l2_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 static int fm_v4l2_vidioc_g_modulator(struct file *file, void *priv,
 		struct v4l2_modulator *mod)
 {
-	struct fmdev *fmdev = video_drvdata(file);;
+	struct fmdev *fmdev = video_drvdata(file);
 
 	if (mod->index != 0)
 		return -EINVAL;
diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 79313a7..8d9192d 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -695,7 +695,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 				 __func__,
 				 event_code);
 
-			return SCI_FAILURE;;
+			return SCI_FAILURE;
 		}
 		return SCI_SUCCESS;
 	case SCI_PHY_SUB_AWAIT_SATA_SPEED_EN:
diff --git a/drivers/staging/iio/addac/adt7316-i2c.c b/drivers/staging/iio/addac/adt7316-i2c.c
index 52d1ea3..1c86cf1 100644
--- a/drivers/staging/iio/addac/adt7316-i2c.c
+++ b/drivers/staging/iio/addac/adt7316-i2c.c
@@ -109,7 +109,7 @@ static int __devinit adt7316_i2c_probe(struct i2c_client *client,
 
 static int __devexit adt7316_i2c_remove(struct i2c_client *client)
 {
-	return adt7316_remove(&client->dev);;
+	return adt7316_remove(&client->dev);
 }
 
 static const struct i2c_device_id adt7316_i2c_id[] = {
diff --git a/drivers/staging/iio/dds/ad9832.c b/drivers/staging/iio/dds/ad9832.c
index e3e61a4..6f0efe6 100644
--- a/drivers/staging/iio/dds/ad9832.c
+++ b/drivers/staging/iio/dds/ad9832.c
@@ -52,7 +52,7 @@ static int ad9832_write_frequency(struct ad9832_state *st,
 					((addr - 3) << ADD_SHIFT) |
 					((regval >> 0) & 0xFF));
 
-	return spi_sync(st->spi, &st->freq_msg);;
+	return spi_sync(st->spi, &st->freq_msg);
 }
 
 static int ad9832_write_phase(struct ad9832_state *st,
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index ce1ac2b..0b3b8d0 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -335,7 +335,7 @@ static int queue_dtd(struct mv_ep *ep, struct mv_req *req)
 	} else {
 		/* Write dQH next pointer and terminate bit to 0 */
 		dqh->next_dtd_ptr = req->head->td_dma
-			& EP_QUEUE_HEAD_NEXT_POINTER_MASK;;
+			& EP_QUEUE_HEAD_NEXT_POINTER_MASK;
 		dqh->size_ioc_int_sts = 0;
 
 		/* Ensure that updates to the QH will occur before priming. */
@@ -376,7 +376,7 @@ static int queue_dtd(struct mv_ep *ep, struct mv_req *req)
 		}
 	}
 done:
-	return retval;;
+	return retval;
 }
 
 static struct mv_dtd *build_dtd(struct mv_req *req, unsigned *length,
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9d761c9..14f6a90 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2931,11 +2931,11 @@ sub process {
 				}
 			}
 			if ($level == 0 && $block =~ /^\s*\{/ && !$allowed) {
-				my $herectx = $here . "\n";;
+				my $herectx = $here . "\n";
 				my $cnt = statement_rawlines($block);
 
 				for (my $n = 0; $n < $cnt; $n++) {
-					$herectx .= raw_line($linenr, $n) . "\n";;
+					$herectx .= raw_line($linenr, $n) . "\n";
 				}
 
 				WARN("BRACES",
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 4d40384..e187f1f 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -101,7 +101,7 @@ scm_version()
 		# Are there uncommitted changes?
 		# These are represented by + after the changeset id.
 		case "$hgid" in
-			*+|*+\ *) printf '%s' -dirty ;;
+			*+|*+\ *) printf '%s' -dirty;
 		esac
 
 		# All done with mercurial
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index cef28e6..b300a1f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2241,7 +2241,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 
 	my $failed = 0;
 	start_monitor;
-	monitor or $failed = 1;;
+	monitor or $failed = 1;
 
 	if (!$failed && $test_type ne "boot" && defined($run_test)) {
 	    do_run_test or $failed = 1;
-- 
1.7.6

