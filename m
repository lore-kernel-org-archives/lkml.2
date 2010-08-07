Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0HGKnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 06:43:55 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:46980 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0HGKnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 06:43:53 -0400
X-Greylist: delayed 799 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Aug 2010 06:43:52 EDT
Subject: [PATCH] [TRIVIAL] fix some (printk) typos: faild and Faild
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 12:30:03 +0200
Message-ID: <1281177003.1993.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.5 (2.31.5-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
I noticed one of these typos in my log. I decided to fix them all.

Entirely untested.

 arch/arm/mach-omap1/board-nokia770.c |    2 +-
 drivers/ata/pata_bf54x.c             |    2 +-
 drivers/gpu/drm/radeon/radeon_cs.c   |    2 +-
 drivers/net/ps3_gelic_net.c          |    4 ++--
 drivers/net/tulip/pnic2.c            |    2 +-
 drivers/rtc/rtc-nuc900.c             |    2 +-
 drivers/video/bf54x-lq043fb.c        |    6 +++---
 drivers/video/bfin-t350mcqb-fb.c     |    2 +-
 fs/exofs/inode.c                     |   14 +++++++-------
 fs/exofs/ios.c                       |   10 +++++-----
 fs/jfs/jfs_mount.c                   |    4 ++--
 kernel/trace/trace_kprobe.c          |    2 +-
 net/wanrouter/wanmain.c              |    4 ++--
 13 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/arm/mach-omap1/board-nokia770.c b/arch/arm/mach-omap1/board-nokia770.c
index 8c28b10..bc93afb 100644
--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@ -362,7 +362,7 @@ static __init int omap_dsp_init(void)
 	ret = dsp_kfunc_device_register(&nokia770_audio_device);
 	if (ret) {
 		printk(KERN_ERR
-		       "KFUNC device registration faild: %s\n",
+		       "KFUNC device registration failed: %s\n",
 		       nokia770_audio_device.name);
 		goto out;
 	}
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 9cae65d..be7b1b2 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1588,7 +1588,7 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
 	host->ports[0]->ioaddr.ctl_addr = (void *)res->start;
 
 	if (peripheral_request_list(atapi_io_port, "atapi-io-port")) {
-		dev_err(&pdev->dev, "Requesting Peripherals faild\n");
+		dev_err(&pdev->dev, "Requesting Peripherals failed\n");
 		return -EFAULT;
 	}
 
diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index ae0fb73..8de578e 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -268,7 +268,7 @@ int radeon_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 	}
 	r = radeon_ib_schedule(rdev, parser.ib);
 	if (r) {
-		DRM_ERROR("Faild to schedule IB !\n");
+		DRM_ERROR("Failed to schedule IB !\n");
 	}
 	radeon_cs_parser_fini(&parser, r);
 	mutex_unlock(&rdev->cs_mutex);
diff --git a/drivers/net/ps3_gelic_net.c b/drivers/net/ps3_gelic_net.c
index 87d6b8f..49f6700 100644
--- a/drivers/net/ps3_gelic_net.c
+++ b/drivers/net/ps3_gelic_net.c
@@ -642,7 +642,7 @@ static inline void gelic_card_disable_rxdmac(struct gelic_card *card)
 	status = lv1_net_stop_rx_dma(bus_id(card), dev_id(card), 0);
 	if (status)
 		dev_err(ctodev(card),
-			"lv1_net_stop_rx_dma faild, %d\n", status);
+			"lv1_net_stop_rx_dma failed, %d\n", status);
 }
 
 /**
@@ -660,7 +660,7 @@ static inline void gelic_card_disable_txdmac(struct gelic_card *card)
 	status = lv1_net_stop_tx_dma(bus_id(card), dev_id(card), 0);
 	if (status)
 		dev_err(ctodev(card),
-			"lv1_net_stop_tx_dma faild, status=%d\n", status);
+			"lv1_net_stop_tx_dma failed, status=%d\n", status);
 }
 
 /**
diff --git a/drivers/net/tulip/pnic2.c b/drivers/net/tulip/pnic2.c
index b819766..4690c8e 100644
--- a/drivers/net/tulip/pnic2.c
+++ b/drivers/net/tulip/pnic2.c
@@ -59,7 +59,7 @@
  * Bit 14:12 - autonegotiation state (write 001 to start autonegotiate)
  * Bit 3     - Autopolarity state
  * Bit 2     - LS10B - link state of 10baseT 0 - good, 1 - failed
- * Bit 1     - LS100B - link state of 100baseT 0 - good, 1- faild
+ * Bit 1     - LS100B - link state of 100baseT 0 - good, 1 - failed
  *
  *
  * Data Port Selection Info
diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index a351bd5..08f95bd 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -279,7 +279,7 @@ static int __devinit nuc900_rtc_probe(struct platform_device *pdev)
 	nuc900_rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
 						&nuc900_rtc_ops, THIS_MODULE);
 	if (IS_ERR(nuc900_rtc->rtcdev)) {
-		dev_err(&pdev->dev, "rtc device register faild\n");
+		dev_err(&pdev->dev, "rtc device register failed\n");
 		err = PTR_ERR(nuc900_rtc->rtcdev);
 		goto fail4;
 	}
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index b020ba7..e7d0f52 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -241,12 +241,12 @@ static int request_ports(struct bfin_bf54xfb_info *fbi)
 	u16 disp = fbi->mach_info->disp;
 
 	if (gpio_request(disp, DRIVER_NAME)) {
-		printk(KERN_ERR "Requesting GPIO %d faild\n", disp);
+		printk(KERN_ERR "Requesting GPIO %d failed\n", disp);
 		return -EFAULT;
 	}
 
 	if (peripheral_request_list(eppi_req_18, DRIVER_NAME)) {
-		printk(KERN_ERR "Requesting Peripherals faild\n");
+		printk(KERN_ERR "Requesting Peripherals failed\n");
 		gpio_free(disp);
 		return -EFAULT;
 	}
@@ -256,7 +256,7 @@ static int request_ports(struct bfin_bf54xfb_info *fbi)
 		u16 eppi_req_24[] = EPPI0_24;
 
 		if (peripheral_request_list(eppi_req_24, DRIVER_NAME)) {
-			printk(KERN_ERR "Requesting Peripherals faild\n");
+			printk(KERN_ERR "Requesting Peripherals failed\n");
 			peripheral_free_list(eppi_req_18);
 			gpio_free(disp);
 			return -EFAULT;
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 7a50272..3cf7767 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -192,7 +192,7 @@ static int bfin_t350mcqb_request_ports(int action)
 {
 	if (action) {
 		if (peripheral_request_list(ppi0_req_8, DRIVER_NAME)) {
-			printk(KERN_ERR "Requesting Peripherals faild\n");
+			printk(KERN_ERR "Requesting Peripherals failed\n");
 			return -EFAULT;
 		}
 	} else
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 4bb6ef8..5862ae8 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -508,7 +508,7 @@ static int write_exec(struct page_collect *pcol)
 
 	pcol_copy = kmalloc(sizeof(*pcol_copy), GFP_KERNEL);
 	if (!pcol_copy) {
-		EXOFS_ERR("write_exec: Faild to kmalloc(pcol)\n");
+		EXOFS_ERR("write_exec: Failed to kmalloc(pcol)\n");
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -524,7 +524,7 @@ static int write_exec(struct page_collect *pcol)
 
 	ret = exofs_oi_write(oi, ios);
 	if (unlikely(ret)) {
-		EXOFS_ERR("write_exec: exofs_oi_write() Faild\n");
+		EXOFS_ERR("write_exec: exofs_oi_write() Failed\n");
 		goto err;
 	}
 
@@ -625,7 +625,7 @@ try_again:
 		/* split the request, next loop will start again */
 		ret = write_exec(pcol);
 		if (unlikely(ret)) {
-			EXOFS_DBGMSG("write_exec faild => %d", ret);
+			EXOFS_DBGMSG("write_exec failed => %d", ret);
 			goto fail;
 		}
 
@@ -709,7 +709,7 @@ int exofs_write_begin(struct file *file, struct address_space *mapping,
 		ret = simple_write_begin(file, mapping, pos, len, flags, pagep,
 					 fsdata);
 		if (ret) {
-			EXOFS_DBGMSG("simple_write_begin faild\n");
+			EXOFS_DBGMSG("simple_write_begin failed\n");
 			return ret;
 		}
 
@@ -722,7 +722,7 @@ int exofs_write_begin(struct file *file, struct address_space *mapping,
 		if (ret) {
 			/*SetPageError was done by _readpage. Is it ok?*/
 			unlock_page(page);
-			EXOFS_DBGMSG("__readpage_filler faild\n");
+			EXOFS_DBGMSG("__readpage_filler failed\n");
 		}
 	}
 
@@ -1112,7 +1112,7 @@ static void create_done(struct exofs_io_state *ios, void *p)
 	atomic_dec(&sbi->s_curr_pending);
 
 	if (unlikely(ret)) {
-		EXOFS_ERR("object=0x%llx creation faild in pid=0x%llx",
+		EXOFS_ERR("object=0x%llx creation failed in pid=0x%llx",
 			  _LLU(exofs_oi_objno(oi)), _LLU(sbi->layout.s_pid));
 		/*TODO: When FS is corrupted creation can fail, object already
 		 * exist. Get rid of this asynchronous creation, if exist
@@ -1232,7 +1232,7 @@ static int exofs_update_inode(struct inode *inode, int do_sync)
 
 	args = kzalloc(sizeof(*args), GFP_KERNEL);
 	if (!args) {
-		EXOFS_DBGMSG("Faild kzalloc of args\n");
+		EXOFS_DBGMSG("Failed kzalloc of args\n");
 		return -ENOMEM;
 	}
 
diff --git a/fs/exofs/ios.c b/fs/exofs/ios.c
index 4337cad..95921f5 100644
--- a/fs/exofs/ios.c
+++ b/fs/exofs/ios.c
@@ -55,7 +55,7 @@ int exofs_read_kern(struct osd_dev *od, u8 *cred, struct osd_obj_id *obj,
 
 	ret = osd_finalize_request(or, 0, cred, NULL);
 	if (unlikely(ret)) {
-		EXOFS_DBGMSG("Faild to osd_finalize_request() => %d\n", ret);
+		EXOFS_DBGMSG("Failed to osd_finalize_request() => %d\n", ret);
 		goto out;
 	}
 
@@ -79,7 +79,7 @@ int exofs_get_io_state(struct exofs_layout *layout,
 	 */
 	ios = kzalloc(exofs_io_state_size(layout->s_numdevs), GFP_KERNEL);
 	if (unlikely(!ios)) {
-		EXOFS_DBGMSG("Faild kzalloc bytes=%d\n",
+		EXOFS_DBGMSG("Failed kzalloc bytes=%d\n",
 			     exofs_io_state_size(layout->s_numdevs));
 		*pios = NULL;
 		return -ENOMEM;
@@ -172,7 +172,7 @@ static int exofs_io_execute(struct exofs_io_state *ios)
 
 		ret = osd_finalize_request(or, 0, ios->cred, NULL);
 		if (unlikely(ret)) {
-			EXOFS_DBGMSG("Faild to osd_finalize_request() => %d\n",
+			EXOFS_DBGMSG("Failed to osd_finalize_request() => %d\n",
 				     ret);
 			return ret;
 		}
@@ -365,7 +365,7 @@ static int _add_stripe_unit(struct exofs_io_state *ios,  unsigned *cur_pg,
 
 		per_dev->bio = bio_kmalloc(GFP_KERNEL, bio_size);
 		if (unlikely(!per_dev->bio)) {
-			EXOFS_DBGMSG("Faild to allocate BIO size=%u\n",
+			EXOFS_DBGMSG("Failed to allocate BIO size=%u\n",
 				     bio_size);
 			return -ENOMEM;
 		}
@@ -584,7 +584,7 @@ static int _sbi_write_mirror(struct exofs_io_state *ios, int cur_comp)
 						  master_dev->bio->bi_max_vecs);
 				if (unlikely(!bio)) {
 					EXOFS_DBGMSG(
-					      "Faild to allocate BIO size=%u\n",
+					      "Failed to allocate BIO size=%u\n",
 					      master_dev->bio->bi_max_vecs);
 					ret = -ENOMEM;
 					goto out;
diff --git a/fs/jfs/jfs_mount.c b/fs/jfs/jfs_mount.c
index 7b698f2..9895595 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -97,7 +97,7 @@ int jfs_mount(struct super_block *sb)
 
 	ipaimap = diReadSpecial(sb, AGGREGATE_I, 0);
 	if (ipaimap == NULL) {
-		jfs_err("jfs_mount: Faild to read AGGREGATE_I");
+		jfs_err("jfs_mount: Failed to read AGGREGATE_I");
 		rc = -EIO;
 		goto errout20;
 	}
@@ -148,7 +148,7 @@ int jfs_mount(struct super_block *sb)
 	if ((sbi->mntflag & JFS_BAD_SAIT) == 0) {
 		ipaimap2 = diReadSpecial(sb, AGGREGATE_I, 1);
 		if (!ipaimap2) {
-			jfs_err("jfs_mount: Faild to read AGGREGATE_I");
+			jfs_err("jfs_mount: Failed to read AGGREGATE_I");
 			rc = -EIO;
 			goto errout35;
 		}
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 8b27c98..52f0323 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -648,7 +648,7 @@ static int register_trace_probe(struct trace_probe *tp)
 	}
 	ret = register_probe_event(tp);
 	if (ret) {
-		pr_warning("Faild to register probe event(%d)\n", ret);
+		pr_warning("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
diff --git a/net/wanrouter/wanmain.c b/net/wanrouter/wanmain.c
index 2bf2340..74944a2 100644
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -471,7 +471,7 @@ static int wanrouter_device_setup(struct wan_device *wandev,
 		data = vmalloc(conf->data_size);
 		if (!data) {
 			printk(KERN_INFO
-				"%s: ERROR, Faild allocate kernel memory !\n",
+				"%s: ERROR, Failed allocate kernel memory !\n",
 				wandev->name);
 			kfree(conf);
 			return -ENOBUFS;
@@ -481,7 +481,7 @@ static int wanrouter_device_setup(struct wan_device *wandev,
 			err = wandev->setup(wandev, conf);
 		} else {
 			printk(KERN_INFO
-			     "%s: ERROR, Faild to copy from user data !\n",
+			     "%s: ERROR, Failed to copy from user data !\n",
 			       wandev->name);
 			err = -EFAULT;
 		}
-- 
1.7.2.1



