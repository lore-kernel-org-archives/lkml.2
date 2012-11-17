Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2KQEIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 23:08:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55210 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab2KQEIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 23:08:21 -0500
Message-ID: <1353125282.4867.97.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.34
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Sat, 17 Nov 2012 04:08:02 +0000
In-Reply-To: <1353125193.4867.95.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-CbXBT53z/rtTP0z8+X42"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CbXBT53z/rtTP0z8+X42
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/fea=
ture-removal-schedule.txt
index 3d84912..47c4ec2 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,14 +6,6 @@ be removed from this file.
=20
 ---------------------------
=20
-What:	x86 floppy disable_hlt
-When:	2012
-Why:	ancient workaround of dubious utility clutters the
-	code used by everybody else.
-Who:	Len Brown <len.brown@intel.com>
-
----------------------------
-
 What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
 When:	2012
 Why:	This optional sub-feature of APM is of dubious reliability,
diff --git a/Makefile b/Makefile
index 63ca1ea2..14ebacf 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 33
+SUBLEVEL =3D 34
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/a=
t91rm9200_devices.c
index 143eebb..929fd91 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -462,7 +462,7 @@ static struct i2c_gpio_platform_data pdata =3D {
=20
 static struct platform_device at91rm9200_twi_device =3D {
 	.name			=3D "i2c-gpio",
-	.id			=3D -1,
+	.id			=3D 0,
 	.dev.platform_data	=3D &pdata,
 };
=20
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/=
at91sam9260_devices.c
index 2590988..465e026 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -467,7 +467,7 @@ static struct i2c_gpio_platform_data pdata =3D {
=20
 static struct platform_device at91sam9260_twi_device =3D {
 	.name			=3D "i2c-gpio",
-	.id			=3D -1,
+	.id			=3D 0,
 	.dev.platform_data	=3D &pdata,
 };
=20
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/=
at91sam9261_devices.c
index daf3e66..d6d1e76 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -284,7 +284,7 @@ static struct i2c_gpio_platform_data pdata =3D {
=20
 static struct platform_device at91sam9261_twi_device =3D {
 	.name			=3D "i2c-gpio",
-	.id			=3D -1,
+	.id			=3D 0,
 	.dev.platform_data	=3D &pdata,
 };
=20
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/=
at91sam9263_devices.c
index 32a7e43..e051376e 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -540,7 +540,7 @@ static struct i2c_gpio_platform_data pdata =3D {
=20
 static struct platform_device at91sam9263_twi_device =3D {
 	.name			=3D "i2c-gpio",
-	.id			=3D -1,
+	.id			=3D 0,
 	.dev.platform_data	=3D &pdata,
 };
=20
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/a=
t91sam9rl_devices.c
index 628eb56..4862b23 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -319,7 +319,7 @@ static struct i2c_gpio_platform_data pdata =3D {
=20
 static struct platform_device at91sam9rl_twi_device =3D {
 	.name			=3D "i2c-gpio",
-	.id			=3D -1,
+	.id			=3D 0,
 	.dev.platform_data	=3D &pdata,
 };
=20
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index f5bbe0ef..0d264bf 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -163,7 +163,7 @@ static void __init soc_detect(u32 dbgu_base)
 	}
=20
 	/* at91sam9g10 */
-	if ((cidr & ~AT91_CIDR_EXT) =3D=3D ARCH_ID_AT91SAM9G10) {
+	if ((socid & ~AT91_CIDR_EXT) =3D=3D ARCH_ID_AT91SAM9G10) {
 		at91_soc_initdata.type =3D AT91_SOC_SAM9G10;
 		at91_boot_soc =3D at91sam9261_soc;
 	}
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 2d2f01c..d75adff 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -93,10 +93,6 @@ do {									\
 			"memory");					\
 } while (0)
=20
-/*
- * disable hlt during certain critical i/o operations
- */
-#define HAVE_DISABLE_HLT
 #else
=20
 /* frame pointer must be last for get_wchan */
@@ -392,9 +388,6 @@ static inline void clflush(volatile void *__p)
=20
 #define nop() asm volatile ("nop")
=20
-void disable_hlt(void);
-void enable_hlt(void);
-
 void cpu_idle_wait(void);
=20
 extern unsigned long arch_align_stack(unsigned long sp);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ee5d4fb..59b9b37 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -341,34 +341,10 @@ void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
 #endif
=20
-#ifdef CONFIG_X86_32
-/*
- * This halt magic was a workaround for ancient floppy DMA
- * wreckage. It should be safe to remove.
- */
-static int hlt_counter;
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-EXPORT_SYMBOL(enable_hlt);
-
-static inline int hlt_use_halt(void)
-{
-	return (!hlt_counter && boot_cpu_data.hlt_works_ok);
-}
-#else
 static inline int hlt_use_halt(void)
 {
 	return 1;
 }
-#endif
=20
 /*
  * We use this if we don't have any better
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index ec3d603..2b8b0de 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1203,6 +1203,25 @@ unsigned long xen_read_cr2_direct(void)
 	return percpu_read(xen_vcpu_info.arch.cr2);
 }
=20
+void xen_flush_tlb_all(void)
+{
+	struct mmuext_op *op;
+	struct multicall_space mcs;
+
+	trace_xen_mmu_flush_tlb_all(0);
+
+	preempt_disable();
+
+	mcs =3D xen_mc_entry(sizeof(*op));
+
+	op =3D mcs.args;
+	op->cmd =3D MMUEXT_TLB_FLUSH_ALL;
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
+}
 static void xen_flush_tlb(void)
 {
 	struct mmuext_op *op;
@@ -2366,7 +2385,7 @@ int xen_remap_domain_mfn_range(struct vm_area_struct =
*vma,
 	err =3D 0;
 out:
=20
-	flush_tlb_all();
+	xen_flush_tlb_all();
=20
 	return err;
 }
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 671d4d6..7bdd61b 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -137,13 +137,18 @@ static void cryptd_queue_worker(struct work_struct *w=
ork)
 	struct crypto_async_request *req, *backlog;
=20
 	cpu_queue =3D container_of(work, struct cryptd_cpu_queue, work);
-	/* Only handle one request at a time to avoid hogging crypto
-	 * workqueue. preempt_disable/enable is used to prevent
-	 * being preempted by cryptd_enqueue_request() */
+	/*
+	 * Only handle one request at a time to avoid hogging crypto workqueue.
+	 * preempt_disable/enable is used to prevent being preempted by
+	 * cryptd_enqueue_request(). local_bh_disable/enable is used to prevent
+	 * cryptd_enqueue_request() being accessed from software interrupts.
+	 */
+	local_bh_disable();
 	preempt_disable();
 	backlog =3D crypto_get_backlog(&cpu_queue->queue);
 	req =3D crypto_dequeue_request(&cpu_queue->queue);
 	preempt_enable();
+	local_bh_enable();
=20
 	if (!req)
 		return;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index c864add..7a90d4a 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1032,37 +1032,6 @@ static int fd_wait_for_completion(unsigned long dela=
y, timeout_fn function)
 	return 0;
 }
=20
-static DEFINE_SPINLOCK(floppy_hlt_lock);
-static int hlt_disabled;
-static void floppy_disable_hlt(void)
-{
-	unsigned long flags;
-
-	WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2012");
-	spin_lock_irqsave(&floppy_hlt_lock, flags);
-	if (!hlt_disabled) {
-		hlt_disabled =3D 1;
-#ifdef HAVE_DISABLE_HLT
-		disable_hlt();
-#endif
-	}
-	spin_unlock_irqrestore(&floppy_hlt_lock, flags);
-}
-
-static void floppy_enable_hlt(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&floppy_hlt_lock, flags);
-	if (hlt_disabled) {
-		hlt_disabled =3D 0;
-#ifdef HAVE_DISABLE_HLT
-		enable_hlt();
-#endif
-	}
-	spin_unlock_irqrestore(&floppy_hlt_lock, flags);
-}
-
 static void setup_DMA(void)
 {
 	unsigned long f;
@@ -1107,7 +1076,6 @@ static void setup_DMA(void)
 	fd_enable_dma();
 	release_dma_lock(f);
 #endif
-	floppy_disable_hlt();
 }
=20
 static void show_floppy(void);
@@ -1709,7 +1677,6 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 	fd_disable_dma();
 	release_dma_lock(f);
=20
-	floppy_enable_hlt();
 	do_floppy =3D NULL;
 	if (fdc >=3D N_FDC || FDCS->address =3D=3D -1) {
 		/* we don't even know which FDC is the culprit */
@@ -1858,8 +1825,6 @@ static void floppy_shutdown(unsigned long data)
 		show_floppy();
 	cancel_activity();
=20
-	floppy_enable_hlt();
-
 	flags =3D claim_dma_lock();
 	fd_disable_dma();
 	release_dma_lock(flags);
@@ -4198,6 +4163,7 @@ static int __init floppy_init(void)
=20
 		disks[dr]->queue =3D blk_init_queue(do_fd_request, &floppy_lock);
 		if (!disks[dr]->queue) {
+			put_disk(disks[dr]);
 			err =3D -ENOMEM;
 			goto out_put_disk;
 		}
@@ -4339,7 +4305,7 @@ static int __init floppy_init(void)
=20
 		err =3D platform_device_register(&floppy_device[drive]);
 		if (err)
-			goto out_flush_work;
+			goto out_remove_drives;
=20
 		err =3D device_create_file(&floppy_device[drive].dev,
 					 &dev_attr_cmos);
@@ -4357,6 +4323,15 @@ static int __init floppy_init(void)
=20
 out_unreg_platform_dev:
 	platform_device_unregister(&floppy_device[drive]);
+out_remove_drives:
+	while (drive--) {
+		if ((allowed_drive_mask & (1 << drive)) &&
+		    fdc_state[FDC(drive)].version !=3D FDC_NONE) {
+			del_gendisk(disks[drive]);
+			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
+			platform_device_unregister(&floppy_device[drive]);
+		}
+	}
 out_flush_work:
 	flush_work_sync(&floppy_work);
 	if (atomic_read(&usage_count))
@@ -4510,7 +4485,6 @@ static void floppy_release_irq_and_dma(void)
 #if N_FDC > 1
 	set_dor(1, ~8, 0);
 #endif
-	floppy_enable_hlt();
=20
 	if (floppy_track_buffer && max_buffer_sectors) {
 		tmpsize =3D max_buffer_sectors * 1024;
diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdale.=
c
index c593bd4..edff410 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -116,7 +116,7 @@ static void timbgpio_irq_disable(struct irq_data *d)
 	unsigned long flags;
=20
 	spin_lock_irqsave(&tgpio->lock, flags);
-	tgpio->last_ier &=3D ~(1 << offset);
+	tgpio->last_ier &=3D ~(1UL << offset);
 	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
 	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
@@ -128,7 +128,7 @@ static void timbgpio_irq_enable(struct irq_data *d)
 	unsigned long flags;
=20
 	spin_lock_irqsave(&tgpio->lock, flags);
-	tgpio->last_ier |=3D 1 << offset;
+	tgpio->last_ier |=3D 1UL << offset;
 	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
 	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 828bf65..020b103 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -136,8 +136,11 @@ int drm_open(struct inode *inode, struct file *filp)
 	retcode =3D drm_open_helper(inode, filp, dev);
 	if (!retcode) {
 		atomic_inc(&dev->counts[_DRM_STAT_OPENS]);
-		if (!dev->open_count++)
+		if (!dev->open_count++) {
 			retcode =3D drm_setup(dev);
+			if (retcode)
+				dev->open_count--;
+		}
 	}
 	if (!retcode) {
 		mutex_lock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_=
drv.h
index 83e820e..bcadf74 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -227,12 +227,12 @@ struct dip_infoframe {
 			uint16_t bottom_bar_start;
 			uint16_t left_bar_end;
 			uint16_t right_bar_start;
-		} avi;
+		} __attribute__ ((packed)) avi;
 		struct {
 			uint8_t vn[8];
 			uint8_t pd[16];
 			uint8_t sdi;
-		} spd;
+		} __attribute__ ((packed)) spd;
 		uint8_t payload[27];
 	} __attribute__ ((packed)) body;
 } __attribute__((packed));
diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/in=
tel_overlay.c
index cdf17d4..478b51f 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -428,9 +428,17 @@ static int intel_overlay_off(struct intel_overlay *ove=
rlay)
 	OUT_RING(flip_addr);
 	OUT_RING(MI_WAIT_FOR_EVENT | MI_WAIT_FOR_OVERLAY_FLIP);
 	/* turn overlay off */
-	OUT_RING(MI_OVERLAY_FLIP | MI_OVERLAY_OFF);
-	OUT_RING(flip_addr);
-	OUT_RING(MI_WAIT_FOR_EVENT | MI_WAIT_FOR_OVERLAY_FLIP);
+	if (IS_I830(dev)) {
+		/* Workaround: Don't disable the overlay fully, since otherwise
+		 * it dies on the next OVERLAY_ON cmd. */
+		OUT_RING(MI_NOOP);
+		OUT_RING(MI_NOOP);
+		OUT_RING(MI_NOOP);
+	} else {
+		OUT_RING(MI_OVERLAY_FLIP | MI_OVERLAY_OFF);
+		OUT_RING(flip_addr);
+		OUT_RING(MI_WAIT_FOR_EVENT | MI_WAIT_FOR_OVERLAY_FLIP);
+	}
 	ADVANCE_LP_RING();
=20
 	return intel_overlay_do_wait_request(overlay, request,
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel=
_sdvo.c
index bbf247c..3f4afba 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -868,31 +868,38 @@ static void intel_sdvo_dump_hdmi_buf(struct intel_sdv=
o *intel_sdvo)
 }
 #endif
=20
-static bool intel_sdvo_set_avi_infoframe(struct intel_sdvo *intel_sdvo)
+static bool intel_sdvo_write_infoframe(struct intel_sdvo *intel_sdvo,
+				       unsigned if_index, uint8_t tx_rate,
+				       uint8_t *data, unsigned length)
 {
-	struct dip_infoframe avi_if =3D {
-		.type =3D DIP_TYPE_AVI,
-		.ver =3D DIP_VERSION_AVI,
-		.len =3D DIP_LEN_AVI,
-	};
-	uint8_t tx_rate =3D SDVO_HBUF_TX_VSYNC;
-	uint8_t set_buf_index[2] =3D { 1, 0 };
-	uint64_t *data =3D (uint64_t *)&avi_if;
-	unsigned i;
-
-	intel_dip_infoframe_csum(&avi_if);
+	uint8_t set_buf_index[2] =3D { if_index, 0 };
+	uint8_t hbuf_size, tmp[8];
+	int i;
=20
 	if (!intel_sdvo_set_value(intel_sdvo,
 				  SDVO_CMD_SET_HBUF_INDEX,
 				  set_buf_index, 2))
 		return false;
=20
-	for (i =3D 0; i < sizeof(avi_if); i +=3D 8) {
+	if (!intel_sdvo_get_value(intel_sdvo, SDVO_CMD_GET_HBUF_INFO,
+				  &hbuf_size, 1))
+		return false;
+
+	/* Buffer size is 0 based, hooray! */
+	hbuf_size++;
+
+	DRM_DEBUG_KMS("writing sdvo hbuf: %i, hbuf_size %i, hbuf_size: %i\n",
+		      if_index, length, hbuf_size);
+
+	for (i =3D 0; i < hbuf_size; i +=3D 8) {
+		memset(tmp, 0, 8);
+		if (i < length)
+			memcpy(tmp, data + i, min_t(unsigned, 8, length - i));
+
 		if (!intel_sdvo_set_value(intel_sdvo,
 					  SDVO_CMD_SET_HBUF_DATA,
-					  data, 8))
+					  tmp, 8))
 			return false;
-		data++;
 	}
=20
 	return intel_sdvo_set_value(intel_sdvo,
@@ -900,6 +907,28 @@ static bool intel_sdvo_set_avi_infoframe(struct intel_=
sdvo *intel_sdvo)
 				    &tx_rate, 1);
 }
=20
+static bool intel_sdvo_set_avi_infoframe(struct intel_sdvo *intel_sdvo)
+{
+	struct dip_infoframe avi_if =3D {
+		.type =3D DIP_TYPE_AVI,
+		.ver =3D DIP_VERSION_AVI,
+		.len =3D DIP_LEN_AVI,
+	};
+	uint8_t sdvo_data[4 + sizeof(avi_if.body.avi)];
+
+	intel_dip_infoframe_csum(&avi_if);
+
+	/* sdvo spec says that the ecc is handled by the hw, and it looks like
+	 * we must not send the ecc field, either. */
+	memcpy(sdvo_data, &avi_if, 3);
+	sdvo_data[3] =3D avi_if.checksum;
+	memcpy(&sdvo_data[4], &avi_if.body, sizeof(avi_if.body.avi));
+
+	return intel_sdvo_write_infoframe(intel_sdvo, SDVO_HBUF_INDEX_AVI_IF,
+					  SDVO_HBUF_TX_VSYNC,
+					  sdvo_data, sizeof(sdvo_data));
+}
+
 static bool intel_sdvo_set_tv_format(struct intel_sdvo *intel_sdvo)
 {
 	struct intel_sdvo_tv_format format;
diff --git a/drivers/gpu/drm/i915/intel_sdvo_regs.h b/drivers/gpu/drm/i915/=
intel_sdvo_regs.h
index 372f33b..4193c54 100644
--- a/drivers/gpu/drm/i915/intel_sdvo_regs.h
+++ b/drivers/gpu/drm/i915/intel_sdvo_regs.h
@@ -708,6 +708,8 @@ struct intel_sdvo_enhancements_arg {
 #define SDVO_CMD_SET_AUDIO_STAT		0x91
 #define SDVO_CMD_GET_AUDIO_STAT		0x92
 #define SDVO_CMD_SET_HBUF_INDEX		0x93
+  #define SDVO_HBUF_INDEX_ELD		0
+  #define SDVO_HBUF_INDEX_AVI_IF	1
 #define SDVO_CMD_GET_HBUF_INDEX		0x94
 #define SDVO_CMD_GET_HBUF_INFO		0x95
 #define SDVO_CMD_SET_HBUF_AV_SPLIT	0x96
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouvea=
u/nouveau_drv.c
index 9791d13..8c084c0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -178,8 +178,10 @@ nouveau_pci_suspend(struct pci_dev *pdev, pm_message_t=
 pm_state)
 	if (dev->switch_power_state =3D=3D DRM_SWITCH_POWER_OFF)
 		return 0;
=20
-	NV_INFO(dev, "Disabling fbcon acceleration...\n");
-	nouveau_fbcon_save_disable_accel(dev);
+	if (dev->mode_config.num_crtc) {
+		NV_INFO(dev, "Disabling fbcon acceleration...\n");
+		nouveau_fbcon_save_disable_accel(dev);
+	}
=20
 	NV_INFO(dev, "Unpinning framebuffer(s)...\n");
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
@@ -246,10 +248,12 @@ nouveau_pci_suspend(struct pci_dev *pdev, pm_message_=
t pm_state)
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
=20
-	console_lock();
-	nouveau_fbcon_set_suspend(dev, 1);
-	console_unlock();
-	nouveau_fbcon_restore_accel(dev);
+	if (dev->mode_config.num_crtc) {
+		console_lock();
+		nouveau_fbcon_set_suspend(dev, 1);
+		console_unlock();
+		nouveau_fbcon_restore_accel(dev);
+	}
 	return 0;
=20
 out_abort:
@@ -275,7 +279,8 @@ nouveau_pci_resume(struct pci_dev *pdev)
 	if (dev->switch_power_state =3D=3D DRM_SWITCH_POWER_OFF)
 		return 0;
=20
-	nouveau_fbcon_save_disable_accel(dev);
+	if (dev->mode_config.num_crtc)
+		nouveau_fbcon_save_disable_accel(dev);
=20
 	NV_INFO(dev, "We're back, enabling device...\n");
 	pci_set_power_state(pdev, PCI_D0);
@@ -376,15 +381,18 @@ nouveau_pci_resume(struct pci_dev *pdev)
 		nv_crtc->lut.depth =3D 0;
 	}
=20
-	console_lock();
-	nouveau_fbcon_set_suspend(dev, 0);
-	console_unlock();
+	if (dev->mode_config.num_crtc) {
+		console_lock();
+		nouveau_fbcon_set_suspend(dev, 0);
+		console_unlock();
=20
-	nouveau_fbcon_zfill_all(dev);
+		nouveau_fbcon_zfill_all(dev);
+	}
=20
 	drm_helper_resume_force_mode(dev);
=20
-	nouveau_fbcon_restore_accel(dev);
+	if (dev->mode_config.num_crtc)
+		nouveau_fbcon_restore_accel(dev);
 	return 0;
 }
=20
@@ -466,9 +474,7 @@ static int __init nouveau_init(void)
 #ifdef CONFIG_VGA_CONSOLE
 		if (vgacon_text_force())
 			nouveau_modeset =3D 0;
-		else
 #endif
-			nouveau_modeset =3D 1;
 	}
=20
 	if (!nouveau_modeset)
diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouv=
eau/nouveau_state.c
index d8831ab..01adcfb 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -46,6 +46,7 @@ static int nouveau_init_engine_ptrs(struct drm_device *de=
v)
 {
 	struct drm_nouveau_private *dev_priv =3D dev->dev_private;
 	struct nouveau_engine *engine =3D &dev_priv->engine;
+	u32 pclass =3D dev->pdev->class >> 8;
=20
 	switch (dev_priv->chipset & 0xf0) {
 	case 0x00:
@@ -481,7 +482,8 @@ static int nouveau_init_engine_ptrs(struct drm_device *=
dev)
 	}
=20
 	/* headless mode */
-	if (nouveau_modeset =3D=3D 2) {
+	if (nouveau_modeset =3D=3D 2 ||
+	    (nouveau_modeset < 0 && pclass !=3D PCI_CLASS_DISPLAY_VGA)) {
 		engine->display.early_init =3D nouveau_stub_init;
 		engine->display.late_takedown =3D nouveau_stub_takedown;
 		engine->display.create =3D nouveau_stub_init;
diff --git a/drivers/gpu/drm/nouveau/nv04_dac.c b/drivers/gpu/drm/nouveau/n=
v04_dac.c
index e000455..2d6bfd0 100644
--- a/drivers/gpu/drm/nouveau/nv04_dac.c
+++ b/drivers/gpu/drm/nouveau/nv04_dac.c
@@ -209,7 +209,7 @@ out:
 	NVWriteVgaCrtc(dev, 0, NV_CIO_CR_MODE_INDEX, saved_cr_mode);
=20
 	if (blue =3D=3D 0x18) {
-		NV_INFO(dev, "Load detected on head A\n");
+		NV_DEBUG(dev, "Load detected on head A\n");
 		return connector_status_connected;
 	}
=20
@@ -323,7 +323,7 @@ nv17_dac_detect(struct drm_encoder *encoder, struct drm=
_connector *connector)
=20
 	if (nv17_dac_sample_load(encoder) &
 	    NV_PRAMDAC_TEST_CONTROL_SENSEB_ALLHI) {
-		NV_INFO(dev, "Load detected on output %c\n",
+		NV_DEBUG(dev, "Load detected on output %c\n",
 			'@' + ffs(dcb->or));
 		return connector_status_connected;
 	} else {
@@ -398,7 +398,7 @@ static void nv04_dac_commit(struct drm_encoder *encoder=
)
=20
 	helper->dpms(encoder, DRM_MODE_DPMS_ON);
=20
-	NV_INFO(dev, "Output %s is running on CRTC %d using output %c\n",
+	NV_DEBUG(dev, "Output %s is running on CRTC %d using output %c\n",
 		drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base)=
,
 		nv_crtc->index, '@' + ffs(nv_encoder->dcb->or));
 }
@@ -447,7 +447,7 @@ static void nv04_dac_dpms(struct drm_encoder *encoder, =
int mode)
 		return;
 	nv_encoder->last_dpms =3D mode;
=20
-	NV_INFO(dev, "Setting dpms mode %d on vga encoder (output %d)\n",
+	NV_DEBUG(dev, "Setting dpms mode %d on vga encoder (output %d)\n",
 		     mode, nv_encoder->dcb->index);
=20
 	nv04_dac_update_dacclk(encoder, mode =3D=3D DRM_MODE_DPMS_ON);
diff --git a/drivers/gpu/drm/nouveau/nv04_dfp.c b/drivers/gpu/drm/nouveau/n=
v04_dfp.c
index 12098bf..752440c 100644
--- a/drivers/gpu/drm/nouveau/nv04_dfp.c
+++ b/drivers/gpu/drm/nouveau/nv04_dfp.c
@@ -468,7 +468,7 @@ static void nv04_dfp_commit(struct drm_encoder *encoder=
)
=20
 	helper->dpms(encoder, DRM_MODE_DPMS_ON);
=20
-	NV_INFO(dev, "Output %s is running on CRTC %d using output %c\n",
+	NV_DEBUG(dev, "Output %s is running on CRTC %d using output %c\n",
 		drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base)=
,
 		nv_crtc->index, '@' + ffs(nv_encoder->dcb->or));
 }
@@ -511,7 +511,7 @@ static void nv04_lvds_dpms(struct drm_encoder *encoder,=
 int mode)
 		return;
 	nv_encoder->last_dpms =3D mode;
=20
-	NV_INFO(dev, "Setting dpms mode %d on lvds encoder (output %d)\n",
+	NV_DEBUG(dev, "Setting dpms mode %d on lvds encoder (output %d)\n",
 		     mode, nv_encoder->dcb->index);
=20
 	if (was_powersaving && is_powersaving_dpms(mode))
@@ -556,7 +556,7 @@ static void nv04_tmds_dpms(struct drm_encoder *encoder,=
 int mode)
 		return;
 	nv_encoder->last_dpms =3D mode;
=20
-	NV_INFO(dev, "Setting dpms mode %d on tmds encoder (output %d)\n",
+	NV_DEBUG(dev, "Setting dpms mode %d on tmds encoder (output %d)\n",
 		     mode, nv_encoder->dcb->index);
=20
 	nv04_dfp_update_backlight(encoder, mode);
diff --git a/drivers/gpu/drm/nouveau/nv04_tv.c b/drivers/gpu/drm/nouveau/nv=
04_tv.c
index 3eb605d..4de1fbe 100644
--- a/drivers/gpu/drm/nouveau/nv04_tv.c
+++ b/drivers/gpu/drm/nouveau/nv04_tv.c
@@ -69,7 +69,7 @@ static void nv04_tv_dpms(struct drm_encoder *encoder, int=
 mode)
 	struct nv04_mode_state *state =3D &dev_priv->mode_reg;
 	uint8_t crtc1A;
=20
-	NV_INFO(dev, "Setting dpms mode %d on TV encoder (output %d)\n",
+	NV_DEBUG(dev, "Setting dpms mode %d on TV encoder (output %d)\n",
 		mode, nv_encoder->dcb->index);
=20
 	state->pllsel &=3D ~(PLLSEL_TV_CRTC1_MASK | PLLSEL_TV_CRTC2_MASK);
@@ -162,7 +162,7 @@ static void nv04_tv_commit(struct drm_encoder *encoder)
=20
 	helper->dpms(encoder, DRM_MODE_DPMS_ON);
=20
-	NV_INFO(dev, "Output %s is running on CRTC %d using output %c\n",
+	NV_DEBUG(dev, "Output %s is running on CRTC %d using output %c\n",
 		      drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)-=
>base), nv_crtc->index,
 		      '@' + ffs(nv_encoder->dcb->or));
 }
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/ev=
ergreen.c
index b61f490..ca94e23 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1164,7 +1164,7 @@ void evergreen_mc_resume(struct radeon_device *rdev, =
struct evergreen_mc_save *s
 	WREG32(BIF_FB_EN, FB_READ_EN | FB_WRITE_EN);
=20
 	for (i =3D 0; i < rdev->num_crtc; i++) {
-		if (save->crtc_enabled) {
+		if (save->crtc_enabled[i]) {
 			tmp =3D RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 			tmp &=3D ~EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
 			WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/=
drm/radeon/radeon_legacy_encoders.c
index 3ad3cc6..8165953 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -650,6 +650,7 @@ static enum drm_connector_status radeon_legacy_primary_=
dac_detect(struct drm_enc
 	tmp |=3D RADEON_DAC_RANGE_CNTL_PS2 | RADEON_DAC_CMP_EN;
 	WREG32(RADEON_DAC_CNTL, tmp);
=20
+	tmp =3D dac_macro_cntl;
 	tmp &=3D ~(RADEON_DAC_PDWN_R |
 		 RADEON_DAC_PDWN_G |
 		 RADEON_DAC_PDWN_B);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c b/drivers/gpu/drm/vmwgf=
x/vmwgfx_dmabuf.c
index 3fa884d..27151f7 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
@@ -306,7 +306,7 @@ void vmw_bo_pin(struct ttm_buffer_object *bo, bool pin)
=20
 	BUG_ON(!atomic_read(&bo->reserved));
 	BUG_ON(old_mem_type !=3D TTM_PL_VRAM &&
-	       old_mem_type !=3D VMW_PL_FLAG_GMR);
+	       old_mem_type !=3D VMW_PL_GMR);
=20
 	pl_flags =3D TTM_PL_FLAG_VRAM | VMW_PL_FLAG_GMR | TTM_PL_FLAG_CACHED;
 	if (pin)
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/v=
mwgfx_drv.c
index 033fc96..b639536 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1048,6 +1048,11 @@ static void vmw_pm_complete(struct device *kdev)
 	struct drm_device *dev =3D pci_get_drvdata(pdev);
 	struct vmw_private *dev_priv =3D vmw_priv(dev);
=20
+	mutex_lock(&dev_priv->hw_mutex);
+	vmw_write(dev_priv, SVGA_REG_ID, SVGA_ID_2);
+	(void) vmw_read(dev_priv, SVGA_REG_ID);
+	mutex_unlock(&dev_priv->hw_mutex);
+
 	/**
 	 * Reclaim 3d reference held by fbdev and potentially
 	 * start fifo.
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index e5c699b..3899989 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -29,22 +29,30 @@
 #define MS_RDESC		0x08
 #define MS_NOGET		0x10
 #define MS_DUPLICATE_USAGES	0x20
+#define MS_RDESC_3K		0x40
=20
-/*
- * Microsoft Wireless Desktop Receiver (Model 1028) has
- * 'Usage Min/Max' where it ought to have 'Physical Min/Max'
- */
 static __u8 *ms_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	unsigned long quirks =3D (unsigned long)hid_get_drvdata(hdev);
=20
+	/*
+	 * Microsoft Wireless Desktop Receiver (Model 1028) has
+	 * 'Usage Min/Max' where it ought to have 'Physical Min/Max'
+	 */
 	if ((quirks & MS_RDESC) && *rsize =3D=3D 571 && rdesc[557] =3D=3D 0x19 &&
 			rdesc[559] =3D=3D 0x29) {
 		hid_info(hdev, "fixing up Microsoft Wireless Receiver Model 1028 report =
descriptor\n");
 		rdesc[557] =3D 0x35;
 		rdesc[559] =3D 0x45;
 	}
+	/* the same as above (s/usage/physical/) */
+	if ((quirks & MS_RDESC_3K) && *rsize =3D=3D 106 &&
+			!memcmp((char []){ 0x19, 0x00, 0x29, 0xff },
+				&rdesc[94], 4)) {
+		rdesc[94] =3D 0x35;
+		rdesc[96] =3D 0x45;
+	}
 	return rdesc;
 }
=20
@@ -193,7 +201,7 @@ static const struct hid_device_id ms_devices[] =3D {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_U=
SB),
 		.driver_data =3D MS_PRESENTER },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_DIGITAL_MEDIA_=
3K),
-		.driver_data =3D MS_ERGONOMY },
+		.driver_data =3D MS_ERGONOMY | MS_RDESC_3K },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_=
DESKTOP_3_0),
 		.driver_data =3D MS_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_=
4500),
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index ceaec92..b6a3ce3 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -2015,6 +2015,7 @@ static int __devinit w83627ehf_probe(struct platform_=
device *pdev)
 	mutex_init(&data->lock);
 	mutex_init(&data->update_lock);
 	data->name =3D w83627ehf_device_names[sio_data->kind];
+	data->bank =3D 0xff;		/* Force initial bank selection */
 	platform_set_drvdata(pdev, data);
=20
 	/* 627EHG and 627EHF have 10 voltage inputs; 627DHG and 667HG have 9 */
diff --git a/drivers/input/touchscreen/tsc40.c b/drivers/input/touchscreen/=
tsc40.c
index 29d5ed4..80d4610 100644
--- a/drivers/input/touchscreen/tsc40.c
+++ b/drivers/input/touchscreen/tsc40.c
@@ -107,7 +107,6 @@ static int tsc_connect(struct serio *serio, struct seri=
o_driver *drv)
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 	input_set_abs_params(ptsc->dev, ABS_X, 0, 0x3ff, 0, 0);
 	input_set_abs_params(ptsc->dev, ABS_Y, 0, 0x3ff, 0, 0);
-	input_set_abs_params(ptsc->dev, ABS_PRESSURE, 0, 0, 0, 0);
=20
 	serio_set_drvdata(serio, ptsc);
=20
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/mar=
vell/sky2.c
index 11ddd838..69fc888 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -3060,8 +3060,10 @@ static irqreturn_t sky2_intr(int irq, void *dev_id)
=20
 	/* Reading this mask interrupts as side effect */
 	status =3D sky2_read32(hw, B0_Y2_SP_ISRC2);
-	if (status =3D=3D 0 || status =3D=3D ~0)
+	if (status =3D=3D 0 || status =3D=3D ~0) {
+		sky2_write32(hw, B0_Y2_SP_ICR, 2);
 		return IRQ_NONE;
+	}
=20
 	prefetch(&hw->st_le[hw->st_idx]);
=20
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/re=
altek/r8169.c
index 4b43bc5..b8db4cd 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -77,7 +77,7 @@ static const int multicast_filter_limit =3D 32;
 #define MAC_ADDR_LEN	6
=20
 #define MAX_READ_REQUEST_SHIFT	12
-#define TX_DMA_BURST	6	/* Maximum PCI burst, '6' is 1024 */
+#define TX_DMA_BURST	7	/* Maximum PCI burst, '7' is unlimited */
 #define SafeMtu		0x1c20	/* ... actually life sucks beyond ~7k */
 #define InterFrameGap	0x03	/* 3 means InterFrameGap =3D the shortest one *=
/
=20
@@ -3521,6 +3521,8 @@ static void rtl_wol_suspend_quirk(struct rtl8169_priv=
ate *tp)
 	void __iomem *ioaddr =3D tp->mmio_addr;
=20
 	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_25:
+	case RTL_GIGA_MAC_VER_26:
 	case RTL_GIGA_MAC_VER_29:
 	case RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32:
@@ -6064,6 +6066,9 @@ static void rtl_set_rx_mode(struct net_device *dev)
 		mc_filter[1] =3D swab32(data);
 	}
=20
+	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_35)
+		mc_filter[1] =3D mc_filter[0] =3D 0xffffffff;
+
 	RTL_W32(MAR0 + 4, mc_filter[1]);
 	RTL_W32(MAR0 + 0, mc_filter[0]);
=20
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index b873b5d..dc53a8f 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1156,6 +1156,7 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 		usb_anchor_urb(urb, &dev->deferred);
 		/* no use to process more packets */
 		netif_stop_queue(net);
+		usb_put_urb(urb);
 		spin_unlock_irqrestore(&dev->txq.lock, flags);
 		netdev_dbg(dev->net, "Delaying transmission for resumption\n");
 		goto deferred;
@@ -1297,6 +1298,8 @@ void usbnet_disconnect (struct usb_interface *intf)
=20
 	cancel_work_sync(&dev->kevent);
=20
+	usb_scuttle_anchored_urbs(&dev->deferred);
+
 	if (dev->driver_info->unbind)
 		dev->driver_info->unbind (dev, intf);
=20
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/a=
th/ath9k/xmit.c
index c59c592..18da100 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -288,6 +288,7 @@ static struct ath_buf *ath_tx_get_buffer(struct ath_sof=
tc *sc)
 	}
=20
 	bf =3D list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
+	bf->bf_next =3D NULL;
 	list_del(&bf->list);
=20
 	spin_unlock_bh(&sc->tx.txbuflock);
@@ -369,7 +370,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, =
struct ath_txq *txq,
 	u16 seq_st =3D 0, acked_cnt =3D 0, txfail_cnt =3D 0;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int isaggr, txfail, txpending, sendbar =3D 0, needreset =3D 0, nbad =3D 0=
;
-	bool rc_update =3D true;
+	bool rc_update =3D true, isba;
 	struct ieee80211_tx_rate rates[4];
 	struct ath_frame_info *fi;
 	int nframes;
@@ -407,13 +408,17 @@ static void ath_tx_complete_aggr(struct ath_softc *sc=
, struct ath_txq *txq,
 	an =3D (struct ath_node *)sta->drv_priv;
 	tidno =3D ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
 	tid =3D ATH_AN_2_TID(an, tidno);
+	isba =3D ts->ts_flags & ATH9K_TX_BA;
=20
 	/*
 	 * The hardware occasionally sends a tx status for the wrong TID.
 	 * In this case, the BA status cannot be considered valid and all
 	 * subframes need to be retransmitted
+	 *
+	 * Only BlockAcks have a TID and therefore normal Acks cannot be
+	 * checked
 	 */
-	if (tidno !=3D ts->tid)
+	if (isba && tidno !=3D ts->tid)
 		txok =3D false;
=20
 	isaggr =3D bf_isaggr(bf);
@@ -1710,6 +1715,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, =
struct ath_txq *txq,
 	if (tid)
 		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
=20
+	bf->bf_next =3D NULL;
 	bf->bf_lastbf =3D bf;
 	ath_tx_fill_desc(sc, bf, txq, fi->framelen);
 	ath_tx_txqaddbuf(sc, txq, &bf_head, false);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless=
/rt2x00/rt2800lib.c
index 1ba079d..fb19447 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2141,7 +2141,7 @@ static int rt2800_get_gain_calibration_delta(struct r=
t2x00_dev *rt2x00dev)
 	/*
 	 * Check if temperature compensation is supported.
 	 */
-	if (tssi_bounds[4] =3D=3D 0xff)
+	if (tssi_bounds[4] =3D=3D 0xff || step =3D=3D 0xff)
 		return 0;
=20
 	/*
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index f35cb10..6fa7222 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3523,7 +3523,9 @@ restart:
 		 */
 		iscsit_thread_check_cpumask(conn, current, 1);
=20
-		schedule_timeout_interruptible(MAX_SCHEDULE_TIMEOUT);
+		wait_event_interruptible(conn->queues_wq,
+					 !iscsit_conn_all_queues_empty(conn) ||
+					 ts->status =3D=3D ISCSI_THREAD_SET_RESET);
=20
 		if ((ts->status =3D=3D ISCSI_THREAD_SET_RESET) ||
 		     signal_pending(current))
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscs=
i/iscsi_target_core.h
index dae283f..bd8ce01 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -491,6 +491,7 @@ struct iscsi_tmr_req {
 };
=20
 struct iscsi_conn {
+	wait_queue_head_t	queues_wq;
 	/* Authentication Successful for this connection */
 	u8			auth_complete;
 	/* State connection is currently in */
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/isc=
si/iscsi_target_login.c
index 2ec5339..eb0c9fe 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -44,6 +44,7 @@ extern spinlock_t sess_idr_lock;
=20
 static int iscsi_login_init_conn(struct iscsi_conn *conn)
 {
+	init_waitqueue_head(&conn->queues_wq);
 	INIT_LIST_HEAD(&conn->conn_list);
 	INIT_LIST_HEAD(&conn->conn_cmd_list);
 	INIT_LIST_HEAD(&conn->immed_queue_list);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscs=
i/iscsi_target_util.c
index 99f2af3..e612722 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -659,7 +659,7 @@ void iscsit_add_cmd_to_immediate_queue(
 	atomic_set(&conn->check_immediate_queue, 1);
 	spin_unlock_bh(&conn->immed_queue_lock);
=20
-	wake_up_process(conn->thread_set->tx_thread);
+	wake_up(&conn->queues_wq);
 }
=20
 struct iscsi_queue_req *iscsit_get_cmd_from_immediate_queue(struct iscsi_c=
onn *conn)
@@ -733,7 +733,7 @@ void iscsit_add_cmd_to_response_queue(
 	atomic_inc(&cmd->response_queue_count);
 	spin_unlock_bh(&conn->response_queue_lock);
=20
-	wake_up_process(conn->thread_set->tx_thread);
+	wake_up(&conn->queues_wq);
 }
=20
 struct iscsi_queue_req *iscsit_get_cmd_from_response_queue(struct iscsi_co=
nn *conn)
@@ -787,6 +787,24 @@ static void iscsit_remove_cmd_from_response_queue(
 	}
 }
=20
+bool iscsit_conn_all_queues_empty(struct iscsi_conn *conn)
+{
+	bool empty;
+
+	spin_lock_bh(&conn->immed_queue_lock);
+	empty =3D list_empty(&conn->immed_queue_list);
+	spin_unlock_bh(&conn->immed_queue_lock);
+
+	if (!empty)
+		return empty;
+
+	spin_lock_bh(&conn->response_queue_lock);
+	empty =3D list_empty(&conn->response_queue_list);
+	spin_unlock_bh(&conn->response_queue_lock);
+
+	return empty;
+}
+
 void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *conn)
 {
 	struct iscsi_queue_req *qr, *qr_tmp;
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscs=
i/iscsi_target_util.h
index 835bf7d..cfac698 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -28,6 +28,7 @@ extern struct iscsi_queue_req *iscsit_get_cmd_from_immedi=
ate_queue(struct iscsi_
 extern void iscsit_add_cmd_to_response_queue(struct iscsi_cmd *, struct is=
csi_conn *, u8);
 extern struct iscsi_queue_req *iscsit_get_cmd_from_response_queue(struct i=
scsi_conn *);
 extern void iscsit_remove_cmd_from_tx_queues(struct iscsi_cmd *, struct is=
csi_conn *);
+extern bool iscsit_conn_all_queues_empty(struct iscsi_conn *);
 extern void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *);
 extern void iscsit_release_cmd(struct iscsi_cmd *);
 extern void iscsit_free_cmd(struct iscsi_cmd *);
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_=
core_configfs.c
index 0b01bfc..013b133 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3205,7 +3205,8 @@ static int __init target_core_init_configfs(void)
 	if (ret < 0)
 		goto out;
=20
-	if (core_dev_setup_virtual_lun0() < 0)
+	ret =3D core_dev_setup_virtual_lun0();
+	if (ret < 0)
 		goto out;
=20
 	return 0;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_co=
re_device.c
index f8773ae..a0143a0 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -835,20 +835,20 @@ int se_dev_check_shutdown(struct se_device *dev)
=20
 u32 se_dev_align_max_sectors(u32 max_sectors, u32 block_size)
 {
-	u32 tmp, aligned_max_sectors;
+	u32 aligned_max_sectors;
+	u32 alignment;
 	/*
 	 * Limit max_sectors to a PAGE_SIZE aligned value for modern
 	 * transport_allocate_data_tasks() operation.
 	 */
-	tmp =3D rounddown((max_sectors * block_size), PAGE_SIZE);
-	aligned_max_sectors =3D (tmp / block_size);
-	if (max_sectors !=3D aligned_max_sectors) {
-		printk(KERN_INFO "Rounding down aligned max_sectors from %u"
-				" to %u\n", max_sectors, aligned_max_sectors);
-		return aligned_max_sectors;
-	}
+	alignment =3D max(1ul, PAGE_SIZE / block_size);
+	aligned_max_sectors =3D rounddown(max_sectors, alignment);
+
+	if (max_sectors !=3D aligned_max_sectors)
+		pr_info("Rounding down aligned max_sectors from %u to %u\n",
+			max_sectors, aligned_max_sectors);
=20
-	return max_sectors;
+	return aligned_max_sectors;
 }
=20
 void se_dev_set_default_attribs(
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index d481f80..43a38aa 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2585,7 +2585,6 @@ error:
 static void mos7840_disconnect(struct usb_serial *serial)
 {
 	int i;
-	unsigned long flags;
 	struct moschip_port *mos7840_port;
 	dbg("%s", " disconnect :entering..........");
=20
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 625890c..080b186 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -105,6 +105,21 @@ static void gntdev_print_maps(struct gntdev_priv *priv=
,
 #endif
 }
=20
+static void gntdev_free_map(struct grant_map *map)
+{
+	if (map =3D=3D NULL)
+		return;
+
+	if (map->pages)
+		free_xenballooned_pages(map->count, map->pages);
+	kfree(map->pages);
+	kfree(map->grants);
+	kfree(map->map_ops);
+	kfree(map->unmap_ops);
+	kfree(map->kmap_ops);
+	kfree(map);
+}
+
 static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int co=
unt)
 {
 	struct grant_map *add;
@@ -142,12 +157,7 @@ static struct grant_map *gntdev_alloc_map(struct gntde=
v_priv *priv, int count)
 	return add;
=20
 err:
-	kfree(add->pages);
-	kfree(add->grants);
-	kfree(add->map_ops);
-	kfree(add->unmap_ops);
-	kfree(add->kmap_ops);
-	kfree(add);
+	gntdev_free_map(add);
 	return NULL;
 }
=20
@@ -196,17 +206,9 @@ static void gntdev_put_map(struct grant_map *map)
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT)
 		notify_remote_via_evtchn(map->notify.event);
=20
-	if (map->pages) {
-		if (!use_ptemod)
-			unmap_grant_pages(map, 0, map->count);
-
-		free_xenballooned_pages(map->count, map->pages);
-	}
-	kfree(map->pages);
-	kfree(map->grants);
-	kfree(map->map_ops);
-	kfree(map->unmap_ops);
-	kfree(map);
+	if (map->pages && !use_ptemod)
+		unmap_grant_pages(map, 0, map->count);
+	gntdev_free_map(map);
 }
=20
 /* ------------------------------------------------------------------ */
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 72ddf23..b3522af 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -225,6 +225,13 @@ sid_to_str(struct cifs_sid *sidptr, char *sidstr)
 }
=20
 static void
+cifs_copy_sid(struct cifs_sid *dst, const struct cifs_sid *src)
+{
+	memcpy(dst, src, sizeof(*dst));
+	dst->num_subauth =3D min_t(u8, src->num_subauth, NUM_SUBAUTHS);
+}
+
+static void
 id_rb_insert(struct rb_root *root, struct cifs_sid *sidptr,
 		struct cifs_sid_id **psidid, char *typestr)
 {
@@ -248,7 +255,7 @@ id_rb_insert(struct rb_root *root, struct cifs_sid *sid=
ptr,
 		}
 	}
=20
-	memcpy(&(*psidid)->sid, sidptr, sizeof(struct cifs_sid));
+	cifs_copy_sid(&(*psidid)->sid, sidptr);
 	(*psidid)->time =3D jiffies - (SID_MAP_RETRY + 1);
 	(*psidid)->refcount =3D 0;
=20
@@ -354,7 +361,7 @@ id_to_sid(unsigned long cid, uint sidtype, struct cifs_=
sid *ssid)
 	 * any fields of the node after a reference is put .
 	 */
 	if (test_bit(SID_ID_MAPPED, &psidid->state)) {
-		memcpy(ssid, &psidid->sid, sizeof(struct cifs_sid));
+		cifs_copy_sid(ssid, &psidid->sid);
 		psidid->time =3D jiffies; /* update ts for accessing */
 		goto id_sid_out;
 	}
@@ -370,14 +377,14 @@ id_to_sid(unsigned long cid, uint sidtype, struct cif=
s_sid *ssid)
 		if (IS_ERR(sidkey)) {
 			rc =3D -EINVAL;
 			cFYI(1, "%s: Can't map and id to a SID", __func__);
+		} else if (sidkey->datalen < sizeof(struct cifs_sid)) {
+			rc =3D -EIO;
+			cFYI(1, "%s: Downcall contained malformed key "
+				"(datalen=3D%hu)", __func__, sidkey->datalen);
 		} else {
 			lsid =3D (struct cifs_sid *)sidkey->payload.data;
-			memcpy(&psidid->sid, lsid,
-				sidkey->datalen < sizeof(struct cifs_sid) ?
-				sidkey->datalen : sizeof(struct cifs_sid));
-			memcpy(ssid, &psidid->sid,
-				sidkey->datalen < sizeof(struct cifs_sid) ?
-				sidkey->datalen : sizeof(struct cifs_sid));
+			cifs_copy_sid(&psidid->sid, lsid);
+			cifs_copy_sid(ssid, &psidid->sid);
 			set_bit(SID_ID_MAPPED, &psidid->state);
 			key_put(sidkey);
 			kfree(psidid->sidstr);
@@ -396,7 +403,7 @@ id_to_sid(unsigned long cid, uint sidtype, struct cifs_=
sid *ssid)
 			return rc;
 		}
 		if (test_bit(SID_ID_MAPPED, &psidid->state))
-			memcpy(ssid, &psidid->sid, sizeof(struct cifs_sid));
+			cifs_copy_sid(ssid, &psidid->sid);
 		else
 			rc =3D -EINVAL;
 	}
@@ -674,8 +681,6 @@ int compare_sids(const struct cifs_sid *ctsid, const st=
ruct cifs_sid *cwsid)
 static void copy_sec_desc(const struct cifs_ntsd *pntsd,
 				struct cifs_ntsd *pnntsd, __u32 sidsoffset)
 {
-	int i;
-
 	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
 	struct cifs_sid *nowner_sid_ptr, *ngroup_sid_ptr;
=20
@@ -691,26 +696,14 @@ static void copy_sec_desc(const struct cifs_ntsd *pnt=
sd,
 	owner_sid_ptr =3D (struct cifs_sid *)((char *)pntsd +
 				le32_to_cpu(pntsd->osidoffset));
 	nowner_sid_ptr =3D (struct cifs_sid *)((char *)pnntsd + sidsoffset);
-
-	nowner_sid_ptr->revision =3D owner_sid_ptr->revision;
-	nowner_sid_ptr->num_subauth =3D owner_sid_ptr->num_subauth;
-	for (i =3D 0; i < 6; i++)
-		nowner_sid_ptr->authority[i] =3D owner_sid_ptr->authority[i];
-	for (i =3D 0; i < 5; i++)
-		nowner_sid_ptr->sub_auth[i] =3D owner_sid_ptr->sub_auth[i];
+	cifs_copy_sid(nowner_sid_ptr, owner_sid_ptr);
=20
 	/* copy group sid */
 	group_sid_ptr =3D (struct cifs_sid *)((char *)pntsd +
 				le32_to_cpu(pntsd->gsidoffset));
 	ngroup_sid_ptr =3D (struct cifs_sid *)((char *)pnntsd + sidsoffset +
 					sizeof(struct cifs_sid));
-
-	ngroup_sid_ptr->revision =3D group_sid_ptr->revision;
-	ngroup_sid_ptr->num_subauth =3D group_sid_ptr->num_subauth;
-	for (i =3D 0; i < 6; i++)
-		ngroup_sid_ptr->authority[i] =3D group_sid_ptr->authority[i];
-	for (i =3D 0; i < 5; i++)
-		ngroup_sid_ptr->sub_auth[i] =3D group_sid_ptr->sub_auth[i];
+	cifs_copy_sid(ngroup_sid_ptr, group_sid_ptr);
=20
 	return;
 }
@@ -1117,8 +1110,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, st=
ruct cifs_ntsd *pnntsd,
 				kfree(nowner_sid_ptr);
 				return rc;
 			}
-			memcpy(owner_sid_ptr, nowner_sid_ptr,
-					sizeof(struct cifs_sid));
+			cifs_copy_sid(owner_sid_ptr, nowner_sid_ptr);
 			kfree(nowner_sid_ptr);
 			*aclflag =3D CIFS_ACL_OWNER;
 		}
@@ -1136,8 +1128,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, st=
ruct cifs_ntsd *pnntsd,
 				kfree(ngroup_sid_ptr);
 				return rc;
 			}
-			memcpy(group_sid_ptr, ngroup_sid_ptr,
-					sizeof(struct cifs_sid));
+			cifs_copy_sid(group_sid_ptr, ngroup_sid_ptr);
 			kfree(ngroup_sid_ptr);
 			*aclflag =3D CIFS_ACL_GROUP;
 		}
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 1cfef9f..94afdfd 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -280,6 +280,7 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_in=
fo *sbi, char *options,
 	char *fnek_src;
 	char *cipher_key_bytes_src;
 	char *fn_cipher_key_bytes_src;
+	u8 cipher_code;
=20
 	*check_ruid =3D 0;
=20
@@ -421,6 +422,18 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_i=
nfo *sbi, char *options,
 	    && !fn_cipher_key_bytes_set)
 		mount_crypt_stat->global_default_fn_cipher_key_bytes =3D
 			mount_crypt_stat->global_default_cipher_key_size;
+
+	cipher_code =3D ecryptfs_code_for_cipher_string(
+		mount_crypt_stat->global_default_cipher_name,
+		mount_crypt_stat->global_default_cipher_key_size);
+	if (!cipher_code) {
+		ecryptfs_printk(KERN_ERR,
+				"eCryptfs doesn't support cipher: %s",
+				mount_crypt_stat->global_default_cipher_name);
+		rc =3D -EINVAL;
+		goto out;
+	}
+
 	mutex_lock(&key_tfm_list_mutex);
 	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
 				 NULL)) {
@@ -506,7 +519,6 @@ static struct dentry *ecryptfs_mount(struct file_system=
_type *fs_type, int flags
 		goto out;
 	}
=20
-	s->s_flags =3D flags;
 	rc =3D bdi_setup_and_register(&sbi->bdi, "ecryptfs", BDI_CAP_MAP_COPY);
 	if (rc)
 		goto out1;
@@ -542,6 +554,15 @@ static struct dentry *ecryptfs_mount(struct file_syste=
m_type *fs_type, int flags
 	}
=20
 	ecryptfs_set_superblock_lower(s, path.dentry->d_sb);
+
+	/**
+	 * Set the POSIX ACL flag based on whether they're enabled in the lower
+	 * mount. Force a read-only eCryptfs mount if the lower mount is ro.
+	 * Allow a ro eCryptfs mount even when the lower mount is rw.
+	 */
+	s->s_flags =3D flags & ~MS_POSIXACL;
+	s->s_flags |=3D path.dentry->d_sb->s_flags & (MS_RDONLY | MS_POSIXACL);
+
 	s->s_maxbytes =3D path.dentry->d_sb->s_maxbytes;
 	s->s_blocksize =3D path.dentry->d_sb->s_blocksize;
 	s->s_magic =3D ECRYPTFS_SUPER_MAGIC;
diff --git a/fs/nfs/dns_resolve.c b/fs/nfs/dns_resolve.c
index a6e711a..ee02db5 100644
--- a/fs/nfs/dns_resolve.c
+++ b/fs/nfs/dns_resolve.c
@@ -213,7 +213,7 @@ static int nfs_dns_parse(struct cache_detail *cd, char =
*buf, int buflen)
 {
 	char buf1[NFS_DNS_HOSTNAME_MAXLEN+1];
 	struct nfs_dns_ent key, *item;
-	unsigned long ttl;
+	unsigned int ttl;
 	ssize_t len;
 	int ret =3D -EINVAL;
=20
@@ -236,7 +236,8 @@ static int nfs_dns_parse(struct cache_detail *cd, char =
*buf, int buflen)
 	key.namelen =3D len;
 	memset(&key.h, 0, sizeof(key.h));
=20
-	ttl =3D get_expiry(&buf);
+	if (get_uint(&buf, &ttl) < 0)
+		goto out;
 	if (ttl =3D=3D 0)
 		goto out;
 	key.h.expiry_time =3D ttl + seconds_since_boot();
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 68b3f20..c5af878 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -274,8 +274,9 @@ extern void nfs_sb_active(struct super_block *sb);
 extern void nfs_sb_deactive(struct super_block *sb);
=20
 /* namespace.c */
+#define NFS_PATH_CANONICAL 1
 extern char *nfs_path(char **p, struct dentry *dentry,
-		      char *buffer, ssize_t buflen);
+		      char *buffer, ssize_t buflen, unsigned flags);
 extern struct vfsmount *nfs_d_automount(struct path *path);
 #ifdef CONFIG_NFS_V4
 rpc_authflavor_t nfs_find_best_sec(struct nfs4_secinfo_flavors *);
@@ -364,7 +365,7 @@ static inline char *nfs_devname(struct dentry *dentry,
 				char *buffer, ssize_t buflen)
 {
 	char *dummy;
-	return nfs_path(&dummy, dentry, buffer, buflen);
+	return nfs_path(&dummy, dentry, buffer, buflen, NFS_PATH_CANONICAL);
 }
=20
 /*
diff --git a/fs/nfs/mount_clnt.c b/fs/nfs/mount_clnt.c
index d4c2d6b..3d93216 100644
--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
@@ -181,7 +181,7 @@ int nfs_mount(struct nfs_mount_request *info)
 	else
 		msg.rpc_proc =3D &mnt_clnt->cl_procinfo[MOUNTPROC_MNT];
=20
-	status =3D rpc_call_sync(mnt_clnt, &msg, 0);
+	status =3D rpc_call_sync(mnt_clnt, &msg, RPC_TASK_SOFT|RPC_TASK_TIMEOUT);
 	rpc_shutdown_client(mnt_clnt);
=20
 	if (status < 0)
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 8102391..a86873e 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -37,6 +37,7 @@ static struct vfsmount *nfs_do_submount(struct dentry *de=
ntry,
  * @dentry - pointer to dentry
  * @buffer - result buffer
  * @buflen - length of buffer
+ * @flags - options (see below)
  *
  * Helper function for constructing the server pathname
  * by arbitrary hashed dentry.
@@ -44,8 +45,14 @@ static struct vfsmount *nfs_do_submount(struct dentry *d=
entry,
  * This is mainly for use in figuring out the path on the
  * server side when automounting on top of an existing partition
  * and in generating /proc/mounts and friends.
+ *
+ * Supported flags:
+ * NFS_PATH_CANONICAL: ensure there is exactly one slash after
+ *		       the original device (export) name
+ *		       (if unset, the original name is returned verbatim)
  */
-char *nfs_path(char **p, struct dentry *dentry, char *buffer, ssize_t bufl=
en)
+char *nfs_path(char **p, struct dentry *dentry, char *buffer, ssize_t bufl=
en,
+	       unsigned flags)
 {
 	char *end;
 	int namelen;
@@ -78,7 +85,7 @@ rename_retry:
 		rcu_read_unlock();
 		goto rename_retry;
 	}
-	if (*end !=3D '/') {
+	if ((flags & NFS_PATH_CANONICAL) && *end !=3D '/') {
 		if (--buflen < 0) {
 			spin_unlock(&dentry->d_lock);
 			rcu_read_unlock();
@@ -95,9 +102,11 @@ rename_retry:
 		return end;
 	}
 	namelen =3D strlen(base);
-	/* Strip off excess slashes in base string */
-	while (namelen > 0 && base[namelen - 1] =3D=3D '/')
-		namelen--;
+	if (flags & NFS_PATH_CANONICAL) {
+		/* Strip off excess slashes in base string */
+		while (namelen > 0 && base[namelen - 1] =3D=3D '/')
+			namelen--;
+	}
 	buflen -=3D namelen;
 	if (buflen < 0) {
 		spin_unlock(&dentry->d_lock);
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index bb80c49..96f2b67 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -57,7 +57,8 @@ Elong:
 static char *nfs4_path(struct dentry *dentry, char *buffer, ssize_t buflen=
)
 {
 	char *limit;
-	char *path =3D nfs_path(&limit, dentry, buffer, buflen);
+	char *path =3D nfs_path(&limit, dentry, buffer, buflen,
+			      NFS_PATH_CANONICAL);
 	if (!IS_ERR(path)) {
 		char *colon =3D strchr(path, ':');
 		if (colon && colon < limit)
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 61796a40..864b831 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -303,8 +303,7 @@ static int nfs4_handle_exception(struct nfs_server *ser=
ver, int errorcode, struc
 			dprintk("%s ERROR: %d Reset session\n", __func__,
 				errorcode);
 			nfs4_schedule_session_recovery(clp->cl_session);
-			exception->retry =3D 1;
-			break;
+			goto wait_on_recovery;
 #endif /* defined(CONFIG_NFS_V4_1) */
 		case -NFS4ERR_FILE_OPEN:
 			if (exception->timeout > HZ) {
@@ -1464,9 +1463,11 @@ static void nfs4_open_prepare(struct rpc_task *task,=
 void *calldata)
 	data->timestamp =3D jiffies;
 	if (nfs4_setup_sequence(data->o_arg.server,
 				&data->o_arg.seq_args,
-				&data->o_res.seq_res, 1, task))
-		return;
-	rpc_call_start(task);
+				&data->o_res.seq_res,
+				1, task) !=3D 0)
+		nfs_release_seqid(data->o_arg.seqid);
+	else
+		rpc_call_start(task);
 	return;
 unlock_no_action:
 	rcu_read_unlock();
@@ -2046,9 +2047,10 @@ static void nfs4_close_prepare(struct rpc_task *task=
, void *data)
 	calldata->timestamp =3D jiffies;
 	if (nfs4_setup_sequence(NFS_SERVER(calldata->inode),
 				&calldata->arg.seq_args, &calldata->res.seq_res,
-				1, task))
-		return;
-	rpc_call_start(task);
+				1, task) !=3D 0)
+		nfs_release_seqid(calldata->arg.seqid);
+	else
+		rpc_call_start(task);
 }
=20
 static const struct rpc_call_ops nfs4_close_ops =3D {
@@ -4148,6 +4150,7 @@ static void nfs4_locku_done(struct rpc_task *task, vo=
id *data)
 			if (nfs4_async_handle_error(task, calldata->server, NULL) =3D=3D -EAGAI=
N)
 				rpc_restart_call_prepare(task);
 	}
+	nfs_release_seqid(calldata->arg.seqid);
 }
=20
 static void nfs4_locku_prepare(struct rpc_task *task, void *data)
@@ -4164,9 +4167,11 @@ static void nfs4_locku_prepare(struct rpc_task *task=
, void *data)
 	calldata->timestamp =3D jiffies;
 	if (nfs4_setup_sequence(calldata->server,
 				&calldata->arg.seq_args,
-				&calldata->res.seq_res, 1, task))
-		return;
-	rpc_call_start(task);
+				&calldata->res.seq_res,
+				1, task) !=3D 0)
+		nfs_release_seqid(calldata->arg.seqid);
+	else
+		rpc_call_start(task);
 }
=20
 static const struct rpc_call_ops nfs4_locku_ops =3D {
@@ -4310,7 +4315,7 @@ static void nfs4_lock_prepare(struct rpc_task *task, =
void *calldata)
 	/* Do we need to do an open_to_lock_owner? */
 	if (!(data->arg.lock_seqid->sequence->flags & NFS_SEQID_CONFIRMED)) {
 		if (nfs_wait_on_sequence(data->arg.open_seqid, task) !=3D 0)
-			return;
+			goto out_release_lock_seqid;
 		data->arg.open_stateid =3D &state->stateid;
 		data->arg.new_lock_owner =3D 1;
 		data->res.open_seqid =3D data->arg.open_seqid;
@@ -4319,10 +4324,15 @@ static void nfs4_lock_prepare(struct rpc_task *task=
, void *calldata)
 	data->timestamp =3D jiffies;
 	if (nfs4_setup_sequence(data->server,
 				&data->arg.seq_args,
-				&data->res.seq_res, 1, task))
+				&data->res.seq_res,
+				1, task) =3D=3D 0) {
+		rpc_call_start(task);
 		return;
-	rpc_call_start(task);
-	dprintk("%s: done!, ret =3D %d\n", __func__, data->rpc_status);
+	}
+	nfs_release_seqid(data->arg.open_seqid);
+out_release_lock_seqid:
+	nfs_release_seqid(data->arg.lock_seqid);
+	dprintk("%s: done!, ret =3D %d\n", __func__, task->tk_status);
 }
=20
 static void nfs4_recover_lock_prepare(struct rpc_task *task, void *calldat=
a)
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index e42d6f6..8150344 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -768,7 +768,7 @@ static int nfs_show_devname(struct seq_file *m, struct =
vfsmount *mnt)
 	int err =3D 0;
 	if (!page)
 		return -ENOMEM;
-	devname =3D nfs_path(&dummy, mnt->mnt_root, page, PAGE_SIZE);
+	devname =3D nfs_path(&dummy, mnt->mnt_root, page, PAGE_SIZE, 0);
 	if (IS_ERR(devname))
 		err =3D PTR_ERR(devname);
 	else
diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 5f312ab..a0205fc 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -401,7 +401,7 @@ fsloc_parse(char **mesg, char *buf, struct nfsd4_fs_loc=
ations *fsloc)
 	int migrated, i, err;
=20
 	/* listsize */
-	err =3D get_int(mesg, &fsloc->locations_count);
+	err =3D get_uint(mesg, &fsloc->locations_count);
 	if (err)
 		return err;
 	if (fsloc->locations_count > MAX_FS_LOCATIONS)
@@ -459,7 +459,7 @@ static int secinfo_parse(char **mesg, char *buf, struct=
 svc_export *exp)
 		return -EINVAL;
=20
 	for (f =3D exp->ex_flavors; f < exp->ex_flavors + listsize; f++) {
-		err =3D get_int(mesg, &f->pseudoflavor);
+		err =3D get_uint(mesg, &f->pseudoflavor);
 		if (err)
 			return err;
 		/*
@@ -468,7 +468,7 @@ static int secinfo_parse(char **mesg, char *buf, struct=
 svc_export *exp)
 		 * problem at export time instead of when a client fails
 		 * to authenticate.
 		 */
-		err =3D get_int(mesg, &f->flags);
+		err =3D get_uint(mesg, &f->flags);
 		if (err)
 			return err;
 		/* Only some flags are allowed to differ between flavors: */
diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index f35794b..a506360 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -21,6 +21,7 @@ static bool should_merge(struct fsnotify_event *old, stru=
ct fsnotify_event *new)
 			if ((old->path.mnt =3D=3D new->path.mnt) &&
 			    (old->path.dentry =3D=3D new->path.dentry))
 				return true;
+			break;
 		case (FSNOTIFY_EVENT_NONE):
 			return true;
 		default:
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4f5d0ce..86ca506 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3514,7 +3514,7 @@ xlog_do_recovery_pass(
 				 *   - order is important.
 				 */
 				error =3D xlog_bread_offset(log, 0,
-						bblks - split_bblks, hbp,
+						bblks - split_bblks, dbp,
 						offset + BBTOB(split_bblks));
 				if (error)
 					goto bread_err2;
diff --git a/include/linux/if_link.h b/include/linux/if_link.h
index c52d4b5..4b24ff4 100644
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@ -137,6 +137,7 @@ enum {
 	IFLA_AF_SPEC,
 	IFLA_GROUP,		/* Group the device belongs to */
 	IFLA_NET_NS_FD,
+	IFLA_EXT_MASK,		/* Extended info mask, VFs, etc */
 	__IFLA_MAX
 };
=20
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 8e872ea..577592e 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -602,6 +602,9 @@ struct tcamsg {
 #define TCA_ACT_TAB 1 /* attr type must be >=3D1 */=09
 #define TCAA_MAX 1
=20
+/* New extended info filters for IFLA_EXT_MASK */
+#define RTEXT_FILTER_VF		(1 << 0)
+
 /* End of information exported to user level */
=20
 #ifdef __KERNEL__
diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index 5efd8ce..f0c6ab5 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -224,6 +224,22 @@ static inline int get_int(char **bpp, int *anint)
 	return 0;
 }
=20
+static inline int get_uint(char **bpp, unsigned int *anint)
+{
+	char buf[50];
+	int len =3D qword_get(bpp, buf, sizeof(buf));
+
+	if (len < 0)
+		return -EINVAL;
+	if (len =3D=3D 0)
+		return -ENOENT;
+
+	if (kstrtouint(buf, 0, anint))
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * timestamps kept in the cache are expressed in seconds
  * since boot.  This is the best for measuring differences in
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 95852e3..19d632d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2431,6 +2431,15 @@ unsigned int ieee80211_get_hdrlen_from_skb(const str=
uct sk_buff *skb);
 unsigned int __attribute_const__ ieee80211_hdrlen(__le16 fc);
=20
 /**
+ * ieee80211_get_mesh_hdrlen - get mesh extension header length
+ * @meshhdr: the mesh extension header, only the flags field
+ *	(first byte) will be accessed
+ * Returns the length of the extension header, which is always at
+ * least 6 bytes and at most 18 if address 5 and 6 are present.
+ */
+unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr);
+
+/**
  * DOC: Data path helpers
  *
  * In addition to generic utilities, cfg80211 also offers
diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 678f1ff..3702939 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -6,7 +6,7 @@
=20
 typedef int (*rtnl_doit_func)(struct sk_buff *, struct nlmsghdr *, void *)=
;
 typedef int (*rtnl_dumpit_func)(struct sk_buff *, struct netlink_callback =
*);
-typedef u16 (*rtnl_calcit_func)(struct sk_buff *);
+typedef u16 (*rtnl_calcit_func)(struct sk_buff *, struct nlmsghdr *);
=20
 extern int	__rtnl_register(int protocol, int msgtype,
 				rtnl_doit_func, rtnl_dumpit_func,
diff --git a/include/sound/core.h b/include/sound/core.h
index 3be5ab7..222f11e 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -132,6 +132,7 @@ struct snd_card {
 	int shutdown;			/* this card is going down */
 	int free_on_last_close;		/* free in context of file_release */
 	wait_queue_head_t shutdown_sleep;
+	atomic_t refcount;		/* refcount for disconnection */
 	struct device *dev;		/* device assigned to this card */
 	struct device *card_dev;	/* cardX object for sysfs */
=20
@@ -189,6 +190,7 @@ struct snd_minor {
 	const struct file_operations *f_ops;	/* file operations */
 	void *private_data;		/* private data for f_ops->open */
 	struct device *dev;		/* device for sysfs */
+	struct snd_card *card_ptr;	/* assigned card instance */
 };
=20
 /* return a device pointer linked to each sound device as a parent */
@@ -295,6 +297,7 @@ int snd_card_info_done(void);
 int snd_component_add(struct snd_card *card, const char *component);
 int snd_card_file_add(struct snd_card *card, struct file *file);
 int snd_card_file_remove(struct snd_card *card, struct file *file);
+void snd_card_unref(struct snd_card *card);
=20
 #define snd_card_set_dev(card, devptr) ((card)->dev =3D (devptr))
=20
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index 92f1a79..348c4fe 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -377,6 +377,14 @@ DECLARE_EVENT_CLASS(xen_mmu_pgd,
 DEFINE_XEN_MMU_PGD_EVENT(xen_mmu_pgd_pin);
 DEFINE_XEN_MMU_PGD_EVENT(xen_mmu_pgd_unpin);
=20
+TRACE_EVENT(xen_mmu_flush_tlb_all,
+	    TP_PROTO(int x),
+	    TP_ARGS(x),
+	    TP_STRUCT__entry(__array(char, x, 0)),
+	    TP_fast_assign((void)x),
+	    TP_printk("%s", "")
+	);
+
 TRACE_EVENT(xen_mmu_flush_tlb,
 	    TP_PROTO(int x),
 	    TP_ARGS(x),
diff --git a/kernel/module.c b/kernel/module.c
index 6c8fa34..65362d9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2193,15 +2193,17 @@ static void layout_symtab(struct module *mod, struc=
t load_info *info)
=20
 	src =3D (void *)info->hdr + symsect->sh_offset;
 	nsrc =3D symsect->sh_size / sizeof(*src);
-	for (ndst =3D i =3D 1; i < nsrc; ++i, ++src)
-		if (is_core_symbol(src, info->sechdrs, info->hdr->e_shnum)) {
-			unsigned int j =3D src->st_name;
+	for (ndst =3D i =3D 0; i < nsrc; i++) {
+		if (i =3D=3D 0 ||
+		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
+			unsigned int j =3D src[i].st_name;
=20
 			while (!__test_and_set_bit(j, info->strmap)
 			       && info->strtab[j])
 				++j;
 			++ndst;
 		}
+	}
=20
 	/* Append room for core symbols at end of core part. */
 	info->symoffs =3D ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
@@ -2238,14 +2240,14 @@ static void add_kallsyms(struct module *mod, const =
struct load_info *info)
=20
 	mod->core_symtab =3D dst =3D mod->module_core + info->symoffs;
 	src =3D mod->symtab;
-	*dst =3D *src;
-	for (ndst =3D i =3D 1; i < mod->num_symtab; ++i, ++src) {
-		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
-			continue;
-		dst[ndst] =3D *src;
-		dst[ndst].st_name =3D bitmap_weight(info->strmap,
-						  dst[ndst].st_name);
-		++ndst;
+	for (ndst =3D i =3D 0; i < mod->num_symtab; i++) {
+		if (i =3D=3D 0 ||
+		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
+			dst[ndst] =3D src[i];
+			dst[ndst].st_name =3D bitmap_weight(info->strmap,
+							  dst[ndst].st_name);
+			++ndst;
+		}
 	}
 	mod->core_num_syms =3D ndst;
=20
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 86eb848..313381c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3015,6 +3015,8 @@ static int kswapd(void *p)
 						&balanced_classzone_idx);
 		}
 	}
+
+	current->reclaim_state =3D NULL;
 	return 0;
 }
=20
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 1fb1aec..aa12649 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -642,8 +642,10 @@ int hci_conn_security(struct hci_conn *conn, __u8 sec_=
level, __u8 auth_type)
 {
 	BT_DBG("conn %p", conn);
=20
+#ifdef CONFIG_BT_L2CAP
 	if (conn->type =3D=3D LE_LINK)
 		return smp_conn_security(conn, sec_level);
+#endif
=20
 	/* For sdp we don't need the link key. */
 	if (sec_level =3D=3D BT_SECURITY_SDP)
diff --git a/net/core/dev.c b/net/core/dev.c
index f500a69..480be72 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1633,7 +1633,7 @@ static inline int deliver_skb(struct sk_buff *skb,
=20
 static inline bool skb_loop_sk(struct packet_type *ptype, struct sk_buff *=
skb)
 {
-	if (ptype->af_packet_priv =3D=3D NULL)
+	if (!ptype->af_packet_priv || !skb->sk)
 		return false;
=20
 	if (ptype->id_match)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 0cf604b..5229c7f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -60,7 +60,6 @@ struct rtnl_link {
 };
=20
 static DEFINE_MUTEX(rtnl_mutex);
-static u16 min_ifinfo_dump_size;
=20
 void rtnl_lock(void)
 {
@@ -727,10 +726,11 @@ static void copy_rtnl_link_stats64(void *v, const str=
uct rtnl_link_stats64 *b)
 }
=20
 /* All VF info */
-static inline int rtnl_vfinfo_size(const struct net_device *dev)
+static inline int rtnl_vfinfo_size(const struct net_device *dev,
+				   u32 ext_filter_mask)
 {
-	if (dev->dev.parent && dev_is_pci(dev->dev.parent)) {
-
+	if (dev->dev.parent && dev_is_pci(dev->dev.parent) &&
+	    (ext_filter_mask & RTEXT_FILTER_VF)) {
 		int num_vfs =3D dev_num_vf(dev->dev.parent);
 		size_t size =3D nla_total_size(sizeof(struct nlattr));
 		size +=3D nla_total_size(num_vfs * sizeof(struct nlattr));
@@ -769,7 +769,8 @@ static size_t rtnl_port_size(const struct net_device *d=
ev)
 		return port_self_size;
 }
=20
-static noinline size_t if_nlmsg_size(const struct net_device *dev)
+static noinline size_t if_nlmsg_size(const struct net_device *dev,
+				     u32 ext_filter_mask)
 {
 	return NLMSG_ALIGN(sizeof(struct ifinfomsg))
 	       + nla_total_size(IFNAMSIZ) /* IFLA_IFNAME */
@@ -787,8 +788,9 @@ static noinline size_t if_nlmsg_size(const struct net_d=
evice *dev)
 	       + nla_total_size(4) /* IFLA_MASTER */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
-	       + nla_total_size(4) /* IFLA_NUM_VF */
-	       + rtnl_vfinfo_size(dev) /* IFLA_VFINFO_LIST */
+	       + nla_total_size(ext_filter_mask
+			        & RTEXT_FILTER_VF ? 4 : 0) /* IFLA_NUM_VF */
+	       + rtnl_vfinfo_size(dev, ext_filter_mask) /* IFLA_VFINFO_LIST */
 	       + rtnl_port_size(dev) /* IFLA_VF_PORTS + IFLA_PORT_SELF */
 	       + rtnl_link_get_size(dev) /* IFLA_LINKINFO */
 	       + rtnl_link_get_af_size(dev); /* IFLA_AF_SPEC */
@@ -871,7 +873,7 @@ static int rtnl_port_fill(struct sk_buff *skb, struct n=
et_device *dev)
=20
 static int rtnl_fill_ifinfo(struct sk_buff *skb, struct net_device *dev,
 			    int type, u32 pid, u32 seq, u32 change,
-			    unsigned int flags)
+			    unsigned int flags, u32 ext_filter_mask)
 {
 	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
@@ -944,10 +946,11 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb, stru=
ct net_device *dev,
 		goto nla_put_failure;
 	copy_rtnl_link_stats64(nla_data(attr), stats);
=20
-	if (dev->dev.parent)
+	if (dev->dev.parent && (ext_filter_mask & RTEXT_FILTER_VF))
 		NLA_PUT_U32(skb, IFLA_NUM_VF, dev_num_vf(dev->dev.parent));
=20
-	if (dev->netdev_ops->ndo_get_vf_config && dev->dev.parent) {
+	if (dev->netdev_ops->ndo_get_vf_config && dev->dev.parent
+	    && (ext_filter_mask & RTEXT_FILTER_VF)) {
 		int i;
=20
 		struct nlattr *vfinfo, *vf;
@@ -1051,6 +1054,8 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, stru=
ct netlink_callback *cb)
 	struct net_device *dev;
 	struct hlist_head *head;
 	struct hlist_node *node;
+	struct nlattr *tb[IFLA_MAX+1];
+	u32 ext_filter_mask =3D 0;
=20
 	s_h =3D cb->args[0];
 	s_idx =3D cb->args[1];
@@ -1058,6 +1063,13 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, str=
uct netlink_callback *cb)
 	rcu_read_lock();
 	cb->seq =3D net->dev_base_seq;
=20
+	if (nlmsg_parse(cb->nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+			ifla_policy) >=3D 0) {
+
+		if (tb[IFLA_EXT_MASK])
+			ext_filter_mask =3D nla_get_u32(tb[IFLA_EXT_MASK]);
+	}
+
 	for (h =3D s_h; h < NETDEV_HASHENTRIES; h++, s_idx =3D 0) {
 		idx =3D 0;
 		head =3D &net->dev_index_head[h];
@@ -1067,7 +1079,8 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, stru=
ct netlink_callback *cb)
 			if (rtnl_fill_ifinfo(skb, dev, RTM_NEWLINK,
 					     NETLINK_CB(cb->skb).pid,
 					     cb->nlh->nlmsg_seq, 0,
-					     NLM_F_MULTI) <=3D 0)
+					     NLM_F_MULTI,
+					     ext_filter_mask) <=3D 0)
 				goto out;
=20
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -1103,6 +1116,7 @@ const struct nla_policy ifla_policy[IFLA_MAX+1] =3D {
 	[IFLA_VF_PORTS]		=3D { .type =3D NLA_NESTED },
 	[IFLA_PORT_SELF]	=3D { .type =3D NLA_NESTED },
 	[IFLA_AF_SPEC]		=3D { .type =3D NLA_NESTED },
+	[IFLA_EXT_MASK]		=3D { .type =3D NLA_U32 },
 };
 EXPORT_SYMBOL(ifla_policy);
=20
@@ -1845,6 +1859,7 @@ static int rtnl_getlink(struct sk_buff *skb, struct n=
lmsghdr* nlh, void *arg)
 	struct net_device *dev =3D NULL;
 	struct sk_buff *nskb;
 	int err;
+	u32 ext_filter_mask =3D 0;
=20
 	err =3D nlmsg_parse(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy);
 	if (err < 0)
@@ -1853,6 +1868,9 @@ static int rtnl_getlink(struct sk_buff *skb, struct n=
lmsghdr* nlh, void *arg)
 	if (tb[IFLA_IFNAME])
 		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
=20
+	if (tb[IFLA_EXT_MASK])
+		ext_filter_mask =3D nla_get_u32(tb[IFLA_EXT_MASK]);
+
 	ifm =3D nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev =3D __dev_get_by_index(net, ifm->ifi_index);
@@ -1864,12 +1882,12 @@ static int rtnl_getlink(struct sk_buff *skb, struct=
 nlmsghdr* nlh, void *arg)
 	if (dev =3D=3D NULL)
 		return -ENODEV;
=20
-	nskb =3D nlmsg_new(if_nlmsg_size(dev), GFP_KERNEL);
+	nskb =3D nlmsg_new(if_nlmsg_size(dev, ext_filter_mask), GFP_KERNEL);
 	if (nskb =3D=3D NULL)
 		return -ENOBUFS;
=20
 	err =3D rtnl_fill_ifinfo(nskb, dev, RTM_NEWLINK, NETLINK_CB(skb).pid,
-			       nlh->nlmsg_seq, 0, 0);
+			       nlh->nlmsg_seq, 0, 0, ext_filter_mask);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size */
 		WARN_ON(err =3D=3D -EMSGSIZE);
@@ -1880,8 +1898,32 @@ static int rtnl_getlink(struct sk_buff *skb, struct =
nlmsghdr* nlh, void *arg)
 	return err;
 }
=20
-static u16 rtnl_calcit(struct sk_buff *skb)
+static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
+	struct net *net =3D sock_net(skb->sk);
+	struct net_device *dev;
+	struct nlattr *tb[IFLA_MAX+1];
+	u32 ext_filter_mask =3D 0;
+	u16 min_ifinfo_dump_size =3D 0;
+
+	if (nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+			ifla_policy) >=3D 0) {
+		if (tb[IFLA_EXT_MASK])
+			ext_filter_mask =3D nla_get_u32(tb[IFLA_EXT_MASK]);
+	}
+
+	if (!ext_filter_mask)
+		return NLMSG_GOODSIZE;
+	/*
+	 * traverse the list of net devices and compute the minimum
+	 * buffer size based upon the filter mask.
+	 */
+	list_for_each_entry(dev, &net->dev_base_head, dev_list) {
+		min_ifinfo_dump_size =3D max_t(u16, min_ifinfo_dump_size,
+					     if_nlmsg_size(dev,
+						           ext_filter_mask));
+	}
+
 	return min_ifinfo_dump_size;
 }
=20
@@ -1916,13 +1958,11 @@ void rtmsg_ifinfo(int type, struct net_device *dev,=
 unsigned change)
 	int err =3D -ENOBUFS;
 	size_t if_info_size;
=20
-	skb =3D nlmsg_new((if_info_size =3D if_nlmsg_size(dev)), GFP_KERNEL);
+	skb =3D nlmsg_new((if_info_size =3D if_nlmsg_size(dev, 0)), GFP_KERNEL);
 	if (skb =3D=3D NULL)
 		goto errout;
=20
-	min_ifinfo_dump_size =3D max_t(u16, if_info_size, min_ifinfo_dump_size);
-
-	err =3D rtnl_fill_ifinfo(skb, dev, type, 0, 0, change, 0);
+	err =3D rtnl_fill_ifinfo(skb, dev, type, 0, 0, change, 0, 0);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size() */
 		WARN_ON(err =3D=3D -EMSGSIZE);
@@ -1980,7 +2020,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, str=
uct nlmsghdr *nlh)
 			return -EOPNOTSUPP;
 		calcit =3D rtnl_get_calcit(family, type);
 		if (calcit)
-			min_dump_alloc =3D calcit(skb);
+			min_dump_alloc =3D calcit(skb, nlh);
=20
 		__rtnl_unlock();
 		rtnl =3D net->rtnl;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7397ad8..52edbb8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -481,14 +481,12 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long=
 arg)
 			 !tp->urg_data ||
 			 before(tp->urg_seq, tp->copied_seq) ||
 			 !before(tp->urg_seq, tp->rcv_nxt)) {
-			struct sk_buff *skb;
=20
 			answ =3D tp->rcv_nxt - tp->copied_seq;
=20
-			/* Subtract 1, if FIN is in queue. */
-			skb =3D skb_peek_tail(&sk->sk_receive_queue);
-			if (answ && skb)
-				answ -=3D tcp_hdr(skb)->fin;
+			/* Subtract 1, if FIN was received */
+			if (answ && sock_flag(sk, SOCK_DONE))
+				answ--;
 		} else
 			answ =3D tp->urg_seq - tp->copied_seq;
 		release_sock(sk);
diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index 813b43a..834857f 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -313,11 +313,13 @@ static void tcp_illinois_info(struct sock *sk, u32 ex=
t,
 			.tcpv_rttcnt =3D ca->cnt_rtt,
 			.tcpv_minrtt =3D ca->base_rtt,
 		};
-		u64 t =3D ca->sum_rtt;
=20
-		do_div(t, ca->cnt_rtt);
-		info.tcpv_rtt =3D t;
+		if (info.tcpv_rttcnt > 0) {
+			u64 t =3D ca->sum_rtt;
=20
+			do_div(t, info.tcpv_rttcnt);
+			info.tcpv_rtt =3D t;
+		}
 		nla_put(skb, INET_DIAG_VEGASINFO, sizeof(info), &info);
 	}
 }
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 0cb78d7..9ffc37f 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -606,7 +606,7 @@ static void ndisc_send_unsol_na(struct net_device *dev)
 {
 	struct inet6_dev *idev;
 	struct inet6_ifaddr *ifa;
-	struct in6_addr mcaddr;
+	struct in6_addr mcaddr =3D IN6ADDR_LINKLOCAL_ALLNODES_INIT;
=20
 	idev =3D in6_dev_get(dev);
 	if (!idev)
@@ -614,7 +614,6 @@ static void ndisc_send_unsol_na(struct net_device *dev)
=20
 	read_lock_bh(&idev->lock);
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
-		addrconf_addr_solict_mult(&ifa->addr, &mcaddr);
 		ndisc_send_na(dev, NULL, &mcaddr, &ifa->addr,
 			      /*router=3D*/ !!idev->cnf.forwarding,
 			      /*solicited=3D*/ false, /*override=3D*/ true,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 488a1b7..19724bd 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -185,7 +185,7 @@ static struct dst_ops ip6_dst_blackhole_ops =3D {
 };
=20
 static const u32 ip6_template_metrics[RTAX_MAX] =3D {
-	[RTAX_HOPLIMIT - 1] =3D 255,
+	[RTAX_HOPLIMIT - 1] =3D 0,
 };
=20
 static struct rt6_info ip6_null_entry_template =3D {
@@ -1097,7 +1097,7 @@ struct dst_entry *icmp6_dst_alloc(struct net_device *=
dev,
 	ipv6_addr_copy(&rt->rt6i_dst.addr, addr);
 	rt->rt6i_dst.plen =3D 128;
 	rt->rt6i_idev     =3D idev;
-	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, 255);
+	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, 0);
=20
 	spin_lock_bh(&icmp6_dst_lock);
 	rt->dst.next =3D icmp6_dst_gc_list;
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 2cef50b..64164fb 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -269,6 +269,7 @@ static int l2tp_eth_create(struct net *net, u32 tunnel_=
id, u32 session_id, u32 p
=20
 out_del_dev:
 	free_netdev(dev);
+	spriv->dev =3D NULL;
 out_del_session:
 	l2tp_session_delete(session);
 out:
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 3ece106..8c7364b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -940,7 +940,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *s=
data,
 	sdata->u.ibss.state =3D IEEE80211_IBSS_MLME_SEARCH;
 	sdata->u.ibss.ibss_join_req =3D jiffies;
=20
-	memcpy(sdata->u.ibss.ssid, params->ssid, IEEE80211_MAX_SSID_LEN);
+	memcpy(sdata->u.ibss.ssid, params->ssid, params->ssid_len);
 	sdata->u.ibss.ssid_len =3D params->ssid_len;
=20
 	mutex_unlock(&sdata->u.ibss.mtx);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index cda4875..cd6cbdb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -515,6 +515,11 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
=20
 		if (ieee80211_is_action(hdr->frame_control)) {
 			u8 category;
+
+			/* make sure category field is present */
+			if (rx->skb->len < IEEE80211_MIN_ACTION_SIZE)
+				return RX_DROP_MONITOR;
+
 			mgmt =3D (struct ieee80211_mgmt *)hdr;
 			category =3D mgmt->u.action.category;
 			if (category !=3D WLAN_CATEGORY_MESH_ACTION &&
@@ -854,14 +859,16 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 		     (!rx->sta || !test_sta_flag(rx->sta, WLAN_STA_ASSOC)))) {
 		if (rx->sta && rx->sta->dummy &&
 		    ieee80211_is_data_present(hdr->frame_control)) {
-			u16 ethertype;
-			u8 *payload;
-
-			payload =3D rx->skb->data +
-				ieee80211_hdrlen(hdr->frame_control);
-			ethertype =3D (payload[6] << 8) | payload[7];
-			if (cpu_to_be16(ethertype) =3D=3D
-			    rx->sdata->control_port_protocol)
+			unsigned int hdrlen;
+			__be16 ethertype;
+
+			hdrlen =3D ieee80211_hdrlen(hdr->frame_control);
+
+			if (rx->skb->len < hdrlen + 8)
+				return RX_DROP_MONITOR;
+
+			skb_copy_bits(rx->skb, hdrlen + 6, &ethertype, 2);
+			if (ethertype =3D=3D rx->sdata->control_port_protocol)
 				return RX_CONTINUE;
 		}
 		return RX_DROP_MONITOR;
@@ -1449,11 +1456,14 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data =
*rx)
=20
 	hdr =3D (struct ieee80211_hdr *)rx->skb->data;
 	fc =3D hdr->frame_control;
+
+	if (ieee80211_is_ctl(fc))
+		return RX_CONTINUE;
+
 	sc =3D le16_to_cpu(hdr->seq_ctrl);
 	frag =3D sc & IEEE80211_SCTL_FRAG;
=20
 	if (likely((!ieee80211_has_morefrags(fc) && frag =3D=3D 0) ||
-		   (rx->skb)->len < 24 ||
 		   is_multicast_ether_addr(hdr->addr1))) {
 		/* not fragmented */
 		goto out;
@@ -1887,6 +1897,20 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data =
*rx)
=20
 	hdr =3D (struct ieee80211_hdr *) skb->data;
 	hdrlen =3D ieee80211_hdrlen(hdr->frame_control);
+
+	/* make sure fixed part of mesh header is there, also checks skb len */
+	if (!pskb_may_pull(rx->skb, hdrlen + 6))
+		return RX_DROP_MONITOR;
+
+	mesh_hdr =3D (struct ieee80211s_hdr *) (skb->data + hdrlen);
+
+	/* make sure full mesh header is there, also checks skb len */
+	if (!pskb_may_pull(rx->skb,
+			   hdrlen + ieee80211_get_mesh_hdrlen(mesh_hdr)))
+		return RX_DROP_MONITOR;
+
+	/* reload pointers */
+	hdr =3D (struct ieee80211_hdr *) skb->data;
 	mesh_hdr =3D (struct ieee80211s_hdr *) (skb->data + hdrlen);
=20
 	/* frame is in RMC, don't forward */
@@ -1895,7 +1919,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *=
rx)
 	    mesh_rmc_check(hdr->addr3, mesh_hdr, rx->sdata))
 		return RX_DROP_MONITOR;
=20
-	if (!ieee80211_is_data(hdr->frame_control))
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    !(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
=20
 	if (!mesh_hdr->ttl)
@@ -1916,9 +1941,12 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data =
*rx)
 		if (is_multicast_ether_addr(hdr->addr1)) {
 			mpp_addr =3D hdr->addr3;
 			proxied_addr =3D mesh_hdr->eaddr1;
-		} else {
+		} else if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6) {
+			/* has_a4 already checked in ieee80211_rx_mesh_check */
 			mpp_addr =3D hdr->addr4;
 			proxied_addr =3D mesh_hdr->eaddr2;
+		} else {
+			return RX_DROP_MONITOR;
 		}
=20
 		rcu_read_lock();
@@ -1941,7 +1969,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *=
rx)
=20
 	mesh_hdr->ttl--;
=20
-	if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
+	{
 		if (!mesh_hdr->ttl)
 			IEEE80211_IFSTA_MESH_CTR_INC(&rx->sdata->u.mesh,
 						     dropped_frames_ttl);
@@ -2295,6 +2323,10 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		}
 		break;
 	case WLAN_CATEGORY_SELF_PROTECTED:
+		if (len < (IEEE80211_MIN_ACTION_SIZE +
+			   sizeof(mgmt->u.action.u.self_prot.action_code)))
+			break;
+
 		switch (mgmt->u.action.u.self_prot.action_code) {
 		case WLAN_SP_MESH_PEERING_OPEN:
 		case WLAN_SP_MESH_PEERING_CLOSE:
@@ -2313,6 +2345,10 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		}
 		break;
 	case WLAN_CATEGORY_MESH_ACTION:
+		if (len < (IEEE80211_MIN_ACTION_SIZE +
+			   sizeof(mgmt->u.action.u.mesh_action.action_code)))
+			break;
+
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
 		if (mesh_action_is_path_sel(mgmt) &&
@@ -2870,10 +2906,15 @@ static void __ieee80211_rx_handle_packet(struct iee=
e80211_hw *hw,
 		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
 		status->rx_flags |=3D IEEE80211_RX_IN_SCAN;
=20
-	if (ieee80211_is_mgmt(fc))
-		err =3D skb_linearize(skb);
-	else
+	if (ieee80211_is_mgmt(fc)) {
+		/* drop frame if too short for header */
+		if (skb->len < ieee80211_hdrlen(fc))
+			err =3D -ENOBUFS;
+		else
+			err =3D skb_linearize(skb);
+	} else {
 		err =3D !pskb_may_pull(skb, ieee80211_hdrlen(fc));
+	}
=20
 	if (err) {
 		dev_kfree_skb(skb);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 38b78b9..3d1d55d 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -137,6 +137,8 @@ static void netlink_destroy_callback(struct netlink_cal=
lback *cb);
 static DEFINE_RWLOCK(nl_table_lock);
 static atomic_t nl_table_users =3D ATOMIC_INIT(0);
=20
+#define nl_deref_protected(X) rcu_dereference_protected(X, lockdep_is_held=
(&nl_table_lock));
+
 static ATOMIC_NOTIFIER_HEAD(netlink_chain);
=20
 static u32 netlink_group_mask(u32 group)
@@ -331,6 +333,11 @@ netlink_update_listeners(struct sock *sk)
 	struct hlist_node *node;
 	unsigned long mask;
 	unsigned int i;
+	struct listeners *listeners;
+
+	listeners =3D nl_deref_protected(tbl->listeners);
+	if (!listeners)
+		return;
=20
 	for (i =3D 0; i < NLGRPLONGS(tbl->groups); i++) {
 		mask =3D 0;
@@ -338,7 +345,7 @@ netlink_update_listeners(struct sock *sk)
 			if (i < NLGRPLONGS(nlk_sk(sk)->ngroups))
 				mask |=3D nlk_sk(sk)->groups[i];
 		}
-		tbl->listeners->masks[i] =3D mask;
+		listeners->masks[i] =3D mask;
 	}
 	/* this function is only called with the netlink table "grabbed", which
 	 * makes sure updates are visible before bind or setsockopt return. */
@@ -519,7 +526,11 @@ static int netlink_release(struct socket *sock)
 	if (netlink_is_kernel(sk)) {
 		BUG_ON(nl_table[sk->sk_protocol].registered =3D=3D 0);
 		if (--nl_table[sk->sk_protocol].registered =3D=3D 0) {
-			kfree(nl_table[sk->sk_protocol].listeners);
+			struct listeners *old;
+
+			old =3D nl_deref_protected(nl_table[sk->sk_protocol].listeners);
+			RCU_INIT_POINTER(nl_table[sk->sk_protocol].listeners, NULL);
+			kfree_rcu(old, rcu);
 			nl_table[sk->sk_protocol].module =3D NULL;
 			nl_table[sk->sk_protocol].registered =3D 0;
 		}
@@ -950,7 +961,7 @@ int netlink_has_listeners(struct sock *sk, unsigned int=
 group)
 	rcu_read_lock();
 	listeners =3D rcu_dereference(nl_table[sk->sk_protocol].listeners);
=20
-	if (group - 1 < nl_table[sk->sk_protocol].groups)
+	if (listeners && group - 1 < nl_table[sk->sk_protocol].groups)
 		res =3D test_bit(group - 1, listeners->masks);
=20
 	rcu_read_unlock();
@@ -1584,7 +1595,7 @@ int __netlink_change_ngroups(struct sock *sk, unsigne=
d int groups)
 		new =3D kzalloc(sizeof(*new) + NLGRPSZ(groups), GFP_ATOMIC);
 		if (!new)
 			return -ENOMEM;
-		old =3D rcu_dereference_protected(tbl->listeners, 1);
+		old =3D nl_deref_protected(tbl->listeners);
 		memcpy(new->masks, old->masks, NLGRPSZ(tbl->groups));
 		rcu_assign_pointer(tbl->listeners, new);
=20
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 76388b0..9032d50 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1604,8 +1604,9 @@ static int sctp_cmd_interpreter(sctp_event_t event_ty=
pe,
 					asoc->outqueue.outstanding_bytes;
 			sackh.num_gap_ack_blocks =3D 0;
 			sackh.num_dup_tsns =3D 0;
+			chunk->subh.sack_hdr =3D &sackh;
 			sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK,
-					SCTP_SACKH(&sackh));
+					SCTP_CHUNK(chunk));
 			break;
=20
 		case SCTP_CMD_DISCARD_PACKET:
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8f5042d..ea93f4b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -548,8 +548,7 @@ int wiphy_register(struct wiphy *wiphy)
 		for (i =3D 0; i < sband->n_channels; i++) {
 			sband->channels[i].orig_flags =3D
 				sband->channels[i].flags;
-			sband->channels[i].orig_mag =3D
-				sband->channels[i].max_antenna_gain;
+			sband->channels[i].orig_mag =3D INT_MAX;
 			sband->channels[i].orig_mpwr =3D
 				sband->channels[i].max_power;
 			sband->channels[i].band =3D band;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 22fb802..5fba039 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -301,23 +301,21 @@ unsigned int ieee80211_get_hdrlen_from_skb(const stru=
ct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
=20
-static int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
+unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 {
 	int ae =3D meshhdr->flags & MESH_FLAGS_AE;
-	/* 7.1.3.5a.2 */
+	/* 802.11-2012, 8.2.4.7.3 */
 	switch (ae) {
+	default:
 	case 0:
 		return 6;
 	case MESH_FLAGS_AE_A4:
 		return 12;
 	case MESH_FLAGS_AE_A5_A6:
 		return 18;
-	case (MESH_FLAGS_AE_A4 | MESH_FLAGS_AE_A5_A6):
-		return 24;
-	default:
-		return 6;
 	}
 }
+EXPORT_SYMBOL(ieee80211_get_mesh_hdrlen);
=20
 int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 			   enum nl80211_iftype iftype)
@@ -365,6 +363,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u=
8 *addr,
 			/* make sure meshdr->flags is on the linear part */
 			if (!pskb_may_pull(skb, hdrlen + 1))
 				return -1;
+			if (meshdr->flags & MESH_FLAGS_AE_A4)
+				return -1;
 			if (meshdr->flags & MESH_FLAGS_AE_A5_A6) {
 				skb_copy_bits(skb, hdrlen +
 					offsetof(struct ieee80211s_hdr, eaddr1),
@@ -389,6 +389,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u=
8 *addr,
 			/* make sure meshdr->flags is on the linear part */
 			if (!pskb_may_pull(skb, hdrlen + 1))
 				return -1;
+			if (meshdr->flags & MESH_FLAGS_AE_A5_A6)
+				return -1;
 			if (meshdr->flags & MESH_FLAGS_AE_A4)
 				skb_copy_bits(skb, hdrlen +
 					offsetof(struct ieee80211s_hdr, eaddr1),
diff --git a/sound/core/control.c b/sound/core/control.c
index 819a5c5..5511307 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -86,6 +86,7 @@ static int snd_ctl_open(struct inode *inode, struct file =
*file)
 	write_lock_irqsave(&card->ctl_files_rwlock, flags);
 	list_add_tail(&ctl->list, &card->ctl_files);
 	write_unlock_irqrestore(&card->ctl_files_rwlock, flags);
+	snd_card_unref(card);
 	return 0;
=20
       __error:
@@ -93,6 +94,8 @@ static int snd_ctl_open(struct inode *inode, struct file =
*file)
       __error2:
 	snd_card_file_remove(card, file);
       __error1:
+	if (card)
+		snd_card_unref(card);
       	return err;
 }
=20
@@ -1433,6 +1436,8 @@ static ssize_t snd_ctl_read(struct file *file, char _=
_user *buffer,
 			spin_unlock_irq(&ctl->read_lock);
 			schedule();
 			remove_wait_queue(&ctl->change_sleep, &wait);
+			if (ctl->card->shutdown)
+				return -ENODEV;
 			if (signal_pending(current))
 				return -ERESTARTSYS;
 			spin_lock_irq(&ctl->read_lock);
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 75ea16f..3f7f662 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -100,8 +100,10 @@ static int snd_hwdep_open(struct inode *inode, struct =
file * file)
 	if (hw =3D=3D NULL)
 		return -ENODEV;
=20
-	if (!try_module_get(hw->card->module))
+	if (!try_module_get(hw->card->module)) {
+		snd_card_unref(hw->card);
 		return -EFAULT;
+	}
=20
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(&hw->open_wait, &wait);
@@ -129,6 +131,10 @@ static int snd_hwdep_open(struct inode *inode, struct =
file * file)
 		mutex_unlock(&hw->open_mutex);
 		schedule();
 		mutex_lock(&hw->open_mutex);
+		if (hw->card->shutdown) {
+			err =3D -ENODEV;
+			break;
+		}
 		if (signal_pending(current)) {
 			err =3D -ERESTARTSYS;
 			break;
@@ -148,6 +154,7 @@ static int snd_hwdep_open(struct inode *inode, struct f=
ile * file)
 	mutex_unlock(&hw->open_mutex);
 	if (err < 0)
 		module_put(hw->card->module);
+	snd_card_unref(hw->card);
 	return err;
 }
=20
@@ -459,12 +466,15 @@ static int snd_hwdep_dev_disconnect(struct snd_device=
 *device)
 		mutex_unlock(&register_mutex);
 		return -EINVAL;
 	}
+	mutex_lock(&hwdep->open_mutex);
+	wake_up(&hwdep->open_wait);
 #ifdef CONFIG_SND_OSSEMUL
 	if (hwdep->ossreg)
 		snd_unregister_oss_device(hwdep->oss_type, hwdep->card, hwdep->device);
 #endif
 	snd_unregister_device(SNDRV_DEVICE_TYPE_HWDEP, hwdep->card, hwdep->device=
);
 	list_del_init(&hwdep->list);
+	mutex_unlock(&hwdep->open_mutex);
 	mutex_unlock(&register_mutex);
 	return 0;
 }
diff --git a/sound/core/init.c b/sound/core/init.c
index 3ac49b1..fa0f35b 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -212,6 +212,7 @@ int snd_card_create(int idx, const char *xid,
 	spin_lock_init(&card->files_lock);
 	INIT_LIST_HEAD(&card->files_list);
 	init_waitqueue_head(&card->shutdown_sleep);
+	atomic_set(&card->refcount, 0);
 #ifdef CONFIG_PM
 	mutex_init(&card->power_lock);
 	init_waitqueue_head(&card->power_sleep);
@@ -445,21 +446,36 @@ static int snd_card_do_free(struct snd_card *card)
 	return 0;
 }
=20
+/**
+ * snd_card_unref - release the reference counter
+ * @card: the card instance
+ *
+ * Decrements the reference counter.  When it reaches to zero, wake up
+ * the sleeper and call the destructor if needed.
+ */
+void snd_card_unref(struct snd_card *card)
+{
+	if (atomic_dec_and_test(&card->refcount)) {
+		wake_up(&card->shutdown_sleep);
+		if (card->free_on_last_close)
+			snd_card_do_free(card);
+	}
+}
+EXPORT_SYMBOL(snd_card_unref);
+
 int snd_card_free_when_closed(struct snd_card *card)
 {
-	int free_now =3D 0;
-	int ret =3D snd_card_disconnect(card);
-	if (ret)
-		return ret;
+	int ret;
=20
-	spin_lock(&card->files_lock);
-	if (list_empty(&card->files_list))
-		free_now =3D 1;
-	else
-		card->free_on_last_close =3D 1;
-	spin_unlock(&card->files_lock);
+	atomic_inc(&card->refcount);
+	ret =3D snd_card_disconnect(card);
+	if (ret) {
+		atomic_dec(&card->refcount);
+		return ret;
+	}
=20
-	if (free_now)
+	card->free_on_last_close =3D 1;
+	if (atomic_dec_and_test(&card->refcount))
 		snd_card_do_free(card);
 	return 0;
 }
@@ -473,7 +489,7 @@ int snd_card_free(struct snd_card *card)
 		return ret;
=20
 	/* wait, until all devices are ready for the free operation */
-	wait_event(card->shutdown_sleep, list_empty(&card->files_list));
+	wait_event(card->shutdown_sleep, !atomic_read(&card->refcount));
 	snd_card_do_free(card);
 	return 0;
 }
@@ -854,6 +870,7 @@ int snd_card_file_add(struct snd_card *card, struct fil=
e *file)
 		return -ENODEV;
 	}
 	list_add(&mfile->list, &card->files_list);
+	atomic_inc(&card->refcount);
 	spin_unlock(&card->files_lock);
 	return 0;
 }
@@ -876,7 +893,6 @@ EXPORT_SYMBOL(snd_card_file_add);
 int snd_card_file_remove(struct snd_card *card, struct file *file)
 {
 	struct snd_monitor_file *mfile, *found =3D NULL;
-	int last_close =3D 0;
=20
 	spin_lock(&card->files_lock);
 	list_for_each_entry(mfile, &card->files_list, list) {
@@ -891,19 +907,13 @@ int snd_card_file_remove(struct snd_card *card, struc=
t file *file)
 			break;
 		}
 	}
-	if (list_empty(&card->files_list))
-		last_close =3D 1;
 	spin_unlock(&card->files_lock);
-	if (last_close) {
-		wake_up(&card->shutdown_sleep);
-		if (card->free_on_last_close)
-			snd_card_do_free(card);
-	}
 	if (!found) {
 		snd_printk(KERN_ERR "ALSA card file remove problem (%p)\n", file);
 		return -ENOENT;
 	}
 	kfree(found);
+	snd_card_unref(card);
 	return 0;
 }
=20
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 18297f7..c353768 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -52,14 +52,19 @@ static int snd_mixer_oss_open(struct inode *inode, stru=
ct file *file)
 					 SNDRV_OSS_DEVICE_TYPE_MIXER);
 	if (card =3D=3D NULL)
 		return -ENODEV;
-	if (card->mixer_oss =3D=3D NULL)
+	if (card->mixer_oss =3D=3D NULL) {
+		snd_card_unref(card);
 		return -ENODEV;
+	}
 	err =3D snd_card_file_add(card, file);
-	if (err < 0)
+	if (err < 0) {
+		snd_card_unref(card);
 		return err;
+	}
 	fmixer =3D kzalloc(sizeof(*fmixer), GFP_KERNEL);
 	if (fmixer =3D=3D NULL) {
 		snd_card_file_remove(card, file);
+		snd_card_unref(card);
 		return -ENOMEM;
 	}
 	fmixer->card =3D card;
@@ -68,8 +73,10 @@ static int snd_mixer_oss_open(struct inode *inode, struc=
t file *file)
 	if (!try_module_get(card->module)) {
 		kfree(fmixer);
 		snd_card_file_remove(card, file);
+		snd_card_unref(card);
 		return -EFAULT;
 	}
+	snd_card_unref(card);
 	return 0;
 }
=20
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 3cc4b86..542f69e 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2441,6 +2441,10 @@ static int snd_pcm_oss_open(struct inode *inode, str=
uct file *file)
 		mutex_unlock(&pcm->open_mutex);
 		schedule();
 		mutex_lock(&pcm->open_mutex);
+		if (pcm->card->shutdown) {
+			err =3D -ENODEV;
+			break;
+		}
 		if (signal_pending(current)) {
 			err =3D -ERESTARTSYS;
 			break;
@@ -2450,6 +2454,7 @@ static int snd_pcm_oss_open(struct inode *inode, stru=
ct file *file)
 	mutex_unlock(&pcm->open_mutex);
 	if (err < 0)
 		goto __error;
+	snd_card_unref(pcm->card);
 	return err;
=20
       __error:
@@ -2457,6 +2462,8 @@ static int snd_pcm_oss_open(struct inode *inode, stru=
ct file *file)
       __error2:
       	snd_card_file_remove(pcm->card, file);
       __error1:
+	if (pcm)
+		snd_card_unref(pcm->card);
 	return err;
 }
=20
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 8928ca87..13eaeb3 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1046,11 +1046,19 @@ static int snd_pcm_dev_disconnect(struct snd_device=
 *device)
 	if (list_empty(&pcm->list))
 		goto unlock;
=20
+	mutex_lock(&pcm->open_mutex);
+	wake_up(&pcm->open_wait);
 	list_del_init(&pcm->list);
 	for (cidx =3D 0; cidx < 2; cidx++)
-		for (substream =3D pcm->streams[cidx].substream; substream; substream =
=3D substream->next)
-			if (substream->runtime)
+		for (substream =3D pcm->streams[cidx].substream; substream; substream =
=3D substream->next) {
+			snd_pcm_stream_lock_irq(substream);
+			if (substream->runtime) {
 				substream->runtime->status->state =3D SNDRV_PCM_STATE_DISCONNECTED;
+				wake_up(&substream->runtime->sleep);
+				wake_up(&substream->runtime->tsleep);
+			}
+			snd_pcm_stream_unlock_irq(substream);
+		}
 	list_for_each_entry(notify, &snd_pcm_notify_list, list) {
 		notify->n_disconnect(pcm);
 	}
@@ -1066,6 +1074,7 @@ static int snd_pcm_dev_disconnect(struct snd_device *=
device)
 		}
 		snd_unregister_device(devtype, pcm->card, pcm->device);
 	}
+	mutex_unlock(&pcm->open_mutex);
  unlock:
 	mutex_unlock(&register_mutex);
 	return 0;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 25ed9fe..7ada40e 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -369,6 +369,14 @@ static int period_to_usecs(struct snd_pcm_runtime *run=
time)
 	return usecs;
 }
=20
+static void snd_pcm_set_state(struct snd_pcm_substream *substream, int sta=
te)
+{
+	snd_pcm_stream_lock_irq(substream);
+	if (substream->runtime->status->state !=3D SNDRV_PCM_STATE_DISCONNECTED)
+		substream->runtime->status->state =3D state;
+	snd_pcm_stream_unlock_irq(substream);
+}
+
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
@@ -452,7 +460,7 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *=
substream,
 		runtime->boundary *=3D 2;
=20
 	snd_pcm_timer_resolution_change(substream);
-	runtime->status->state =3D SNDRV_PCM_STATE_SETUP;
+	snd_pcm_set_state(substream, SNDRV_PCM_STATE_SETUP);
=20
 	if (pm_qos_request_active(&substream->latency_pm_qos_req))
 		pm_qos_remove_request(&substream->latency_pm_qos_req);
@@ -464,7 +472,7 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *=
substream,
 	/* hardware might be unusable from this time,
 	   so we force application to retry to set
 	   the correct hardware parameter settings */
-	runtime->status->state =3D SNDRV_PCM_STATE_OPEN;
+	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	if (substream->ops->hw_free !=3D NULL)
 		substream->ops->hw_free(substream);
 	return err;
@@ -512,7 +520,7 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *su=
bstream)
 		return -EBADFD;
 	if (substream->ops->hw_free)
 		result =3D substream->ops->hw_free(substream);
-	runtime->status->state =3D SNDRV_PCM_STATE_OPEN;
+	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
 	return result;
 }
@@ -1320,7 +1328,7 @@ static void snd_pcm_post_prepare(struct snd_pcm_subst=
ream *substream, int state)
 {
 	struct snd_pcm_runtime *runtime =3D substream->runtime;
 	runtime->control->appl_ptr =3D runtime->status->hw_ptr;
-	runtime->status->state =3D SNDRV_PCM_STATE_PREPARED;
+	snd_pcm_set_state(substream, SNDRV_PCM_STATE_PREPARED);
 }
=20
 static struct action_ops snd_pcm_action_prepare =3D {
@@ -1500,6 +1508,10 @@ static int snd_pcm_drain(struct snd_pcm_substream *s=
ubstream,
 		down_read(&snd_pcm_link_rwsem);
 		snd_pcm_stream_lock_irq(substream);
 		remove_wait_queue(&to_check->sleep, &wait);
+		if (card->shutdown) {
+			result =3D -ENODEV;
+			break;
+		}
 		if (tout =3D=3D 0) {
 			if (substream->runtime->status->state =3D=3D SNDRV_PCM_STATE_SUSPENDED)
 				result =3D -ESTRPIPE;
@@ -1620,6 +1632,7 @@ static int snd_pcm_link(struct snd_pcm_substream *sub=
stream, int fd)
  _end:
 	write_unlock_irq(&snd_pcm_link_rwlock);
 	up_write(&snd_pcm_link_rwsem);
+	snd_card_unref(substream1->pcm->card);
 	fput(file);
 	return res;
 }
@@ -2092,7 +2105,10 @@ static int snd_pcm_playback_open(struct inode *inode=
, struct file *file)
 		return err;
 	pcm =3D snd_lookup_minor_data(iminor(inode),
 				    SNDRV_DEVICE_TYPE_PCM_PLAYBACK);
-	return snd_pcm_open(file, pcm, SNDRV_PCM_STREAM_PLAYBACK);
+	err =3D snd_pcm_open(file, pcm, SNDRV_PCM_STREAM_PLAYBACK);
+	if (pcm)
+		snd_card_unref(pcm->card);
+	return err;
 }
=20
 static int snd_pcm_capture_open(struct inode *inode, struct file *file)
@@ -2103,7 +2119,10 @@ static int snd_pcm_capture_open(struct inode *inode,=
 struct file *file)
 		return err;
 	pcm =3D snd_lookup_minor_data(iminor(inode),
 				    SNDRV_DEVICE_TYPE_PCM_CAPTURE);
-	return snd_pcm_open(file, pcm, SNDRV_PCM_STREAM_CAPTURE);
+	err =3D snd_pcm_open(file, pcm, SNDRV_PCM_STREAM_CAPTURE);
+	if (pcm)
+		snd_card_unref(pcm->card);
+	return err;
 }
=20
 static int snd_pcm_open(struct file *file, struct snd_pcm *pcm, int stream=
)
@@ -2140,6 +2159,10 @@ static int snd_pcm_open(struct file *file, struct sn=
d_pcm *pcm, int stream)
 		mutex_unlock(&pcm->open_mutex);
 		schedule();
 		mutex_lock(&pcm->open_mutex);
+		if (pcm->card->shutdown) {
+			err =3D -ENODEV;
+			break;
+		}
 		if (signal_pending(current)) {
 			err =3D -ERESTARTSYS;
 			break;
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index ebf6e49..1bb95ae 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -379,8 +379,10 @@ static int snd_rawmidi_open(struct inode *inode, struc=
t file *file)
 	if (rmidi =3D=3D NULL)
 		return -ENODEV;
=20
-	if (!try_module_get(rmidi->card->module))
+	if (!try_module_get(rmidi->card->module)) {
+		snd_card_unref(rmidi->card);
 		return -ENXIO;
+	}
=20
 	mutex_lock(&rmidi->open_mutex);
 	card =3D rmidi->card;
@@ -422,6 +424,10 @@ static int snd_rawmidi_open(struct inode *inode, struc=
t file *file)
 		mutex_unlock(&rmidi->open_mutex);
 		schedule();
 		mutex_lock(&rmidi->open_mutex);
+		if (rmidi->card->shutdown) {
+			err =3D -ENODEV;
+			break;
+		}
 		if (signal_pending(current)) {
 			err =3D -ERESTARTSYS;
 			break;
@@ -440,6 +446,7 @@ static int snd_rawmidi_open(struct inode *inode, struct=
 file *file)
 #endif
 	file->private_data =3D rawmidi_file;
 	mutex_unlock(&rmidi->open_mutex);
+	snd_card_unref(rmidi->card);
 	return 0;
=20
  __error:
@@ -447,6 +454,7 @@ static int snd_rawmidi_open(struct inode *inode, struct=
 file *file)
  __error_card:
 	mutex_unlock(&rmidi->open_mutex);
 	module_put(rmidi->card->module);
+	snd_card_unref(rmidi->card);
 	return err;
 }
=20
@@ -991,6 +999,8 @@ static ssize_t snd_rawmidi_read(struct file *file, char=
 __user *buf, size_t coun
 			spin_unlock_irq(&runtime->lock);
 			schedule();
 			remove_wait_queue(&runtime->sleep, &wait);
+			if (rfile->rmidi->card->shutdown)
+				return -ENODEV;
 			if (signal_pending(current))
 				return result > 0 ? result : -ERESTARTSYS;
 			if (!runtime->avail)
@@ -1234,6 +1244,8 @@ static ssize_t snd_rawmidi_write(struct file *file, c=
onst char __user *buf,
 			spin_unlock_irq(&runtime->lock);
 			timeout =3D schedule_timeout(30 * HZ);
 			remove_wait_queue(&runtime->sleep, &wait);
+			if (rfile->rmidi->card->shutdown)
+				return -ENODEV;
 			if (signal_pending(current))
 				return result > 0 ? result : -ERESTARTSYS;
 			if (!runtime->avail && !timeout)
@@ -1609,9 +1621,20 @@ static int snd_rawmidi_dev_register(struct snd_devic=
e *device)
 static int snd_rawmidi_dev_disconnect(struct snd_device *device)
 {
 	struct snd_rawmidi *rmidi =3D device->device_data;
+	int dir;
=20
 	mutex_lock(&register_mutex);
+	mutex_lock(&rmidi->open_mutex);
+	wake_up(&rmidi->open_wait);
 	list_del_init(&rmidi->list);
+	for (dir =3D 0; dir < 2; dir++) {
+		struct snd_rawmidi_substream *s;
+		list_for_each_entry(s, &rmidi->streams[dir].substreams, list) {
+			if (s->runtime)
+				wake_up(&s->runtime->sleep);
+		}
+	}
+
 #ifdef CONFIG_SND_OSSEMUL
 	if (rmidi->ossreg) {
 		if ((int)rmidi->device =3D=3D midi_map[rmidi->card->number]) {
@@ -1626,6 +1649,7 @@ static int snd_rawmidi_dev_disconnect(struct snd_devi=
ce *device)
 	}
 #endif /* CONFIG_SND_OSSEMUL */
 	snd_unregister_device(SNDRV_DEVICE_TYPE_RAWMIDI, rmidi->card, rmidi->devi=
ce);
+	mutex_unlock(&rmidi->open_mutex);
 	mutex_unlock(&register_mutex);
 	return 0;
 }
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 828af35..8e17b4d 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -99,6 +99,10 @@ static void snd_request_other(int minor)
  *
  * Checks that a minor device with the specified type is registered, and r=
eturns
  * its user data pointer.
+ *
+ * This function increments the reference counter of the card instance
+ * if an associated instance with the given minor number and type is found=
.
+ * The caller must call snd_card_unref() appropriately later.
  */
 void *snd_lookup_minor_data(unsigned int minor, int type)
 {
@@ -109,9 +113,11 @@ void *snd_lookup_minor_data(unsigned int minor, int ty=
pe)
 		return NULL;
 	mutex_lock(&sound_mutex);
 	mreg =3D snd_minors[minor];
-	if (mreg && mreg->type =3D=3D type)
+	if (mreg && mreg->type =3D=3D type) {
 		private_data =3D mreg->private_data;
-	else
+		if (private_data && mreg->card_ptr)
+			atomic_inc(&mreg->card_ptr->refcount);
+	} else
 		private_data =3D NULL;
 	mutex_unlock(&sound_mutex);
 	return private_data;
@@ -275,6 +281,7 @@ int snd_register_device_for_dev(int type, struct snd_ca=
rd *card, int dev,
 	preg->device =3D dev;
 	preg->f_ops =3D f_ops;
 	preg->private_data =3D private_data;
+	preg->card_ptr =3D card;
 	mutex_lock(&sound_mutex);
 #ifdef CONFIG_SND_DYNAMIC_MINORS
 	minor =3D snd_find_free_minor(type);
diff --git a/sound/core/sound_oss.c b/sound/core/sound_oss.c
index c700920..ec86009 100644
--- a/sound/core/sound_oss.c
+++ b/sound/core/sound_oss.c
@@ -40,6 +40,9 @@
 static struct snd_minor *snd_oss_minors[SNDRV_OSS_MINORS];
 static DEFINE_MUTEX(sound_oss_mutex);
=20
+/* NOTE: This function increments the refcount of the associated card like
+ * snd_lookup_minor_data(); the caller must call snd_card_unref() appropri=
ately
+ */
 void *snd_lookup_oss_minor_data(unsigned int minor, int type)
 {
 	struct snd_minor *mreg;
@@ -49,9 +52,11 @@ void *snd_lookup_oss_minor_data(unsigned int minor, int =
type)
 		return NULL;
 	mutex_lock(&sound_oss_mutex);
 	mreg =3D snd_oss_minors[minor];
-	if (mreg && mreg->type =3D=3D type)
+	if (mreg && mreg->type =3D=3D type) {
 		private_data =3D mreg->private_data;
-	else
+		if (private_data && mreg->card_ptr)
+			atomic_inc(&mreg->card_ptr->refcount);
+	} else
 		private_data =3D NULL;
 	mutex_unlock(&sound_oss_mutex);
 	return private_data;
@@ -123,6 +128,7 @@ int snd_register_oss_device(int type, struct snd_card *=
card, int dev,
 	preg->device =3D dev;
 	preg->f_ops =3D f_ops;
 	preg->private_data =3D private_data;
+	preg->card_ptr =3D card;
 	mutex_lock(&sound_oss_mutex);
 	snd_oss_minors[minor] =3D preg;
 	minor_unit =3D SNDRV_MINOR_OSS_DEVICE(minor);
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index bcb3310..b4890f9 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -573,6 +573,7 @@ static int ad198x_build_pcms(struct hda_codec *codec)
 	if (spec->multiout.dig_out_nid) {
 		info++;
 		codec->num_pcms++;
+		codec->spdif_status_reset =3D 1;
 		info->name =3D "AD198x Digital";
 		info->pcm_type =3D HDA_PCM_TYPE_SPDIF;
 		info->stream[SNDRV_PCM_STREAM_PLAYBACK] =3D ad198x_pcm_digital_playback;
diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index e449278..0ed6867 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -93,8 +93,8 @@ enum {
 #define CS420X_VENDOR_NID	0x11
 #define CS_DIG_OUT1_PIN_NID	0x10
 #define CS_DIG_OUT2_PIN_NID	0x15
-#define CS_DMIC1_PIN_NID	0x12
-#define CS_DMIC2_PIN_NID	0x0e
+#define CS_DMIC1_PIN_NID	0x0e
+#define CS_DMIC2_PIN_NID	0x12
=20
 /* coef indices */
 #define IDX_SPDIF_STAT		0x0000
@@ -1088,14 +1088,18 @@ static void init_input(struct hda_codec *codec)
 			cs_automic(codec);
=20
 		coef =3D 0x000a; /* ADC1/2 - Digital and Analog Soft Ramp */
+		cs_vendor_coef_set(codec, IDX_ADC_CFG, coef);
+
+		coef =3D cs_vendor_coef_get(codec, IDX_BEEP_CFG);
 		if (is_active_pin(codec, CS_DMIC2_PIN_NID))
-			coef |=3D 0x0500; /* DMIC2 2 chan on, GPIO1 off */
+			coef |=3D 1 << 4; /* DMIC2 2 chan on, GPIO1 off */
 		if (is_active_pin(codec, CS_DMIC1_PIN_NID))
-			coef |=3D 0x1800; /* DMIC1 2 chan on, GPIO0 off
+			coef |=3D 1 << 3; /* DMIC1 2 chan on, GPIO0 off
 					 * No effect if SPDIF_OUT2 is
 					 * selected in IDX_SPDIF_CTL.
 					*/
-		cs_vendor_coef_set(codec, IDX_ADC_CFG, coef);
+
+		cs_vendor_coef_set(codec, IDX_BEEP_CFG, coef);
 	}
 }
=20
@@ -1109,7 +1113,7 @@ static const struct hda_verb cs_coef_init_verbs[] =3D=
 {
 	  | 0x0400 /* Disable Coefficient Auto increment */
 	  )},
 	/* Beep */
-	{0x11, AC_VERB_SET_COEF_INDEX, IDX_DAC_CFG},
+	{0x11, AC_VERB_SET_COEF_INDEX, IDX_BEEP_CFG},
 	{0x11, AC_VERB_SET_PROC_COEF, 0x0007}, /* Enable Beep thru DAC1/2/3 */
=20
 	{} /* terminator */
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c2c7f90..3ce2da2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6039,6 +6039,7 @@ static const struct hda_codec_preset snd_hda_preset_r=
ealtek[] =3D {
 	  .patch =3D patch_alc662 },
 	{ .id =3D 0x10ec0663, .name =3D "ALC663", .patch =3D patch_alc662 },
 	{ .id =3D 0x10ec0665, .name =3D "ALC665", .patch =3D patch_alc662 },
+	{ .id =3D 0x10ec0668, .name =3D "ALC668", .patch =3D patch_alc662 },
 	{ .id =3D 0x10ec0670, .name =3D "ALC670", .patch =3D patch_alc662 },
 	{ .id =3D 0x10ec0680, .name =3D "ALC680", .patch =3D patch_alc680 },
 	{ .id =3D 0x10ec0880, .name =3D "ALC880", .patch =3D patch_alc880 },
@@ -6056,6 +6057,7 @@ static const struct hda_codec_preset snd_hda_preset_r=
ealtek[] =3D {
 	{ .id =3D 0x10ec0889, .name =3D "ALC889", .patch =3D patch_alc882 },
 	{ .id =3D 0x10ec0892, .name =3D "ALC892", .patch =3D patch_alc662 },
 	{ .id =3D 0x10ec0899, .name =3D "ALC898", .patch =3D patch_alc882 },
+	{ .id =3D 0x10ec0900, .name =3D "ALC1150", .patch =3D patch_alc882 },
 	{} /* terminator */
 };
=20
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 7160ff2..9e0c889 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1856,11 +1856,11 @@ static int via_auto_fill_dac_nids(struct hda_codec =
*codec)
 {
 	struct via_spec *spec =3D codec->spec;
 	const struct auto_pin_cfg *cfg =3D &spec->autocfg;
-	int i, dac_num;
+	int i;
 	hda_nid_t nid;
=20
+	spec->multiout.num_dacs =3D 0;
 	spec->multiout.dac_nids =3D spec->private_dac_nids;
-	dac_num =3D 0;
 	for (i =3D 0; i < cfg->line_outs; i++) {
 		hda_nid_t dac =3D 0;
 		nid =3D cfg->line_out_pins[i];
@@ -1871,16 +1871,13 @@ static int via_auto_fill_dac_nids(struct hda_codec =
*codec)
 		if (!i && parse_output_path(codec, nid, dac, 1,
 					    &spec->out_mix_path))
 			dac =3D spec->out_mix_path.path[0];
-		if (dac) {
-			spec->private_dac_nids[i] =3D dac;
-			dac_num++;
-		}
+		if (dac)
+			spec->private_dac_nids[spec->multiout.num_dacs++] =3D dac;
 	}
 	if (!spec->out_path[0].depth && spec->out_mix_path.depth) {
 		spec->out_path[0] =3D spec->out_mix_path;
 		spec->out_mix_path.depth =3D 0;
 	}
-	spec->multiout.num_dacs =3D dac_num;
 	return 0;
 }
=20
@@ -3689,6 +3686,18 @@ static void set_widgets_power_state_vt2002P(struct h=
da_codec *codec)
 				    AC_VERB_SET_POWER_STATE, AC_PWRST_D3);
 }
=20
+/* NIDs 0x24 and 0x33 on VT1802 have connections to non-existing NID 0x3e
+ * Replace this with mixer NID 0x1c
+ */
+static void fix_vt1802_connections(struct hda_codec *codec)
+{
+	static hda_nid_t conn_24[] =3D { 0x14, 0x1c };
+	static hda_nid_t conn_33[] =3D { 0x1c };
+
+	snd_hda_override_conn_list(codec, 0x24, ARRAY_SIZE(conn_24), conn_24);
+	snd_hda_override_conn_list(codec, 0x33, ARRAY_SIZE(conn_33), conn_33);
+}
+
 /* patch for vt2002P */
 static int patch_vt2002P(struct hda_codec *codec)
 {
@@ -3703,6 +3712,8 @@ static int patch_vt2002P(struct hda_codec *codec)
 	spec->aa_mix_nid =3D 0x21;
 	override_mic_boost(codec, 0x2b, 0, 3, 40);
 	override_mic_boost(codec, 0x29, 0, 3, 40);
+	if (spec->codec_type =3D=3D VT1802)
+		fix_vt1802_connections(codec);
 	add_secret_dac_path(codec);
=20
 	/* automatic parse from the BIOS config */
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 0f6dc0d..566acb3 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -336,7 +336,7 @@ static int snd_usb_audio_create(struct usb_device *dev,=
 int idx,
 		return -ENOMEM;
 	}
=20
-	mutex_init(&chip->shutdown_mutex);
+	init_rwsem(&chip->shutdown_rwsem);
 	chip->index =3D idx;
 	chip->dev =3D dev;
 	chip->card =3D card;
@@ -555,9 +555,11 @@ static void snd_usb_audio_disconnect(struct usb_device=
 *dev,
 		return;
=20
 	card =3D chip->card;
-	mutex_lock(&register_mutex);
-	mutex_lock(&chip->shutdown_mutex);
+	down_write(&chip->shutdown_rwsem);
 	chip->shutdown =3D 1;
+	up_write(&chip->shutdown_rwsem);
+
+	mutex_lock(&register_mutex);
 	chip->num_interfaces--;
 	if (chip->num_interfaces <=3D 0) {
 		snd_card_disconnect(card);
@@ -574,11 +576,9 @@ static void snd_usb_audio_disconnect(struct usb_device=
 *dev,
 			snd_usb_mixer_disconnect(p);
 		}
 		usb_chip[chip->index] =3D NULL;
-		mutex_unlock(&chip->shutdown_mutex);
 		mutex_unlock(&register_mutex);
 		snd_card_free_when_closed(card);
 	} else {
-		mutex_unlock(&chip->shutdown_mutex);
 		mutex_unlock(&register_mutex);
 	}
 }
@@ -610,16 +610,20 @@ int snd_usb_autoresume(struct snd_usb_audio *chip)
 {
 	int err =3D -ENODEV;
=20
+	down_read(&chip->shutdown_rwsem);
 	if (!chip->shutdown && !chip->probing)
 		err =3D usb_autopm_get_interface(chip->pm_intf);
+	up_read(&chip->shutdown_rwsem);
=20
 	return err;
 }
=20
 void snd_usb_autosuspend(struct snd_usb_audio *chip)
 {
+	down_read(&chip->shutdown_rwsem);
 	if (!chip->shutdown && !chip->probing)
 		usb_autopm_put_interface(chip->pm_intf);
+	up_read(&chip->shutdown_rwsem);
 }
=20
 static int usb_audio_suspend(struct usb_interface *intf, pm_message_t mess=
age)
diff --git a/sound/usb/card.h b/sound/usb/card.h
index a39edcc..665e297 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -86,6 +86,7 @@ struct snd_usb_substream {
 	struct snd_urb_ctx syncurb[SYNC_URBS];	/* sync urb table */
 	char *syncbuf;				/* sync buffer for all sync URBs */
 	dma_addr_t sync_dma;			/* DMA address of syncbuf */
+	unsigned int speed;		/* USB_SPEED_XXX */
=20
 	u64 formats;			/* format bitmasks (all or'ed) */
 	unsigned int num_formats;		/* number of supported audio formats (list) */
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 08dcce5..24c5114 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -148,8 +148,10 @@ void snd_usb_release_substream_urbs(struct snd_usb_sub=
stream *subs, int force)
 	int i;
=20
 	/* stop urbs (to be sure) */
-	deactivate_urbs(subs, force, 1);
-	wait_clear_urbs(subs);
+	if (!subs->stream->chip->shutdown) {
+		deactivate_urbs(subs, force, 1);
+		wait_clear_urbs(subs);
+	}
=20
 	for (i =3D 0; i < MAX_URBS; i++)
 		release_urb_ctx(&subs->dataurb[i]);
@@ -895,7 +897,8 @@ void snd_usb_init_substream(struct snd_usb_stream *as,
 	subs->dev =3D as->chip->dev;
 	subs->txfr_quirk =3D as->chip->txfr_quirk;
 	subs->ops =3D audio_urb_ops[stream];
-	if (snd_usb_get_speed(subs->dev) >=3D USB_SPEED_HIGH)
+	subs->speed =3D snd_usb_get_speed(subs->dev);
+	if (subs->speed >=3D USB_SPEED_HIGH)
 		subs->ops.prepare_sync =3D prepare_capture_sync_urb_hs;
=20
 	snd_usb_set_pcm_ops(as->pcm, stream);
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index ab23869..6730a33 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -287,25 +287,32 @@ static int get_ctl_value_v1(struct usb_mixer_elem_inf=
o *cval, int request, int v
 	unsigned char buf[2];
 	int val_len =3D cval->val_type >=3D USB_MIXER_S16 ? 2 : 1;
 	int timeout =3D 10;
-	int err;
+	int idx =3D 0, err;
=20
 	err =3D snd_usb_autoresume(cval->mixer->chip);
 	if (err < 0)
 		return -EIO;
+	down_read(&chip->shutdown_rwsem);
 	while (timeout-- > 0) {
+		if (chip->shutdown)
+			break;
+		idx =3D snd_usb_ctrl_intf(chip) | (cval->id << 8);
 		if (snd_usb_ctl_msg(chip->dev, usb_rcvctrlpipe(chip->dev, 0), request,
 				    USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
-				    validx, snd_usb_ctrl_intf(chip) | (cval->id << 8),
-				    buf, val_len) >=3D val_len) {
+				    validx, idx, buf, val_len) >=3D val_len) {
 			*value_ret =3D convert_signed_value(cval, snd_usb_combine_bytes(buf, va=
l_len));
-			snd_usb_autosuspend(cval->mixer->chip);
-			return 0;
+			err =3D 0;
+			goto out;
 		}
 	}
-	snd_usb_autosuspend(cval->mixer->chip);
 	snd_printdd(KERN_ERR "cannot get ctl value: req =3D %#x, wValue =3D %#x, =
wIndex =3D %#x, type =3D %d\n",
-		    request, validx, snd_usb_ctrl_intf(chip) | (cval->id << 8), cval->va=
l_type);
-	return -EINVAL;
+		    request, validx, idx, cval->val_type);
+	err =3D -EINVAL;
+
+ out:
+	up_read(&chip->shutdown_rwsem);
+	snd_usb_autosuspend(cval->mixer->chip);
+	return err;
 }
=20
 static int get_ctl_value_v2(struct usb_mixer_elem_info *cval, int request,=
 int validx, int *value_ret)
@@ -313,7 +320,7 @@ static int get_ctl_value_v2(struct usb_mixer_elem_info =
*cval, int request, int v
 	struct snd_usb_audio *chip =3D cval->mixer->chip;
 	unsigned char buf[2 + 3*sizeof(__u16)]; /* enough space for one range */
 	unsigned char *val;
-	int ret, size;
+	int idx =3D 0, ret, size;
 	__u8 bRequest;
=20
 	if (request =3D=3D UAC_GET_CUR) {
@@ -330,16 +337,22 @@ static int get_ctl_value_v2(struct usb_mixer_elem_inf=
o *cval, int request, int v
 	if (ret)
 		goto error;
=20
-	ret =3D snd_usb_ctl_msg(chip->dev, usb_rcvctrlpipe(chip->dev, 0), bReques=
t,
+	down_read(&chip->shutdown_rwsem);
+	if (chip->shutdown)
+		ret =3D -ENODEV;
+	else {
+		idx =3D snd_usb_ctrl_intf(chip) | (cval->id << 8);
+		ret =3D snd_usb_ctl_msg(chip->dev, usb_rcvctrlpipe(chip->dev, 0), bReque=
st,
 			      USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
-			      validx, snd_usb_ctrl_intf(chip) | (cval->id << 8),
-			      buf, size);
+			      validx, idx, buf, size);
+	}
+	up_read(&chip->shutdown_rwsem);
 	snd_usb_autosuspend(chip);
=20
 	if (ret < 0) {
 error:
 		snd_printk(KERN_ERR "cannot get ctl value: req =3D %#x, wValue =3D %#x, =
wIndex =3D %#x, type =3D %d\n",
-			   request, validx, snd_usb_ctrl_intf(chip) | (cval->id << 8), cval->va=
l_type);
+			   request, validx, idx, cval->val_type);
 		return ret;
 	}
=20
@@ -417,7 +430,7 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_i=
nfo *cval,
 {
 	struct snd_usb_audio *chip =3D cval->mixer->chip;
 	unsigned char buf[2];
-	int val_len, err, timeout =3D 10;
+	int idx =3D 0, val_len, err, timeout =3D 10;
=20
 	if (cval->mixer->protocol =3D=3D UAC_VERSION_1) {
 		val_len =3D cval->val_type >=3D USB_MIXER_S16 ? 2 : 1;
@@ -440,19 +453,27 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem=
_info *cval,
 	err =3D snd_usb_autoresume(chip);
 	if (err < 0)
 		return -EIO;
-	while (timeout-- > 0)
+	down_read(&chip->shutdown_rwsem);
+	while (timeout-- > 0) {
+		if (chip->shutdown)
+			break;
+		idx =3D snd_usb_ctrl_intf(chip) | (cval->id << 8);
 		if (snd_usb_ctl_msg(chip->dev,
 				    usb_sndctrlpipe(chip->dev, 0), request,
 				    USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_OUT,
-				    validx, snd_usb_ctrl_intf(chip) | (cval->id << 8),
-				    buf, val_len) >=3D 0) {
-			snd_usb_autosuspend(chip);
-			return 0;
+				    validx, idx, buf, val_len) >=3D 0) {
+			err =3D 0;
+			goto out;
 		}
-	snd_usb_autosuspend(chip);
+	}
 	snd_printdd(KERN_ERR "cannot set ctl value: req =3D %#x, wValue =3D %#x, =
wIndex =3D %#x, type =3D %d, data =3D %#x/%#x\n",
-		    request, validx, snd_usb_ctrl_intf(chip) | (cval->id << 8), cval->va=
l_type, buf[0], buf[1]);
-	return -EINVAL;
+		    request, validx, idx, cval->val_type, buf[0], buf[1]);
+	err =3D -EINVAL;
+
+ out:
+	up_read(&chip->shutdown_rwsem);
+	snd_usb_autosuspend(chip);
+	return err;
 }
=20
 static int set_cur_ctl_value(struct usb_mixer_elem_info *cval, int validx,=
 int value)
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index ab125ee..38a607a 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -186,6 +186,11 @@ static int snd_audigy2nx_led_put(struct snd_kcontrol *=
kcontrol, struct snd_ctl_e
 	if (value > 1)
 		return -EINVAL;
 	changed =3D value !=3D mixer->audigy2nx_leds[index];
+	down_read(&mixer->chip->shutdown_rwsem);
+	if (mixer->chip->shutdown) {
+		err =3D -ENODEV;
+		goto out;
+	}
 	if (mixer->chip->usb_id =3D=3D USB_ID(0x041e, 0x3042))
 		err =3D snd_usb_ctl_msg(mixer->chip->dev,
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x24,
@@ -202,6 +207,8 @@ static int snd_audigy2nx_led_put(struct snd_kcontrol *k=
control, struct snd_ctl_e
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x24,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
 			      value, index + 2, NULL, 0);
+ out:
+	up_read(&mixer->chip->shutdown_rwsem);
 	if (err < 0)
 		return err;
 	mixer->audigy2nx_leds[index] =3D value;
@@ -295,11 +302,16 @@ static void snd_audigy2nx_proc_read(struct snd_info_e=
ntry *entry,
=20
 	for (i =3D 0; jacks[i].name; ++i) {
 		snd_iprintf(buffer, "%s: ", jacks[i].name);
-		err =3D snd_usb_ctl_msg(mixer->chip->dev,
+		down_read(&mixer->chip->shutdown_rwsem);
+		if (mixer->chip->shutdown)
+			err =3D 0;
+		else
+			err =3D snd_usb_ctl_msg(mixer->chip->dev,
 				      usb_rcvctrlpipe(mixer->chip->dev, 0),
 				      UAC_GET_MEM, USB_DIR_IN | USB_TYPE_CLASS |
 				      USB_RECIP_INTERFACE, 0,
 				      jacks[i].unitid << 8, buf, 3);
+		up_read(&mixer->chip->shutdown_rwsem);
 		if (err =3D=3D 3 && (buf[0] =3D=3D 3 || buf[0] =3D=3D 6))
 			snd_iprintf(buffer, "%02x %02x\n", buf[1], buf[2]);
 		else
@@ -329,10 +341,15 @@ static int snd_xonar_u1_switch_put(struct snd_kcontro=
l *kcontrol,
 	else
 		new_status =3D old_status & ~0x02;
 	changed =3D new_status !=3D old_status;
-	err =3D snd_usb_ctl_msg(mixer->chip->dev,
+	down_read(&mixer->chip->shutdown_rwsem);
+	if (mixer->chip->shutdown)
+		err =3D -ENODEV;
+	else
+		err =3D snd_usb_ctl_msg(mixer->chip->dev,
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x08,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
 			      50, 0, &new_status, 1);
+	up_read(&mixer->chip->shutdown_rwsem);
 	if (err < 0)
 		return err;
 	mixer->xonar_u1_status =3D new_status;
@@ -371,11 +388,17 @@ static int snd_nativeinstruments_control_get(struct s=
nd_kcontrol *kcontrol,
 	u8 bRequest =3D (kcontrol->private_value >> 16) & 0xff;
 	u16 wIndex =3D kcontrol->private_value & 0xffff;
 	u8 tmp;
+	int ret;
=20
-	int ret =3D usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), bRequest,
+	down_read(&mixer->chip->shutdown_rwsem);
+	if (mixer->chip->shutdown)
+		ret =3D -ENODEV;
+	else
+		ret =3D usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 				  0, cpu_to_le16(wIndex),
 				  &tmp, sizeof(tmp), 1000);
+	up_read(&mixer->chip->shutdown_rwsem);
=20
 	if (ret < 0) {
 		snd_printk(KERN_ERR
@@ -396,11 +419,17 @@ static int snd_nativeinstruments_control_put(struct s=
nd_kcontrol *kcontrol,
 	u8 bRequest =3D (kcontrol->private_value >> 16) & 0xff;
 	u16 wIndex =3D kcontrol->private_value & 0xffff;
 	u16 wValue =3D ucontrol->value.integer.value[0];
+	int ret;
=20
-	int ret =3D usb_control_msg(dev, usb_sndctrlpipe(dev, 0), bRequest,
+	down_read(&mixer->chip->shutdown_rwsem);
+	if (mixer->chip->shutdown)
+		ret =3D -ENODEV;
+	else
+		ret =3D usb_control_msg(dev, usb_sndctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 				  cpu_to_le16(wValue), cpu_to_le16(wIndex),
 				  NULL, 0, 1000);
+	up_read(&mixer->chip->shutdown_rwsem);
=20
 	if (ret < 0) {
 		snd_printk(KERN_ERR
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 839165f..983e071 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -67,6 +67,8 @@ static snd_pcm_uframes_t snd_usb_pcm_pointer(struct snd_p=
cm_substream *substream
 	unsigned int hwptr_done;
=20
 	subs =3D (struct snd_usb_substream *)substream->runtime->private_data;
+	if (subs->stream->chip->shutdown)
+		return SNDRV_PCM_POS_XRUN;
 	spin_lock(&subs->lock);
 	hwptr_done =3D subs->hwptr_done;
 	substream->runtime->delay =3D snd_usb_pcm_delay(subs,
@@ -373,8 +375,14 @@ static int snd_usb_hw_params(struct snd_pcm_substream =
*substream,
 	changed =3D subs->cur_audiofmt !=3D fmt ||
 		subs->period_bytes !=3D params_period_bytes(hw_params) ||
 		subs->cur_rate !=3D rate;
+
+	down_read(&subs->stream->chip->shutdown_rwsem);
+	if (subs->stream->chip->shutdown) {
+		ret =3D -ENODEV;
+		goto unlock;
+	}
 	if ((ret =3D set_format(subs, fmt)) < 0)
-		return ret;
+		goto unlock;
=20
 	if (subs->cur_rate !=3D rate) {
 		struct usb_host_interface *alts;
@@ -383,12 +391,11 @@ static int snd_usb_hw_params(struct snd_pcm_substream=
 *substream,
 		alts =3D &iface->altsetting[fmt->altset_idx];
 		ret =3D snd_usb_init_sample_rate(subs->stream->chip, subs->interface, al=
ts, fmt, rate);
 		if (ret < 0)
-			return ret;
+			goto unlock;
 		subs->cur_rate =3D rate;
 	}
=20
 	if (changed) {
-		mutex_lock(&subs->stream->chip->shutdown_mutex);
 		/* format changed */
 		snd_usb_release_substream_urbs(subs, 0);
 		/* influenced: period_bytes, channels, rate, format, */
@@ -396,9 +403,10 @@ static int snd_usb_hw_params(struct snd_pcm_substream =
*substream,
 						  params_rate(hw_params),
 						  snd_pcm_format_physical_width(params_format(hw_params)) *
 							params_channels(hw_params));
-		mutex_unlock(&subs->stream->chip->shutdown_mutex);
 	}
=20
+unlock:
+	up_read(&subs->stream->chip->shutdown_rwsem);
 	return ret;
 }
=20
@@ -414,9 +422,9 @@ static int snd_usb_hw_free(struct snd_pcm_substream *su=
bstream)
 	subs->cur_audiofmt =3D NULL;
 	subs->cur_rate =3D 0;
 	subs->period_bytes =3D 0;
-	mutex_lock(&subs->stream->chip->shutdown_mutex);
+	down_read(&subs->stream->chip->shutdown_rwsem);
 	snd_usb_release_substream_urbs(subs, 0);
-	mutex_unlock(&subs->stream->chip->shutdown_mutex);
+	up_read(&subs->stream->chip->shutdown_rwsem);
 	return snd_pcm_lib_free_vmalloc_buffer(substream);
 }
=20
@@ -429,12 +437,18 @@ static int snd_usb_pcm_prepare(struct snd_pcm_substre=
am *substream)
 {
 	struct snd_pcm_runtime *runtime =3D substream->runtime;
 	struct snd_usb_substream *subs =3D runtime->private_data;
+	int ret =3D 0;
=20
 	if (! subs->cur_audiofmt) {
 		snd_printk(KERN_ERR "usbaudio: no format is specified!\n");
 		return -ENXIO;
 	}
=20
+	down_read(&subs->stream->chip->shutdown_rwsem);
+	if (subs->stream->chip->shutdown) {
+		ret =3D -ENODEV;
+		goto unlock;
+	}
 	/* some unit conversions in runtime */
 	subs->maxframesize =3D bytes_to_frames(runtime, subs->maxpacksize);
 	subs->curframesize =3D bytes_to_frames(runtime, subs->curpacksize);
@@ -447,7 +461,10 @@ static int snd_usb_pcm_prepare(struct snd_pcm_substrea=
m *substream)
 	subs->last_frame_number =3D 0;
 	runtime->delay =3D 0;
=20
-	return snd_usb_substream_prepare(subs, runtime);
+	ret =3D snd_usb_substream_prepare(subs, runtime);
+ unlock:
+	up_read(&subs->stream->chip->shutdown_rwsem);
+	return ret;
 }
=20
 static struct snd_pcm_hardware snd_usb_hardware =3D
@@ -500,7 +517,7 @@ static int hw_check_valid_format(struct snd_usb_substre=
am *subs,
 		return 0;
 	}
 	/* check whether the period time is >=3D the data packet interval */
-	if (snd_usb_get_speed(subs->dev) !=3D USB_SPEED_FULL) {
+	if (subs->speed !=3D USB_SPEED_FULL) {
 		ptime =3D 125 * (1 << fp->datainterval);
 		if (ptime > pt->max || (ptime =3D=3D pt->max && pt->openmax)) {
 			hwc_debug("   > check: ptime %u > max %u\n", ptime, pt->max);
@@ -776,7 +793,7 @@ static int setup_hw_info(struct snd_pcm_runtime *runtim=
e, struct snd_usb_substre
 		return err;
=20
 	param_period_time_if_needed =3D SNDRV_PCM_HW_PARAM_PERIOD_TIME;
-	if (snd_usb_get_speed(subs->dev) =3D=3D USB_SPEED_FULL)
+	if (subs->speed =3D=3D USB_SPEED_FULL)
 		/* full speed devices have fixed data packet interval */
 		ptmin =3D 1000;
 	if (ptmin =3D=3D 1000)
diff --git a/sound/usb/proc.c b/sound/usb/proc.c
index 961c9a2..aef03db 100644
--- a/sound/usb/proc.c
+++ b/sound/usb/proc.c
@@ -107,7 +107,7 @@ static void proc_dump_substream_formats(struct snd_usb_=
substream *subs, struct s
 			}
 			snd_iprintf(buffer, "\n");
 		}
-		if (snd_usb_get_speed(subs->dev) !=3D USB_SPEED_FULL)
+		if (subs->speed !=3D USB_SPEED_FULL)
 			snd_iprintf(buffer, "    Data packet interval: %d us\n",
 				    125 * (1 << fp->datainterval));
 		// snd_iprintf(buffer, "    Max Packet Size =3D %d\n", fp->maxpacksize);
@@ -128,7 +128,7 @@ static void proc_dump_substream_status(struct snd_usb_s=
ubstream *subs, struct sn
 		snd_iprintf(buffer, "]\n");
 		snd_iprintf(buffer, "    Packet Size =3D %d\n", subs->curpacksize);
 		snd_iprintf(buffer, "    Momentary freq =3D %u Hz (%#x.%04x)\n",
-			    snd_usb_get_speed(subs->dev) =3D=3D USB_SPEED_FULL
+			    subs->speed =3D=3D USB_SPEED_FULL
 			    ? get_full_speed_hz(subs->freqm)
 			    : get_high_speed_hz(subs->freqm),
 			    subs->freqm >> 16, subs->freqm & 0xffff);
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 3e2b035..6c805a5 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -36,7 +36,7 @@ struct snd_usb_audio {
 	struct snd_card *card;
 	struct usb_interface *pm_intf;
 	u32 usb_id;
-	struct mutex shutdown_mutex;
+	struct rw_semaphore shutdown_rwsem;
 	unsigned int shutdown:1;
 	unsigned int probing:1;
 	unsigned int autosuspended:1;=09



--=-CbXBT53z/rtTP0z8+X42
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUKcNoue/yOyVhhEJAQqXnQ/+LUSqL0tFrfHwtB2LspN//jChfFpWVr7R
pEhLn7iBJljkXLqqmKauxqulkUz71JEhQ6hROoEazM5mdPD2h/PUrXea4/gix51a
1jAvZNh/rDru57S094C+vxmevbkxE+yiVa4pXPzwKpNuAgc50xJkTk7heUnIDAQU
6eNJwnppLYbMOf2rlEv31UpIwtZNrHPn1H1VBmUR2Bp9I62CC7bHFIzNTcxFMrpj
DLBtWtRwpV7fEjvwDb3Ncj4IZSuVhMa2cpMrZUkLF36BfLHyu0WA4k3dFFYa4a+E
myaKDXXz+Xg97A5lY+LGqQmBUfTM6+UdPC8CHtrQ5jiQudTD8DHT4k5060MmYMnW
u/Wq+xAkBjMXVmh/I9UINC0pdH0Qeu5gpwHY4jUtrDMkecFVjiHFVKOoeR4fPzn+
LPCG30sSvh8eH3gtxJXkFTG2gLd36jRbp+AORFuUxmu8PrsA1VJAMaW4lY0GJtVq
MWPefq4gKoIy9mp/BKjSkM/lNAH/Bl+Yofsu63eVNCZmV9DAUJA5HUodmWkUU8Uk
22DWvECr80IQ5UVkb6x8HSV2t5kRUnAJA6IjxANK2+Qh/hZaZVDRffBPWlyvD3Tt
7ViaznxjswrZlzgAWyd18r6J4mhwQtSJ5eBtmEAU3GnqWYssl9Pdn925IdIQdAoG
Sk4LrFDVa30=
=LK9U
-----END PGP SIGNATURE-----

--=-CbXBT53z/rtTP0z8+X42--
