Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab1BKADc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:03:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64985 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab1BKAD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:03:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sQW0eKfJNV9imx/2HqfD5qZOgexhe6pC1BJosIJiryeB5MkESbQ/QX+pS+D8WcWlwC
         pGMLpp1bJAKPL7x/EHF3wFJxOzV1cou9ibgc5h2kaTqoKfXh9l1aew8xgWaWChXipLeq
         wi6WnOmj4pcp+Zum8JgQqG9kUzHHShj7SiwNk=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>
Subject: [PATCH] Staging: tidspbridge: fixed several coding style issues
Date: Fri, 11 Feb 2011 01:02:46 +0100
Message-Id: <1297382566-18748-1-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed several coding style issues.

Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>
---
 drivers/staging/tidspbridge/core/_tiomap.h         |    4 +-
 drivers/staging/tidspbridge/core/_tiomap_pwr.h     |   10 +-
 drivers/staging/tidspbridge/core/io_sm.c           |    7 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |   37 ++--
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |   16 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |    2 +-
 drivers/staging/tidspbridge/core/wdt.c             |    2 +-
 drivers/staging/tidspbridge/dynload/cload.c        |   10 +-
 drivers/staging/tidspbridge/dynload/reloc.c        |    2 +-
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |  236 ++++++++++----------
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  108 +++++-----
 .../tidspbridge/include/dspbridge/cfgdefs.h        |    2 +-
 .../staging/tidspbridge/include/dspbridge/cmm.h    |    4 +-
 .../staging/tidspbridge/include/dspbridge/dbc.h    |    6 +-
 .../tidspbridge/include/dspbridge/dspdefs.h        |   42 ++--
 .../tidspbridge/include/dspbridge/host_os.h        |    2 +-
 .../staging/tidspbridge/include/dspbridge/mbx_sh.h |    2 +-
 .../tidspbridge/include/dspbridge/nldrdefs.h       |    4 +-
 .../staging/tidspbridge/include/dspbridge/node.h   |    2 +-
 .../staging/tidspbridge/include/dspbridge/ntfy.h   |    2 +-
 .../staging/tidspbridge/include/dspbridge/rms_sh.h |    2 +-
 .../staging/tidspbridge/include/dspbridge/sync.h   |    2 +-
 drivers/staging/tidspbridge/pmgr/dbll.c            |    2 +-
 drivers/staging/tidspbridge/pmgr/dev.c             |    4 +-
 drivers/staging/tidspbridge/pmgr/dmm.c             |    4 +-
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |    4 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |    4 +-
 drivers/staging/tidspbridge/rmgr/node.c            |    5 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |    4 +-
 drivers/staging/tidspbridge/rmgr/strm.c            |    2 +-
 30 files changed, 272 insertions(+), 261 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/_tiomap.h b/drivers/staging/tidspbridge/core/_tiomap.h
index 1159a50..de65109 100644
--- a/drivers/staging/tidspbridge/core/_tiomap.h
+++ b/drivers/staging/tidspbridge/core/_tiomap.h
@@ -145,8 +145,8 @@ struct map_l4_peripheral {
 #define L4_PERIPHERAL_MBOX        0x48094000
 #define DSPVA_PERIPHERAL_MBOX     0x11808000
 
-#define PM_GRPSEL_BASE 			0x48307000
-#define DSPVA_GRPSEL_BASE 		0x11821000
+#define PM_GRPSEL_BASE		0x48307000
+#define DSPVA_GRPSEL_BASE	0x11821000
 
 #define L4_PERIPHERAL_SIDETONE_MCBSP2        0x49028000
 #define DSPVA_PERIPHERAL_SIDETONE_MCBSP2 0x11824000
diff --git a/drivers/staging/tidspbridge/core/_tiomap_pwr.h b/drivers/staging/tidspbridge/core/_tiomap_pwr.h
index bd0354d..7bbd380 100644
--- a/drivers/staging/tidspbridge/core/_tiomap_pwr.h
+++ b/drivers/staging/tidspbridge/core/_tiomap_pwr.h
@@ -40,7 +40,7 @@ extern int sleep_dsp(struct bridge_dev_context *dev_context,
 			    u32 dw_cmd, void *pargs);
 /*
  *  ========interrupt_dsp========
- *  	  Sends an interrupt to DSP unconditionally.
+ *	Sends an interrupt to DSP unconditionally.
  */
 extern void interrupt_dsp(struct bridge_dev_context *dev_context,
 							u16 mb_val);
@@ -53,24 +53,24 @@ extern int dsp_peripheral_clk_ctrl(struct bridge_dev_context
 					*dev_context, void *pargs);
 /*
  *  ======== handle_hibernation_from_dsp ========
- *  	Handle Hibernation requested from DSP
+ *	Handle Hibernation requested from DSP
  */
 int handle_hibernation_from_dsp(struct bridge_dev_context *dev_context);
 /*
  *  ======== post_scale_dsp ========
- *  	Handle Post Scale notification to DSP
+ *	Handle Post Scale notification to DSP
  */
 int post_scale_dsp(struct bridge_dev_context *dev_context,
 							void *pargs);
 /*
  *  ======== pre_scale_dsp ========
- *  	Handle Pre Scale notification to DSP
+ *	Handle Pre Scale notification to DSP
  */
 int pre_scale_dsp(struct bridge_dev_context *dev_context,
 							void *pargs);
 /*
  *  ======== handle_constraints_set ========
- *  	Handle constraints request from DSP
+ *	Handle constraints request from DSP
  */
 int handle_constraints_set(struct bridge_dev_context *dev_context,
 				  void *pargs);
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 27e0aa8..0e21b72 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -456,7 +456,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 
 		dev_dbg(bridge, "%s: ul_gpp_pa %x, ul_gpp_va %x, ul_dsp_va %x, "
 			"shm0_end %x, ul_dyn_ext_base %x, ul_ext_end %x, "
-			"ul_seg_size %x ul_seg1_size %x \n", __func__,
+			"ul_seg_size %x ul_seg1_size %x\n", __func__,
 			ul_gpp_pa, ul_gpp_va, ul_dsp_va, shm0_end,
 			ul_dyn_ext_base, ul_ext_end, ul_seg_size, ul_seg1_size);
 
@@ -1160,9 +1160,8 @@ static void input_chnl(struct io_mgr *pio_mgr, struct chnl_object *pchnl,
 				/* Tell DSP if no more I/O buffers available */
 				if (!pchnl->pio_requests)
 					goto func_end;
-				if (LST_IS_EMPTY(pchnl->pio_requests)) {
+				if (LST_IS_EMPTY(pchnl->pio_requests))
 					set_chnl_free(sm, pchnl->chnl_id);
-				}
 				clear_chnl = true;
 				notify_client = true;
 			} else {
@@ -1241,7 +1240,7 @@ static void input_msg(struct io_mgr *pio_mgr, struct msg_mgr *hmsg_mgr)
 		msg_queue_obj =
 		    (struct msg_queue *)lst_first(hmsg_mgr->queue_list);
 		dev_dbg(bridge,	"input msg: dw_cmd=0x%x dw_arg1=0x%x "
-			"dw_arg2=0x%x msgq_id=0x%x \n", msg.msg.dw_cmd,
+			"dw_arg2=0x%x msgq_id=0x%x\n", msg.msg.dw_cmd,
 			msg.msg.dw_arg1, msg.msg.dw_arg2, msg.msgq_id);
 		/*
 		 * Interrupt may occur before shared memory and message
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index a3f69f6..4d7fd02 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -133,7 +133,8 @@ static int mem_map_vmalloc(struct bridge_dev_context *dev_context,
 				  u32 ul_num_bytes,
 				  struct hw_mmu_map_attrs_t *hw_attrs);
 
-bool wait_for_start(struct bridge_dev_context *dev_context, u32 dw_sync_addr);
+static bool wait_for_start(struct bridge_dev_context *dev_context,
+				u32 dw_sync_addr);
 
 /*  ----------------------------------- Globals */
 
@@ -296,7 +297,8 @@ static int bridge_brd_monitor(struct bridge_dev_context *dev_ctxt)
 					OMAP3430_IVA2_MOD, OMAP2_CM_CLKSTCTRL);
 
 		/* Wait until the state has moved to ON */
-		while ((*pdata->dsp_prm_read)(OMAP3430_IVA2_MOD, OMAP2_PM_PWSTST) &
+		while ((*pdata->dsp_prm_read)(OMAP3430_IVA2_MOD,
+					OMAP2_PM_PWSTST) &
 						OMAP_INTRANSITION_MASK)
 			;
 		/* Disable Automatic transition */
@@ -429,8 +431,8 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		/* Assert RST1 i.e only the RST only for DSP megacell */
 		if (!status) {
 			(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2_MASK,
-					OMAP3430_RST1_IVA2_MASK, OMAP3430_IVA2_MOD,
-					OMAP2_RM_RSTCTRL);
+					OMAP3430_RST1_IVA2_MASK,
+					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
 			/* Mask address with 1K for compatibility */
 			__raw_writel(dsp_addr & OMAP3_IVA2_BOOTADDR_MASK,
 					OMAP343X_CTRL_REGADDR(
@@ -447,7 +449,8 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		/* Reset and Unreset the RST2, so that BOOTADDR is copied to
 		 * IVA2 SYSC register */
 		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK,
-			OMAP3430_RST2_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
+			OMAP3430_RST2_IVA2_MASK, OMAP3430_IVA2_MOD,
+			OMAP2_RM_RSTCTRL);
 		udelay(100);
 		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK, 0,
 					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
@@ -461,7 +464,8 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		/* Only make TLB entry if both addresses are non-zero */
 		for (entry_ndx = 0; entry_ndx < BRDIOCTL_NUMOFMMUTLB;
 		     entry_ndx++) {
-			struct bridge_ioctl_extproc *e = &dev_context->atlb_entry[entry_ndx];
+			struct bridge_ioctl_extproc *e =
+				&dev_context->atlb_entry[entry_ndx];
 			struct hw_mmu_map_attrs_t map_attrs = {
 				.endianism = e->endianism,
 				.element_size = e->elem_size,
@@ -547,7 +551,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		if ((unsigned int *)ul_dsp_clk_addr != NULL) {
 			/* Get the clock rate */
 			ul_dsp_clk_rate = dsp_clk_get_iva2_rate();
-			dev_dbg(bridge, "%s: DSP clock rate (KHZ): 0x%x \n",
+			dev_dbg(bridge, "%s: DSP clock rate (KHZ): 0x%x\n",
 				__func__, ul_dsp_clk_rate);
 			(void)bridge_brd_write(dev_context,
 					       (u8 *) &ul_dsp_clk_rate,
@@ -567,21 +571,22 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 
 	}
 	if (!status) {
-/*PM_IVA2GRPSEL_PER = 0xC0;*/
+		/*PM_IVA2GRPSEL_PER = 0xC0;*/
 		temp = readl(resources->dw_per_pm_base + 0xA8);
 		temp = (temp & 0xFFFFFF30) | 0xC0;
 		writel(temp, resources->dw_per_pm_base + 0xA8);
 
-/*PM_MPUGRPSEL_PER &= 0xFFFFFF3F; */
+		/*PM_MPUGRPSEL_PER &= 0xFFFFFF3F; */
 		temp = readl(resources->dw_per_pm_base + 0xA4);
 		temp = (temp & 0xFFFFFF3F);
 		writel(temp, resources->dw_per_pm_base + 0xA4);
-/*CM_SLEEPDEP_PER |= 0x04; */
+		/*CM_SLEEPDEP_PER |= 0x04; */
 		temp = readl(resources->dw_per_base + 0x44);
 		temp = (temp & 0xFFFFFFFB) | 0x04;
 		writel(temp, resources->dw_per_base + 0x44);
 
-/*CM_CLKSTCTRL_IVA2 = 0x00000003 -To Allow automatic transitions */
+		/*CM_CLKSTCTRL_IVA2 = 0x00000003
+		 * -To Allow automatic transitions */
 		(*pdata->dsp_cm_write)(OMAP34XX_CLKSTCTRL_ENABLE_AUTO,
 					OMAP3430_IVA2_MOD, OMAP2_CM_CLKSTCTRL);
 
@@ -650,8 +655,9 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 	/* as per TRM, it is advised to first drive the IVA2 to 'Standby' mode,
 	 * before turning off the clocks.. This is to ensure that there are no
 	 * pending L3 or other transactons from IVA2 */
-	dsp_pwr_state = (*pdata->dsp_prm_read)(OMAP3430_IVA2_MOD, OMAP2_PM_PWSTST) &
-					OMAP_POWERSTATEST_MASK;
+	dsp_pwr_state = (*pdata->dsp_prm_read)(OMAP3430_IVA2_MOD,
+					OMAP2_PM_PWSTST) &
+						OMAP_POWERSTATEST_MASK;
 	if (dsp_pwr_state != PWRDM_POWER_OFF) {
 		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK, 0,
 					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
@@ -691,8 +697,9 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 		dev_context->mbox = NULL;
 	}
 	/* Reset IVA2 clocks*/
-	(*pdata->dsp_prm_write)(OMAP3430_RST1_IVA2_MASK | OMAP3430_RST2_IVA2_MASK |
-			OMAP3430_RST3_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
+	(*pdata->dsp_prm_write)(OMAP3430_RST1_IVA2_MASK |
+			OMAP3430_RST2_IVA2_MASK | OMAP3430_RST3_IVA2_MASK,
+			OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
 
 	dsp_clock_disable_all(dev_context->dsp_per_clks);
 	dsp_clk_disable(DSP_CLK_IVA2);
diff --git a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
index fb9026e..0718ab8 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
@@ -51,7 +51,7 @@
 
 /*
  *  ======== handle_constraints_set ========
- *  	Sets new DSP constraint
+ *	Sets new DSP constraint
  */
 int handle_constraints_set(struct bridge_dev_context *dev_context,
 				  void *pargs)
@@ -75,7 +75,7 @@ int handle_constraints_set(struct bridge_dev_context *dev_context,
 
 /*
  *  ======== handle_hibernation_from_dsp ========
- *  	Handle Hibernation requested from DSP
+ *	Handle Hibernation requested from DSP
  */
 int handle_hibernation_from_dsp(struct bridge_dev_context *dev_context)
 {
@@ -99,7 +99,8 @@ int handle_hibernation_from_dsp(struct bridge_dev_context *dev_context)
 			return -EPERM;
 		}
 		pwr_state = (*pdata->dsp_prm_read)(OMAP3430_IVA2_MOD,
-					OMAP2_PM_PWSTST) & OMAP_POWERSTATEST_MASK;
+					OMAP2_PM_PWSTST) &
+						OMAP_POWERSTATEST_MASK;
 	}
 	if (timeout == 0) {
 		pr_err("%s: Timed out waiting for DSP off mode\n", __func__);
@@ -144,7 +145,7 @@ int handle_hibernation_from_dsp(struct bridge_dev_context *dev_context)
 
 /*
  *  ======== sleep_dsp ========
- *  	Put DSP in low power consuming state.
+ *	Put DSP in low power consuming state.
  */
 int sleep_dsp(struct bridge_dev_context *dev_context, u32 dw_cmd,
 		     void *pargs)
@@ -209,7 +210,8 @@ int sleep_dsp(struct bridge_dev_context *dev_context, u32 dw_cmd,
 			return -EPERM;
 		}
 		pwr_state = (*pdata->dsp_prm_read)(OMAP3430_IVA2_MOD,
-					OMAP2_PM_PWSTST) & OMAP_POWERSTATEST_MASK;
+					OMAP2_PM_PWSTST) &
+						OMAP_POWERSTATEST_MASK;
 	}
 
 	if (!timeout) {
@@ -250,7 +252,7 @@ int sleep_dsp(struct bridge_dev_context *dev_context, u32 dw_cmd,
 
 /*
  *  ======== wake_dsp ========
- *  	Wake up DSP from sleep.
+ *	Wake up DSP from sleep.
  */
 int wake_dsp(struct bridge_dev_context *dev_context, void *pargs)
 {
@@ -276,7 +278,7 @@ int wake_dsp(struct bridge_dev_context *dev_context, void *pargs)
 
 /*
  *  ======== dsp_peripheral_clk_ctrl ========
- *  	Enable/Disable the DSP peripheral clocks as needed..
+ *	Enable/Disable the DSP peripheral clocks as needed..
  */
 int dsp_peripheral_clk_ctrl(struct bridge_dev_context *dev_context,
 				   void *pargs)
diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 3430418..84b37e2 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -178,7 +178,7 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 	void *dummy_va_addr;
 
 	resources = dev_context->resources;
-	dummy_va_addr = (void*)__get_free_page(GFP_ATOMIC);
+	dummy_va_addr = (void *)__get_free_page(GFP_ATOMIC);
 
 	/*
 	 * Before acking the MMU fault, let's make sure MMU can only
diff --git a/drivers/staging/tidspbridge/core/wdt.c b/drivers/staging/tidspbridge/core/wdt.c
index 2126f59..9c6047f 100644
--- a/drivers/staging/tidspbridge/core/wdt.c
+++ b/drivers/staging/tidspbridge/core/wdt.c
@@ -27,7 +27,7 @@
 
 #ifdef CONFIG_TIDSPBRIDGE_WDT3
 
-#define OMAP34XX_WDT3_BASE 		(L4_PER_34XX_BASE + 0x30000)
+#define OMAP34XX_WDT3_BASE		(L4_PER_34XX_BASE + 0x30000)
 
 static struct dsp_wdt_setting dsp_wdt;
 
diff --git a/drivers/staging/tidspbridge/dynload/cload.c b/drivers/staging/tidspbridge/dynload/cload.c
index c85a5e8..7568cbe 100644
--- a/drivers/staging/tidspbridge/dynload/cload.c
+++ b/drivers/staging/tidspbridge/dynload/cload.c
@@ -212,8 +212,8 @@ int dynamic_load_module(struct dynamic_loader_stream *module,
  * Effect:
  *      The module image is read using *module.  Target storage for the new
  *      image is
- * 	obtained from *alloc.  Symbols defined and referenced by the module are
- * 	managed using *syms.  The image is then relocated and references
+ *      obtained from *alloc.  Symbols defined and referenced by the module are
+ *      managed using *syms.  The image is then relocated and references
  *      resolved as necessary, and the resulting executable bits are placed
  *      into target memory using *init.
  *
@@ -409,8 +409,8 @@ void dload_headers(struct dload_state *dlthis)
 /*	COFF Section Processing
  *
  *	COFF sections are read in and retained intact.  Each record is embedded
- * 	in a new structure that records the updated load and
- * 	run addresses of the section */
+ *	in a new structure that records the updated load and
+ *	run addresses of the section */
 
 static const char secn_errid[] = { "section" };
 
@@ -1194,7 +1194,7 @@ static void dload_data(struct dload_state *dlthis)
 				dest = ibuf.bufr;
 #ifdef OPT_ZERO_COPY_LOADER
 				zero_copy = false;
-				if (!dload_check_type(sptr, DLOAD_CINIT) {
+				if (!dload_check_type(sptr, DLOAD_CINIT)) {
 					dlthis->myio->writemem(dlthis->myio,
 							       &dest,
 							       lptr->load_addr +
diff --git a/drivers/staging/tidspbridge/dynload/reloc.c b/drivers/staging/tidspbridge/dynload/reloc.c
index 7b28c07..2245851 100644
--- a/drivers/staging/tidspbridge/dynload/reloc.c
+++ b/drivers/staging/tidspbridge/dynload/reloc.c
@@ -85,7 +85,7 @@ rvalue dload_unpack(struct dload_state *dlthis, tgt_au_t * data, int fieldsz,
  * Parameters:
  *	val		Value to insert
  *	data	Pointer to storage unit containing lowest host address of
- * 		image data
+ *              image data
  *	fieldsz	Size of bit field, 0 < fieldsz <= sizeof(rvalue)*BITS_PER_AU
  *	offset	Offset from LSB, 0 <= offset < BITS_PER_AU
  *	sgn	Signedness of the field (ROP_SGN, ROP_UNS, ROP_MAX, ROP_ANY)
diff --git a/drivers/staging/tidspbridge/hw/MMURegAcM.h b/drivers/staging/tidspbridge/hw/MMURegAcM.h
index ab1a16d..4e2647a 100644
--- a/drivers/staging/tidspbridge/hw/MMURegAcM.h
+++ b/drivers/staging/tidspbridge/hw/MMURegAcM.h
@@ -25,199 +25,199 @@
 #if defined(USE_LEVEL_1_MACROS)
 
 #define MMUMMU_SYSCONFIG_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_SYSCONFIG_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_READ_REGISTER32),\
+		__raw_readl((base_address)+MMU_MMU_SYSCONFIG_OFFSET))
 
 #define MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32);\
-    data &= ~(MMU_MMU_SYSCONFIG_IDLE_MODE_MASK);\
-    new_value <<= MMU_MMU_SYSCONFIG_IDLE_MODE_OFFSET;\
-    new_value &= MMU_MMU_SYSCONFIG_IDLE_MODE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32);\
+	data &= ~(MMU_MMU_SYSCONFIG_IDLE_MODE_MASK);\
+	new_value <<= MMU_MMU_SYSCONFIG_IDLE_MODE_OFFSET;\
+	new_value &= MMU_MMU_SYSCONFIG_IDLE_MODE_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32);\
-    data &= ~(MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK);\
-    new_value <<= MMU_MMU_SYSCONFIG_AUTO_IDLE_OFFSET;\
-    new_value &= MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32);\
+	data &= ~(MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK);\
+	new_value <<= MMU_MMU_SYSCONFIG_AUTO_IDLE_OFFSET;\
+	new_value &= MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_IRQSTATUS_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(easil1_mmummu_irqstatus_read_register32),\
-      __raw_readl((base_address)+MMU_MMU_IRQSTATUS_OFFSET))
+	(_DEBUG_LEVEL1_EASI(easil1_mmummu_irqstatus_read_register32),\
+		__raw_readl((base_address)+MMU_MMU_IRQSTATUS_OFFSET))
 
 #define MMUMMU_IRQSTATUS_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_IRQSTATUS_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQSTATUS_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_IRQSTATUS_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQSTATUS_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_IRQENABLE_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_IRQENABLE_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_READ_REGISTER32),\
+		__raw_readl((base_address)+MMU_MMU_IRQENABLE_OFFSET))
 
 #define MMUMMU_IRQENABLE_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_IRQENABLE_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_IRQENABLE_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_WALKING_STTWL_RUNNING_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_WALKING_STTWL_RUNNING_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_WALKING_ST_OFFSET))))\
-      & MMU_MMU_WALKING_ST_TWL_RUNNING_MASK) >>\
-      MMU_MMU_WALKING_ST_TWL_RUNNING_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_WALKING_STTWL_RUNNING_READ32),\
+		(((__raw_readl(((base_address)+(MMU_MMU_WALKING_ST_OFFSET))))\
+		& MMU_MMU_WALKING_ST_TWL_RUNNING_MASK) >>\
+		MMU_MMU_WALKING_ST_TWL_RUNNING_OFFSET))
 
 #define MMUMMU_CNTLTWL_ENABLE_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_CNTL_OFFSET)))) &\
-      MMU_MMU_CNTL_TWL_ENABLE_MASK) >>\
-      MMU_MMU_CNTL_TWL_ENABLE_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_READ32),\
+		(((__raw_readl(((base_address)+(MMU_MMU_CNTL_OFFSET)))) &\
+		MMU_MMU_CNTL_TWL_ENABLE_MASK) >>\
+		MMU_MMU_CNTL_TWL_ENABLE_OFFSET))
 
 #define MMUMMU_CNTLTWL_ENABLE_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_CNTL_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_WRITE32);\
-    data &= ~(MMU_MMU_CNTL_TWL_ENABLE_MASK);\
-    new_value <<= MMU_MMU_CNTL_TWL_ENABLE_OFFSET;\
-    new_value &= MMU_MMU_CNTL_TWL_ENABLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_CNTL_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_WRITE32);\
+	data &= ~(MMU_MMU_CNTL_TWL_ENABLE_MASK);\
+	new_value <<= MMU_MMU_CNTL_TWL_ENABLE_OFFSET;\
+	new_value &= MMU_MMU_CNTL_TWL_ENABLE_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_CNTLMMU_ENABLE_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_CNTL_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLMMU_ENABLE_WRITE32);\
-    data &= ~(MMU_MMU_CNTL_MMU_ENABLE_MASK);\
-    new_value <<= MMU_MMU_CNTL_MMU_ENABLE_OFFSET;\
-    new_value &= MMU_MMU_CNTL_MMU_ENABLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_CNTL_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLMMU_ENABLE_WRITE32);\
+	data &= ~(MMU_MMU_CNTL_MMU_ENABLE_MASK);\
+	new_value <<= MMU_MMU_CNTL_MMU_ENABLE_OFFSET;\
+	new_value &= MMU_MMU_CNTL_MMU_ENABLE_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_FAULT_AD_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FAULT_AD_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_FAULT_AD_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FAULT_AD_READ_REGISTER32),\
+		__raw_readl((base_address)+MMU_MMU_FAULT_AD_OFFSET))
 
 #define MMUMMU_TTB_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_TTB_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_TTB_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_TTB_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_TTB_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_LOCK_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_LOCK_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_READ_REGISTER32),\
+		__raw_readl((base_address)+MMU_MMU_LOCK_OFFSET))
 
 #define MMUMMU_LOCK_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_LOCK_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_LOCK_BASE_VALUE_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_BASE_VALUE_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
-      MMU_MMU_LOCK_BASE_VALUE_MASK) >>\
-      MMU_MMU_LOCK_BASE_VALUE_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_BASE_VALUE_READ32),\
+		(((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
+		MMU_MMU_LOCK_BASE_VALUE_MASK) >>\
+		MMU_MMU_LOCK_BASE_VALUE_OFFSET))
 
 #define MMUMMU_LOCK_BASE_VALUE_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(easil1_mmummu_lock_base_value_write32);\
-    data &= ~(MMU_MMU_LOCK_BASE_VALUE_MASK);\
-    new_value <<= MMU_MMU_LOCK_BASE_VALUE_OFFSET;\
-    new_value &= MMU_MMU_LOCK_BASE_VALUE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_LOCK_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(easil1_mmummu_lock_base_value_write32);\
+	data &= ~(MMU_MMU_LOCK_BASE_VALUE_MASK);\
+	new_value <<= MMU_MMU_LOCK_BASE_VALUE_OFFSET;\
+	new_value &= MMU_MMU_LOCK_BASE_VALUE_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_LOCK_CURRENT_VICTIM_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
-      MMU_MMU_LOCK_CURRENT_VICTIM_MASK) >>\
-      MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_READ32),\
+		(((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
+		MMU_MMU_LOCK_CURRENT_VICTIM_MASK) >>\
+		MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET))
 
 #define MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_WRITE32);\
-    data &= ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK);\
-    new_value <<= MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET;\
-    new_value &= MMU_MMU_LOCK_CURRENT_VICTIM_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_LOCK_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_WRITE32);\
+	data &= ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK);\
+	new_value <<= MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET;\
+	new_value &= MMU_MMU_LOCK_CURRENT_VICTIM_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_LOCK_CURRENT_VICTIM_SET32(var, value)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_SET32),\
-      (((var) & ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK)) |\
-      (((value) << MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET) &\
-      MMU_MMU_LOCK_CURRENT_VICTIM_MASK)))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_SET32),\
+		(((var) & ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK)) |\
+		(((value) << MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET) &\
+		MMU_MMU_LOCK_CURRENT_VICTIM_MASK)))
 
 #define MMUMMU_LD_TLB_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_LD_TLB_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_READ_REGISTER32),\
+		__raw_readl((base_address)+MMU_MMU_LD_TLB_OFFSET))
 
 #define MMUMMU_LD_TLB_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_LD_TLB_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_LD_TLB_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_CAM_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_CAM_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CAM_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_CAM_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CAM_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_RAM_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_RAM_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_RAM_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_RAM_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_RAM_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_FLUSH_ENTRY_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_FLUSH_ENTRY_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #endif /* USE_LEVEL_1_MACROS */
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
index 014f5d5..88fdb93 100644
--- a/drivers/staging/tidspbridge/hw/hw_mmu.c
+++ b/drivers/staging/tidspbridge/hw/hw_mmu.c
@@ -48,69 +48,69 @@ enum hw_mmu_page_size_t {
 };
 
 /*
- * FUNCTION	      : mmu_flush_entry
+ * FUNCTION		: mmu_flush_entry
  *
  * INPUTS:
  *
- *       Identifier      : base_address
+ *       Identifier	: base_address
  *       Type		: const u32
- *       Description     : Base Address of instance of MMU module
+ *       Description	: Base Address of instance of MMU module
  *
  * RETURNS:
  *
  *       Type		: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description	: 0		 -- No errors occured
  *			 RET_BAD_NULL_PARAM     -- A Pointer
  *						Paramater was set to NULL
  *
- * PURPOSE:	      : Flush the TLB entry pointed by the
- *			lock counter register
- *			even if this entry is set protected
+ * PURPOSE:		: Flush the TLB entry pointed by the
+ *			  lock counter register
+ *			  even if this entry is set protected
  *
- * METHOD:	       : Check the Input parameter and Flush a
- *			 single entry in the TLB.
+ * METHOD:		: Check the Input parameter and Flush a
+ *			  single entry in the TLB.
  */
 static hw_status mmu_flush_entry(const void __iomem *base_address);
 
 /*
- * FUNCTION	      : mmu_set_cam_entry
+ * FUNCTION		: mmu_set_cam_entry
  *
  * INPUTS:
  *
- *       Identifier      : base_address
+ *       Identifier	: base_address
  *       TypE		: const u32
- *       Description     : Base Address of instance of MMU module
+ *       Description	: Base Address of instance of MMU module
  *
- *       Identifier      : page_sz
+ *       Identifier	: page_sz
  *       TypE		: const u32
- *       Description     : It indicates the page size
+ *       Description	: It indicates the page size
  *
- *       Identifier      : preserved_bit
+ *       Identifier	: preserved_bit
  *       Type		: const u32
- *       Description     : It indicates the TLB entry is preserved entry
+ *       Description	: It indicates the TLB entry is preserved entry
  *							or not
  *
- *       Identifier      : valid_bit
+ *       Identifier	: valid_bit
  *       Type		: const u32
- *       Description     : It indicates the TLB entry is valid entry or not
+ *       Description	: It indicates the TLB entry is valid entry or not
  *
  *
- *       Identifier      : virtual_addr_tag
- *       Type	    	: const u32
- *       Description     : virtual Address
+ *       Identifier	: virtual_addr_tag
+ *       Type		: const u32
+ *       Description	: virtual Address
  *
  * RETURNS:
  *
- *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
- *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
- *						   was set to NULL
- *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter out
- *						   of Range
+ *       Type		: hw_status
+ *       Description	: 0				-- No errors occured
+ *			  RET_BAD_NULL_PARAM		-- A Pointer Paramater
+ *							   was set to NULL
+ *			  RET_PARAM_OUT_OF_RANGE	-- Input Parameter out
+ *							   of Range
  *
- * PURPOSE:	      	: Set MMU_CAM reg
+ * PURPOSE:		: Set MMU_CAM reg
  *
- * METHOD:	       	: Check the Input parameters and set the CAM entry.
+ * METHOD:		: Check the Input parameters and set the CAM entry.
  */
 static hw_status mmu_set_cam_entry(const void __iomem *base_address,
 				   const u32 page_sz,
@@ -119,43 +119,43 @@ static hw_status mmu_set_cam_entry(const void __iomem *base_address,
 				   const u32 virtual_addr_tag);
 
 /*
- * FUNCTION	      : mmu_set_ram_entry
+ * FUNCTION		: mmu_set_ram_entry
  *
  * INPUTS:
  *
- *       Identifier      : base_address
- *       Type	    	: const u32
- *       Description     : Base Address of instance of MMU module
+ *       Identifier	: base_address
+ *       Type		: const u32
+ *       Description	: Base Address of instance of MMU module
  *
- *       Identifier      : physical_addr
- *       Type	    	: const u32
- *       Description     : Physical Address to which the corresponding
- *			 virtual   Address shouldpoint
+ *       Identifier	: physical_addr
+ *       Type		: const u32
+ *       Description	: Physical Address to which the corresponding
+ *			  virtual   Address shouldpoint
  *
- *       Identifier      : endianism
- *       Type	    	: hw_endianism_t
- *       Description     : endianism for the given page
+ *       Identifier	: endianism
+ *       Type		: hw_endianism_t
+ *       Description	: endianism for the given page
  *
- *       Identifier      : element_size
- *       Type	    	: hw_element_size_t
- *       Description     : The element size ( 8,16, 32 or 64 bit)
+ *       Identifier	: element_size
+ *       Type		: hw_element_size_t
+ *       Description	: The element size ( 8,16, 32 or 64 bit)
  *
- *       Identifier      : mixed_size
- *       Type	    	: hw_mmu_mixed_size_t
- *       Description     : Element Size to follow CPU or TLB
+ *       Identifier	: mixed_size
+ *       Type		: hw_mmu_mixed_size_t
+ *       Description	: Element Size to follow CPU or TLB
  *
  * RETURNS:
  *
- *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
- *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
- *							was set to NULL
- *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter
- *							out of Range
+ *       Type		: hw_status
+ *       Description	: 0				-- No errors occured
+ *			  RET_BAD_NULL_PARAM		-- A Pointer Paramater
+ *							   was set to NULL
+ *			  RET_PARAM_OUT_OF_RANGE	-- Input Parameter
+ *							   out of Range
  *
- * PURPOSE:	      : Set MMU_CAM reg
+ * PURPOSE:		: Set MMU_CAM reg
  *
- * METHOD:	       : Check the Input parameters and set the RAM entry.
+ * METHOD:		: Check the Input parameters and set the RAM entry.
  */
 static hw_status mmu_set_ram_entry(const void __iomem *base_address,
 				   const u32 physical_addr,
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
index 38122db..4d99bbc 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
@@ -60,7 +60,7 @@ struct cfg_hostres {
 	 *                          reserved.
 	 *      dw_chnl_buf_size:      Size of channel buffer to send to RMS
 	 *      dw_num_chnls:		Total number of channels
-	 *      			(including reserved).
+	 *				(including reserved).
 	 */
 	u32 dw_chnl_offset;
 	u32 dw_chnl_buf_size;
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cmm.h b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
index 6ad313f..8299aa1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
@@ -70,7 +70,7 @@ extern void *cmm_calloc_buf(struct cmm_object *hcmm_mgr,
  *      Create a communication memory manager object.
  *  Parameters:
  *      ph_cmm_mgr:	Location to store a communication manager handle on
- *      		output.
+ *			output.
  *      hdev_obj: Handle to a device object.
  *      mgr_attrts: Comm mem manager attributes.
  *  Returns:
@@ -152,7 +152,7 @@ extern int cmm_free_buf(struct cmm_object *hcmm_mgr,
  *  Parameters:
  *      hprocessor:   Handle to a Processor.
  *      ph_cmm_mgr:	Location to store the shared memory mgr handle on
- *      		output.
+ *			output.
  *
  *  Returns:
  *      0:        Cmm Mgr opaque handle returned.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbc.h b/drivers/staging/tidspbridge/include/dspbridge/dbc.h
index 463760f..26caead 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbc.h
@@ -29,9 +29,9 @@
 #ifdef CONFIG_TIDSPBRIDGE_DEBUG
 
 #define DBC_ASSERT(exp) \
-    if (!(exp)) \
-	pr_err("%s, line %d: Assertion (" #exp ") failed.\n", \
-	__FILE__, __LINE__)
+	if (!(exp)) \
+		pr_err("%s, line %d: Assertion (" #exp ") failed.\n", \
+		__FILE__, __LINE__)
 #define DBC_REQUIRE DBC_ASSERT	/* Function Precondition. */
 #define DBC_ENSURE  DBC_ASSERT	/* Function Postcondition. */
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index 0ae7d16..b20e26e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -86,7 +86,7 @@ typedef int(*fxn_brd_monitor) (struct bridge_dev_context *dev_ctxt);
  *  Update the Board state to the specified state.
  */
 typedef int(*fxn_brd_setstate) (struct bridge_dev_context
-				       * dev_ctxt, u32 brd_state);
+				       *dev_ctxt, u32 brd_state);
 
 /*
  *  ======== bridge_brd_start ========
@@ -108,7 +108,7 @@ typedef int(*fxn_brd_setstate) (struct bridge_dev_context
  *      else:           Board state is indeterminate.
  */
 typedef int(*fxn_brd_start) (struct bridge_dev_context
-				    * dev_ctxt, u32 dsp_addr);
+				    *dev_ctxt, u32 dsp_addr);
 
 /*
  *  ======== bridge_brd_mem_copy ========
@@ -131,7 +131,7 @@ typedef int(*fxn_brd_start) (struct bridge_dev_context
  *      else:           Board state is indeterminate.
  */
 typedef int(*fxn_brd_memcopy) (struct bridge_dev_context
-				      * dev_ctxt,
+				      *dev_ctxt,
 				      u32 dsp_dest_addr,
 				      u32 dsp_src_addr,
 				      u32 ul_num_bytes, u32 mem_type);
@@ -156,7 +156,7 @@ typedef int(*fxn_brd_memcopy) (struct bridge_dev_context
  *  Ensures:
  */
 typedef int(*fxn_brd_memwrite) (struct bridge_dev_context
-				       * dev_ctxt,
+				       *dev_ctxt,
 				       u8 *host_buf,
 				       u32 dsp_addr, u32 ul_num_bytes,
 				       u32 mem_type);
@@ -179,7 +179,7 @@ typedef int(*fxn_brd_memwrite) (struct bridge_dev_context
  *  Ensures:
  */
 typedef int(*fxn_brd_memmap) (struct bridge_dev_context
-				     * dev_ctxt, u32 ul_mpu_addr,
+				     *dev_ctxt, u32 ul_mpu_addr,
 				     u32 virt_addr, u32 ul_num_bytes,
 				     u32 map_attr,
 				     struct page **mapped_pages);
@@ -200,7 +200,7 @@ typedef int(*fxn_brd_memmap) (struct bridge_dev_context
  *  Ensures:
  */
 typedef int(*fxn_brd_memunmap) (struct bridge_dev_context
-				       * dev_ctxt,
+				       *dev_ctxt,
 				       u32 virt_addr, u32 ul_num_bytes);
 
 /*
@@ -326,7 +326,7 @@ typedef int(*fxn_brd_write) (struct bridge_dev_context *dev_ctxt,
 typedef int(*fxn_chnl_create) (struct chnl_mgr
 				      **channel_mgr,
 				      struct dev_object
-				      * hdev_obj,
+				      *hdev_obj,
 				      const struct
 				      chnl_mgrattrs * mgr_attrts);
 
@@ -370,7 +370,7 @@ typedef void (*fxn_deh_notify) (struct deh_mgr *hdeh_mgr,
  *  Parameters:
  *      chnl:           Location to store a channel object handle.
  *      hchnl_mgr:	Handle to channel manager, as returned by
- *      		CHNL_GetMgr().
+ *			CHNL_GetMgr().
  *      chnl_mode:          One of {CHNL_MODETODSP, CHNL_MODEFROMDSP} specifies
  *                      direction of data transfer.
  *      ch_id:        If CHNL_PICKFREE is specified, the channel manager will
@@ -471,7 +471,7 @@ typedef int(*fxn_chnl_close) (struct chnl_object *chnl_obj);
  *          set to CHNL_IOCSTATEOS.
  */
 typedef int(*fxn_chnl_addioreq) (struct chnl_object
-					* chnl_obj,
+					*chnl_obj,
 					void *host_buf,
 					u32 byte_size,
 					u32 buf_size,
@@ -581,7 +581,7 @@ typedef int(*fxn_chnl_getinfo) (struct chnl_object *chnl_obj,
  *                          struct, if (mgr_info != NULL).
  */
 typedef int(*fxn_chnl_getmgrinfo) (struct chnl_mgr
-					  * hchnl_mgr,
+					  *hchnl_mgr,
 					  u32 ch_id,
 					  struct chnl_mgrinfo *mgr_info);
 
@@ -640,8 +640,9 @@ typedef int(*fxn_chnl_idle) (struct chnl_object *chnl_obj,
  *  Ensures:
  */
 typedef int(*fxn_chnl_registernotify)
- (struct chnl_object *chnl_obj,
-  u32 event_mask, u32 notify_type, struct dsp_notification *hnotification);
+	(struct chnl_object *chnl_obj,
+	u32 event_mask, u32 notify_type,
+	struct dsp_notification *hnotification);
 
 /*
  *  ======== bridge_dev_create ========
@@ -682,9 +683,9 @@ typedef int(*fxn_chnl_registernotify)
 typedef int(*fxn_dev_create) (struct bridge_dev_context
 				     **device_ctx,
 				     struct dev_object
-				     * hdev_obj,
+				     *hdev_obj,
 				     struct cfg_hostres
-				     * config_param);
+				     *config_param);
 
 /*
  *  ======== bridge_dev_ctrl ========
@@ -818,8 +819,8 @@ typedef int(*fxn_io_getprocload) (struct io_mgr *hio_mgr,
  *  Ensures:
  */
 typedef int(*fxn_msg_create)
- (struct msg_mgr **msg_man,
-  struct dev_object *hdev_obj, msg_onexit msg_callback);
+	(struct msg_mgr **msg_man,
+	struct dev_object *hdev_obj, msg_onexit msg_callback);
 
 /*
  *  ======== bridge_msg_create_queue ========
@@ -844,8 +845,8 @@ typedef int(*fxn_msg_create)
  *      msgq !=NULL <==> 0.
  */
 typedef int(*fxn_msg_createqueue)
- (struct msg_mgr *hmsg_mgr,
-  struct msg_queue **msgq, u32 msgq_id, u32 max_msgs, void *h);
+	(struct msg_mgr *hmsg_mgr,
+	struct msg_queue **msgq, u32 msgq_id, u32 max_msgs, void *h);
 
 /*
  *  ======== bridge_msg_delete ========
@@ -940,8 +941,9 @@ typedef int(*fxn_msg_put) (struct msg_queue *msg_queue_obj,
  *  Ensures:
  */
 typedef int(*fxn_msg_registernotify)
- (struct msg_queue *msg_queue_obj,
-  u32 event_mask, u32 notify_type, struct dsp_notification *hnotification);
+	(struct msg_queue *msg_queue_obj,
+	u32 event_mask, u32 notify_type,
+	struct dsp_notification *hnotification);
 
 /*
  *  ======== bridge_msg_set_queue_id ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/host_os.h b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
index 6549898..1e32a7f 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -18,7 +18,7 @@
 #define _HOST_OS_H_
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/semaphore.h>
 #include <linux/uaccess.h>
 #include <linux/irq.h>
diff --git a/drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h b/drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h
index 5d165cd..b152abf 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h
@@ -74,7 +74,7 @@
  *   ---------------------------------
  *   |0|0|1|0|0|0|x|x|x|x|x|c|c|c|c|c|
 
- * 	0010 00xx xxxc cccc
+ *	0010 00xx xxxc cccc
  *	0010 00nn pppp qqqq
  *	nn:
  *	00 = reserved
diff --git a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
index c85d3da..21b2044 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
@@ -130,7 +130,7 @@ enum nldr_phase {
 typedef int(*nldr_allocatefxn) (struct nldr_object *nldr_obj,
 				       void *priv_ref,
 				       const struct dcd_nodeprops
-				       * node_props,
+				       *node_props,
 				       struct nldr_nodeobject
 				       **nldr_nodeobj,
 				       bool *pf_phase_split);
@@ -223,7 +223,7 @@ typedef void (*nldr_freefxn) (struct nldr_nodeobject *nldr_node_obj);
  *  Ensures:
  */
 typedef int(*nldr_getfxnaddrfxn) (struct nldr_nodeobject
-					 * nldr_node_obj,
+					 *nldr_node_obj,
 					 char *str_fxn, u32 * addr);
 
 /*
diff --git a/drivers/staging/tidspbridge/include/dspbridge/node.h b/drivers/staging/tidspbridge/include/dspbridge/node.h
index 49ed5c1..7638b2a 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/node.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/node.h
@@ -570,7 +570,7 @@ extern int node_get_uuid_props(void *hprocessor,
  * @sym_addr_output:	Symbol Output address
  * @sym_name:		String with the symbol name of the closest symbol
  *
- * 	This function finds the closest symbol to the address where a MMU
+ *	This function finds the closest symbol to the address where a MMU
  *	Fault occurred on the DSP side.
  */
 int node_find_addr(struct node_mgr *node_mgr, u32 sym_addr,
diff --git a/drivers/staging/tidspbridge/include/dspbridge/ntfy.h b/drivers/staging/tidspbridge/include/dspbridge/ntfy.h
index cbc8819..ac1a835 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/ntfy.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/ntfy.h
@@ -38,7 +38,7 @@ struct ntfy_object {
  * ntfy_event - structure store specify event to be notified
  * @noti_block:	List of notify objects
  * @event:	event that it respond
- * @type: 	event type (only DSP_SIGNALEVENT supported)
+ * @type:	event type (only DSP_SIGNALEVENT supported)
  * @sync_obj:	sync_event used to set the event
  *
  */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/rms_sh.h b/drivers/staging/tidspbridge/include/dspbridge/rms_sh.h
index 7bc5574..2fec63b 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/rms_sh.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/rms_sh.h
@@ -30,7 +30,7 @@
 /* Memory Types: */
 #define RMS_CODE                0	/* Program space */
 #define RMS_DATA                1	/* Data space */
-#define RMS_IO                	2	/* I/O space */
+#define RMS_IO                  2	/* I/O space */
 
 /* RM Server Command and Response Buffer Sizes: */
 #define RMS_COMMANDBUFSIZE     256	/* Size of command buffer */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/sync.h b/drivers/staging/tidspbridge/include/dspbridge/sync.h
index e2651e7..4d0835c 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/sync.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/sync.h
@@ -31,7 +31,7 @@
  * @multi_comp:	use to signal multiple events.
  *
  */
-struct sync_object{
+struct sync_object {
 	struct completion comp;
 	struct completion *multi_comp;
 };
diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 878aa50..9fb5113 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -1557,7 +1557,7 @@ void find_symbol_callback(void *elem, void *user_data)
  * @sym_addr_output:	Symbol Output address
  * @name_output:		String with the dsp symbol
  *
- * 	This function retrieves the dsp symbol from the dsp binary.
+ *	This function retrieves the dsp symbol from the dsp binary.
  */
 bool dbll_find_dsp_symbol(struct dbll_library_obj *zl_lib, u32 address,
 				u32 offset_range, u32 *sym_addr_output,
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 132e960..adca71e 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -1093,8 +1093,8 @@ static void store_interface_fxns(struct bridge_drv_interface *drv_fxns,
 
 	/* Local helper macro: */
 #define  STORE_FXN(cast, pfn) \
-    (intf_fxns->pfn = ((drv_fxns->pfn != NULL) ? drv_fxns->pfn : \
-    (cast)fxn_not_implemented))
+	(intf_fxns->pfn = ((drv_fxns->pfn != NULL) ? drv_fxns->pfn : \
+		(cast)fxn_not_implemented))
 
 	DBC_REQUIRE(intf_fxns != NULL);
 	DBC_REQUIRE(drv_fxns != NULL);
diff --git a/drivers/staging/tidspbridge/pmgr/dmm.c b/drivers/staging/tidspbridge/pmgr/dmm.c
index 8685233..b89864d 100644
--- a/drivers/staging/tidspbridge/pmgr/dmm.c
+++ b/drivers/staging/tidspbridge/pmgr/dmm.c
@@ -523,9 +523,9 @@ u32 dmm_mem_map_dump(struct dmm_object *dmm_mgr)
 	spin_unlock(&dmm_mgr->dmm_lock);
 	printk(KERN_INFO "Total DSP VA FREE memory = %d Mbytes\n",
 	       freemem / (1024 * 1024));
-	printk(KERN_INFO "Total DSP VA USED memory= %d Mbytes \n",
+	printk(KERN_INFO "Total DSP VA USED memory= %d Mbytes\n",
 	       (((table_size * PG_SIZE4K) - freemem)) / (1024 * 1024));
-	printk(KERN_INFO "DSP VA - Biggest FREE block = %d Mbytes \n\n",
+	printk(KERN_INFO "DSP VA - Biggest FREE block = %d Mbytes\n\n",
 	       (bigsize * PG_SIZE4K / (1024 * 1024)));
 
 	return 0;
diff --git a/drivers/staging/tidspbridge/rmgr/dspdrv.c b/drivers/staging/tidspbridge/rmgr/dspdrv.c
index 7a6fc73..d533a07 100644
--- a/drivers/staging/tidspbridge/rmgr/dspdrv.c
+++ b/drivers/staging/tidspbridge/rmgr/dspdrv.c
@@ -39,7 +39,7 @@
 
 /*
  *  ======== dsp_init ========
- *  	Allocates bridge resources. Loads a base image onto DSP, if specified.
+ *	Allocates bridge resources. Loads a base image onto DSP, if specified.
  */
 u32 dsp_init(u32 *init_status)
 {
@@ -111,7 +111,7 @@ func_cont:
 
 /*
  *  ======== dsp_deinit ========
- *  	Frees the resources allocated for bridge.
+ *	Frees the resources allocated for bridge.
  */
 bool dsp_deinit(u32 device_context)
 {
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index 28354bb..2dc976b 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -241,7 +241,7 @@ struct nldr_nodeobject {
 	 *  Mask indicating whether each mem segment specified in seg_id[]
 	 *  is preferred or required.
 	 *  For example
-	 *  	if (code_data_flag_mask & (1 << EXECUTEDATAFLAGBIT)) != 0,
+	 *	if (code_data_flag_mask & (1 << EXECUTEDATAFLAGBIT)) != 0,
 	 *  then it is required to load execute phase data into the memory
 	 *  specified by seg_id[EXECUTEDATAFLAGBIT].
 	 */
@@ -1890,7 +1890,7 @@ static bool find_in_persistent_lib_array(struct nldr_nodeobject *nldr_node_obj,
  * @offset_output:		Symbol Output address
  * @sym_name:		String with the dsp symbol
  *
- * 	This function finds the node library for a given address and
+ *	This function finds the node library for a given address and
  *	retrieves the dsp symbol by calling dbll_find_dsp_symbol.
  */
 int nldr_find_addr(struct nldr_nodeobject *nldr_node, u32 sym_addr,
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 1562f3c..254256f 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -418,7 +418,7 @@ int node_allocate(struct proc_object *hprocessor,
 
 	/* check for page aligned Heap size */
 	if (((attr_in->heap_size) & (PG_SIZE4K - 1))) {
-		pr_err("%s: node heap size not aligned to 4K, size = 0x%x \n",
+		pr_err("%s: node heap size not aligned to 4K, size = 0x%x\n",
 		       __func__, attr_in->heap_size);
 		status = -EINVAL;
 	} else {
@@ -2474,7 +2474,8 @@ int node_terminate(struct node_object *hnode, int *pstatus)
 			if (!hdeh_mgr)
 				goto func_cont;
 
-			bridge_deh_notify(hdeh_mgr, DSP_SYSERROR, DSP_EXCEPTIONABORT);
+			bridge_deh_notify(hdeh_mgr, DSP_SYSERROR,
+						DSP_EXCEPTIONABORT);
 		}
 	}
 func_cont:
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index b47d7aa..760dfbc 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -1432,7 +1432,7 @@ func_end:
  */
 int proc_register_notify(void *hprocessor, u32 event_mask,
 				u32 notify_type, struct dsp_notification
-				* hnotification)
+				*hnotification)
 {
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
@@ -1652,7 +1652,7 @@ int proc_stop(void *hprocessor)
 		status = node_enum_nodes(hnode_mgr, &hnode, node_tab_size,
 					 &num_nodes, &nodes_allocated);
 		if ((status == -EINVAL) || (nodes_allocated > 0)) {
-			pr_err("%s: Can't stop device, active nodes = %d \n",
+			pr_err("%s: Can't stop device, active nodes = %d\n",
 			       __func__, nodes_allocated);
 			return -EBADR;
 		}
diff --git a/drivers/staging/tidspbridge/rmgr/strm.c b/drivers/staging/tidspbridge/rmgr/strm.c
index 2e42714..f4a0531 100644
--- a/drivers/staging/tidspbridge/rmgr/strm.c
+++ b/drivers/staging/tidspbridge/rmgr/strm.c
@@ -697,7 +697,7 @@ func_end:
  */
 int strm_register_notify(struct strm_object *stream_obj, u32 event_mask,
 				u32 notify_type, struct dsp_notification
-				* hnotification)
+				*hnotification)
 {
 	struct bridge_drv_interface *intf_fxns;
 	int status = 0;
-- 
1.7.1

