Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab1INUAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:00:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59646 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab1INUAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:00:16 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 16:00:16 EDT
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/3]Fix typos in the kernel 
Date: Wed, 14 Sep 2011 12:52:48 -0700
Message-Id: <1316029968-11277-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316029968-11277-1-git-send-email-justinmattock@gmail.com>
References: <1316029968-11277-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes some typos that I have found in the kernel.
Note:not sure if I am able to send this, due to kernel.org being down.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 drivers/staging/cxt1e1/libsbew.h                   |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    2 +-
 drivers/staging/iio/industrialio-trigger.c         |    2 +-
 drivers/staging/sep/sep_driver.c                   |    2 +-
 drivers/staging/tidspbridge/Kconfig                |    2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    2 +-
 drivers/tty/serial/mrst_max3110.c                  |    2 +-
 drivers/usb/gadget/langwell_udc.c                  |    2 +-
 drivers/usb/host/hwa-hc.c                          |    2 +-
 drivers/usb/host/imx21-hcd.c                       |    2 +-
 drivers/usb/musb/musb_gadget.c                     |    2 +-
 drivers/usb/otg/fsl_otg.c                          |    2 +-
 drivers/uwb/i1480/dfu/usb.c                        |    2 +-
 fs/btrfs/inode.c                                   |    2 +-
 fs/ext3/inode.c                                    |    2 +-
 fs/ext4/inode.c                                    |    2 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/ocfs2/file.c                                    |    2 +-
 fs/xfs/xfs_file.c                                  |    6 +++---
 fs/xfs/xfs_log_cil.c                               |    2 +-
 include/drm/drmP.h                                 |    2 +-
 include/linux/wanrouter.h                          |    2 +-
 include/net/mac80211.h                             |    2 +-
 net/ipv4/ip_fragment.c                             |    2 +-
 net/mac80211/work.c                                |    2 +-
 net/sctp/endpointola.c                             |    2 +-
 tools/power/cpupower/debug/i386/intel_gsic.c       |    2 +-
 30 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index d345472..470c508 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -103,7 +103,7 @@ struct brcmf_sdreg {
 
 struct sdioh_info {
 	struct osl_info *osh;		/* osh handler */
-	bool client_intr_enabled;	/* interrupt connnected flag */
+	bool client_intr_enabled;	/* interrupt connected flag */
 	bool intr_handler_valid;	/* client driver interrupt handler valid */
 	void (*intr_handler)(void *);	/* registered interrupt handler */
 	void *intr_handler_arg;	/* argument to call interrupt handler */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index c75a1a1..f9545b0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -3598,7 +3598,7 @@ int i_APCI3200_InterruptHandleEos(struct comedi_device *dev)
 			n = comedi_buf_write_alloc(s->async,
 				(7 + 12) * sizeof(unsigned int));
 
-			/*  If not enougth memory available, event is set to Comedi Buffer Errror */
+			/*  If not enough memory available, event is set to Comedi Buffer Error */
 			if (n > ((7 + 12) * sizeof(unsigned int))) {
 				printk("\ncomedi_buf_write_alloc n = %i", n);
 				s->async->events |= COMEDI_CB_ERROR;
diff --git a/drivers/staging/cxt1e1/libsbew.h b/drivers/staging/cxt1e1/libsbew.h
index 5c99646..ae8f06d 100644
--- a/drivers/staging/cxt1e1/libsbew.h
+++ b/drivers/staging/cxt1e1/libsbew.h
@@ -323,7 +323,7 @@ struct sbecom_port_param
 #define CFG_CH_DINV_TX      0x02
 
 
-/* Posssible resettable chipsets/functions */
+/* Possible resettable chipsets/functions */
 #define RESET_DEV_TEMUX     1
 #define RESET_DEV_TECT3     RESET_DEV_TEMUX
 #define RESET_DEV_PLL       2
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 990b2af..8156d79 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -349,10 +349,10 @@ static void ft1000_reset_asic(struct net_device *dev)
 	}
 	mdelay(1);
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		// set watermark to -1 in order to not generate an interrrupt
+		// set watermark to -1 in order to not generate an interrupt
 		ft1000_write_reg(dev, FT1000_REG_WATERMARK, 0xffff);
 	} else {
-		// set watermark to -1 in order to not generate an interrrupt
+		// set watermark to -1 in order to not generate an interrupt
 		ft1000_write_reg(dev, FT1000_REG_MAG_WATERMARK, 0xffff);
 	}
 	// clear interrupts
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 3f303ea..1b5e8a7 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -601,7 +601,7 @@ static void ft1000_reset_asic(struct net_device *dev)
 
 	mdelay(1);
 
-	/* set watermark to -1 in order to not generate an interrrupt */
+	/* set watermark to -1 in order to not generate an interrupt */
 	ft1000_write_register(ft1000dev, 0xffff, FT1000_REG_MAG_WATERMARK);
 
 	/* clear interrupts */
diff --git a/drivers/staging/iio/industrialio-trigger.c b/drivers/staging/iio/industrialio-trigger.c
index 90ca2df..d4437a0 100644
--- a/drivers/staging/iio/industrialio-trigger.c
+++ b/drivers/staging/iio/industrialio-trigger.c
@@ -308,7 +308,7 @@ void iio_dealloc_pollfunc(struct iio_poll_func *pf)
 EXPORT_SYMBOL_GPL(iio_dealloc_pollfunc);
 
 /**
- * iio_trigger_read_currrent() - trigger consumer sysfs query which trigger
+ * iio_trigger_read_current() - trigger consumer sysfs query which trigger
  *
  * For trigger consumers the current_trigger interface allows the trigger
  * used by the device to be queried.
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index bf7286e..0112302 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -1235,7 +1235,7 @@ static void sep_build_lli_table(struct sep_device *sep,
 	/* Counter of lli array entry */
 	u32 array_counter;
 
-	/* Init currrent table data size and lli array entry counter */
+	/* Init current table data size and lli array entry counter */
 	curr_table_data_size = 0;
 	array_counter = 0;
 	*num_table_entries_ptr = 1;
diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 93de4f2..21a559e 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -78,7 +78,7 @@ config TIDSPBRIDGE_NTFY_PWRERR
 	bool "Notify power errors"
 	depends on TIDSPBRIDGE
 	help
-	  Enable notifications to registered clients on the event of power errror
+	  Enable notifications to registered clients on the event of power error
 	  trying to suspend bridge driver. Say Y, to signal this event as a fatal
 	  error, this will require a bridge restart to recover.
 
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index a7e407e..fda2402 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -285,7 +285,7 @@ int dcd_enumerate_object(s32 index, enum dsp_dcdobjtype obj_type,
 			enum_refs = 0;
 
 			/*
-			 * TODO: Revisit, this is not an errror case but code
+			 * TODO: Revisit, this is not an error case but code
 			 * expects non-zero value.
 			 */
 			status = ENODATA;
diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index 23bc743..492c14d 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -23,7 +23,7 @@
  *    1 word. If SPI master controller doesn't support sclk frequency change,
  *    then the char need be sent out one by one with some delay
  *
- * 2. Currently only RX available interrrupt is used, no need for waiting TXE
+ * 2. Currently only RX available interrupt is used, no need for waiting TXE
  *    interrupt for a low speed UART device
  */
 
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index a06e2c2..ff4d40d 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -2969,7 +2969,7 @@ static irqreturn_t langwell_irq(int irq, void *_dev)
 		handle_port_change(dev);
 	}
 
-	/* suspend interrrupt */
+	/* suspend interrupt */
 	if (irq_sts & STS_SLI) {
 		dev_vdbg(&dev->pdev->dev, "suspend interrupt\n");
 		handle_bus_suspend(dev);
diff --git a/drivers/usb/host/hwa-hc.c b/drivers/usb/host/hwa-hc.c
index 9bfac65..b5c56a9 100644
--- a/drivers/usb/host/hwa-hc.c
+++ b/drivers/usb/host/hwa-hc.c
@@ -481,7 +481,7 @@ static int __hwahc_op_set_ptk(struct wusbhc *wusbhc, u8 port_idx, u32 tkid,
 		encryption_value = 0;
 	}
 
-	/* Set the encryption type for commmunicating with the device */
+	/* Set the encryption type for communicating with the device */
 	result = usb_control_msg(wa->usb_dev, usb_sndctrlpipe(wa->usb_dev, 0),
 			USB_REQ_SET_ENCRYPTION,
 			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
index af05718..7b5de30 100644
--- a/drivers/usb/host/imx21-hcd.c
+++ b/drivers/usb/host/imx21-hcd.c
@@ -473,7 +473,7 @@ static void free_epdmem(struct imx21 *imx21, struct usb_host_endpoint *ep)
 /* End handling 				*/
 /* ===========================================	*/
 
-/* Endpoint now idle - release it's ETD(s) or asssign to queued request */
+/* Endpoint now idle - release it's ETD(s) or assign to queued request */
 static void ep_idle(struct imx21 *imx21, struct ep_priv *ep_priv)
 {
 	int i;
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index e818203..fe8d14c 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -704,7 +704,7 @@ static void rxstate(struct musb *musb, struct musb_request *req)
 	 * most these gadgets, end of is signified either by a short packet,
 	 * or filling the last byte of the buffer.  (Sending extra data in
 	 * that last pckate should trigger an overflow fault.)  But in mode 1,
-	 * we don't get DMA completion interrrupt for short packets.
+	 * we don't get DMA completion interrupt for short packets.
 	 *
 	 * Theoretically, we could enable DMAReq irq (MUSB_RXCSR_DMAMODE = 1),
 	 * to get endpoint interrupt on every DMA req, but that didn't seem
diff --git a/drivers/usb/otg/fsl_otg.c b/drivers/usb/otg/fsl_otg.c
index 0f420b2..2d9cc44 100644
--- a/drivers/usb/otg/fsl_otg.c
+++ b/drivers/usb/otg/fsl_otg.c
@@ -639,7 +639,7 @@ static int fsl_otg_set_power(struct otg_transceiver *otg_p, unsigned mA)
  * Delayed pin detect interrupt processing.
  *
  * When the Mini-A cable is disconnected from the board,
- * the pin-detect interrupt happens before the disconnnect
+ * the pin-detect interrupt happens before the disconnect
  * interrupts for the connected device(s).  In order to
  * process the disconnect interrupt(s) prior to switching
  * roles, the pin-detect interrupts are delayed, and handled
diff --git a/drivers/uwb/i1480/dfu/usb.c b/drivers/uwb/i1480/dfu/usb.c
index ba86643..a315d4d 100644
--- a/drivers/uwb/i1480/dfu/usb.c
+++ b/drivers/uwb/i1480/dfu/usb.c
@@ -104,7 +104,7 @@ void i1480_usb_destroy(struct i1480_usb *i1480_usb)
  *
  * Data buffers to USB cannot be on the stack or in vmalloc'ed areas,
  * so we copy it to the local i1480 buffer before proceeding. In any
- * case, we have a max size we can send, soooo.
+ * case, we have a max size we can send.
  */
 static
 int i1480_usb_write(struct i1480 *i1480, u32 memory_address,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ccc743..5623536 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2168,7 +2168,7 @@ enum btrfs_orphan_cleanup_state {
 };
 
 /*
- * This is called in transaction commmit time. If there are no orphan
+ * This is called in transaction commit time. If there are no orphan
  * files in the subvolume, it removes orphan item and frees block_rsv
  * structure.
  */
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 04da6ac..7a00f8e 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2490,7 +2490,7 @@ int ext3_can_truncate(struct inode *inode)
  * transaction, and VFS/VM ensures that ext3_truncate() cannot run
  * simultaneously on behalf of the same inode.
  *
- * As we work through the truncate and commmit bits of it to the journal there
+ * As we work through the truncate and commit bits of it to the journal there
  * is one core, guiding principle: the file's tree must always be consistent on
  * disk.  We must be able to restart the truncate after a crash.
  *
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c4da98a..6b1daeb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3128,7 +3128,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
  * transaction, and VFS/VM ensures that ext4_truncate() cannot run
  * simultaneously on behalf of the same inode.
  *
- * As we work through the truncate and commmit bits of it to the journal there
+ * As we work through the truncate and commit bits of it to the journal there
  * is one core, guiding principle: the file's tree must always be consistent on
  * disk.  We must be able to restart the truncate after a crash.
  *
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3787ec1..4e65380 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -554,7 +554,7 @@ static int nfsd4_sanitize_slot_size(u32 size)
 /*
  * XXX: If we run out of reserved DRC memory we could (up to a point)
  * re-negotiate active sessions and reduce their slot usage to make
- * rooom for new connections. For now we just fail the create session.
+ * room for new connections. For now we just fail the create session.
  */
 static int nfsd4_get_drc_mem(int slotsize, u32 num)
 {
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index de4ea1a..199c606 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2108,7 +2108,7 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		 * remove_suid() calls ->setattr without any hint that
 		 * we may have already done our cluster locking. Since
 		 * ocfs2_setattr() *must* take cluster locks to
-		 * proceeed, this will lead us to recursively lock the
+		 * proceed, this will lead us to recursively lock the
 		 * inode. There's also the dinode i_size state which
 		 * can be lost via setattr during extending writes (we
 		 * set inode->i_size at the end of a write. */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7f7b424..cf91287 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -183,10 +183,10 @@ xfs_file_fsync(
 
 	/*
 	 * First check if the VFS inode is marked dirty.  All the dirtying
-	 * of non-transactional updates no goes through mark_inode_dirty*,
-	 * which allows us to distinguish beteeen pure timestamp updates
+	 * of non-transactional updates do not go through mark_inode_dirty*,
+	 * which allows us to distinguish between pure timestamp updates
 	 * and i_size updates which need to be caught for fdatasync.
-	 * After that also theck for the dirty state in the XFS inode, which
+	 * After that also check for the dirty state in the XFS inode, which
 	 * might gets cleared when the inode gets written out via the AIL
 	 * or xfs_iflush_cluster.
 	 */
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index c7755d5..3ba29b1 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -256,7 +256,7 @@ xfs_cil_prepare_item(
  * Insert the log items into the CIL and calculate the difference in space
  * consumed by the item. Add the space to the checkpoint ticket and calculate
  * if the change requires additional log metadata. If it does, take that space
- * as well. Remove the amount of space we addded to the checkpoint ticket from
+ * as well. Remove the amount of space we added to the checkpoint ticket from
  * the current transaction ticket so that the accounting works out correctly.
  */
 static void
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 9b7c2bb..ab98697 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -819,7 +819,7 @@ struct drm_driver {
 	 * Specifically, the timestamp in @vblank_time should correspond as
 	 * closely as possible to the time when the first video scanline of
 	 * the video frame after the end of VBLANK will start scanning out,
-	 * the time immmediately after end of the VBLANK interval. If the
+	 * the time immediately after end of the VBLANK interval. If the
 	 * @crtc is currently inside VBLANK, this will be a time in the future.
 	 * If the @crtc is currently scanning out a frame, this will be the
 	 * past start time of the current scanout. This is meant to adhere
diff --git a/include/linux/wanrouter.h b/include/linux/wanrouter.h
index e0aa396..3157cc1 100644
--- a/include/linux/wanrouter.h
+++ b/include/linux/wanrouter.h
@@ -309,7 +309,7 @@ typedef struct wandev_conf
 #define WANOPT_EVEN	2
 
 /* CHDLC Protocol Options */
-/* DF Commmented out for now.
+/* DF Commented out for now.
 
 #define WANOPT_CHDLC_NO_DCD		IGNORE_DCD_FOR_LINK_STAT
 #define WANOPT_CHDLC_NO_CTS		IGNORE_CTS_FOR_LINK_STAT
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9259e97..6400ba4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1389,7 +1389,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * DOC: Beacon filter support
  *
  * Some hardware have beacon filter support to reduce host cpu wakeups
- * which will reduce system power consumption. It usuallly works so that
+ * which will reduce system power consumption. It usually works so that
  * the firmware creates a checksum of the beacon but omits all constantly
  * changing elements (TSF, TIM etc). Whenever the checksum changes the
  * beacon is forwarded to the host, otherwise it will be just dropped. That
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 0e0ab98..b4544c6 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -392,7 +392,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	/* Is this the final fragment? */
 	if ((flags & IP_MF) == 0) {
 		/* If we already have some bits beyond end
-		 * or have different end, the segment is corrrupted.
+		 * or have different end, the segment is corrupted.
 		 */
 		if (end < qp->q.len ||
 		    ((qp->q.last_in & INET_FRAG_LAST_IN) && end != qp->q.len))
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 380b9a7..cdd7ea0 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1097,7 +1097,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		local->tmp_channel = NULL;
 		/* If tmp_channel wasn't operating channel, then
 		 * we need to go back on-channel.
-		 * NOTE:  If we can ever be here while scannning,
+		 * NOTE:  If we can ever be here while scanning,
 		 * or if the hw_config() channel config logic changes,
 		 * then we may need to do a more thorough check to see if
 		 * we still need to do a hardware config.  Currently,
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index c8cc24e..68a385d 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -415,7 +415,7 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
 	sctp_subtype_t subtype;
 	sctp_state_t state;
 	int error = 0;
-	int first_time = 1;	/* is this the first time through the looop */
+	int first_time = 1;	/* is this the first time through the loop */
 
 	if (ep->base.dead)
 		return;
diff --git a/tools/power/cpupower/debug/i386/intel_gsic.c b/tools/power/cpupower/debug/i386/intel_gsic.c
index 53f5293..95ce4a6 100644
--- a/tools/power/cpupower/debug/i386/intel_gsic.c
+++ b/tools/power/cpupower/debug/i386/intel_gsic.c
@@ -53,7 +53,7 @@ int main (void)
 			       "RISK.\n");
 		}
 		if ((r.ebx & 0xffff) != 0xb2) {
-			printf("non-default command port. If speedstep-smi "
+			printf("non-default command port. If spedstep-smi "
 			       "doesn't work out of the box,\nyou may want to "
 			       "try out the default value by passing "
 			       "smi_port=0x82 to the module\n ON YOUR OWN "
-- 
1.7.6

