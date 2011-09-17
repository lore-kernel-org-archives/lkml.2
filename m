Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab1IQFVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 01:21:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57053 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750797Ab1IQFVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 01:21:39 -0400
Subject: [trivial PATCH] treewide: Correct internal/external typos
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 16 Sep 2011 22:21:38 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316236899.27917.36.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And a couple other typos on the same lines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-omap2/omap_phy_internal.c    |    2 +-
 arch/arm/mach-pxa/include/mach/tosa.h      |    2 +-
 drivers/media/radio/wl128x/fmdrv_common.c  |    2 +-
 drivers/scsi/lpfc/lpfc_init.c              |    2 +-
 drivers/scsi/mvsas/mv_sas.c                |    2 +-
 drivers/staging/sm7xx/smtcfb.c             |    2 +-
 drivers/staging/tidspbridge/core/_tiomap.h |    2 +-
 drivers/usb/host/ohci-pnx4008.c            |    2 +-
 kernel/trace/trace_entries.h               |    2 +-
 sound/pci/rme9652/hdspm.c                  |    2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_phy_internal.c b/arch/arm/mach-omap2/omap_phy_internal.c
index 58775e3..824860a 100644
--- a/arch/arm/mach-omap2/omap_phy_internal.c
+++ b/arch/arm/mach-omap2/omap_phy_internal.c
@@ -140,7 +140,7 @@ int omap4430_phy_suspend(struct device *dev, int suspend)
 		/* save the context */
 		usbotghs_control = __raw_readl(ctrl_base + USBOTGHS_CONTROL);
 	} else {
-		/* Enable the internel phy clcoks */
+		/* Enable the internal phy clocks */
 		omap4430_phy_set_clk(dev, 1);
 		/* power on the phy */
 		if (__raw_readl(ctrl_base + CONTROL_DEV_CONF) & PHY_PD) {
diff --git a/arch/arm/mach-pxa/include/mach/tosa.h b/arch/arm/mach-pxa/include/mach/tosa.h
index 1272c4b..d8dda48 100644
--- a/arch/arm/mach-pxa/include/mach/tosa.h
+++ b/arch/arm/mach-pxa/include/mach/tosa.h
@@ -15,7 +15,7 @@
 
 /*  TOSA Chip selects  */
 #define TOSA_LCDC_PHYS		PXA_CS4_PHYS
-/* Internel Scoop */
+/* Internal Scoop */
 #define TOSA_CF_PHYS		(PXA_CS2_PHYS + 0x00800000)
 /* Jacket Scoop */
 #define TOSA_SCOOP_PHYS  	(PXA_CS5_PHYS + 0x00800000)
diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 5991ab6..92711eb 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1057,7 +1057,7 @@ static void fm_irq_handle_intmsk_cmd_resp(struct fmdev *fmdev)
 		clear_bit(FM_INTTASK_RUNNING, &fmdev->flag);
 }
 
-/* Returns availability of RDS data in internel buffer */
+/* Returns availability of RDS data in internal buffer */
 u32 fmc_is_rds_data_available(struct fmdev *fmdev, struct file *file,
 				struct poll_table_struct *pts)
 {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a3c8200..9ce90c9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4367,7 +4367,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	 * Initialize driver internal slow-path work queues
 	 */
 
-	/* Driver internel slow-path CQ Event pool */
+	/* Driver internal slow-path CQ Event pool */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_cqe_event_pool);
 	/* Response IOCB work queue list */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_queue_event);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 4958fef..ff7bd81 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1451,7 +1451,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 
 		if (res) {
 			del_timer(&task->timer);
-			mv_printk("executing internel task failed:%d\n", res);
+			mv_printk("executing internal task failed:%d\n", res);
 			goto ex_err;
 		}
 
diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index a164fc4..9d452fd 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -1052,7 +1052,7 @@ static int smtcfb_pci_suspend(struct device *device)
 
 	sfb = pci_get_drvdata(pdev);
 
-	/* set the hw in sleep mode use externel clock and self memory refresh
+	/* set the hw in sleep mode use external clock and self memory refresh
 	 * so that we can turn off internal PLLs later on
 	 */
 	smtc_seqw(0x20, (smtc_seqr(0x20) | 0xc0));
diff --git a/drivers/staging/tidspbridge/core/_tiomap.h b/drivers/staging/tidspbridge/core/_tiomap.h
index 7cb5871..6491af5 100644
--- a/drivers/staging/tidspbridge/core/_tiomap.h
+++ b/drivers/staging/tidspbridge/core/_tiomap.h
@@ -200,7 +200,7 @@ static const struct map_l4_peripheral l4_peripheral_table[] = {
  *  ---------------------------------
  *  |  (class)  | (module specific) |
  *
- *  where  c -> Externel Clock Command: Clk & Autoidle Disable/Enable
+ *  where  c -> External Clock Command: Clk & Autoidle Disable/Enable
  *  i -> External Clock ID Timers 5,6,7,8, McBSP1,2 and WDT3
  */
 
diff --git a/drivers/usb/host/ohci-pnx4008.c b/drivers/usb/host/ohci-pnx4008.c
index 653d6a6..c6ba67b 100644
--- a/drivers/usb/host/ohci-pnx4008.c
+++ b/drivers/usb/host/ohci-pnx4008.c
@@ -147,7 +147,7 @@ static void isp1301_configure(void)
 {
 	/* PNX4008 only supports DAT_SE0 USB mode */
 	/* PNX4008 R2A requires setting the MAX603 to output 3.6V */
-	/* Power up externel charge-pump */
+	/* Power up external charge-pump */
 
 	i2c_write(MC1_DAT_SE0 | MC1_SPEED_REG, ISP1301_I2C_MODE_CONTROL_1);
 	i2c_write(~(MC1_DAT_SE0 | MC1_SPEED_REG),
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 9336590..2ad5cd0 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -31,7 +31,7 @@
  *	to be deciphered for the format file. Although these macros
  *	may become out of sync with the internal structure, they
  *	will create a compile error if it happens. Since the
- *	internel structures are just tracing helpers, this is not
+ *	internal structures are just tracing helpers, this is not
  *	an issue.
  *
  *	When an internal structure is used, it should use:
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 493e394..833f901 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -1416,7 +1416,7 @@ static int hdspm_set_rate(struct hdspm * hdspm, int rate, int called_internally)
 			    HDSPM_AUTOSYNC_FROM_NONE) {
 
 				snd_printk(KERN_WARNING "HDSPM: "
-					   "Detected no Externel Sync \n");
+					   "Detected no External Sync\n");
 				not_set = 1;
 
 			} else if (rate != external_freq) {


