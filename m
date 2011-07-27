Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1G0GGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:06:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61417 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1G0GGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:06:52 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2]remove extra semicolons from various parts of the kernel
Date: Tue, 26 Jul 2011 23:06:29 -0700
Message-Id: <1311746789-2870-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

This is a resend from the original, changing the title from PATCH to 
RFC(since this is a review for commit, and I should have put that the first go around).
and also removing some of the commit's with ia64 and bash since it is significant.
let me know if I might have missed anything etc..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/mach-nuc93x/time.c             |    2 +-
 arch/arm/mach-w90x900/cpu.c             |    2 +-
 drivers/block/rbd.c                     |    2 +-
 drivers/gpu/drm/radeon/radeon_fence.c   |    2 +-
 drivers/i2c/busses/i2c-designware.c     |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c |    2 +-
 drivers/scsi/isci/phy.c                 |    2 +-
 drivers/staging/iio/addac/adt7316-i2c.c |    2 +-
 drivers/staging/iio/dds/ad9832.c        |    2 +-
 drivers/usb/gadget/mv_udc_core.c        |    4 ++--
 scripts/checkpatch.pl                   |    4 ++--
 tools/testing/ktest/ktest.pl            |    2 +-
 12 files changed, 14 insertions(+), 14 deletions(-)

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

