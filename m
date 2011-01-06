Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab1AFNSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:18:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:32954 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751436Ab1AFNSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:18:46 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18JpDYYZYUJQN5HQqhhsiIPcAt/i2+Of5mAEoSSI9
	pMW/BjfbiTE664
From: Peter Huewe <peterhuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] trivial: fix common spelling mistakes
Date: Thu,  6 Jan 2011 14:18:23 +0100
Message-Id: <1294319903-11197-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes.
The changes were carried out by hand and are made in
documentation/comments only - no functional change.
Variables were left untouched on purpose.
Linebreaks were also left untouched on purpose.

The fixed spelling mistakes are:
WRONG 		-> RIGHT

accomodate 	-> accommodate
acommodate 	-> accommodate

adress 		-> address
addres		-> address

hightest 	-> highest
hight 		-> height
hight 		-> high (when mentioned in contrast to low)
hightlight	-> highlight

libary 		-> library
libaray 	-> library

occured 	-> occurred

reqest 		-> request
reguest 	-> request
requst 		-> request
reqeust 	-> request

acheive 	-> achieve
beggining 	-> beginning
embarass	-> embarrass
enviroment	-> environment
fagment 	-> fragment
indefinately-> indefinitely
knowlege 	-> knowledge
regester 	-> register
unferflow	-> underflow

And some other minor changes that caught my eye doing the changes

KernelVersion: trivial.git, master, 90a8a73c

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/x86/kvm/x86.c                                 |    2 +-
 arch/x86/pci/i386.c                                |    2 +-
 block/genhd.c                                      |    2 +-
 drivers/ata/libata-scsi.c                          |    2 +-
 drivers/ata/sata_mv.c                              |    2 +-
 drivers/block/cciss.c                              |    2 +-
 drivers/block/drbd/drbd_int.h                      |    2 +-
 drivers/block/ps3vram.c                            |    2 +-
 drivers/block/xsysace.c                            |    2 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    2 +-
 drivers/char/hvc_iucv.c                            |    4 ++--
 drivers/dma/intel_mid_dma.c                        |    4 ++--
 drivers/edac/edac_core.h                           |    2 +-
 drivers/gpu/drm/radeon/atombios.h                  |    6 +++---
 drivers/gpu/vga/vgaarb.c                           |    2 +-
 drivers/hid/hid-core.c                             |    4 ++--
 drivers/hwmon/sht15.c                              |    4 ++--
 drivers/i2c/busses/i2c-intel-mid.c                 |   10 +++++-----
 drivers/infiniband/hw/ipath/ipath_ruc.c            |    2 +-
 drivers/infiniband/hw/qib/qib_keys.c               |    2 +-
 drivers/infiniband/hw/qib/qib_mad.h                |    2 +-
 drivers/infiniband/hw/qib/qib_ruc.c                |    2 +-
 drivers/input/mouse/vsxxxaa.c                      |    2 +-
 drivers/isdn/hardware/mISDN/w6692.c                |    2 +-
 drivers/isdn/hisax/amd7930_fn.c                    |    2 +-
 drivers/isdn/hisax/avm_pci.c                       |    2 +-
 drivers/isdn/hisax/elsa.c                          |    2 +-
 drivers/isdn/hisax/hisax_fcpcipnp.c                |    4 ++--
 drivers/md/md.h                                    |    2 +-
 drivers/media/IR/ir-keytable.c                     |    2 +-
 drivers/media/common/saa7146_i2c.c                 |    6 +++---
 drivers/media/dvb/b2c2/flexcop-pci.c               |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    2 +-
 drivers/media/dvb/pluto2/pluto2.c                  |    2 +-
 drivers/media/video/cx23885/cx23885.h              |    4 ++--
 drivers/media/video/davinci/dm644x_ccdc.c          |    2 +-
 drivers/media/video/gspca/sonixj.c                 |    2 +-
 drivers/media/video/gspca/spca501.c                |    2 +-
 drivers/media/video/gspca/zc3xx.c                  |    2 +-
 drivers/media/video/ivtv/ivtv-firmware.c           |    2 +-
 drivers/media/video/ov6650.c                       |    2 +-
 drivers/media/video/ov9640.c                       |    2 +-
 drivers/media/video/saa7164/saa7164-cmd.c          |    2 +-
 drivers/media/video/stk-sensor.c                   |    2 +-
 drivers/media/video/usbvideo/usbvideo.c            |    2 +-
 drivers/media/video/uvc/uvc_video.c                |    4 ++--
 drivers/message/fusion/lsi/mpi_log_sas.h           |   10 +++++-----
 drivers/message/fusion/lsi/mpi_raid.h              |    2 +-
 drivers/message/fusion/mptctl.c                    |    2 +-
 drivers/misc/sgi-gru/grukservices.c                |    2 +-
 drivers/mmc/core/mmc_ops.c                         |    2 +-
 drivers/mtd/chips/cfi_cmdset_0001.c                |    4 ++--
 drivers/mtd/lpddr/lpddr_cmds.c                     |    2 +-
 drivers/mtd/maps/ceiva.c                           |    2 +-
 drivers/mtd/maps/pmcmsp-flash.c                    |    2 +-
 drivers/mtd/mtdchar.c                              |    2 +-
 drivers/mtd/nand/diskonchip.c                      |    4 ++--
 drivers/mtd/nand/sh_flctl.c                        |    2 +-
 drivers/net/atl1c/atl1c_hw.c                       |    2 +-
 drivers/net/atl1e/atl1e_hw.c                       |    2 +-
 drivers/net/atlx/atl2.c                            |    2 +-
 drivers/net/bnx2x/bnx2x_reg.h                      |    2 +-
 drivers/net/bonding/bond_3ad.c                     |    4 ++--
 drivers/net/bonding/bond_alb.c                     |    2 +-
 drivers/net/caif/caif_shmcore.c                    |    2 +-
 drivers/net/can/sja1000/sja1000.c                  |    2 +-
 drivers/net/can/usb/ems_usb.c                      |    2 +-
 drivers/net/can/usb/esd_usb2.c                     |    2 +-
 drivers/net/cassini.c                              |    2 +-
 drivers/net/chelsio/subr.c                         |    2 +-
 drivers/net/cxgb3/t3_hw.c                          |    6 +++---
 drivers/net/cxgb4/t4_hw.c                          |    2 +-
 drivers/net/e1000e/netdev.c                        |    2 +-
 drivers/net/ibm_newemac/tah.c                      |    2 +-
 drivers/net/igb/e1000_phy.c                        |    2 +-
 drivers/net/igb/igb_main.c                         |    2 +-
 drivers/net/igbvf/netdev.c                         |    2 +-
 drivers/net/ipg.c                                  |   20 ++++++++++----------
 drivers/net/irda/pxaficp_ir.c                      |    2 +-
 drivers/net/irda/via-ircc.c                        |    2 +-
 drivers/net/ixgbe/ixgbe_phy.c                      |    2 +-
 drivers/net/ll_temac_main.c                        |    2 +-
 drivers/net/mlx4/en_rx.c                           |    4 ++--
 drivers/net/ppp_async.c                            |    2 +-
 drivers/net/s2io.c                                 |    2 +-
 drivers/net/skge.h                                 |    8 ++++----
 drivers/net/sky2.h                                 |    6 +++---
 drivers/net/smsc911x.c                             |    2 +-
 drivers/net/smsc9420.c                             |    2 +-
 drivers/net/tc35815.c                              |    2 +-
 drivers/net/tsi108_eth.h                           |    8 ++++----
 drivers/net/tun.c                                  |    2 +-
 drivers/net/via-rhine.c                            |    4 ++--
 drivers/net/via-velocity.c                         |    2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |    2 +-
 drivers/net/vxge/vxge-traffic.h                    |    2 +-
 drivers/net/wireless/ath/ath5k/reg.h               |    2 +-
 drivers/net/wireless/b43/b43.h                     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-sta.c             |    2 +-
 drivers/net/wireless/libertas/cfg.c                |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00usb.h            |    2 +-
 drivers/parisc/pdc_stable.c                        |    2 +-
 drivers/pnp/pnpbios/bioscalls.c                    |    2 +-
 drivers/ps3/ps3-sys-manager.c                      |    2 +-
 drivers/s390/block/dasd_3990_erp.c                 |    4 ++--
 drivers/s390/char/tty3270.c                        |    2 +-
 drivers/s390/cio/device_fsm.c                      |    2 +-
 drivers/s390/net/claw.c                            |    2 +-
 drivers/scsi/3w-9xxx.h                             |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |    4 ++--
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    2 +-
 drivers/scsi/dc395x.c                              |    2 +-
 drivers/scsi/fcoe/libfcoe.c                        |    2 +-
 drivers/scsi/gdth.h                                |    2 +-
 drivers/scsi/initio.c                              |    2 +-
 drivers/scsi/libfc/fc_lport.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |    2 +-
 drivers/scsi/megaraid/mega_common.h                |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    4 ++--
 drivers/scsi/qla2xxx/qla_isr.c                     |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |    4 ++--
 drivers/scsi/qla2xxx/qla_nx.c                      |    2 +-
 drivers/scsi/scsi_transport_fc.c                   |    2 +-
 drivers/serial/8250.c                              |    2 +-
 drivers/serial/bfin_sport_uart.c                   |    2 +-
 drivers/serial/max3107.c                           |    2 +-
 drivers/serial/sn_console.c                        |    2 +-
 drivers/serial/ucc_uart.c                          |    2 +-
 drivers/spi/amba-pl022.c                           |    2 +-
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    2 +-
 drivers/staging/bcm/InterfaceIdleMode.c            |    4 ++--
 drivers/staging/bcm/InterfaceInit.c                |    2 +-
 drivers/staging/bcm/InterfaceIsr.c                 |    6 +++---
 drivers/staging/bcm/InterfaceRx.c                  |    2 +-
 drivers/staging/bcm/InterfaceTx.c                  |    4 ++--
 drivers/staging/bcm/PHSModule.c                    |    2 +-
 drivers/staging/bcm/cntrl_SignalingInterface.h     |    4 ++--
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    2 +-
 drivers/staging/comedi/comedi_fops.c               |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |    8 ++++----
 drivers/staging/comedi/drivers/adv_pci1710.c       |    2 +-
 drivers/staging/comedi/drivers/comedi_test.c       |    2 +-
 drivers/staging/comedi/drivers/me4000.c            |    4 ++--
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    4 ++--
 drivers/staging/comedi/drivers/ni_labpc.c          |    6 +++---
 drivers/staging/comedi/drivers/s626.c              |    2 +-
 drivers/staging/crystalhd/crystalhd_hw.c           |    2 +-
 drivers/staging/easycap/easycap_low.c              |    2 +-
 drivers/staging/et131x/et1310_rx.c                 |    2 +-
 drivers/staging/et131x/et131x_isr.c                |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    4 ++--
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    2 +-
 drivers/staging/iio/chrdev.h                       |    2 +-
 drivers/staging/intel_sst/intel_sst_dsp.c          |    2 +-
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |    2 +-
 drivers/staging/intel_sst/intel_sst_pvt.c          |    2 +-
 drivers/staging/octeon/cvmx-helper.c               |    2 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |    4 ++--
 drivers/staging/rt2860/common/action.c             |    2 +-
 drivers/staging/rt2860/common/ba_action.c          |    4 ++--
 drivers/staging/rt2860/sta/connect.c               |    2 +-
 drivers/staging/spectra/flash.c                    |    2 +-
 drivers/staging/tidspbridge/hw/hw_mmu.c            |    6 +++---
 drivers/staging/vt6655/device_main.c               |    2 +-
 drivers/staging/vt6655/tether.h                    |    4 ++--
 drivers/staging/vt6656/baseband.c                  |    2 +-
 .../westbridge/astoria/api/src/cyaslowlevel.c      |    2 +-
 .../westbridge/astoria/block/cyasblkdev_block.c    |    2 +-
 drivers/staging/wlags49_h2/hcf.c                   |    2 +-
 drivers/staging/wlags49_h2/mdd.h                   |    2 +-
 drivers/staging/wlan-ng/p80211req.c                |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/c67x00/c67x00-sched.c                  |    2 +-
 drivers/usb/class/cdc-acm.h                        |    2 +-
 drivers/usb/gadget/amd5536udc.c                    |    8 ++++----
 drivers/usb/gadget/fsl_qe_udc.h                    |    4 ++--
 drivers/usb/gadget/fsl_udc_core.c                  |    4 ++--
 drivers/usb/gadget/langwell_udc.c                  |    2 +-
 drivers/usb/host/fhci-tds.c                        |    4 ++--
 drivers/usb/host/fhci.h                            |    2 +-
 drivers/video/da8xx-fb.c                           |    2 +-
 drivers/video/fbsysfs.c                            |    2 +-
 drivers/watchdog/acquirewdt.c                      |    2 +-
 drivers/watchdog/sch311x_wdt.c                     |    2 +-
 drivers/watchdog/smsc37b787_wdt.c                  |    2 +-
 drivers/watchdog/sp805_wdt.c                       |    2 +-
 fs/ecryptfs/inode.c                                |    2 +-
 fs/ecryptfs/main.c                                 |    2 +-
 fs/ext4/ext4.h                                     |    2 +-
 fs/ext4/extents.c                                  |    2 +-
 fs/jffs2/readinode.c                               |    2 +-
 fs/nfs/file.c                                      |    2 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/ntfs/attrib.c                                   |    2 +-
 fs/ntfs/inode.c                                    |    2 +-
 fs/ntfs/logfile.h                                  |    2 +-
 fs/ntfs/mft.c                                      |    4 ++--
 fs/ntfs/super.c                                    |   14 +++++++-------
 fs/ocfs2/cluster/quorum.c                          |    2 +-
 fs/reiserfs/xattr.c                                |    2 +-
 fs/udf/inode.c                                     |    2 +-
 fs/xfs/linux-2.6/xfs_file.c                        |    2 +-
 fs/xfs/quota/xfs_qm_bhv.c                          |    2 +-
 fs/xfs/xfs_log_recover.c                           |    4 ++--
 include/drm/ttm/ttm_bo_driver.h                    |    4 ++--
 include/linux/atmlec.h                             |    2 +-
 include/linux/can/error.h                          |    2 +-
 include/linux/fb.h                                 |    4 ++--
 include/linux/spi/spidev.h                         |    2 +-
 include/linux/sunrpc/svc.h                         |    2 +-
 include/linux/usb.h                                |    2 +-
 include/linux/uwb.h                                |    2 +-
 include/net/9p/client.h                            |    2 +-
 include/sound/cs8427.h                             |    2 +-
 kernel/latencytop.c                                |    2 +-
 kernel/power/main.c                                |    2 +-
 kernel/user-return-notifier.c                      |    2 +-
 mm/hugetlb.c                                       |    6 +++---
 mm/kmemleak.c                                      |    6 +++---
 mm/percpu.c                                        |    6 +++---
 net/9p/client.c                                    |    2 +-
 net/ipv4/tcp_output.c                              |    2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |    2 +-
 net/irda/irlap_event.c                             |    2 +-
 net/irda/timer.c                                   |    2 +-
 net/mac80211/rc80211_pid.h                         |    2 +-
 net/netfilter/nf_conntrack_core.c                  |    2 +-
 net/rds/iw_cm.c                                    |    2 +-
 net/sunrpc/xprtsock.c                              |    4 ++--
 security/smack/smack_lsm.c                         |    2 +-
 sound/pci/ctxfi/cthw20k1.c                         |    2 +-
 sound/pci/ctxfi/cthw20k2.c                         |    2 +-
 sound/pci/pcxhr/pcxhr_core.c                       |   12 ++++++------
 sound/ppc/snd_ps3.c                                |    2 +-
 sound/ppc/snd_ps3_reg.h                            |    8 ++++----
 sound/soc/codecs/wm8962.c                          |    2 +-
 241 files changed, 340 insertions(+), 340 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b989e1f..ba2e12b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1017,7 +1017,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	/*
 	 * Special case: close write to TSC within 5 seconds of
 	 * another CPU is interpreted as an attempt to synchronize
-	 * The 5 seconds is to accomodate host load / swapping as
+	 * The 5 seconds is to accommodate host load / swapping as
 	 * well as any reset of TSC during the boot process.
 	 *
 	 * In that case, for a reliable TSC, we can match TSC offsets,
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b1805b7..bbce412 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -241,7 +241,7 @@ void __init pcibios_resource_survey(void)
 	e820_reserve_resources_late();
 	/*
 	 * Insert the IO APIC resources after PCI initialization has
-	 * occured to handle IO APICS that are mapped in on a BAR in
+	 * occurred to handle IO APICS that are mapped in on a BAR in
 	 * PCI space, but before trying to assign unassigned pci res.
 	 */
 	ioapic_insert_resources();
diff --git a/block/genhd.c b/block/genhd.c
index 5fa2b44..88fd358 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1117,7 +1117,7 @@ static void media_change_notify_thread(struct work_struct *work)
 	char *envp[] = { event, NULL };
 
 	/*
-	 * set enviroment vars to indicate which event this is for
+	 * set environment vars to indicate which event this is for
 	 * so that user space will know to go check the media status.
 	 */
 	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 66aa4be..9798899 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1002,7 +1002,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
  *	@qc: Command that we are erroring out
  *
  *	Generate sense block for a failed ATA command @qc.  Descriptor
- *	format is used to accomodate LBA48 block address.
+ *	format is used to accommodate LBA48 block address.
  *
  *	LOCKING:
  *	None.
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index bf74a36..82693fa 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2045,7 +2045,7 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 
 	cw = &pp->crqb[in_index].ata_cmd[0];
 
-	/* Sadly, the CRQB cannot accomodate all registers--there are
+	/* Sadly, the CRQB cannot accommodate all registers--there are
 	 * only 11 bytes...so we must pick and choose required
 	 * registers based on the command.  So, we drop feature and
 	 * hob_feature for [RW] DMA commands, but they are needed for
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8e0f925..a63342b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2424,7 +2424,7 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 
 	--h->num_luns;
 
-	/* if it was the last disk, find the new hightest lun */
+	/* if it was the last disk, find the new highest lun */
 	if (clear_all && recalculate_highest_lun) {
 		int newhighest = -1;
 		for (i = 0; i <= h->highest_lun; i++) {
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 1ea1a34..cfb8721 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1763,7 +1763,7 @@ static inline int _drbd_set_state(struct drbd_conf *mdev,
 }
 
 /**
- * drbd_request_state() - Reqest a state change
+ * drbd_request_state() - Request a state change
  * @mdev:	DRBD device.
  * @mask:	mask of state bits to change.
  * @val:	value of new state bits.
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index b3bdb8a..43b3efc 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -648,7 +648,7 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
 		goto fail_free_priv;
 	}
 
-	/* Put FIFO at begginning of XDR buffer */
+	/* Put FIFO at beginning of XDR buffer */
 	priv->fifo_base = (u32 *) (priv->xdr_buf + FIFO_OFFSET);
 	priv->fifo_ptr = priv->fifo_base;
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 829161e..17c5408 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -621,7 +621,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		ace_dump_mem(ace->cf_id, 512);	/* Debug: Dump out disk ID */
 
 		if (ace->data_result) {
-			/* Error occured, disable the disk */
+			/* Error occurred, disable the disk */
 			ace->media_change = 1;
 			set_capacity(ace->gd, 0);
 			dev_err(ace->dev, "error fetching CF id (%i)\n",
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index dcc2a6e..551052d 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -966,7 +966,7 @@ static void btmrvl_sdio_remove(struct sdio_func *func)
 							MODULE_SHUTDOWN_REQ);
 				btmrvl_sdio_disable_host_int(card);
 			}
-			BT_DBG("unregester dev");
+			BT_DBG("unregister dev");
 			btmrvl_sdio_unregister_dev(card);
 			btmrvl_remove_card(card->priv);
 			kfree(card);
diff --git a/drivers/char/hvc_iucv.c b/drivers/char/hvc_iucv.c
index c3425bb..b6f7d52 100644
--- a/drivers/char/hvc_iucv.c
+++ b/drivers/char/hvc_iucv.c
@@ -255,7 +255,7 @@ static int hvc_iucv_write(struct hvc_iucv_private *priv,
 		default:
 			written = -EIO;
 		}
-		/* remove buffer if an error has occured or received data
+		/* remove buffer if an error has occurred or received data
 		 * is not correct */
 		if (rc || (rb->mbuf->version != MSG_VERSION) ||
 			  (rb->msg.length    != MSG_SIZE(rb->mbuf->datalen)))
@@ -620,7 +620,7 @@ static void hvc_iucv_hangup(struct hvc_iucv_private *priv)
  *		the index of an struct hvc_iucv_private instance.
  *
  * This routine notifies the HVC back-end that a tty hangup (carrier loss,
- * virtual or otherwise) has occured.
+ * virtual or otherwise) has occurred.
  * The z/VM IUCV HVC device driver ignores virtual hangups (vhangup())
  * to keep an existing IUCV communication path established.
  * (Background: vhangup() is called from user space (by getty or login) to
diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 3109bd9..c6fd899 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -891,8 +891,8 @@ static int intel_mid_dma_alloc_chan_resources(struct dma_chan *chan)
 
 /**
  * midc_handle_error -	Handle DMA txn error
- * @mid: controller where error occured
- * @midc: chan where error occured
+ * @mid: controller where error occurred
+ * @midc: chan where error occurred
  *
  * Scan the descriptor for error
  */
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 251440c..0f134ba 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -822,7 +822,7 @@ extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
  * There are a limited number of error logging registers that can
  * be exausted.  When all registers are exhausted and an additional
  * error occurs then an error overflow register records that an
- * error occured and the type of error, but doesn't have any
+ * error occurred and the type of error, but doesn't have any
  * further information.  The ce/ue versions make for cleaner
  * reporting logic and function interface - reduces conditional
  * statement clutter and extra function arguments.
diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index fe359a2..e4e1379 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -4344,7 +4344,7 @@ typedef struct _ENABLE_HARDWARE_ICON_CURSOR_PS_ALLOCATION
 
 typedef struct _ENABLE_GRAPH_SURFACE_PARAMETERS
 {
-  USHORT usHight;                     // Image Hight
+  USHORT usHight;                     // Image Height
   USHORT usWidth;                     // Image Width
   UCHAR  ucSurface;                   // Surface 1 or 2	
   UCHAR  ucPadding[3];
@@ -4352,7 +4352,7 @@ typedef struct _ENABLE_GRAPH_SURFACE_PARAMETERS
 
 typedef struct _ENABLE_GRAPH_SURFACE_PARAMETERS_V1_2
 {
-  USHORT usHight;                     // Image Hight
+  USHORT usHight;                     // Image Height
   USHORT usWidth;                     // Image Width
   UCHAR  ucSurface;                   // Surface 1 or 2
   UCHAR  ucEnable;                    // ATOM_ENABLE or ATOM_DISABLE
@@ -4361,7 +4361,7 @@ typedef struct _ENABLE_GRAPH_SURFACE_PARAMETERS_V1_2
 
 typedef struct _ENABLE_GRAPH_SURFACE_PARAMETERS_V1_3
 {
-  USHORT usHight;                     // Image Hight
+  USHORT usHight;                     // Image Height
   USHORT usWidth;                     // Image Width
   UCHAR  ucSurface;                   // Surface 1 or 2
   UCHAR  ucEnable;                    // ATOM_ENABLE or ATOM_DISABLE
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index c380c65..4761b63 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -151,7 +151,7 @@ static inline void vga_irq_set_state(struct vga_device *vgadev, bool state)
 static void vga_check_first_use(void)
 {
 	/* we should inform all GPUs in the system that
-	 * VGA arb has occured and to try and disable resources
+	 * VGA arb has occurred and to try and disable resources
 	 * if they can */
 	if (!vga_arbiter_used) {
 		vga_arbiter_used = true;
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 88cb04e..49725b3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -294,7 +294,7 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
 	case HID_GLOBAL_ITEM_TAG_PUSH:
 
 		if (parser->global_stack_ptr == HID_GLOBAL_STACK_SIZE) {
-			dbg_hid("global enviroment stack overflow\n");
+			dbg_hid("global environment stack overflow\n");
 			return -1;
 		}
 
@@ -305,7 +305,7 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
 	case HID_GLOBAL_ITEM_TAG_POP:
 
 		if (!parser->global_stack_ptr) {
-			dbg_hid("global enviroment stack underflow\n");
+			dbg_hid("global environment stack underflow\n");
 			return -1;
 		}
 
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index a610e78..fe92360 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -251,7 +251,7 @@ static inline int sht15_update_single_val(struct sht15_data *data,
 	enable_irq(gpio_to_irq(data->pdata->gpio_data));
 	if (gpio_get_value(data->pdata->gpio_data) == 0) {
 		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
-		/* Only relevant if the interrupt hasn't occured. */
+		/* Only relevant if the interrupt hasn't occurred. */
 		if (!atomic_read(&data->interrupt_handled))
 			schedule_work(&data->read_work);
 	}
@@ -452,7 +452,7 @@ static void sht15_bh_read_data(struct work_struct *work_s)
 		*/
 		atomic_set(&data->interrupt_handled, 0);
 		enable_irq(gpio_to_irq(data->pdata->gpio_data));
-		/* If still not occured or another handler has been scheduled */
+		/* If still not occurred or another handler has been scheduled */
 		if (gpio_get_value(data->pdata->gpio_data)
 		    || atomic_read(&data->interrupt_handled))
 			return;
diff --git a/drivers/i2c/busses/i2c-intel-mid.c b/drivers/i2c/busses/i2c-intel-mid.c
index c714927..dda5cd8 100644
--- a/drivers/i2c/busses/i2c-intel-mid.c
+++ b/drivers/i2c/busses/i2c-intel-mid.c
@@ -170,8 +170,8 @@ struct intel_mid_i2c_private {
 /* Raw Interrupt Status Register */
 #define IC_RAW_INTR_STAT	0x34		/* Read Only */
 #define GEN_CALL		(1 << 11)	/* General call */
-#define START_DET		(1 << 10)	/* (RE)START occured */
-#define STOP_DET		(1 << 9)	/* STOP occured */
+#define START_DET		(1 << 10)	/* (RE)START occurred */
+#define STOP_DET		(1 << 9)	/* STOP occurred */
 #define ACTIVITY		(1 << 8)	/* Bus busy */
 #define RX_DONE			(1 << 7)	/* Not used in Master mode */
 #define	TX_ABRT			(1 << 6)	/* Transmit Abort */
@@ -455,7 +455,7 @@ static inline bool intel_mid_i2c_address_neq(const struct i2c_msg *p1,
  *
  * By reading register IC_TX_ABRT_SOURCE, various transfer errors can be
  * distingushed. At present, no circumstances have been found out that
- * multiple errors would be occured simutaneously, so we simply use the
+ * multiple errors would be occurred simutaneously, so we simply use the
  * register value directly.
  *
  * At last the error bits are cleared. (Note clear ABRT_SBYTE_NORSTRT bit need
@@ -469,7 +469,7 @@ static void intel_mid_i2c_abort(struct intel_mid_i2c_private *i2c)
 
 	/* Single transfer error check:
 	 * According to databook, TX/RX FIFOs would be flushed when
-	 * the abort interrupt occured.
+	 * the abort interrupt occurred.
 	 */
 	if (abort & ABRT_MASTER_DIS)
 		dev_err(&adap->dev,
@@ -569,7 +569,7 @@ static int xfer_read(struct i2c_adapter *adap, unsigned char *buf, int length)
  * Return Values:
  * 0	if the read transfer succeeds
  * -ETIMEDOUT	if we cannot read the "raw" interrupt register
- * -EINVAL	if a transfer abort occured
+ * -EINVAL	if a transfer abort occurred
  *
  * For every byte, a "WRITE" command will be loaded into IC_DATA_CMD prior to
  * data transfer. The actual "write" operation will be performed when the
diff --git a/drivers/infiniband/hw/ipath/ipath_ruc.c b/drivers/infiniband/hw/ipath/ipath_ruc.c
index 1f95bba..edfe687 100644
--- a/drivers/infiniband/hw/ipath/ipath_ruc.c
+++ b/drivers/infiniband/hw/ipath/ipath_ruc.c
@@ -289,7 +289,7 @@ again:
 		goto clr_busy;
 	wqe = get_swqe_ptr(sqp, sqp->s_last);
 
-	/* Return if it is not OK to start a new work reqeust. */
+	/* Return if it is not OK to start a new work request. */
 	if (!(ib_ipath_state_ops[sqp->state] & IPATH_PROCESS_NEXT_SEND_OK)) {
 		if (!(ib_ipath_state_ops[sqp->state] & IPATH_FLUSH_SEND))
 			goto clr_busy;
diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 4b80eb1..49bfd91 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -275,7 +275,7 @@ bail:
 }
 
 /*
- * Initialize the memory region specified by the work reqeust.
+ * Initialize the memory region specified by the work request.
  */
 int qib_fast_reg_mr(struct qib_qp *qp, struct ib_send_wr *wr)
 {
diff --git a/drivers/infiniband/hw/qib/qib_mad.h b/drivers/infiniband/hw/qib/qib_mad.h
index 147aff9..7840ab5 100644
--- a/drivers/infiniband/hw/qib/qib_mad.h
+++ b/drivers/infiniband/hw/qib/qib_mad.h
@@ -73,7 +73,7 @@ struct ib_mad_notice_attr {
 
 		struct {
 			__be16	reserved;
-			__be16	lid;		/* LID where change occured */
+			__be16	lid;		/* LID where change occurred */
 			u8	reserved2;
 			u8	local_changes;	/* low bit - local changes */
 			__be32	new_cap_mask;	/* new capability mask */
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index eb78d93..d1823b9 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -381,7 +381,7 @@ again:
 		goto clr_busy;
 	wqe = get_swqe_ptr(sqp, sqp->s_last);
 
-	/* Return if it is not OK to start a new work reqeust. */
+	/* Return if it is not OK to start a new work request. */
 	if (!(ib_qib_state_ops[sqp->state] & QIB_PROCESS_NEXT_SEND_OK)) {
 		if (!(ib_qib_state_ops[sqp->state] & QIB_FLUSH_SEND))
 			goto clr_busy;
diff --git a/drivers/input/mouse/vsxxxaa.c b/drivers/input/mouse/vsxxxaa.c
index bf2c0c8..eb9a3cf 100644
--- a/drivers/input/mouse/vsxxxaa.c
+++ b/drivers/input/mouse/vsxxxaa.c
@@ -334,7 +334,7 @@ static void vsxxxaa_handle_POR_packet(struct vsxxxaa *mouse)
 	 * M: manufacturer location code
 	 * R: revision code
 	 * E: Error code. If it's in the range of 0x00..0x1f, only some
-	 *    minor problem occured. Errors >= 0x20 are considered bad
+	 *    minor problem occurred. Errors >= 0x20 are considered bad
 	 *    and the device may not work properly...
 	 * D: <0010> == mouse, <0100> == tablet
 	 */
diff --git a/drivers/isdn/hardware/mISDN/w6692.c b/drivers/isdn/hardware/mISDN/w6692.c
index 9e84870..3c376df 100644
--- a/drivers/isdn/hardware/mISDN/w6692.c
+++ b/drivers/isdn/hardware/mISDN/w6692.c
@@ -779,7 +779,7 @@ w6692_irq(int intno, void *dev_id)
 	spin_lock(&card->lock);
 	ista = ReadW6692(card, W_ISTA);
 	if ((ista | card->imask) == card->imask) {
-		/* possible a shared  IRQ reqest */
+		/* possible a shared  IRQ request */
 		spin_unlock(&card->lock);
 		return IRQ_NONE;
 	}
diff --git a/drivers/isdn/hisax/amd7930_fn.c b/drivers/isdn/hisax/amd7930_fn.c
index 5d72783..6ce042b 100644
--- a/drivers/isdn/hisax/amd7930_fn.c
+++ b/drivers/isdn/hisax/amd7930_fn.c
@@ -628,7 +628,7 @@ Amd7930_l1hw(struct PStack *st, int pr, void *arg)
 			if ((cs->dc.amd7930.ph_state == 8)) {
 				/* b-channels off, PH-AR cleared
 				 * change to F3 */
-				Amd7930_ph_command(cs, 0x20, "HW_RESET REQEST"); //LMR1 bit 5
+				Amd7930_ph_command(cs, 0x20, "HW_RESET REQUEST"); //LMR1 bit 5
 				spin_unlock_irqrestore(&cs->lock, flags);
 			} else {
 				Amd7930_ph_command(cs, 0x40, "HW_RESET REQUEST");
diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index fcf4ed1..2f834fd 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -653,7 +653,7 @@ avm_pcipnp_interrupt(int intno, void *dev_id)
 	spin_lock_irqsave(&cs->lock, flags);
 	sval = inb(cs->hw.avm.cfg_reg + 2);
 	if ((sval & AVM_STATUS0_IRQ_MASK) == AVM_STATUS0_IRQ_MASK) {
-		/* possible a shared  IRQ reqest */
+		/* possible a shared  IRQ request */
 		spin_unlock_irqrestore(&cs->lock, flags);
 		return IRQ_NONE;
 	}
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index 5d9d338..6d097f5 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -70,7 +70,7 @@ static const char *ITACVer[] =
 /* PCI stuff */
 #define ELSA_PCI_IRQ_MASK	0x04
 
-/* ITAC Registeradressen (only Microlink PC) */
+/* ITAC register addresses (only Microlink PC) */
 #define ITAC_SYS	0x34
 #define ITAC_ISEN	0x48
 #define ITAC_RFIE	0x4A
diff --git a/drivers/isdn/hisax/hisax_fcpcipnp.c b/drivers/isdn/hisax/hisax_fcpcipnp.c
index 8b0a7d8..5e3e458 100644
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c
+++ b/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -659,7 +659,7 @@ fcpci2_irq(int intno, void *dev)
 
 	val = inb(adapter->io + AVM_STATUS0);
 	if (!(val & AVM_STATUS0_IRQ_MASK))
-		/* hopefully a shared  IRQ reqest */
+		/* hopefully a shared  IRQ request */
 		return IRQ_NONE;
 	DBG(2, "STATUS0 %#x", val);
 	if (val & AVM_STATUS0_IRQ_ISAC)
@@ -679,7 +679,7 @@ fcpci_irq(int intno, void *dev)
 
 	sval = inb(adapter->io + 2);
 	if ((sval & AVM_STATUS0_IRQ_MASK) == AVM_STATUS0_IRQ_MASK)
-		/* possibly a shared  IRQ reqest */
+		/* possibly a shared  IRQ request */
 		return IRQ_NONE;
 	DBG(2, "sval %#x", sval);
 	if (!(sval & AVM_STATUS0_IRQ_ISAC))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d05bab5..91fccab 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -90,7 +90,7 @@ struct mdk_rdev_s
 #define	AllReserved	6		/* If whole device is reserved for
 					 * one array */
 #define	AutoDetected	7		/* added by auto-detect */
-#define Blocked		8		/* An error occured on an externally
+#define Blocked		8		/* An error occurred on an externally
 					 * managed array, don't allow writes
 					 * until it is cleared */
 	wait_queue_head_t blocked_wait;
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index f60107c..57b2e48 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -172,7 +172,7 @@ static unsigned int ir_update_mapping(struct input_dev *dev,
  * @rc_tab:	scancode table to be searched
  * @scancode:	the desired scancode
  * @resize:	controls whether we allowed to resize the table to
- *		accomodate not yet present scancodes
+ *		accommodate not yet present scancodes
  * @return:	index of the mapping containing scancode in question
  *		or -1U in case of failure.
  *
diff --git a/drivers/media/common/saa7146_i2c.c b/drivers/media/common/saa7146_i2c.c
index 74ee172..8434c0c 100644
--- a/drivers/media/common/saa7146_i2c.c
+++ b/drivers/media/common/saa7146_i2c.c
@@ -161,7 +161,7 @@ static int saa7146_i2c_reset(struct saa7146_dev *dev)
 		msleep(SAA7146_I2C_DELAY);
 	}
 
-	/* if any error is still present, a fatal error has occured ... */
+	/* if any error is still present, a fatal error has occurred ... */
 	status = saa7146_i2c_status(dev);
 	if ( dev->i2c_bitrate != status ) {
 		DEB_I2C(("fatal error. status:0x%08x\n",status));
@@ -326,9 +326,9 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
 			if ( 0 != err) {
 				/* this one is unsatisfying: some i2c slaves on some
 				   dvb cards don't acknowledge correctly, so the saa7146
-				   thinks that an address error occured. in that case, the
+				   thinks that an address error occurred. in that case, the
 				   transaction should be retrying, even if an address error
-				   occured. analog saa7146 based cards extensively rely on
+				   occurred. analog saa7146 based cards extensively rely on
 				   i2c address probing, however, and address errors indicate that a
 				   device is really *not* there. retrying in that case
 				   increases the time the device needs to probe greatly, so
diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/dvb/b2c2/flexcop-pci.c
index 227c020..9552540 100644
--- a/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -58,7 +58,7 @@ struct flexcop_pci {
 
 	int active_dma1_addr; /* 0 = addr0 of dma1; 1 = addr1 of dma1 */
 	u32 last_dma1_cur_pos;
-	/* position of the pointer last time the timer/packet irq occured */
+	/* position of the pointer last time the timer/packet irq occurred */
 	int count;
 	int count_prev;
 	int stream_problem;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index cad6634..312bf46 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1638,7 +1638,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 	case FE_READ_STATUS: {
 		fe_status_t* status = parg;
 
-		/* if retune was requested but hasn't occured yet, prevent
+		/* if retune was requested but hasn't occurred yet, prevent
 		 * that user get signal state from previous tuning */
 		if (fepriv->state == FESTATE_RETUNE ||
 		    fepriv->state == FESTATE_ERROR) {
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 34f7b3b..347a038 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -320,7 +320,7 @@ struct usb_data_stream {
  * struct dvb_usb_adapter - a DVB adapter on a USB device
  * @id: index of this adapter (starting with 0).
  *
- * @feedcount: number of reqested feeds (used for streaming-activation)
+ * @feedcount: number of requested feeds (used for streaming-activation)
  * @pid_filtering: is hardware pid_filtering used or not.
  *
  * @pll_addr: I2C address of the tuner for programming
diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 6ca6713..be44652 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -332,7 +332,7 @@ static irqreturn_t pluto_irq(int irq, void *dev_id)
 	struct pluto *pluto = dev_id;
 	u32 tscr;
 
-	/* check whether an interrupt occured on this device */
+	/* check whether an interrupt occurred on this device */
 	tscr = pluto_readreg(pluto, REG_TSCR);
 	if (!(tscr & (TSCR_DE | TSCR_OVR)))
 		return IRQ_NONE;
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index ed94b17..b1ba4ed 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -210,8 +210,8 @@ struct cx23885_board {
 
 	/* Vendors can and do run the PCIe bridge at different
 	 * clock rates, driven physically by crystals on the PCBs.
-	 * The core has to accomodate this. This allows the user
-	 * to add new boards with new frequencys. The value is
+	 * The core has to accommodate this. This allows the user
+	 * to add new boards with new frequencies. The value is
 	 * expressed in Hz.
 	 *
 	 * The core framework will default this value based on
diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index 490aafb..b3fe98d 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -258,7 +258,7 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 	/*
 	 * Allocate memory for FPC table if current
 	 * FPC table buffer is not big enough to
-	 * accomodate FPC Number requested
+	 * accommodate FPC Number requested
 	 */
 	if (raw_params->fault_pxl.fp_num != config_params->fault_pxl.fp_num) {
 		if (fpc_physaddr != NULL) {
diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index e23de57..3c56e80 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -1128,7 +1128,7 @@ static const u8 ov7660_sensor_param1[][8] = {
 /*	{0xb1, 0x21, 0x01, 0x78, 0x78, 0x00, 0x00, 0x10}, * BLUE */
 /****** (some exchanges in the win trace) ******/
 /*fixme:param2*/
-	{0xa1, 0x21, 0x93, 0x00, 0x00, 0x00, 0x00, 0x10},/* dummy line hight */
+	{0xa1, 0x21, 0x93, 0x00, 0x00, 0x00, 0x00, 0x10},/* dummy line high */
 	{0xa1, 0x21, 0x92, 0x25, 0x00, 0x00, 0x00, 0x10}, /* dummy line low */
 	{0xa1, 0x21, 0x2a, 0x00, 0x00, 0x00, 0x00, 0x10}, /* EXHCH */
 	{0xa1, 0x21, 0x2b, 0x00, 0x00, 0x00, 0x00, 0x10}, /* EXHCL */
diff --git a/drivers/media/video/gspca/spca501.c b/drivers/media/video/gspca/spca501.c
index 642839a..ed2eb84 100644
--- a/drivers/media/video/gspca/spca501.c
+++ b/drivers/media/video/gspca/spca501.c
@@ -1715,7 +1715,7 @@ static const __u16 spca501c_mysterious_init_data[][3] = {
 	{0x00, 0x0080, 0x0021},	/* 640 */
 	{0x00, 0x0001, 0x0022},
 	{0x00, 0x00e0, 0x0023},	/* 480 */
-	{0x00, 0x0000, 0x0024},	/* Offset H hight */
+	{0x00, 0x0000, 0x0024},	/* Offset H high */
 	{0x00, 0x00d3, 0x0025},	/* low */
 	{0x00, 0x0000, 0x0026},	/* Offset V */
 	{0x00, 0x000d, 0x0027},	/* low */
diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index c7e1970..4eeec22 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -5753,7 +5753,7 @@ static u16 i2c_read(struct gspca_dev *gspca_dev,
 	if (retbyte != 0x00)
 		err("i2c_r status error %02x", retbyte);
 	retval = reg_r_i(gspca_dev, 0x0095);		/* read Lowbyte */
-	retval |= reg_r_i(gspca_dev, 0x0096) << 8;	/* read Hightbyte */
+	retval |= reg_r_i(gspca_dev, 0x0096) << 8;	/* read Highbyte */
 	PDEBUG(D_USBI, "i2c r [%02x] -> %04x (%02x)",
 			reg, retval, retbyte);
 	return retval;
diff --git a/drivers/media/video/ivtv/ivtv-firmware.c b/drivers/media/video/ivtv/ivtv-firmware.c
index 4df0194..0f27f5b 100644
--- a/drivers/media/video/ivtv/ivtv-firmware.c
+++ b/drivers/media/video/ivtv/ivtv-firmware.c
@@ -377,7 +377,7 @@ int ivtv_firmware_check(struct ivtv *itv, char *where)
 			  "Reloading\n", where);
 		res = ivtv_firmware_restart(itv);
 		/*
-		 * Even if restarted ok, still signal a problem had occured.
+		 * Even if restarted ok, still signal a problem had occurred.
 		 * The caller can come through this function again to check
 		 * if things are really ok after the restart.
 		 */
diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index cf93de9..336180b 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -1038,7 +1038,7 @@ static int ov6650_reset(struct i2c_client *client)
 	ret = ov6650_reg_rmw(client, REG_COMA, COMA_RESET, 0);
 	if (ret)
 		dev_err(&client->dev,
-			"An error occured while entering soft reset!\n");
+			"An error occurred while entering soft reset!\n");
 
 	return ret;
 }
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 99e9e1d..905f184 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -271,7 +271,7 @@ static int ov9640_reset(struct i2c_client *client)
 	ret = ov9640_reg_write(client, OV9640_COM7, OV9640_COM7_SCCB_RESET);
 	if (ret)
 		dev_err(&client->dev,
-			"An error occured while entering soft reset!\n");
+			"An error occurred while entering soft reset!\n");
 
 	return ret;
 }
diff --git a/drivers/media/video/saa7164/saa7164-cmd.c b/drivers/media/video/saa7164/saa7164-cmd.c
index 301a9e3..7f6eb6a 100644
--- a/drivers/media/video/saa7164/saa7164-cmd.c
+++ b/drivers/media/video/saa7164/saa7164-cmd.c
@@ -256,7 +256,7 @@ out:
 }
 
 /* Wait for a signal event, without holding a mutex. Either return TIMEOUT if
- * the event never occured, or SAA_OK if it was signaled during the wait.
+ * the event never occurred, or SAA_OK if it was signaled during the wait.
  */
 int saa7164_cmd_wait(struct saa7164_dev *dev, u8 seqno)
 {
diff --git a/drivers/media/video/stk-sensor.c b/drivers/media/video/stk-sensor.c
index e546b01..5d0f84c 100644
--- a/drivers/media/video/stk-sensor.c
+++ b/drivers/media/video/stk-sensor.c
@@ -502,7 +502,7 @@ int stk_sensor_configure(struct stk_camera *dev)
 	int com7;
 	/*
 	 * We setup the sensor to output dummy lines in low-res modes,
-	 * so we don't get absurdly hight framerates.
+	 * so we don't get absurdly high framerates.
 	 */
 	unsigned dummylines;
 	int flip;
diff --git a/drivers/media/video/usbvideo/usbvideo.c b/drivers/media/video/usbvideo/usbvideo.c
index f1fcf97..afedfad 100644
--- a/drivers/media/video/usbvideo/usbvideo.c
+++ b/drivers/media/video/usbvideo/usbvideo.c
@@ -1624,7 +1624,7 @@ static ssize_t usbvideo_v4l_read(struct file *file, char __user *buf,
 	 *
 	 * First things first, make sure we don't copy more than we
 	 * have - even if the application wants more. That would be
-	 * a big security embarassment!
+	 * a big security embarrassment!
 	 */
 	if ((count + frame->seqRead_Index) > frame->seqRead_Length)
 		count = frame->seqRead_Length - frame->seqRead_Index;
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 5673d67..d270f24 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -390,7 +390,7 @@ int uvc_commit_video(struct uvc_streaming *stream,
  *
  * uvc_video_decode_end is called with header data at the end of a bulk or
  * isochronous payload. It performs any additional header data processing and
- * returns 0 or a negative error code if an error occured. As header data have
+ * returns 0 or a negative error code if an error occurred. As header data have
  * already been processed by uvc_video_decode_start, this functions isn't
  * required to perform sanity checks a second time.
  *
@@ -654,7 +654,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 							    buf);
 		} while (ret == -EAGAIN);
 
-		/* If an error occured skip the rest of the payload. */
+		/* If an error occurred skip the rest of the payload. */
 		if (ret < 0 || buf == NULL) {
 			stream->bulk.skip_payload = 1;
 		} else {
diff --git a/drivers/message/fusion/lsi/mpi_log_sas.h b/drivers/message/fusion/lsi/mpi_log_sas.h
index 691620d..c8765c9 100644
--- a/drivers/message/fusion/lsi/mpi_log_sas.h
+++ b/drivers/message/fusion/lsi/mpi_log_sas.h
@@ -56,9 +56,9 @@
 #define IOP_LOGINFO_CODE_FWUPLOAD_NO_FLASH_AVAILABLE         (0x0003E000) /* Tried to upload from flash, but there is none */
 #define IOP_LOGINFO_CODE_FWUPLOAD_UNKNOWN_IMAGE_TYPE         (0x0003E001) /* ImageType field contents were invalid */
 #define IOP_LOGINFO_CODE_FWUPLOAD_WRONG_IMAGE_SIZE           (0x0003E002) /* ImageSize field in TCSGE was bad/offset in MfgPg 4 was wrong */
-#define IOP_LOGINFO_CODE_FWUPLOAD_ENTIRE_FLASH_UPLOAD_FAILED (0x0003E003) /* Error occured while attempting to upload the entire flash */
-#define IOP_LOGINFO_CODE_FWUPLOAD_REGION_UPLOAD_FAILED       (0x0003E004) /* Error occured while attempting to upload single flash region */
-#define IOP_LOGINFO_CODE_FWUPLOAD_DMA_FAILURE                (0x0003E005) /* Problem occured while DMAing FW to host memory */
+#define IOP_LOGINFO_CODE_FWUPLOAD_ENTIRE_FLASH_UPLOAD_FAILED (0x0003E003) /* Error occurred while attempting to upload the entire flash */
+#define IOP_LOGINFO_CODE_FWUPLOAD_REGION_UPLOAD_FAILED       (0x0003E004) /* Error occurred while attempting to upload single flash region */
+#define IOP_LOGINFO_CODE_FWUPLOAD_DMA_FAILURE                (0x0003E005) /* Problem occurred while DMAing FW to host memory */
 
 #define IOP_LOGINFO_CODE_DIAG_MSG_ERROR                      (0x00040000) /* Error handling diag msg - or'd with diag status */
 
@@ -187,8 +187,8 @@
 #define PL_LOGINFO_SUB_CODE_BREAK_ON_INCOMPLETE_BREAK_RCVD   (0x00005000)
 
 #define PL_LOGINFO_CODE_ENCL_MGMT_SMP_FRAME_FAILURE          (0x00200000) /* Can't get SMP Frame */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_READ_ERROR             (0x00200010) /* Error occured on SMP Read */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_WRITE_ERROR            (0x00200020) /* Error occured on SMP Write */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_READ_ERROR             (0x00200010) /* Error occurred on SMP Read */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_WRITE_ERROR            (0x00200020) /* Error occurred on SMP Write */
 #define PL_LOGINFO_CODE_ENCL_MGMT_NOT_SUPPORTED_ON_ENCL      (0x00200040) /* Encl Mgmt services not available for this WWID */
 #define PL_LOGINFO_CODE_ENCL_MGMT_ADDR_MODE_NOT_SUPPORTED    (0x00200050) /* Address Mode not suppored */
 #define PL_LOGINFO_CODE_ENCL_MGMT_BAD_SLOT_NUM               (0x00200060) /* Invalid Slot Number in SEP Msg */
diff --git a/drivers/message/fusion/lsi/mpi_raid.h b/drivers/message/fusion/lsi/mpi_raid.h
index add60cc..0f2c8b4 100644
--- a/drivers/message/fusion/lsi/mpi_raid.h
+++ b/drivers/message/fusion/lsi/mpi_raid.h
@@ -217,7 +217,7 @@ typedef struct _MSG_SCSI_IO_RAID_PT_REPLY
 
 
 /****************************************************************************/
-/* Mailbox reqeust structure */
+/* Mailbox request structure */
 /****************************************************************************/
 
 typedef struct _MSG_MAILBOX_REQUEST
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index a3856ed..f79d5a2 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2398,7 +2398,7 @@ done_free_mem:
 	}
 
 	/* mf is null if command issued successfully
-	 * otherwise, failure occured after mf acquired.
+	 * otherwise, failure occurred after mf acquired.
 	 */
 	if (mf)
 		mpt_free_msg_frame(ioc, mf);
diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
index 34749ee..9e9bdda 100644
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -229,7 +229,7 @@ again:
 	bid = blade_id < 0 ? uv_numa_blade_id() : blade_id;
 	bs = gru_base[bid];
 
-	/* Handle the case where migration occured while waiting for the sema */
+	/* Handle the case where migration occurred while waiting for the sema */
 	down_read(&bs->bs_kgts_sema);
 	if (blade_id < 0 && bid != uv_numa_blade_id()) {
 		up_read(&bs->bs_kgts_sema);
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 326447c..3d61b2e 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -105,7 +105,7 @@ int mmc_go_idle(struct mmc_host *host)
 	 * that in case of hardware that won't pull up DAT3/nCS otherwise.
 	 *
 	 * SPI hosts ignore ios.chip_select; it's managed according to
-	 * rules that must accomodate non-MMC slaves which this layer
+	 * rules that must accommodate non-MMC slaves which this layer
 	 * won't even know about.
 	 */
 	if (!mmc_host_is_spi(host)) {
diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index ad9268b..a659ca4 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -1268,12 +1268,12 @@ static int inval_cache_and_wait_for_operation(
 			mutex_lock(&chip->mutex);
 		}
 		if (chip->erase_suspended && chip_state == FL_ERASING)  {
-			/* Erase suspend occured while sleep: reset timeout */
+			/* Erase suspend occurred while sleep: reset timeout */
 			timeo = reset_timeo;
 			chip->erase_suspended = 0;
 		}
 		if (chip->write_suspended && chip_state == FL_WRITING)  {
-			/* Write suspend occured while sleep: reset timeout */
+			/* Write suspend occurred while sleep: reset timeout */
 			timeo = reset_timeo;
 			chip->write_suspended = 0;
 		}
diff --git a/drivers/mtd/lpddr/lpddr_cmds.c b/drivers/mtd/lpddr/lpddr_cmds.c
index 04fdfcc..28bdc1c 100644
--- a/drivers/mtd/lpddr/lpddr_cmds.c
+++ b/drivers/mtd/lpddr/lpddr_cmds.c
@@ -171,7 +171,7 @@ static int wait_for_ready(struct map_info *map, struct flchip *chip,
 			mutex_lock(&chip->mutex);
 		}
 		if (chip->erase_suspended || chip->write_suspended)  {
-			/* Suspend has occured while sleep: reset timeout */
+			/* Suspend has occurred while sleep: reset timeout */
 			timeo = reset_timeo;
 			chip->erase_suspended = chip->write_suspended = 0;
 		}
diff --git a/drivers/mtd/maps/ceiva.c b/drivers/mtd/maps/ceiva.c
index c09f4f5..7e643c8 100644
--- a/drivers/mtd/maps/ceiva.c
+++ b/drivers/mtd/maps/ceiva.c
@@ -42,7 +42,7 @@
  *
  * Please note:
  *  1. The flash size given should be the largest flash size that can
- *     be accomodated.
+ *     be accommodated.
  *
  *  2. The bus width must defined in clps_setup_flash.
  *
diff --git a/drivers/mtd/maps/pmcmsp-flash.c b/drivers/mtd/maps/pmcmsp-flash.c
index acb13fa..64aea6a 100644
--- a/drivers/mtd/maps/pmcmsp-flash.c
+++ b/drivers/mtd/maps/pmcmsp-flash.c
@@ -3,7 +3,7 @@
  * Config with both CFI and JEDEC device support.
  *
  * Basically physmap.c with the addition of partitions and
- * an array of mapping info to accomodate more than one flash type per board.
+ * an array of mapping info to accommodate more than one flash type per board.
  *
  * Copyright 2005-2007 PMC-Sierra, Inc.
  *
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 4759d82..5502b2a 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -234,7 +234,7 @@ static ssize_t mtd_read(struct file *file, char __user *buf, size_t count,loff_t
 		 * the data. For our userspace tools it is important
 		 * to dump areas with ecc errors !
 		 * For kernel internal usage it also might return -EUCLEAN
-		 * to signal the caller that a bitflip has occured and has
+		 * to signal the caller that a bitflip has occurred and has
 		 * been corrected by the ECC algorithm.
 		 * Userspace software which accesses NAND this way
 		 * must be aware of the fact that it deals with NAND
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index b7f8de7..39cd047 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -137,7 +137,7 @@ static struct rs_control *rs_decoder;
  *
  * Fabrice Bellard figured this out in the old docecc code. I added
  * some comments, improved a minor bit and converted it to make use
- * of the generic Reed-Solomon libary. tglx
+ * of the generic Reed-Solomon library. tglx
  */
 static int doc_ecc_decode(struct rs_control *rs, uint8_t *data, uint8_t *ecc)
 {
@@ -986,7 +986,7 @@ static int doc200x_correct_data(struct mtd_info *mtd, u_char *dat,
 		dummy = ReadDOC(docptr, ECCConf);
 	}
 
-	/* Error occured ? */
+	/* Error occurred ? */
 	if (dummy & 0x80) {
 		for (i = 0; i < 6; i++) {
 			if (DoC_is_MillenniumPlus(doc))
diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index 546c2f0..81bbb5e 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -78,7 +78,7 @@ static void start_translation(struct sh_flctl *flctl)
 
 static void timeout_error(struct sh_flctl *flctl, const char *str)
 {
-	dev_err(&flctl->pdev->dev, "Timeout occured in %s\n", str);
+	dev_err(&flctl->pdev->dev, "Timeout occurred in %s\n", str);
 }
 
 static void wait_completion(struct sh_flctl *flctl)
diff --git a/drivers/net/atl1c/atl1c_hw.c b/drivers/net/atl1c/atl1c_hw.c
index 1bf6720..fc3cbb0 100644
--- a/drivers/net/atl1c/atl1c_hw.c
+++ b/drivers/net/atl1c/atl1c_hw.c
@@ -56,7 +56,7 @@ void atl1c_hw_set_mac_addr(struct atl1c_hw *hw)
 		(((u32)hw->mac_addr[4]) << 8)  |
 		(((u32)hw->mac_addr[5])) ;
 	AT_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 0, value);
-	/* hight dword */
+	/* high dword */
 	value = (((u32)hw->mac_addr[0]) << 8) |
 		(((u32)hw->mac_addr[1])) ;
 	AT_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 1, value);
diff --git a/drivers/net/atl1e/atl1e_hw.c b/drivers/net/atl1e/atl1e_hw.c
index 76cc043..d9ae31f 100644
--- a/drivers/net/atl1e/atl1e_hw.c
+++ b/drivers/net/atl1e/atl1e_hw.c
@@ -55,7 +55,7 @@ void atl1e_hw_set_mac_addr(struct atl1e_hw *hw)
 		(((u32)hw->mac_addr[4]) << 8)  |
 		(((u32)hw->mac_addr[5])) ;
 	AT_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 0, value);
-	/* hight dword */
+	/* high dword */
 	value = (((u32)hw->mac_addr[0]) << 8) |
 		(((u32)hw->mac_addr[1])) ;
 	AT_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 1, value);
diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
index 35b14be..53fcf89 100644
--- a/drivers/net/atlx/atl2.c
+++ b/drivers/net/atlx/atl2.c
@@ -2751,7 +2751,7 @@ static void atl2_set_mac_addr(struct atl2_hw *hw)
 		(((u32)hw->mac_addr[4]) << 8)  |
 		(((u32)hw->mac_addr[5]));
 	ATL2_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 0, value);
-	/* hight dword */
+	/* high dword */
 	value = (((u32)hw->mac_addr[0]) << 8) |
 		(((u32)hw->mac_addr[1]));
 	ATL2_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 1, value);
diff --git a/drivers/net/bnx2x/bnx2x_reg.h b/drivers/net/bnx2x/bnx2x_reg.h
index 1cefe48..245220a 100644
--- a/drivers/net/bnx2x/bnx2x_reg.h
+++ b/drivers/net/bnx2x/bnx2x_reg.h
@@ -1604,7 +1604,7 @@
    (~misc_registers_sw_timer_cfg_4.sw_timer_cfg_4[1] ) is set */
 #define MISC_REG_SW_TIMER_RELOAD_VAL_4				 0xa2fc
 /* [RW 32] the value of the counter for sw timers1-8. there are 8 addresses
-   in this register. addres 0 - timer 1; address 1 - timer 2, ...  address 7 -
+   in this register. address 0 - timer 1; address 1 - timer 2, ...  address 7 -
    timer 8 */
 #define MISC_REG_SW_TIMER_VAL					 0xa5c0
 /* [RW 1] Set by the MCP to remember if one or more of the drivers is/are
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 881914b..30f368d 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -840,7 +840,7 @@ static int ad_lacpdu_send(struct port *port)
 	lacpdu_header = (struct lacpdu_header *)skb_put(skb, length);
 
 	memcpy(lacpdu_header->hdr.h_dest, lacpdu_mcast_addr, ETH_ALEN);
-	/* Note: source addres is set to be the member's PERMANENT address,
+	/* Note: source address is set to be the member's PERMANENT address,
 	   because we use it to identify loopback lacpdus in receive. */
 	memcpy(lacpdu_header->hdr.h_source, slave->perm_hwaddr, ETH_ALEN);
 	lacpdu_header->hdr.h_proto = PKT_TYPE_LACPDU;
@@ -881,7 +881,7 @@ static int ad_marker_send(struct port *port, struct bond_marker *marker)
 	marker_header = (struct bond_marker_header *)skb_put(skb, length);
 
 	memcpy(marker_header->hdr.h_dest, lacpdu_mcast_addr, ETH_ALEN);
-	/* Note: source addres is set to be the member's PERMANENT address,
+	/* Note: source address is set to be the member's PERMANENT address,
 	   because we use it to identify loopback MARKERs in receive. */
 	memcpy(marker_header->hdr.h_source, slave->perm_hwaddr, ETH_ALEN);
 	marker_header->hdr.h_proto = PKT_TYPE_LACPDU;
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 26bb118..f7dce08 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -671,7 +671,7 @@ static struct slave *rlb_choose_channel(struct sk_buff *skb, struct bonding *bon
 	if (assigned_slave) {
 		client_info->ip_src = arp->ip_src;
 		client_info->ip_dst = arp->ip_dst;
-		/* arp->mac_dst is broadcast for arp reqeusts.
+		/* arp->mac_dst is broadcast for arp requests.
 		 * will be updated with clients actual unicast mac address
 		 * upon receiving an arp reply.
 		 */
diff --git a/drivers/net/caif/caif_shmcore.c b/drivers/net/caif/caif_shmcore.c
index 8051116..731aa11 100644
--- a/drivers/net/caif/caif_shmcore.c
+++ b/drivers/net/caif/caif_shmcore.c
@@ -591,7 +591,7 @@ int caif_shmcore_probe(struct shmdev_layer *pshm_dev)
 			(NR_TX_BUF * TX_BUF_SZ + NR_RX_BUF * RX_BUF_SZ)) {
 
 		pr_warn("ERROR, Amount of available"
-				" Phys. SHM cannot accomodate current SHM "
+				" Phys. SHM cannot accommodate current SHM "
 				"driver configuration, Bailing out ...\n");
 		free_netdev(pshm_dev->pshm_netdev);
 		return -ENOMEM;
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 0a8de01..a358ea9 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -425,7 +425,7 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 			cf->data[3] = ecc & ECC_SEG;
 			break;
 		}
-		/* Error occured during transmission? */
+		/* Error occurred during transmission? */
 		if ((ecc & ECC_DIR) == 0)
 			cf->data[2] |= CAN_ERR_PROT_TX;
 	}
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index e75f1a8..a72c7bf 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -386,7 +386,7 @@ static void ems_usb_rx_err(struct ems_usb *dev, struct ems_cpc_msg *msg)
 			break;
 		}
 
-		/* Error occured during transmission? */
+		/* Error occurred during transmission? */
 		if ((ecc & SJA1000_ECC_DIR) == 0)
 			cf->data[2] |= CAN_ERR_PROT_TX;
 
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 05a5275..b7f155f 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -284,7 +284,7 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 				break;
 			}
 
-			/* Error occured during transmission? */
+			/* Error occurred during transmission? */
 			if (!(ecc & SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index d6b6d6a..9314ace 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -5149,7 +5149,7 @@ err_out_free_res:
 	pci_release_regions(pdev);
 
 err_write_cacheline:
-	/* Try to restore it in case the error occured after we
+	/* Try to restore it in case the error occurred after we
 	 * set it.
 	 */
 	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, orig_cacheline_size);
diff --git a/drivers/net/chelsio/subr.c b/drivers/net/chelsio/subr.c
index 63ebf76..8a43c7e 100644
--- a/drivers/net/chelsio/subr.c
+++ b/drivers/net/chelsio/subr.c
@@ -556,7 +556,7 @@ struct chelsio_vpd_t {
 #define EEPROM_MAX_POLL   4
 
 /*
- * Read SEEPROM. A zero is written to the flag register when the addres is
+ * Read SEEPROM. A zero is written to the flag register when the address is
  * written to the Control register. The hardware device will set the flag to a
  * one when 4B have been transferred to the Data register.
  */
diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 3a6adf0..9029a3b 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -607,7 +607,7 @@ struct t3_vpd {
  *
  *	Read a 32-bit word from a location in VPD EEPROM using the card's PCI
  *	VPD ROM capability.  A zero is written to the flag bit when the
- *	addres is written to the control register.  The hardware device will
+ *	address is written to the control register.  The hardware device will
  *	set the flag to 1 when 4 bytes have been read into the data register.
  */
 int t3_seeprom_read(struct adapter *adapter, u32 addr, __le32 *data)
@@ -1390,7 +1390,7 @@ struct intr_info {
  *
  *	A table driven interrupt handler that applies a set of masks to an
  *	interrupt status word and performs the corresponding actions if the
- *	interrupts described by the mask have occured.  The actions include
+ *	interrupts described by the mask have occurred.  The actions include
  *	optionally printing a warning or alert message, and optionally
  *	incrementing a stat counter.  The table is terminated by an entry
  *	specifying mask 0.  Returns the number of fatal interrupt conditions.
@@ -2783,7 +2783,7 @@ static void init_mtus(unsigned short mtus[])
 {
 	/*
 	 * See draft-mathis-plpmtud-00.txt for the values.  The min is 88 so
-	 * it can accomodate max size TCP/IP headers when SACK and timestamps
+	 * it can accommodate max size TCP/IP headers when SACK and timestamps
 	 * are enabled and still have at least 8 bytes of payload.
 	 */
 	mtus[0] = 88;
diff --git a/drivers/net/cxgb4/t4_hw.c b/drivers/net/cxgb4/t4_hw.c
index e97521c..86ea677 100644
--- a/drivers/net/cxgb4/t4_hw.c
+++ b/drivers/net/cxgb4/t4_hw.c
@@ -884,7 +884,7 @@ struct intr_info {
  *
  *	A table driven interrupt handler that applies a set of masks to an
  *	interrupt status word and performs the corresponding actions if the
- *	interrupts described by the mask have occured.  The actions include
+ *	interrupts described by the mask have occurred.  The actions include
  *	optionally emitting a warning or alert message.  The table is terminated
  *	by an entry specifying mask 0.  Returns the number of fatal interrupt
  *	conditions.
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index c4ca162..518092c 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4848,7 +4848,7 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 	if (skb->protocol == htons(ETH_P_IP))
 		tx_flags |= E1000_TX_FLAGS_IPV4;
 
-	/* if count is 0 then mapping error has occured */
+	/* if count is 0 then mapping error has occurred */
 	count = e1000_tx_map(adapter, skb, first, max_per_txd, nr_frags, mss);
 	if (count) {
 		e1000_tx_queue(adapter, tx_flags, count);
diff --git a/drivers/net/ibm_newemac/tah.c b/drivers/net/ibm_newemac/tah.c
index 299aa49..02b1d7c 100644
--- a/drivers/net/ibm_newemac/tah.c
+++ b/drivers/net/ibm_newemac/tah.c
@@ -60,7 +60,7 @@ void tah_reset(struct platform_device *ofdev)
 		printk(KERN_ERR "%s: reset timeout\n",
 			ofdev->dev.of_node->full_name);
 
-	/* 10KB TAH TX FIFO accomodates the max MTU of 9000 */
+	/* 10KB TAH TX FIFO accommodates the max MTU of 9000 */
 	out_be32(&p->mr,
 		 TAH_MR_CVR | TAH_MR_ST_768 | TAH_MR_TFS_10KB | TAH_MR_DTFP |
 		 TAH_MR_DIG);
diff --git a/drivers/net/igb/e1000_phy.c b/drivers/net/igb/e1000_phy.c
index ddd036a..405dec1 100644
--- a/drivers/net/igb/e1000_phy.c
+++ b/drivers/net/igb/e1000_phy.c
@@ -1421,7 +1421,7 @@ out:
 }
 
 /**
- *  igb_check_downshift - Checks whether a downshift in speed occured
+ *  igb_check_downshift - Checks whether a downshift in speed occurred
  *  @hw: pointer to the HW structure
  *
  *  Success returns 0, Failure returns 1
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 892d196..3373687 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -4153,7 +4153,7 @@ netdev_tx_t igb_xmit_frame_ring_adv(struct sk_buff *skb,
 
 	/*
 	 * count reflects descriptors mapped, if 0 or less then mapping error
-	 * has occured and we need to rewind the descriptor queue
+	 * has occurred and we need to rewind the descriptor queue
 	 */
 	count = igb_tx_map_adv(tx_ring, skb, first);
 	if (!count) {
diff --git a/drivers/net/igbvf/netdev.c b/drivers/net/igbvf/netdev.c
index 28af019..998ab29 100644
--- a/drivers/net/igbvf/netdev.c
+++ b/drivers/net/igbvf/netdev.c
@@ -2284,7 +2284,7 @@ static netdev_tx_t igbvf_xmit_frame_ring_adv(struct sk_buff *skb,
 
 	/*
 	 * count reflects descriptors mapped, if 0 then mapping error
-	 * has occured and we need to rewind the descriptor queue
+	 * has occurred and we need to rewind the descriptor queue
 	 */
 	count = igbvf_tx_map_adv(adapter, tx_ring, skb, first);
 
diff --git a/drivers/net/ipg.c b/drivers/net/ipg.c
index aa93655..650e843 100644
--- a/drivers/net/ipg.c
+++ b/drivers/net/ipg.c
@@ -493,7 +493,7 @@ static int ipg_config_autoneg(struct net_device *dev)
 	txflowcontrol = 0;
 	rxflowcontrol = 0;
 
-	/* To accomodate a problem in 10Mbps operation,
+	/* To accommodate a problem in 10Mbps operation,
 	 * set a global flag if PHY running in 10Mbps mode.
 	 */
 	sp->tenmbpsmode = 0;
@@ -1141,13 +1141,13 @@ static int ipg_nic_rx_check_error(struct net_device *dev)
 
 		/* Increment detailed receive error statistics. */
 		if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXFIFOOVERRUN) {
-			IPG_DEBUG_MSG("RX FIFO overrun occured.\n");
+			IPG_DEBUG_MSG("RX FIFO overrun occurred.\n");
 
 			sp->stats.rx_fifo_errors++;
 		}
 
 		if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXRUNTFRAME) {
-			IPG_DEBUG_MSG("RX runt occured.\n");
+			IPG_DEBUG_MSG("RX runt occurred.\n");
 			sp->stats.rx_length_errors++;
 		}
 
@@ -1156,7 +1156,7 @@ static int ipg_nic_rx_check_error(struct net_device *dev)
 		 */
 
 		if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXALIGNMENTERROR) {
-			IPG_DEBUG_MSG("RX alignment error occured.\n");
+			IPG_DEBUG_MSG("RX alignment error occurred.\n");
 			sp->stats.rx_frame_errors++;
 		}
 
@@ -1421,12 +1421,12 @@ static int ipg_nic_rx(struct net_device *dev)
 
 			/* Increment detailed receive error statistics. */
 			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXFIFOOVERRUN) {
-				IPG_DEBUG_MSG("RX FIFO overrun occured.\n");
+				IPG_DEBUG_MSG("RX FIFO overrun occurred.\n");
 				sp->stats.rx_fifo_errors++;
 			}
 
 			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXRUNTFRAME) {
-				IPG_DEBUG_MSG("RX runt occured.\n");
+				IPG_DEBUG_MSG("RX runt occurred.\n");
 				sp->stats.rx_length_errors++;
 			}
 
@@ -1436,7 +1436,7 @@ static int ipg_nic_rx(struct net_device *dev)
 			 */
 
 			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXALIGNMENTERROR) {
-				IPG_DEBUG_MSG("RX alignment error occured.\n");
+				IPG_DEBUG_MSG("RX alignment error occurred.\n");
 				sp->stats.rx_frame_errors++;
 			}
 
@@ -1460,7 +1460,7 @@ static int ipg_nic_rx(struct net_device *dev)
 			}
 		} else {
 
-			/* Adjust the new buffer length to accomodate the size
+			/* Adjust the new buffer length to accommodate the size
 			 * of the received frame.
 			 */
 			skb_put(skb, framelen);
@@ -1886,7 +1886,7 @@ static netdev_tx_t ipg_nic_hard_start_xmit(struct sk_buff *skb,
 	/* Request TxComplete interrupts at an interval defined
 	 * by the constant IPG_FRAMESBETWEENTXCOMPLETES.
 	 * Request TxComplete interrupt for every frame
-	 * if in 10Mbps mode to accomodate problem with 10Mbps
+	 * if in 10Mbps mode to accommodate problem with 10Mbps
 	 * processing.
 	 */
 	if (sp->tenmbpsmode)
@@ -2100,7 +2100,7 @@ static int ipg_nic_change_mtu(struct net_device *dev, int new_mtu)
 	struct ipg_nic_private *sp = netdev_priv(dev);
 	int err;
 
-	/* Function to accomodate changes to Maximum Transfer Unit
+	/* Function to accommodate changes to Maximum Transfer Unit
 	 * (or MTU) of IPG NIC. Cannot use default function since
 	 * the default will not allow for MTU > 1500 bytes.
 	 */
diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
index c192c31..b8135e6 100644
--- a/drivers/net/irda/pxaficp_ir.c
+++ b/drivers/net/irda/pxaficp_ir.c
@@ -483,7 +483,7 @@ static irqreturn_t pxa_irda_fir_irq(int irq, void *dev_id)
 	}
 
 	if (icsr0 & ICSR0_EIF) {
-		/* An error in FIFO occured, or there is a end of frame */
+		/* An error in FIFO occurred, or there is a end of frame */
 		pxa_irda_fir_irq_eif(si, dev, icsr0);
 	}
 
diff --git a/drivers/net/irda/via-ircc.c b/drivers/net/irda/via-ircc.c
index 67c0ad4..272b7f5 100644
--- a/drivers/net/irda/via-ircc.c
+++ b/drivers/net/irda/via-ircc.c
@@ -246,7 +246,7 @@ static int __devinit via_init_one (struct pci_dev *pcidev, const struct pci_devi
 			FirIRQ = bTmp1 & 0x0f;
 
 			pci_read_config_byte(pcidev,0x69,&bTmp);
-			FirIOBase = bTmp << 8;//hight byte
+			FirIOBase = bTmp << 8;//high byte
 			pci_read_config_byte(pcidev,0x68,&bTmp);
 			FirIOBase = (FirIOBase | bTmp ) & 0xfff0;
   //-------------------------
diff --git a/drivers/net/ixgbe/ixgbe_phy.c b/drivers/net/ixgbe/ixgbe_phy.c
index 6c0d42e..e413374 100644
--- a/drivers/net/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ixgbe/ixgbe_phy.c
@@ -1378,7 +1378,7 @@ s32 ixgbe_get_phy_firmware_version_tnx(struct ixgbe_hw *hw,
 }
 
 /**
- *  ixgbe_tn_check_overtemp - Checks if an overtemp occured.
+ *  ixgbe_tn_check_overtemp - Checks if an overtemp occurred.
  *  @hw: pointer to hardware structure
  *
  *  Checks if the LASI temp alarm status was triggered due to overtemp
diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index 9f8e702..661ed1f 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -238,7 +238,7 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		goto out;
 	}
 	/* allocate the tx and rx ring buffer descriptors. */
-	/* returns a virtual addres and a physical address. */
+	/* returns a virtual address and a physical address. */
 	lp->tx_bd_v = dma_alloc_coherent(ndev->dev.parent,
 					 sizeof(*lp->tx_bd_v) * TX_BD_NUM,
 					 &lp->tx_bd_p, GFP_KERNEL);
diff --git a/drivers/net/mlx4/en_rx.c b/drivers/net/mlx4/en_rx.c
index 570f250..44f84e6 100644
--- a/drivers/net/mlx4/en_rx.c
+++ b/drivers/net/mlx4/en_rx.c
@@ -706,8 +706,8 @@ int mlx4_en_poll_rx_cq(struct napi_struct *napi, int budget)
 }
 
 
-/* Calculate the last offset position that accomodates a full fragment
- * (assuming fagment size = stride-align) */
+/* Calculate the last offset position that accommodates a full fragment
+ * (assuming fragment size = stride-align) */
 static int mlx4_en_last_alloc_offset(struct mlx4_en_priv *priv, u16 stride, u16 align)
 {
 	u16 res = MLX4_EN_ALLOC_SIZE % stride;
diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
index 78d70a6..e647b6a 100644
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -545,7 +545,7 @@ ppp_async_encode(struct asyncppp *ap)
 	proto = (data[0] << 8) + data[1];
 
 	/*
-	 * LCP packets with code values between 1 (configure-reqest)
+	 * LCP packets with code values between 1 (configure-request)
 	 * and 7 (code-reject) must be sent as though no options
 	 * had been negotiated.
 	 */
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index ecc25aa..265ae6d 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -3563,7 +3563,7 @@ static void s2io_reset(struct s2io_nic *sp)
 	}
 
 	/*
-	 * Clear spurious ECC interrupts that would have occured on
+	 * Clear spurious ECC interrupts that would have occurred on
 	 * XFRAME II cards after reset.
 	 */
 	if (sp->device_type == XFRAME_II_DEVICE) {
diff --git a/drivers/net/skge.h b/drivers/net/skge.h
index 507addc..51c0214 100644
--- a/drivers/net/skge.h
+++ b/drivers/net/skge.h
@@ -1038,7 +1038,7 @@ enum {
 
 	PHY_ST_PRE_SUP	= 1<<6, /* Bit  6:	Preamble Suppression */
 	PHY_ST_AN_OVER	= 1<<5, /* Bit  5:	Auto-Negotiation Over */
-	PHY_ST_REM_FLT	= 1<<4, /* Bit  4:	Remote Fault Condition Occured */
+	PHY_ST_REM_FLT	= 1<<4, /* Bit  4:	Remote Fault Condition Occurred */
 	PHY_ST_AN_CAP	= 1<<3, /* Bit  3:	Auto-Negotiation Capability */
 	PHY_ST_LSYNC	= 1<<2, /* Bit  2:	Link Synchronized */
 	PHY_ST_JAB_DET	= 1<<1, /* Bit  1:	Jabber Detected */
@@ -1721,8 +1721,8 @@ enum {
 	GM_GPSR_LINK_UP		= 1<<12, /* Bit 12:	Link Up Status */
 	GM_GPSR_PAUSE		= 1<<11, /* Bit 11:	Pause State */
 	GM_GPSR_TX_ACTIVE	= 1<<10, /* Bit 10:	Tx in Progress */
-	GM_GPSR_EXC_COL		= 1<<9,	/* Bit  9:	Excessive Collisions Occured */
-	GM_GPSR_LAT_COL		= 1<<8,	/* Bit  8:	Late Collisions Occured */
+	GM_GPSR_EXC_COL		= 1<<9,	/* Bit  9:	Excessive Collisions Occurred */
+	GM_GPSR_LAT_COL		= 1<<8,	/* Bit  8:	Late Collisions Occurred */
 
 	GM_GPSR_PHY_ST_CH	= 1<<5,	/* Bit  5:	PHY Status Change */
 	GM_GPSR_GIG_SPEED	= 1<<4,	/* Bit  4:	Gigabit Speed (1 = 1000 Mbps) */
@@ -2227,7 +2227,7 @@ enum {
 	XM_ST_BC	= 1<<7,		/* Bit  7:	Broadcast packet */
 	XM_ST_MC	= 1<<6,		/* Bit  6:	Multicast packet */
 	XM_ST_UC	= 1<<5,		/* Bit  5:	Unicast packet */
-	XM_ST_TX_UR	= 1<<4,		/* Bit  4:	FIFO Underrun occured */
+	XM_ST_TX_UR	= 1<<4,		/* Bit  4:	FIFO Underrun occurred */
 	XM_ST_CS_ERR	= 1<<3,		/* Bit  3:	Carrier Sense Error */
 	XM_ST_LAT_COL	= 1<<2,		/* Bit  2:	Late Collision Error */
 	XM_ST_MUL_COL	= 1<<1,		/* Bit  1:	Multiple Collisions */
diff --git a/drivers/net/sky2.h b/drivers/net/sky2.h
index 61891a6..3a63034 100644
--- a/drivers/net/sky2.h
+++ b/drivers/net/sky2.h
@@ -1194,7 +1194,7 @@ enum {
 
 	PHY_ST_PRE_SUP	= 1<<6, /* Bit  6:	Preamble Suppression */
 	PHY_ST_AN_OVER	= 1<<5, /* Bit  5:	Auto-Negotiation Over */
-	PHY_ST_REM_FLT	= 1<<4, /* Bit  4:	Remote Fault Condition Occured */
+	PHY_ST_REM_FLT	= 1<<4, /* Bit  4:	Remote Fault Condition Occurred */
 	PHY_ST_AN_CAP	= 1<<3, /* Bit  3:	Auto-Negotiation Capability */
 	PHY_ST_LSYNC	= 1<<2, /* Bit  2:	Link Synchronized */
 	PHY_ST_JAB_DET	= 1<<1, /* Bit  1:	Jabber Detected */
@@ -1725,8 +1725,8 @@ enum {
 	GM_GPSR_LINK_UP		= 1<<12, /* Bit 12:	Link Up Status */
 	GM_GPSR_PAUSE		= 1<<11, /* Bit 11:	Pause State */
 	GM_GPSR_TX_ACTIVE	= 1<<10, /* Bit 10:	Tx in Progress */
-	GM_GPSR_EXC_COL		= 1<<9,	/* Bit  9:	Excessive Collisions Occured */
-	GM_GPSR_LAT_COL		= 1<<8,	/* Bit  8:	Late Collisions Occured */
+	GM_GPSR_EXC_COL		= 1<<9,	/* Bit  9:	Excessive Collisions Occurred */
+	GM_GPSR_LAT_COL		= 1<<8,	/* Bit  8:	Late Collisions Occurred */
 
 	GM_GPSR_PHY_ST_CH	= 1<<5,	/* Bit  5:	PHY Status Change */
 	GM_GPSR_GIG_SPEED	= 1<<4,	/* Bit  4:	Gigabit Speed (1 = 1000 Mbps) */
diff --git a/drivers/net/smsc911x.c b/drivers/net/smsc911x.c
index 64bfdae..d3150d9 100644
--- a/drivers/net/smsc911x.c
+++ b/drivers/net/smsc911x.c
@@ -1664,7 +1664,7 @@ static int smsc911x_eeprom_send_cmd(struct smsc911x_data *pdata, u32 op)
 	}
 
 	if (e2cmd & E2P_CMD_EPC_TIMEOUT_) {
-		SMSC_TRACE(DRV, "Error occured during eeprom operation");
+		SMSC_TRACE(DRV, "Error occurred during eeprom operation");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/smsc9420.c b/drivers/net/smsc9420.c
index b09ee1c..4c92ad8 100644
--- a/drivers/net/smsc9420.c
+++ b/drivers/net/smsc9420.c
@@ -364,7 +364,7 @@ static int smsc9420_eeprom_send_cmd(struct smsc9420_pdata *pd, u32 op)
 	}
 
 	if (e2cmd & E2P_CMD_EPC_TIMEOUT_) {
-		smsc_info(HW, "Error occured during eeprom operation");
+		smsc_info(HW, "Error occurred during eeprom operation");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/tc35815.c b/drivers/net/tc35815.c
index b6eec8c..d3fc827 100644
--- a/drivers/net/tc35815.c
+++ b/drivers/net/tc35815.c
@@ -339,7 +339,7 @@ struct BDesc {
 #define TX_THRESHOLD	1024
 /* used threshold with packet max byte for low pci transfer ability.*/
 #define TX_THRESHOLD_MAX 1536
-/* setting threshold max value when overrun error occured this count. */
+/* setting threshold max value when overrun error occurred this count. */
 #define TX_THRESHOLD_KEEP_LIMIT 10
 
 /* 16 + RX_BUF_NUM * 8 + RX_FD_NUM * 16 + TX_FD_NUM * 32 <= PAGE_SIZE*FD_PAGE_NUM */
diff --git a/drivers/net/tsi108_eth.h b/drivers/net/tsi108_eth.h
index 5a77ae6..5fee7d7 100644
--- a/drivers/net/tsi108_eth.h
+++ b/drivers/net/tsi108_eth.h
@@ -305,9 +305,9 @@
 #define TSI108_TX_CRC	(1 << 5)	/* Generate CRC for this packet */
 #define TSI108_TX_INT	(1 << 14)	/* Generate an IRQ after frag. processed */
 #define TSI108_TX_RETRY	(0xf << 16)	/* 4 bit field indicating num. of retries */
-#define TSI108_TX_COL	(1 << 20)	/* Set if a collision occured */
-#define TSI108_TX_LCOL	(1 << 24)	/* Set if a late collision occured */
-#define TSI108_TX_UNDER	(1 << 25)	/* Set if a FIFO underrun occured */
+#define TSI108_TX_COL	(1 << 20)	/* Set if a collision occurred */
+#define TSI108_TX_LCOL	(1 << 24)	/* Set if a late collision occurred */
+#define TSI108_TX_UNDER	(1 << 25)	/* Set if a FIFO underrun occurred */
 #define TSI108_TX_RLIM	(1 << 26)	/* Set if the retry limit was reached */
 #define TSI108_TX_OK	(1 << 30)	/* Set if the frame TX was successful */
 #define TSI108_TX_OWN	(1 << 31)	/* Set if the device owns the descriptor */
@@ -332,7 +332,7 @@ typedef struct {
 #define TSI108_RX_RUNT	(1 << 4)/* Packet is less than minimum size */
 #define TSI108_RX_HASH	(1 << 7)/* Hash table match */
 #define TSI108_RX_BAD	(1 << 8)	/* Bad frame */
-#define TSI108_RX_OVER	(1 << 9)	/* FIFO overrun occured */
+#define TSI108_RX_OVER	(1 << 9)	/* FIFO overrun occurred */
 #define TSI108_RX_TRUNC	(1 << 11)	/* Packet truncated due to excess length */
 #define TSI108_RX_CRC	(1 << 12)	/* Packet had a CRC error */
 #define TSI108_RX_INT	(1 << 13)	/* Generate an IRQ after frag. processed */
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 55f3a3e..e625f95 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1309,7 +1309,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	case SIOCGIFHWADDR:
-		/* Get hw addres */
+		/* Get hw address */
 		memcpy(ifr.ifr_hwaddr.sa_data, tun->dev->dev_addr, ETH_ALEN);
 		ifr.ifr_hwaddr.sa_family = tun->dev->type;
 		if (copy_to_user(argp, &ifr, ifreq_len))
diff --git a/drivers/net/via-rhine.c b/drivers/net/via-rhine.c
index 4930f9d..ea814f5 100644
--- a/drivers/net/via-rhine.c
+++ b/drivers/net/via-rhine.c
@@ -1583,7 +1583,7 @@ static void rhine_restart_tx(struct net_device *dev) {
 	u32 intr_status;
 
 	/*
-	 * If new errors occured, we need to sort them out before doing Tx.
+	 * If new errors occurred, we need to sort them out before doing Tx.
 	 * In that case the ISR will be back here RSN anyway.
 	 */
 	intr_status = get_intr_status(dev);
@@ -1604,7 +1604,7 @@ static void rhine_restart_tx(struct net_device *dev) {
 		/* This should never happen */
 		if (debug > 1)
 			printk(KERN_WARNING "%s: rhine_restart_tx() "
-			       "Another error occured %8.8x.\n",
+			       "Another error occurred %8.8x.\n",
 			       dev->name, intr_status);
 	}
 
diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index cab96ad..6676a0d 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -292,7 +292,7 @@ VELOCITY_PARAM(DMA_length, "DMA length");
 /* IP_byte_align[] is used for IP header DWORD byte aligned
    0: indicate the IP header won't be DWORD byte aligned.(Default) .
    1: indicate the IP header will be DWORD byte aligned.
-      In some enviroment, the IP header should be DWORD byte aligned,
+      In some environment, the IP header should be DWORD byte aligned,
       or the packet will be droped when we receive it. (eg: IPVS)
 */
 VELOCITY_PARAM(IP_byte_align, "Enable IP header dword aligned");
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 21314e0..c8bce81 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -846,7 +846,7 @@ vmxnet3_prepare_tso(struct sk_buff *skb,
  * Transmits a pkt thru a given tq
  * Returns:
  *    NETDEV_TX_OK:      descriptors are setup successfully
- *    NETDEV_TX_OK:      error occured, the pkt is dropped
+ *    NETDEV_TX_OK:      error occurred, the pkt is dropped
  *    NETDEV_TX_BUSY:    tx ring is full, queue is stopped
  *
  * Side-effects:
diff --git a/drivers/net/vxge/vxge-traffic.h b/drivers/net/vxge/vxge-traffic.h
index 9890d4d..6542958 100644
--- a/drivers/net/vxge/vxge-traffic.h
+++ b/drivers/net/vxge/vxge-traffic.h
@@ -1695,7 +1695,7 @@ struct vxge_hw_device_stats_sw_err {
  * struct vxge_hw_device_stats - Contains HW per-device statistics,
  * including hw.
  * @devh: HW device handle.
- * @dma_addr: DMA addres of the %hw_info. Given to device to fill-in the stats.
+ * @dma_addr: DMA address of the %hw_info. Given to device to fill-in the stats.
  * @hw_info_dmah: DMA handle used to map hw statistics onto the device memory
  *                space.
  * @hw_info_dma_acch: One more DMA handle used subsequently to free the
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index ca79ecd..729f024 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -1125,7 +1125,7 @@
  * Second station id register (Upper 16 bits of MAC address + PCU settings)
  */
 #define AR5K_STA_ID1			0x8004			/* Register Address */
-#define	AR5K_STA_ID1_ADDR_U16		0x0000ffff	/* Upper 16 bits of MAC addres */
+#define	AR5K_STA_ID1_ADDR_U16		0x0000ffff	/* Upper 16 bits of MAC address */
 #define AR5K_STA_ID1_AP			0x00010000	/* Set AP mode */
 #define AR5K_STA_ID1_ADHOC		0x00020000	/* Set Ad-Hoc mode */
 #define AR5K_STA_ID1_PWR_SV		0x00040000	/* Power save reporting */
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 72821c4..b915677 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -635,8 +635,8 @@ struct b43_request_fw_context {
 	char errors[B43_NR_FWTYPES][128];
 	/* Temporary buffer for storing the firmware name. */
 	char fwname[64];
-	/* A fatal error occured while requesting. Firmware reqest
-	 * can not continue, as any other reqest will also fail. */
+	/* A fatal error occurred while requesting. Firmware request
+	 * can not continue, as any other request will also fail. */
 	int fatal_failure;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 7c7f7dc..972b738 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -107,7 +107,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 	/*
 	 * XXX: The MAC address in the command buffer is often changed from
 	 * the original sent to the device. That is, the MAC address
-	 * written to the command buffer often is not the same MAC adress
+	 * written to the command buffer often is not the same MAC address
 	 * read from the command buffer when the command returns. This
 	 * issue has not yet been resolved and this debugging is left to
 	 * observe the problem.
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 373930a..0c81af4 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -125,7 +125,7 @@ static u8 lbs_auth_to_authtype(enum nl80211_auth_type auth_type)
 
 
 /* Various firmware commands need the list of supported rates, but with
-   the hight-bit set for basic rates */
+   the high-bit set for basic rates */
 static int lbs_add_rates(u8 *rates)
 {
 	size_t i;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index d81d85f..069ff74 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -362,7 +362,7 @@ struct txentry_desc {
  *	only be touched after the device has signaled it is done with it.
  * @ENTRY_DATA_PENDING: This entry contains a valid frame and is waiting
  *	for the signal to start sending.
- * @ENTRY_DATA_IO_FAILED: Hardware indicated that an IO error occured
+ * @ENTRY_DATA_IO_FAILED: Hardware indicated that an IO error occurred
  *	while transfering the data to the hardware. No TX status report will
  *	be expected from the hardware.
  */
@@ -618,7 +618,7 @@ static inline int rt2x00queue_threshold(struct data_queue *queue)
 }
 
 /**
- * rt2x00queue_timeout - Check if a timeout occured for STATUS reorts
+ * rt2x00queue_timeout - Check if a timeout occurred for STATUS reorts
  * @queue: Queue to check.
  */
 static inline int rt2x00queue_timeout(struct data_queue *queue)
@@ -628,7 +628,7 @@ static inline int rt2x00queue_timeout(struct data_queue *queue)
 }
 
 /**
- * rt2x00queue_timeout - Check if a timeout occured for DMA transfers
+ * rt2x00queue_timeout - Check if a timeout occurred for DMA transfers
  * @queue: Queue to check.
  */
 static inline int rt2x00queue_dma_timeout(struct data_queue *queue)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index c2d997f..6c19507 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -400,7 +400,7 @@ void rt2x00usb_kill_tx_queue(struct data_queue *queue);
  * @rt2x00dev: Pointer to &struct rt2x00_dev
  *
  * Check the health of the USB communication and determine
- * if timeouts have occured. If this is the case, this function
+ * if timeouts have occurred. If this is the case, this function
  * will reset all communication to restore functionality again.
  */
 void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index 1062b8f..a73ac67 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -213,7 +213,7 @@ pdcspath_store(struct pdcspath_entry *entry)
 
 	/* addr, devpath and count must be word aligned */
 	if (pdc_stable_write(entry->addr, devpath, sizeof(*devpath)) != PDC_OK) {
-		printk(KERN_ERR "%s: an error occured when writing to PDC.\n"
+		printk(KERN_ERR "%s: an error occurred when writing to PDC.\n"
 				"It is likely that the Stable Storage data has been corrupted.\n"
 				"Please check it carefully upon next reboot.\n", __func__);
 		WARN_ON(1);
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 8591f6a..b859d16 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -219,7 +219,7 @@ void pnpbios_print_status(const char *module, u16 status)
 		       module);
 		break;
 	case PNP_HARDWARE_ERROR:
-		printk(KERN_ERR "PnPBIOS: %s: a hardware failure has occured\n",
+		printk(KERN_ERR "PnPBIOS: %s: a hardware failure has occurred\n",
 		       module);
 		break;
 	default:
diff --git a/drivers/ps3/ps3-sys-manager.c b/drivers/ps3/ps3-sys-manager.c
index d37c445..1b98367 100644
--- a/drivers/ps3/ps3-sys-manager.c
+++ b/drivers/ps3/ps3-sys-manager.c
@@ -80,7 +80,7 @@ static void __maybe_unused _dump_sm_header(
  *
  * Currently all messages received from the system manager are either
  * (16 bytes header + 8 bytes payload = 24 bytes) or (16 bytes header
- * + 16 bytes payload = 32 bytes).  This knowlege is used to simplify
+ * + 16 bytes payload = 32 bytes).  This knowledge is used to simplify
  * the logic.
  */
 
diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
index 968c76c..0d6f6a7 100644
--- a/drivers/s390/block/dasd_3990_erp.c
+++ b/drivers/s390/block/dasd_3990_erp.c
@@ -2207,7 +2207,7 @@ dasd_3990_erp_inspect_32(struct dasd_ccw_req * erp, char *sense)
  * DASD_3990_ERP_CONTROL_CHECK
  *
  * DESCRIPTION
- *   Does a generic inspection if a control check occured and sets up
+ *   Does a generic inspection if a control check occurred and sets up
  *   the related error recovery procedure
  *
  * PARAMETER
@@ -2250,7 +2250,7 @@ dasd_3990_erp_inspect(struct dasd_ccw_req *erp)
 	struct dasd_ccw_req *erp_new = NULL;
 	char *sense;
 
-	/* if this problem occured on an alias retry on base */
+	/* if this problem occurred on an alias retry on base */
 	erp_new = dasd_3990_erp_inspect_alias(erp);
 	if (erp_new)
 		return erp_new;
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 911822db..d6add2f 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -1013,7 +1013,7 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
 		}
 	}
 	if (highlight != TAX_RESET)
-		flen += 3;	/* TO_SA to reset hightlight. */
+		flen += 3;	/* TO_SA to reset highlight. */
 	if (f_color != TAC_RESET)
 		flen += 3;	/* TO_SA to reset color. */
 	if (line->len < tp->view.cols)
diff --git a/drivers/s390/cio/device_fsm.c b/drivers/s390/cio/device_fsm.c
index a845695..ee2410d 100644
--- a/drivers/s390/cio/device_fsm.c
+++ b/drivers/s390/cio/device_fsm.c
@@ -318,7 +318,7 @@ ccw_device_sense_id_done(struct ccw_device *cdev, int err)
 
 /**
   * ccw_device_notify() - inform the device's driver about an event
-  * @cdev: device for which an event occured
+  * @cdev: device for which an event occurred
   * @event: event that occurred
   *
   * Returns:
diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index 8e4153d..90a8057 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -773,7 +773,7 @@ claw_irq_handler(struct ccw_device *cdev,
 	case CLAW_START_WRITE:
 		if (p_ch->irb->scsw.cmd.dstat & DEV_STAT_UNIT_CHECK) {
 			dev_info(&cdev->dev,
-				"%s: Unit Check Occured in "
+				"%s: Unit Check Occurred in "
 				"write channel\n", dev->name);
 			clear_bit(0, (void *)&p_ch->IO_active);
 			if (p_ch->irb->ecw[0] & 0x80) {
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index 3343824..040f721 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -61,7 +61,7 @@ static twa_message_type twa_aen_table[] = {
 	{0x0000, "AEN queue empty"},
 	{0x0001, "Controller reset occurred"},
 	{0x0002, "Degraded unit detected"},
-	{0x0003, "Controller error occured"},
+	{0x0003, "Controller error occurred"},
 	{0x0004, "Background rebuild failed"},
 	{0x0005, "Background rebuild done"},
 	{0x0006, "Incomplete unit detected"},
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 3233bf5..dd03631 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -599,7 +599,7 @@ void
 ahd_outw(struct ahd_softc *ahd, u_int port, u_int value)
 {
 	/*
-	 * Write low byte first to accomodate registers
+	 * Write low byte first to accommodate registers
 	 * such as PRGMCNT where the order maters.
 	 */
 	ahd_outb(ahd, port, value & 0xFF);
@@ -6245,7 +6245,7 @@ ahd_shutdown(void *arg)
 /*
  * Reset the controller and record some information about it
  * that is only available just after a reset.  If "reinit" is
- * non-zero, this reset occured after initial configuration
+ * non-zero, this reset occurred after initial configuration
  * and the caller requests that the chip be fully reinitialized
  * to a runable state.  Chip interrupts are *not* enabled after
  * a reinitialization.  The caller must enable interrupts via
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 3f5a542..d22fda5 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -4581,7 +4581,7 @@ ahc_shutdown(void *arg)
 /*
  * Reset the controller and record some information about it
  * that is only available just after a reset.  If "reinit" is
- * non-zero, this reset occured after initial configuration
+ * non-zero, this reset occurred after initial configuration
  * and the caller requests that the chip be fully reinitialized
  * to a runable state.  Chip interrupts are *not* enabled after
  * a reinitialization.  The caller must enable interrupts via
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 8d9dbb3..044a75e 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -172,7 +172,7 @@ void bnx2i_arm_cq_event_coalescing(struct bnx2i_endpoint *ep, u8 action)
 
 /**
  * bnx2i_get_rq_buf - copy RQ buffer contents to driver buffer
- * @conn:		iscsi connection on which RQ event occured
+ * @conn:		iscsi connection on which RQ event occurred
  * @ptr:		driver buffer to which RQ buffer contents is to
  *			be copied
  * @len:		length of valid data inside RQ buf
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 8f1b5c8..204b169 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1774,7 +1774,7 @@ static void dc395x_handle_interrupt(struct AdapterCtlBlk *acb,
 		dc395x_statev(acb, srb, &scsi_status);
 
 		/* 
-		 * if there were any exception occured scsi_status
+		 * if there were any exception occurred scsi_status
 		 * will be modify to bus free phase new scsi_status
 		 * transfer out from ... previous dc395x_statev
 		 */
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index bc17c71..70c45ec 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1720,7 +1720,7 @@ static void fcoe_ctlr_vn_send(struct fcoe_ctlr *fip,
  * fcoe_ctlr_vn_rport_callback - Event handler for rport events.
  * @lport: The lport which is receiving the event
  * @rdata: remote port private data
- * @event: The event that occured
+ * @event: The event that occurred
  *
  * Locking Note:  The rport lock must not be held when calling this function.
  */
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 120a062..d969855 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -895,7 +895,7 @@ typedef struct {
         u8          ldr_no;                 /* log. drive no. */
         u8          rw_attribs;             /* r/w attributes */
         u8          cluster_type;           /* cluster properties */
-        u8          media_changed;          /* Flag:MOUNT/UNMOUNT occured */
+        u8          media_changed;          /* Flag:MOUNT/UNMOUNT occurred */
         u32         start_sec;              /* start sector */
     } hdr[MAX_LDRIVES];                         /* host drives */
     struct {
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 9627d06..b637b55 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -1917,7 +1917,7 @@ static int int_initio_scsi_rst(struct initio_host * host)
 }
 
 /**
- *	int_initio_scsi_resel	-	Reselection occured
+ *	int_initio_scsi_resel	-	Reselection occurred
  *	@host: InitIO host adapter
  *
  *	A SCSI reselection event has been signalled and the interrupt
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 9be63ed..bf8f3d6 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -163,7 +163,7 @@ static int fc_frame_drop(struct fc_lport *lport, struct fc_frame *fp)
  * fc_lport_rport_callback() - Event handler for rport events
  * @lport: The lport which is receiving the event
  * @rdata: private remote port data
- * @event: The event that occured
+ * @event: The event that occurred
  *
  * Locking Note: The rport lock should not be held when calling
  *		 this function.
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 554efa6..1125e13 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6021,7 +6021,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 			return IOCB_ERROR;
 		}
 		wqe->els_req.payload_len = xmit_len;
-		/* Els_reguest64 has a TMO */
+		/* Els_request64 has a TMO */
 		bf_set(wqe_tmo, &wqe->els_req.wqe_com,
 			iocbq->iocb.ulpTimeout);
 		/* Need a VF for word 4 set the vf bit*/
diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index 5ead128..7d40e2b 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -11,7 +11,7 @@
  *
  * FILE		: mega_common.h
  *
- * Libaray of common routine used by all low-level megaraid drivers
+ * Library of common routine used by all low-level megaraid drivers
  */
 
 #ifndef _MEGA_COMMON_H_
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 5708cb2..1febff2 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3973,7 +3973,7 @@ megaraid_sysfs_get_ldmap_timeout(unsigned long data)
  * NOTE: The commands issuance functionality is not generalized and
  * implemented in context of "get ld map" command only. If required, the
  * command issuance logical can be trivially pulled out and implemented as a
- * standalone libary. For now, this should suffice since there is no other
+ * standalone library. For now, this should suffice since there is no other
  * user of this interface.
  *
  * Return 0 on success.
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 1a96a00..e330a12 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2898,7 +2898,7 @@ _scsih_tm_tr_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
  * @smid: system request message index
  *
  * This will check delayed target reset list, and feed the
- * next reqeust.
+ * next request.
  *
  * Return 1 meaning mf should be freed from _base_interrupt
  *        0 means the mf is freed from this function.
@@ -3205,7 +3205,7 @@ _scsih_flush_running_cmds(struct MPT2SAS_ADAPTER *ioc)
 /**
  * _scsih_setup_eedp - setup MPI request for EEDP transfer
  * @scmd: pointer to scsi command object
- * @mpi_request: pointer to the SCSI_IO reqest message frame
+ * @mpi_request: pointer to the SCSI_IO request message frame
  *
  * Supporting protection 1 and 3.
  *
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7f77898..9430c09 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -413,7 +413,7 @@ skip_rio:
 				    "marked OFFLINE!\n");
 				vha->flags.online = 0;
 			} else {
-				/* Check to see if MPI timeout occured */
+				/* Check to see if MPI timeout occurred */
 				if ((mbx & MBX_3) && (ha->flags.port0))
 					set_bit(MPI_RESET_NEEDED,
 					    &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index effd8a1..67e1aed 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -303,7 +303,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			    !test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
 
 				qla_printk(KERN_WARNING, ha,
-				    "Mailbox command timeout occured. "
+				    "Mailbox command timeout occurred. "
 				    "Scheduling ISP " "abort. eeh_busy: 0x%x\n",
 				    ha->flags.eeh_busy);
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
@@ -321,7 +321,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			    !test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
 
 				qla_printk(KERN_WARNING, ha,
-				    "Mailbox command timeout occured. "
+				    "Mailbox command timeout occurred. "
 				    "Issuing ISP abort.\n");
 
 				set_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index ae2acac..96fcf49 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2578,7 +2578,7 @@ qla82xx_calc_dsd_lists(uint16_t dsds)
  * qla82xx_start_scsi() - Send a SCSI command to the ISP
  * @sp: command to send to the ISP
  *
- * Returns non-zero if a failure occured, else zero.
+ * Returns non-zero if a failure occurred, else zero.
  */
 int
 qla82xx_start_scsi(srb_t *sp)
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 998c01b..fcb7358 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -4120,7 +4120,7 @@ fc_bsg_remove(struct request_queue *q)
 		/* drain all requests in the queue */
 		while (1) {
 			/* need the lock to fetch a request
-			 * this may fetch the same reqeust as the previous pass
+			 * this may fetch the same request as the previous pass
 			 */
 			req = blk_fetch_request(q);
 			/* save requests in use and starved */
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 09a5508..c5167eb 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1584,7 +1584,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 		} else if (up->port.iotype == UPIO_DWAPB &&
 			  (iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 			/* The DesignWare APB UART has an Busy Detect (0x07)
-			 * interrupt meaning an LCR write attempt occured while the
+			 * interrupt meaning an LCR write attempt occurred while the
 			 * UART was busy. The interrupt must be cleared by reading
 			 * the UART status register (USR) and the LCR re-written. */
 			unsigned int status;
diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index e95c524..f723167 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -261,7 +261,7 @@ static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
 }
 #endif
 
-/* Reqeust IRQ, Setup clock */
+/* Request IRQ, Setup clock */
 static int sport_startup(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
diff --git a/drivers/serial/max3107.c b/drivers/serial/max3107.c
index 910870e..54a03f0 100644
--- a/drivers/serial/max3107.c
+++ b/drivers/serial/max3107.c
@@ -843,7 +843,7 @@ static int max3107_startup(struct uart_port *port)
 	/* Setup IRQ */
 	if (request_irq(s->spi->irq, max3107_irq, IRQF_TRIGGER_FALLING,
 			"max3107", s)) {
-		dev_err(&s->spi->dev, "IRQ reguest failed\n");
+		dev_err(&s->spi->dev, "IRQ request failed\n");
 		destroy_workqueue(s->workqueue);
 		s->workqueue = NULL;
 		return -EBUSY;
diff --git a/drivers/serial/sn_console.c b/drivers/serial/sn_console.c
index cff9a30..5b65066 100644
--- a/drivers/serial/sn_console.c
+++ b/drivers/serial/sn_console.c
@@ -481,7 +481,7 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
 	while (port->sc_ops->sal_input_pending()) {
 		ch = port->sc_ops->sal_getc();
 		if (ch < 0) {
-			printk(KERN_ERR "sn_console: An error occured while "
+			printk(KERN_ERR "sn_console: An error occurred while "
 			       "obtaining data from the console (0x%0x)\n", ch);
 			break;
 		}
diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index 3f4848e..0a96549 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -1160,7 +1160,7 @@ static unsigned int soc_info(unsigned int *rev_h, unsigned int *rev_l)
 }
 
 /*
- * requst_firmware_nowait() callback function
+ * request_firmware_nowait() callback function
  *
  * This function is called by the kernel when a firmware is made available,
  * or if it times out waiting for the firmware.
diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
index fb3d1b3..755b08e 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/amba-pl022.c
@@ -1420,7 +1420,7 @@ static void do_polling_transfer(struct pl022 *pl022)
 		       SSP_CR1(pl022->virtbase));
 
 		dev_dbg(&pl022->adev->dev, "polling transfer ongoing ...\n");
-		/* FIXME: insert a timeout so we don't hang here indefinately */
+		/* FIXME: insert a timeout so we don't hang here indefinitely */
 		while (pl022->tx < pl022->tx_end || pl022->rx < pl022->rx_end)
 			readwriter(pl022);
 
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index db6d30c..b6e08f8 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -280,7 +280,7 @@ static void FailureCallback(void *pContext, A_STATUS Status)
 {
     GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)pContext; 
     
-        /* target assertion occured */           
+        /* target assertion occurred */           
     NotifyTransportFailure(pProt, Status);  
 }
 
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index a659f70..8c42717 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -522,7 +522,7 @@ dbglog_parse_debug_logs(A_INT8 *datap, A_UINT32 len)
 int
 ar6000_dbglog_get_debug_logs(AR_SOFTC_T *ar)
 {
-    A_UINT32 data[8]; /* Should be able to accomodate struct dbglog_buf_s */
+    A_UINT32 data[8]; /* Should be able to accommodate struct dbglog_buf_s */
     A_UINT32 address;
     A_UINT32 length;
     A_UINT32 dropped;
diff --git a/drivers/staging/bcm/InterfaceIdleMode.c b/drivers/staging/bcm/InterfaceIdleMode.c
index 0750382..3456959 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.c
+++ b/drivers/staging/bcm/InterfaceIdleMode.c
@@ -11,7 +11,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 
 
 Return:				BCM_STATUS_SUCCESS - If Wakeup of the HW Interface was successful.
-						Other           - If an error occured.
+						Other           - If an error occurred.
 */
 
 
@@ -26,7 +26,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 
 
 Return:				BCM_STATUS_SUCCESS - If Idle mode response related HW configuration was successful.
-						Other           - If an error occured.
+						Other           - If an error occurred.
 */
 
 /*
diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index 824f9a4..0667ca1 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -848,7 +848,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 
 Return:					BCM_STATUS_SUCCESS - If Initialization of the
 						HW Interface was successful.
-						Other           - If an error occured.
+						Other           - If an error occurred.
 */
 INT InterfaceInitialize(void)
 {
diff --git a/drivers/staging/bcm/InterfaceIsr.c b/drivers/staging/bcm/InterfaceIsr.c
index f928fe4..acc8d38 100644
--- a/drivers/staging/bcm/InterfaceIsr.c
+++ b/drivers/staging/bcm/InterfaceIsr.c
@@ -78,7 +78,7 @@ static void read_int_callback(struct urb *urb/*, struct pt_regs *regs*/)
 		case -EINPROGRESS:
 		{
 			//This situation may happend when URBunlink is used. for detail check usb_unlink_urb documentation.
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Impossibe condition has occured... something very bad is going on");
+			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Impossibe condition has occurred... something very bad is going on");
 			break ;
 			//return;
 		}
@@ -174,7 +174,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 
 
 Return:				BCM_STATUS_SUCCESS - If configuring the interrupts was successful.
-						Other           - If an error occured.
+						Other           - If an error occurred.
 */
 
 void InterfaceEnableInterrupt(PMINI_ADAPTER Adapter)
@@ -191,7 +191,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 
 
 Return:				BCM_STATUS_SUCCESS - If disabling the interrupts was successful.
-						Other           - If an error occured.
+						Other           - If an error occurred.
 */
 
 void InterfaceDisableInterrupt(PMINI_ADAPTER Adapter)
diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
index 6fee968..afcf103 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -229,7 +229,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 
 
 Return:				TRUE  - If Rx was successful.
-					Other - If an error occured.
+					Other - If an error occurred.
 */
 
 BOOLEAN InterfaceRx (PS_INTERFACE_ADAPTER psIntfAdapter)
diff --git a/drivers/staging/bcm/InterfaceTx.c b/drivers/staging/bcm/InterfaceTx.c
index 771f7b3..80d6ae9 100644
--- a/drivers/staging/bcm/InterfaceTx.c
+++ b/drivers/staging/bcm/InterfaceTx.c
@@ -14,7 +14,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 
 
 Return:				BCM_STATUS_SUCCESS - If Tx was successful.
-						Other           - If an error occured.
+						Other           - If an error occurred.
 */
 
 ULONG InterfaceTxDataPacket(PMINI_ADAPTER Adapter,PVOID Packet,USHORT usVcid)
@@ -34,7 +34,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 						UINT uiBufferLength		   - Buffer Length
 
 Return:				BCM_STATUS_SUCCESS - If control packet transmit was successful.
-						Other           - If an error occured.
+						Other           - If an error occurred.
 */
 
 ULONG InterfaceTxControlPacket(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT uiBufferLength)
diff --git a/drivers/staging/bcm/PHSModule.c b/drivers/staging/bcm/PHSModule.c
index 8a38cf4..01d54bd 100644
--- a/drivers/staging/bcm/PHSModule.c
+++ b/drivers/staging/bcm/PHSModule.c
@@ -22,7 +22,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter         - Miniport Adapter Context
 						BOOLEAN bHeaderSuppressionEnabled - indicates if header suprression is enabled for SF.
 
 Return:					STATUS_SUCCESS - If the send was successful.
-						Other          - If an error occured.
+						Other          - If an error occurred.
 */
 
 int PHSTransmit(PMINI_ADAPTER Adapter,
diff --git a/drivers/staging/bcm/cntrl_SignalingInterface.h b/drivers/staging/bcm/cntrl_SignalingInterface.h
index 4cbe300..7aa3165 100644
--- a/drivers/staging/bcm/cntrl_SignalingInterface.h
+++ b/drivers/staging/bcm/cntrl_SignalingInterface.h
@@ -35,8 +35,8 @@ extern B_UINT32 g_u32Corr2MacFlags;
 #define VENDOR_PHS_PARAM_LENGTH 10
 #define MAX_NUM_ACTIVE_BS 10
 #define AUTH_TOKEN_LENGTH	10
-#define NUM_HARQ_CHANNELS	16	//Changed from 10 to 16 to accomodate all HARQ channels
-#define VENDOR_CLASSIFIER_PARAM_LENGTH 1 //Changed the size to 1 byte since we dnt use it
+#define NUM_HARQ_CHANNELS	16	//Changed from 10 to 16 to accommodate all HARQ channels
+#define VENDOR_CLASSIFIER_PARAM_LENGTH 1 //Changed the size to 1 byte since we dont use it
 #define  VENDOR_SPECIF_QOS_PARAM 1
 #define VENDOR_PHS_PARAM_LENGTH	10
 #define MBS_CONTENTS_ID_LENGTH	10
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index a4e49f3..d178473 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -419,7 +419,7 @@ static int wlc_ffpld_check_txfunfl(wlc_info_t *wlc, int fid)
 		/*
 		   compute a new dma xfer rate for max_mpdu @ max mcs.
 		   This is the minimum dma rate that
-		   can acheive no unferflow condition for the current mpdu size.
+		   can achieve no underflow condition for the current mpdu size.
 		 */
 		/* note : we divide/multiply by 100 to avoid integer overflows */
 		fifo->dmaxferrate =
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 093032b..a6c1d5b 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2045,7 +2045,7 @@ void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
 			     COMEDI_CB_OVERFLOW)) {
 		runflags_mask |= SRF_RUNNING;
 	}
-	/* remember if an error event has occured, so an error
+	/* remember if an error event has occurred, so an error
 	 * can be returned the next time the user does a read() */
 	if (s->async->events & (COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW)) {
 		runflags_mask |= SRF_ERROR;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
index 9dd857d..f5b8521 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
@@ -488,9 +488,9 @@ int i_APCI2032_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
+| Return Value      : TRUE  : No error occurred                              |
+|		            : FALSE : Error occurred. Return the error               |
+|			                                                                 |
 +----------------------------------------------------------------------------+
 */
 void v_APCI2032_Interrupt(int irq, void *d)
@@ -498,7 +498,7 @@ void v_APCI2032_Interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	unsigned int ui_DO;
 
-	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occured. */
+	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occurred. */
 
 	if (ui_DO == 0) {
 		printk("\nInterrupt from unKnown source\n");
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 466e69f..0fd0ac5 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -98,7 +98,7 @@ Configuration options:
 #define	Status_FE	0x0100	/* 1=FIFO is empty */
 #define Status_FH	0x0200	/* 1=FIFO is half full */
 #define Status_FF	0x0400	/* 1=FIFO is full, fatal error */
-#define Status_IRQ	0x0800	/* 1=IRQ occured */
+#define Status_IRQ	0x0800	/* 1=IRQ occurred */
 /* bits from control register (PCI171x_CONTROL) */
 #define Control_CNT0	0x0040	/* 1=CNT0 have external source,
 				 * 0=have internal 100kHz source */
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index b220b30..a804742 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -81,7 +81,7 @@ static const struct waveform_board waveform_boards[] = {
 /* Data unique to this driver */
 struct waveform_private {
 	struct timer_list timer;
-	struct timeval last;	/* time at which last timer interrupt occured */
+	struct timeval last;	/* time at which last timer interrupt occurred */
 	unsigned int uvolt_amplitude;	/* waveform amplitude in microvolts */
 	unsigned long usec_period;	/* waveform period in microseconds */
 	unsigned long usec_current;	/* current time (modulo waveform period) */
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index e6825c2..3ba93fb 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -1810,7 +1810,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		       ai_context->irq_status_reg) &
 	    ME4000_IRQ_STATUS_BIT_AI_HF) {
 		ISR_PDEBUG
-		    ("me4000_ai_isr(): Fifo half full interrupt occured\n");
+		    ("me4000_ai_isr(): Fifo half full interrupt occurred\n");
 
 		/* Read status register to find out what happened */
 		tmp = me4000_inl(dev, ai_context->ctrl_reg);
@@ -1903,7 +1903,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 	if (me4000_inl(dev,
 		       ai_context->irq_status_reg) & ME4000_IRQ_STATUS_BIT_SC) {
 		ISR_PDEBUG
-		    ("me4000_ai_isr(): Sample counter interrupt occured\n");
+		    ("me4000_ai_isr(): Sample counter interrupt occurred\n");
 
 		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOA;
 
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index e46d62b..e8755d7 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -106,8 +106,8 @@ TRIG_WAKE_EOS
 #define   OVFL_BIT		0x8	/*  fifo overflow */
 #define   EDAQ_BIT		0x10	/*  end of aquisition interrupt */
 #define   DCAL_BIT		0x20	/*  offset calibration in progress */
-#define   INTR_BIT		0x40	/*  interrupt has occured */
-#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occured */
+#define   INTR_BIT		0x40	/*  interrupt has occurred */
+#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occurred */
 #define   ID_BITS(x)	(((x) >> 8) & 0x3)
 #define IRQ_DMA_CNTRL_REG		0x12	/*  write only */
 #define   DMA_CHAN_BITS(x)		((x) & 0x7)	/*  sets dma channel */
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 4d1868d..2658408 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -183,11 +183,11 @@ NI manuals:
 #define   OVERRUN_BIT	0x2
 /* fifo overflow */
 #define   OVERFLOW_BIT	0x4
-/* timer interrupt has occured */
+/* timer interrupt has occurred */
 #define   TIMER_BIT	0x8
-/* dma terminal count has occured */
+/* dma terminal count has occurred */
 #define   DMATC_BIT	0x10
-/* external trigger has occured */
+/* external trigger has occurred */
 #define   EXT_TRIG_BIT	0x40
 /* 1200 boards only */
 #define STATUS2_REG	0x1d
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index d5ba3ab..5617182 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2570,7 +2570,7 @@ static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val)
 	while ((RR7146(P_I2CCTRL) & (I2C_BUSY | I2C_ERR)) == I2C_BUSY)
 		;
 
-	/*  Return non-zero if I2C error occured. */
+	/*  Return non-zero if I2C error occurred. */
 	return RR7146(P_I2CCTRL) & I2C_ERR;
 
 }
diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index f631857..3d43db6 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -2366,7 +2366,7 @@ enum BC_STATUS crystalhd_hw_set_core_clock(struct crystalhd_hw *hw)
 	BCMLOG(BCMLOG_INFO, "clock is moving to %d with n %d with vco_mg %d\n",
 	       hw->core_clock_mhz, n, vco_mg);
 
-	/* Change the DRAM refresh rate to accomodate the new frequency */
+	/* Change the DRAM refresh rate to accommodate the new frequency */
 	/* refresh reg = ((refresh_rate * clock_rate)/16) - 1; rounding up*/
 	refresh_reg = (7 * hw->core_clock_mhz / 16);
 	bc_dec_reg_wr(hw->adp, SDRAM_REF_PARAM, ((1 << 12) | refresh_reg));
diff --git a/drivers/staging/easycap/easycap_low.c b/drivers/staging/easycap/easycap_low.c
index ad1fc4c..22c41af 100644
--- a/drivers/staging/easycap/easycap_low.c
+++ b/drivers/staging/easycap/easycap_low.c
@@ -27,7 +27,7 @@
 */
 /*****************************************************************************/
 /*
- *  ACKNOWLEGEMENTS AND REFERENCES
+ *  ACKNOWLEDGEMENTS AND REFERENCES
  *  ------------------------------
  *  This driver makes use of register information contained in the Syntek
  *  Semicon DC-1125 driver hosted at
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 8e04bdd..f3a5aba 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -122,7 +122,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * number of entries in FBR1.
 	 *
 	 * FBR1 holds "large" frames, FBR0 holds "small" frames.  If FBR1
-	 * entries are huge in order to accomodate a "jumbo" frame, then it
+	 * entries are huge in order to accommodate a "jumbo" frame, then it
 	 * will have less entries.  Conversely, FBR1 will now be relied upon
 	 * to carry more "normal" frames, thus it's entry size also increases
 	 * and the number of entries goes up too (since it now carries
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 36f68fe..3a174df 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -466,7 +466,7 @@ void et131x_isr_handler(struct work_struct *work)
 		/* Handle SLV Timeout Interrupt */
 		if (status & ET_INTR_SLV_TIMEOUT) {
 			/*
-			 * This means a timeout has occured on a read or
+			 * This means a timeout has occurred on a read or
 			 * write request to one of the JAGCore registers. The
 			 * Global Resources block has terminated the request
 			 * and on a read request, returned a "fake" value.
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 5b89ee2..c29a010 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -303,7 +303,7 @@ u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buf
 {
     u16 ret = STATUS_SUCCESS;
 
-    //DEBUG("ft1000_read_dpram16: indx: %d  hightlow: %d\n", indx, highlow);
+    //DEBUG("ft1000_read_dpram16: indx: %d  highlow: %d\n", indx, highlow);
 
     u8 request;
 
@@ -337,7 +337,7 @@ u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buf
 // Parameters:  ft1000_device  - device structure
 //              indx - starting address to write the data
 //              value - 16bits value to write
-//              hightlow - high or low 16 bit word
+//              highlow - high or low 16 bit word
 //
 // Returns:     STATUS_SUCCESS - success
 //              STATUS_FAILURE - failure
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index 330d5d6..27ca673 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -408,7 +408,7 @@ static const struct attribute_group lis3l02dq_trigger_attr_group = {
  *
  * As the trigger may occur on any data element being updated it is
  * really rather likely to occur during the read from the previous
- * trigger event.  The only way to discover if this has occured on
+ * trigger event.  The only way to discover if this has occurred on
  * boards not supporting level interrupts is to take a look at the line.
  * If it is indicating another interrupt and we don't seem to have a
  * handler looking at it, then we need to notify the core that we need
diff --git a/drivers/staging/iio/chrdev.h b/drivers/staging/iio/chrdev.h
index 98d1a2c..bfbb22e 100644
--- a/drivers/staging/iio/chrdev.h
+++ b/drivers/staging/iio/chrdev.h
@@ -42,7 +42,7 @@ struct iio_event_data {
 };
 
 /**
- * struct iio_detected_event_list - list element for events that have occured
+ * struct iio_detected_event_list - list element for events that have occurred
  * @list:		linked list header
  * @ev:			the event itself
  * @shared_pointer:	used when the event is shared - i.e. can be escallated
diff --git a/drivers/staging/intel_sst/intel_sst_dsp.c b/drivers/staging/intel_sst/intel_sst_dsp.c
index d80a6ee..2045b04 100644
--- a/drivers/staging/intel_sst/intel_sst_dsp.c
+++ b/drivers/staging/intel_sst/intel_sst_dsp.c
@@ -401,7 +401,7 @@ exit:
 
 }
 
-/* This function is called when FW requests for a particular libary download
+/* This function is called when FW requests for a particular library download
 This function prepares the library to download*/
 int sst_load_library(struct snd_sst_lib_download *lib, u8 ops)
 {
diff --git a/drivers/staging/intel_sst/intel_sst_fw_ipc.h b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
index 9d3c368..600fdf8 100644
--- a/drivers/staging/intel_sst/intel_sst_fw_ipc.h
+++ b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
@@ -108,7 +108,7 @@
 #define IPC_SST_PERIOD_ELAPSED 0x97 /* period elapsed */
 #define IPC_IA_TARGET_DEV_CHNGD 0x98 /* error in processing a stream */
 
-#define IPC_SST_ERROR_EVENT 0x99 /* Buffer over run occured */
+#define IPC_SST_ERROR_EVENT 0x99 /* Buffer over run occurred */
 /* L2S messages */
 #define IPC_SC_DDR_LINK_UP 0xC0
 #define IPC_SC_DDR_LINK_DOWN 0xC1
diff --git a/drivers/staging/intel_sst/intel_sst_pvt.c b/drivers/staging/intel_sst/intel_sst_pvt.c
index 6487e19..c27f572 100644
--- a/drivers/staging/intel_sst/intel_sst_pvt.c
+++ b/drivers/staging/intel_sst/intel_sst_pvt.c
@@ -126,7 +126,7 @@ int sst_wait_interruptible_timeout(
 		retval = block->ret_code;
 	} else {
 		block->on = false;
-		pr_err("sst: timeout occured...\n");
+		pr_err("sst: timeout occurred...\n");
 		/*setting firmware state as uninit so that the
 		firmware will get re-downloaded on next request
 		this is because firmare not responding for 5 sec
diff --git a/drivers/staging/octeon/cvmx-helper.c b/drivers/staging/octeon/cvmx-helper.c
index 5915066..e9c5c83 100644
--- a/drivers/staging/octeon/cvmx-helper.c
+++ b/drivers/staging/octeon/cvmx-helper.c
@@ -691,7 +691,7 @@ int __cvmx_helper_errata_fix_ipd_ptr_alignment(void)
 
 		if (!retry_cnt)
 			cvmx_dprintf("WARNING: FIX_IPD_PTR_ALIGNMENT "
-				     "get_work() timeout occured.\n");
+				     "get_work() timeout occurred.\n");
 
 		/* Free packet */
 		if (work)
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index ed58f48..f44755a 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -148,7 +148,7 @@ static struct usb_driver quausb2_usb_driver = {
  * value of the line status flags from the port
  * @shadowMSR: Last received state of the modem status register, holds
  * the value of the modem status received from the port
- * @rcv_flush: Flag indicating that a receive flush has occured on
+ * @rcv_flush: Flag indicating that a receive flush has occurred on
  * the hardware.
  * @xmit_flush: Flag indicating that a transmit flush has been processed by
  * the hardware.
@@ -726,7 +726,7 @@ static int qt2_write(struct tty_struct *tty, struct usb_serial_port *port,
 		return 0;
 	} else if (port_extra->tx_pending_bytes >= QT2_FIFO_DEPTH) {
 		/* buffer is full (==). > should not occur, but would indicate
-		 * that an overflow had occured */
+		 * that an overflow had occurred */
 		dbg("%s(): port transmit buffer is full!", __func__);
 		/* schedule_work(&port->work); commented in vendor driver */
 		return 0;
diff --git a/drivers/staging/rt2860/common/action.c b/drivers/staging/rt2860/common/action.c
index 56ad236..2f21e66 100644
--- a/drivers/staging/rt2860/common/action.c
+++ b/drivers/staging/rt2860/common/action.c
@@ -456,7 +456,7 @@ void PeerHTAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *Elem)
 /*
 	==========================================================================
 	Description:
-		Retry sending ADDBA Reqest.
+		Retry sending ADDBA Request.
 
 	IRQL = DISPATCH_LEVEL
 
diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
index 8eef82d..c3a4c74 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -970,7 +970,7 @@ void BASessionTearDownALL(struct rt_rtmp_adapter *pAd, u8 Wcid)
 /*
 	==========================================================================
 	Description:
-		Retry sending ADDBA Reqest.
+		Retry sending ADDBA Request.
 
 	IRQL = DISPATCH_LEVEL
 
@@ -1032,7 +1032,7 @@ void BAOriSessionSetupTimeout(void *SystemSpecific1,
 /*
 	==========================================================================
 	Description:
-		Retry sending ADDBA Reqest.
+		Retry sending ADDBA Request.
 
 	IRQL = DISPATCH_LEVEL
 
diff --git a/drivers/staging/rt2860/sta/connect.c b/drivers/staging/rt2860/sta/connect.c
index c380551..156bd32 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -1852,7 +1852,7 @@ void LinkUp(struct rt_rtmp_adapter *pAd, u8 BssType)
 	IRQL = DISPATCH_LEVEL
 
 	Note:
-		We need more information to know it's this requst from AP.
+		We need more information to know it's this request from AP.
 		If yes! we need to do extra handling, for example, remove the WPA key.
 		Otherwise on 4-way handshaking will faied, since the WPA key didn't be
 		remove while auto reconnect.
diff --git a/drivers/staging/spectra/flash.c b/drivers/staging/spectra/flash.c
index 4e6e451..d0bb896 100644
--- a/drivers/staging/spectra/flash.c
+++ b/drivers/staging/spectra/flash.c
@@ -973,7 +973,7 @@ static void process_cmd_fail_abort(int *first_failed_cmd,
 	if (0 == *first_failed_cmd)
 		*first_failed_cmd = PendingCMD[idx].SBDCmdIndex;
 
-	nand_dbg_print(NAND_DBG_DEBUG, "Uncorrectable error has occured "
+	nand_dbg_print(NAND_DBG_DEBUG, "Uncorrectable error has occurred "
 		"while executing %u Command %u accesing Block %u\n",
 		(unsigned int)p_BTableChangesDelta->ftl_cmd_cnt,
 		PendingCMD[idx].CMD,
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
index 014f5d5..c214df9 100644
--- a/drivers/staging/tidspbridge/hw/hw_mmu.c
+++ b/drivers/staging/tidspbridge/hw/hw_mmu.c
@@ -59,7 +59,7 @@ enum hw_mmu_page_size_t {
  * RETURNS:
  *
  *       Type		: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description     : 0		 -- No errors occurred
  *			 RET_BAD_NULL_PARAM     -- A Pointer
  *						Paramater was set to NULL
  *
@@ -102,7 +102,7 @@ static hw_status mmu_flush_entry(const void __iomem *base_address);
  * RETURNS:
  *
  *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description     : 0		 -- No errors occurred
  *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
  *						   was set to NULL
  *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter out
@@ -147,7 +147,7 @@ static hw_status mmu_set_cam_entry(const void __iomem *base_address,
  * RETURNS:
  *
  *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description     : 0		 -- No errors occurred
  *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
  *							was set to NULL
  *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index f5028d9..eda7fa2 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -137,7 +137,7 @@ DEVICE_PARAM(TxDescriptors1,"Number of transmit descriptors1");
 /* IP_byte_align[] is used for IP header unsigned long byte aligned
    0: indicate the IP header won't be unsigned long byte aligned.(Default) .
    1: indicate the IP header will be unsigned long byte aligned.
-      In some enviroment, the IP header should be unsigned long byte aligned,
+      In some environment, the IP header should be unsigned long byte aligned,
       or the packet will be droped when we receive it. (eg: IPVS)
 */
 DEVICE_PARAM(IP_byte_align,"Enable IP header dword aligned");
diff --git a/drivers/staging/vt6655/tether.h b/drivers/staging/vt6655/tether.h
index 787d885..3b4efb2 100644
--- a/drivers/staging/vt6655/tether.h
+++ b/drivers/staging/vt6655/tether.h
@@ -53,7 +53,7 @@
 #define TYPE_PKT_802_1x     0x888e
 #define TYPE_PKT_PreAuth    0x88C7
 
-#define TYPE_PKT_PING_M_REQ 0x8011      // master reguest
+#define TYPE_PKT_PING_M_REQ 0x8011      // master request
 #define TYPE_PKT_PING_S_GNT 0x8022      // slave grant
 #define TYPE_PKT_PING_M     0x8077      // pingpong master packet
 #define TYPE_PKT_PING_S     0x8088      // pingpong slave packet
@@ -106,7 +106,7 @@
 #define TYPE_PKT_802_1x     0x8e88
 #define TYPE_PKT_PreAuth    0xC788
 
-#define TYPE_PKT_PING_M_REQ 0x1180      // master reguest
+#define TYPE_PKT_PING_M_REQ 0x1180      // master request
 #define TYPE_PKT_PING_S_GNT 0x2280      // slave grant
 #define TYPE_PKT_PING_M     0x7780      // pingpong master packet
 #define TYPE_PKT_PING_S     0x8880      // pingpong slave packet
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index e5add20..8650561 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1096,7 +1096,7 @@ else {
         pbyAgc = abyVT3184_AGC;
         wLengthAgc = sizeof(abyVT3184_AGC);
 
-        pDevice->abyBBVGA[0] = 0x20; //RobertYu:20060104, reguest by Jack
+        pDevice->abyBBVGA[0] = 0x20; //RobertYu:20060104, request by Jack
         pDevice->abyBBVGA[1] = 0x10;
         pDevice->abyBBVGA[2] = 0x0;
         pDevice->abyBBVGA[3] = 0x0;
diff --git a/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c b/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
index d43dd85..5573533 100644
--- a/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
+++ b/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
@@ -678,7 +678,7 @@ cy_as_read_intr_status(
 		/*
 		* queue the mailbox data for later processing.
 		* this allows the firmware to move forward and
-		* service the requst from the P port.
+		* service the request from the P port.
 		*/
 		cy_as_ll_queue_mailbox_data(dev_p);
 
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
index e1851f0..43cef26 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
@@ -117,7 +117,7 @@ struct cyasblkdev_blk_data {
 	 * 16 * 4K (64 K per request)*/
 	struct scatterlist	  sg[16];
 
-	/* non-zero enables printk of executed reqests */
+	/* non-zero enables printk of executed requests */
 	unsigned int	dbgprn_flags;
 
 	/*gen_disk for private, system disk */
diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index d4bdd3e..bd8d3cc 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -1735,7 +1735,7 @@ DESC_STRCT *descp;	// pointer to start of FrameList
 * - in case encapsulation by the HCF is selected:
 *	  -	The FrameList does not consists of at least 2 Descriptors.
 *	  -	The first databuffer does not contain exactly the (space for) the 802.11 header (== 28 words)
-*	  -	The first databuffer does not have a size to additionally accomodate the 802.3 header and the
+*	  -	The first databuffer does not have a size to additionally accommodate the 802.3 header and the
 *		SNAP header of the frame after encapsulation (== 39 words).
 *	  -	The second databuffer does not contain at least DA, SA and 'type/length' (==14 bytes or 7 words)
 *!! The 2nd part of the list of asserts should be kept in sync with put_frame_lst, in order to get
diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index 5aa9eb8..5ce3342 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -851,7 +851,7 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 #define HCF_ERR_LEN					0x08	/* buffer size insufficient
 		 								  	 *		  -	IFB_ConfigTable too small
 		 								  	 *		  -	hcf_get_info buffer has a size of 0 or 1 or less than needed
-		 							  		 *			to accomodate all data
+		 							  		 *			to accommodate all data
 		 							  		 *		  -	hcf_put_info: CFG_DLNV_DATA exceeds intermediate
 											 *		  buffer size */
 #define HCF_ERR_INCOMP_PRI			0x09	// primary functions are not compatible
diff --git a/drivers/staging/wlan-ng/p80211req.c b/drivers/staging/wlan-ng/p80211req.c
index 179194e..d540e47 100644
--- a/drivers/staging/wlan-ng/p80211req.c
+++ b/drivers/staging/wlan-ng/p80211req.c
@@ -80,7 +80,7 @@ static int p80211req_mibset_mibget(wlandevice_t *wlandev,
 /*----------------------------------------------------------------
 * p80211req_dorequest
 *
-* Handles an MLME reqest/confirm message.
+* Handles an MLME request/confirm message.
 *
 * Arguments:
 *	wlandev		WLAN device struct
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 44447f5..25fe5a1 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1830,7 +1830,7 @@ static int uea_start_reset(struct uea_softc *sc)
 
 	/* mask interrupt */
 	sc->booting = 1;
-	/* We need to set this here because, a ack timeout could have occured,
+	/* We need to set this here because, a ack timeout could have occurred,
 	 * but before we start the reboot, the ack occurs and set this to 1.
 	 * So we will failed to wait Ready CMV.
 	 */
diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
index f6b3c25..a03fbc1 100644
--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -907,7 +907,7 @@ static inline int c67x00_end_of_data(struct c67x00_td *td)
 
 /* Remove all td's from the list which come
  * after last_td and are meant for the same pipe.
- * This is used when a short packet has occured */
+ * This is used when a short packet has occurred */
 static inline void c67x00_clear_pipe(struct c67x00_hcd *c67x00,
 				     struct c67x00_td *last_td)
 {
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index 5eeb570..b4ea54d 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -52,7 +52,7 @@
  */
 
 /*
- * The only reason to have several buffers is to accomodate assumptions
+ * The only reason to have several buffers is to accommodate assumptions
  * in line disciplines. They ask for empty space amount, receive our URB size,
  * and proceed to issue several 1-character writes, assuming they will fit.
  * The very first write takes a complete URB. Fortunately, this only happens
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 9034e03..fd0af5f 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -2137,7 +2137,7 @@ static irqreturn_t udc_data_out_isr(struct udc *dev, int ep_ix)
 	if (use_dma) {
 		/* BNA event ? */
 		if (tmp & AMD_BIT(UDC_EPSTS_BNA)) {
-			DBG(dev, "BNA ep%dout occured - DESPTR = %x \n",
+			DBG(dev, "BNA ep%dout occurred - DESPTR = %x \n",
 					ep->num, readl(&ep->regs->desptr));
 			/* clear BNA */
 			writel(tmp | AMD_BIT(UDC_EPSTS_BNA), &ep->regs->sts);
@@ -2151,7 +2151,7 @@ static irqreturn_t udc_data_out_isr(struct udc *dev, int ep_ix)
 	}
 	/* HE event ? */
 	if (tmp & AMD_BIT(UDC_EPSTS_HE)) {
-		dev_err(&dev->pdev->dev, "HE ep%dout occured\n", ep->num);
+		dev_err(&dev->pdev->dev, "HE ep%dout occurred\n", ep->num);
 
 		/* clear HE */
 		writel(tmp | AMD_BIT(UDC_EPSTS_HE), &ep->regs->sts);
@@ -2354,7 +2354,7 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
 		/* BNA ? */
 		if (epsts & AMD_BIT(UDC_EPSTS_BNA)) {
 			dev_err(&dev->pdev->dev,
-				"BNA ep%din occured - DESPTR = %08lx \n",
+				"BNA ep%din occurred - DESPTR = %08lx \n",
 				ep->num,
 				(unsigned long) readl(&ep->regs->desptr));
 
@@ -2367,7 +2367,7 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
 	/* HE event ? */
 	if (epsts & AMD_BIT(UDC_EPSTS_HE)) {
 		dev_err(&dev->pdev->dev,
-			"HE ep%dn occured - DESPTR = %08lx \n",
+			"HE ep%dn occurred - DESPTR = %08lx \n",
 			ep->num, (unsigned long) readl(&ep->regs->desptr));
 
 		/* clear HE */
diff --git a/drivers/usb/gadget/fsl_qe_udc.h b/drivers/usb/gadget/fsl_qe_udc.h
index bea5b82..8e18d0d 100644
--- a/drivers/usb/gadget/fsl_qe_udc.h
+++ b/drivers/usb/gadget/fsl_qe_udc.h
@@ -208,14 +208,14 @@ struct qe_frame{
 /* Frame status field */
 /* Receive side */
 #define FRAME_OK               0x00000000 /* Frame tranmitted or received OK */
-#define FRAME_ERROR            0x80000000 /* Error occured on frame */
+#define FRAME_ERROR            0x80000000 /* Error occurred on frame */
 #define START_FRAME_LOST       0x40000000 /* START_FRAME_LOST */
 #define END_FRAME_LOST         0x20000000 /* END_FRAME_LOST */
 #define RX_ER_NONOCT           0x10000000 /* Rx Non Octet Aligned Packet */
 #define RX_ER_BITSTUFF         0x08000000 /* Frame Aborted --Received packet
 					     with bit stuff error */
 #define RX_ER_CRC              0x04000000 /* Received packet with CRC error */
-#define RX_ER_OVERUN           0x02000000 /* Over-run occured on reception */
+#define RX_ER_OVERUN           0x02000000 /* Over-run occurred on reception */
 #define RX_ER_PID              0x01000000 /* Wrong PID received */
 /* Tranmit side */
 #define TX_ER_NAK              0x00800000 /* Received NAK handshake */
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 4c55eda..008aa27 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1228,7 +1228,7 @@ static void ch9getstatus(struct fsl_udc *udc, u8 request_type, u16 value,
 	udc->ep0_dir = USB_DIR_IN;
 	/* Borrow the per device status_req */
 	req = udc->status_req;
-	/* Fill in the reqest structure */
+	/* Fill in the request structure */
 	*((u16 *) req->req.buf) = cpu_to_le16(tmp);
 	req->ep = ep;
 	req->req.length = 2;
@@ -1461,7 +1461,7 @@ static int process_ep_req(struct fsl_udc *udc, int pipe,
 				status = -EILSEQ;
 				break;
 			} else
-				ERR("Unknown error has occured (0x%x)!\n",
+				ERR("Unknown error has occurred (0x%x)!\n",
 					errors);
 
 		} else if (le32_to_cpu(curr_td->size_ioc_sts)
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index b8ec954..a52144a 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -2186,7 +2186,7 @@ static void get_status(struct langwell_udc *dev, u8 request_type, u16 value,
 	/* borrow the per device status_req */
 	req = dev->status_req;
 
-	/* fill in the reqest structure */
+	/* fill in the request structure */
 	*((u16 *) req->req.buf) = cpu_to_le16(status_data);
 	req->ep = ep;
 	req->req.length = 2;
diff --git a/drivers/usb/host/fhci-tds.c b/drivers/usb/host/fhci-tds.c
index 7be548c..ec8d163 100644
--- a/drivers/usb/host/fhci-tds.c
+++ b/drivers/usb/host/fhci-tds.c
@@ -337,7 +337,7 @@ static void fhci_td_transaction_confirm(struct fhci_usb *usb)
 					pkt->status = USB_TD_RX_ER_NONOCT;
 				else
 					fhci_err(usb->fhci, "illegal error "
-						 "occured\n");
+						 "occurred\n");
 			} else if (td_status & TD_NAK)
 				pkt->status = USB_TD_TX_ER_NAK;
 			else if (td_status & TD_TO)
@@ -347,7 +347,7 @@ static void fhci_td_transaction_confirm(struct fhci_usb *usb)
 			else if (td_status & TD_STAL)
 				pkt->status = USB_TD_TX_ER_STALL;
 			else
-				fhci_err(usb->fhci, "illegal error occured\n");
+				fhci_err(usb->fhci, "illegal error occurred\n");
 		} else if ((extra_data & TD_TOK_IN) &&
 				pkt->len > td_length - CRC_SIZE) {
 			pkt->status = USB_TD_RX_DATA_UNDERUN;
diff --git a/drivers/usb/host/fhci.h b/drivers/usb/host/fhci.h
index 71c3caa..d16bc8d 100644
--- a/drivers/usb/host/fhci.h
+++ b/drivers/usb/host/fhci.h
@@ -82,7 +82,7 @@
 #define USB_TD_RX_ER_NONOCT	0x40000000 /* Tx Non Octet Aligned Packet */
 #define USB_TD_RX_ER_BITSTUFF	0x20000000 /* Frame Aborted-Received pkt */
 #define USB_TD_RX_ER_CRC	0x10000000 /* CRC error */
-#define USB_TD_RX_ER_OVERUN	0x08000000 /* Over - run occured */
+#define USB_TD_RX_ER_OVERUN	0x08000000 /* Over - run occurred */
 #define USB_TD_RX_ER_PID	0x04000000 /* wrong PID received */
 #define USB_TD_RX_DATA_UNDERUN	0x02000000 /* shorter than expected */
 #define USB_TD_RX_DATA_OVERUN	0x01000000 /* longer than expected */
diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index c265aed..d6e424a 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -763,7 +763,7 @@ static int fb_wait_for_vsync(struct fb_info *info)
 
 	/*
 	 * Set flag to 0 and wait for isr to set to 1. It would seem there is a
-	 * race condition here where the ISR could have occured just before or
+	 * race condition here where the ISR could have occurred just before or
 	 * just after this set. But since we are just coarsely waiting for
 	 * a frame to complete then that's OK. i.e. if the frame completed
 	 * just before this code executed then we have to wait another full
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index 0a08f13..7ed39d6 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -33,7 +33,7 @@
  * for driver private data (info->par). info->par (if any) will be
  * aligned to sizeof(long).
  *
- * Returns the new structure, or NULL if an error occured.
+ * Returns the new structure, or NULL if an error occurred.
  *
  */
 struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 2ffce4d..b6a2b58 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -26,7 +26,7 @@
  *	Theory of Operation:
  *		The Watch-Dog Timer is provided to ensure that standalone
  *		Systems can always recover from catastrophic conditions that
- *		caused the CPU to crash. This condition may have occured by
+ *		caused the CPU to crash. This condition may have occurred by
  *		external EMI or a software bug. When the CPU stops working
  *		correctly, hardware on the board will either perform a hardware
  *		reset (cold boot) or a non-maskable interrupt (NMI) to bring the
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index 0461858..ced0264 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -201,7 +201,7 @@ static void sch311x_wdt_get_status(int *status)
 	spin_lock(&sch311x_wdt_data.io_lock);
 
 	/* -- Watchdog timer control --
-	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
+	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occurred
 	 * Bit 1   Reserved
 	 * Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
 	 * Bit 3   P20 Force Timeout enabled:
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 8a1f0bc..4b3462b 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -191,7 +191,7 @@ static inline void wdt_timer_conf(unsigned char conf)
 static inline void wdt_timer_ctrl(unsigned char reg)
 {
 	/* -- Watchdog timer control --
-	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
+	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occurred
 	 * Bit 1   Power LED Toggle: 0 = Disable Toggle, 1 = Toggle at 1 Hz
 	 * Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
 	 * Bit 3   P20 Force Timeout enabled:
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 9127eda..5f405ce 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -90,7 +90,7 @@ static void wdt_setload(unsigned int timeout)
 	/*
 	 * sp805 runs counter with given value twice, after the end of first
 	 * counter it gives an interrupt and then starts counter again. If
-	 * interrupt already occured then it resets the system. This is why
+	 * interrupt already occurred then it resets the system. This is why
 	 * load is half of what should be required.
 	 */
 	load = div_u64(rate, 2) * timeout - 1;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 9d1a22d..d527955 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -894,7 +894,7 @@ static int truncate_upper(struct dentry *dentry, struct iattr *ia,
 
 
 		/*
-		 * XXX(truncate) this should really happen at the begginning
+		 * XXX(truncate) this should really happen at the beginning
 		 * of ->setattr.  But the code is too messy to that as part
 		 * of a larger patch.  ecryptfs is also totally missing out
 		 * on the inode_change_ok check at the beginning of
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index a9dbd62..806905e 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -857,7 +857,7 @@ static int __init ecryptfs_init(void)
 	}
 	rc = ecryptfs_init_messaging();
 	if (rc) {
-		printk(KERN_ERR "Failure occured while attempting to "
+		printk(KERN_ERR "Failure occurred while attempting to "
 				"initialize the communications channel to "
 				"ecryptfsd\n");
 		goto out_destroy_kthread;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94ce3d7..1f253a9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -577,7 +577,7 @@ struct ext4_mount_options {
 #endif
 };
 
-/* Max physical block we can addres w/o extents */
+/* Max physical block we can address w/o extents */
 #define EXT4_MAX_BLOCK_FILE_PHYS	0xFFFFFFFF
 
 /*
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0554c48..d6d5d4d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1627,7 +1627,7 @@ out:
 
 /*
  * ext4_ext_insert_extent:
- * tries to merge requsted extent into the existing extent or
+ * tries to merge requested extent into the existing extent or
  * inserts requested extent as new one into the tree,
  * creating new leaf in the no-space case.
  */
diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index d32ee94..2ab1a0d 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -24,7 +24,7 @@
  *
  * Returns: 0 if the data CRC is correct;
  * 	    1 - if incorrect;
- *	    error code if an error occured.
+ *	    error code if an error occurred.
  */
 static int check_node_data(struct jffs2_sb_info *c, struct jffs2_tmp_dnode_info *tn)
 {
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 7bf029e..7051f5e 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -301,7 +301,7 @@ nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
  * disk, but it retrieves and clears ctx->error after synching, despite
  * the two being set at the same time in nfs_context_set_write_error().
  * This is because the former is used to notify the _next_ call to
- * nfs_file_write() that a write error occured, and hence cause it to
+ * nfs_file_write() that a write error occurred, and hence cause it to
  * fall back to doing a synchronous write.
  */
 static int
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 116cab9..8d5729d 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3600,7 +3600,7 @@ find_lockstateowner_str(struct inode *inode, clientid_t *clid,
 /*
  * Alloc a lock owner structure.
  * Called in nfsd4_lock - therefore, OPEN and OPEN_CONFIRM (if needed) has 
- * occured. 
+ * occurred. 
  *
  * strhashval = lock_ownerstr_hashval 
  */
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index f5094ee..0990be5 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -1181,7 +1181,7 @@ not_found:
  * for, i.e. if one wants to add the attribute to the mft record this is the
  * correct place to insert its attribute list entry into.
  *
- * When -errno != -ENOENT, an error occured during the lookup.  @ctx->attr is
+ * When -errno != -ENOENT, an error occurred during the lookup.  @ctx->attr is
  * then undefined and in particular you should not rely on it not changing.
  */
 int ntfs_attr_lookup(const ATTR_TYPE type, const ntfschar *name,
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 93622b1..bffa7e6 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2522,7 +2522,7 @@ retry_truncate:
 		 * specifies that the behaviour is unspecified thus we do not
 		 * have to do anything.  This means that in our implementation
 		 * in the rare case that the file is mmap()ped and a write
-		 * occured into the mmap()ped region just beyond the file size
+		 * occurred into the mmap()ped region just beyond the file size
 		 * and writepage has not yet been called to write out the page
 		 * (which would clear the area beyond the file size) and we now
 		 * extend the file size to incorporate this dirty region
diff --git a/fs/ntfs/logfile.h b/fs/ntfs/logfile.h
index b5a6f08..aa2b6ac 100644
--- a/fs/ntfs/logfile.h
+++ b/fs/ntfs/logfile.h
@@ -222,7 +222,7 @@ typedef struct {
 /* 24*/	sle64 file_size;	/* Usable byte size of the log file.  If the
 				   restart_area_offset + the offset of the
 				   file_size are > 510 then corruption has
-				   occured.  This is the very first check when
+				   occurred.  This is the very first check when
 				   starting with the restart_area as if it
 				   fails it means that some of the above values
 				   will be corrupted by the multi sector
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index b572b67..fd227af 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -1442,7 +1442,7 @@ static int ntfs_mft_bitmap_extend_allocation_nolock(ntfs_volume *vol)
 		// Note: It will need to be a special mft record and if none of
 		// those are available it gets rather complicated...
 		ntfs_error(vol->sb, "Not enough space in this mft record to "
-				"accomodate extended mft bitmap attribute "
+				"accommodate extended mft bitmap attribute "
 				"extent.  Cannot handle this yet.");
 		ret = -EOPNOTSUPP;
 		goto undo_alloc;
@@ -1879,7 +1879,7 @@ static int ntfs_mft_data_extend_allocation_nolock(ntfs_volume *vol)
 		// and we would then need to update all references to this mft
 		// record appropriately.  This is rather complicated...
 		ntfs_error(vol->sb, "Not enough space in this mft record to "
-				"accomodate extended mft data attribute "
+				"accommodate extended mft data attribute "
 				"extent.  Cannot handle this yet.");
 		ret = -EOPNOTSUPP;
 		goto undo_alloc;
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index a30ecacc..456ff04 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -458,7 +458,7 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 	 * the volume on boot and updates them.
 	 *
 	 * When remounting read-only, mark the volume clean if no volume errors
-	 * have occured.
+	 * have occurred.
 	 */
 	if ((sb->s_flags & MS_RDONLY) && !(*flags & MS_RDONLY)) {
 		static const char *es = ".  Cannot remount read-write.";
@@ -1269,7 +1269,7 @@ static int check_windows_hibernation_status(ntfs_volume *vol)
 					"hibernated on the volume.");
 			return 0;
 		}
-		/* A real error occured. */
+		/* A real error occurred. */
 		ntfs_error(vol->sb, "Failed to find inode number for "
 				"hiberfil.sys.");
 		return ret;
@@ -1370,7 +1370,7 @@ static bool load_and_init_quota(ntfs_volume *vol)
 			NVolSetQuotaOutOfDate(vol);
 			return true;
 		}
-		/* A real error occured. */
+		/* A real error occurred. */
 		ntfs_error(vol->sb, "Failed to find inode number for $Quota.");
 		return false;
 	}
@@ -1454,7 +1454,7 @@ not_enabled:
 			NVolSetUsnJrnlStamped(vol);
 			return true;
 		}
-		/* A real error occured. */
+		/* A real error occurred. */
 		ntfs_error(vol->sb, "Failed to find inode number for "
 				"$UsnJrnl.");
 		return false;
@@ -2292,7 +2292,7 @@ static void ntfs_put_super(struct super_block *sb)
 	ntfs_commit_inode(vol->mft_ino);
 
 	/*
-	 * If a read-write mount and no volume errors have occured, mark the
+	 * If a read-write mount and no volume errors have occurred, mark the
 	 * volume clean.  Also, re-commit all affected inodes.
 	 */
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -2496,7 +2496,7 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
 	if (vol->nr_clusters & 63)
 		nr_free += 64 - (vol->nr_clusters & 63);
 	up_read(&vol->lcnbmp_lock);
-	/* If errors occured we may well have gone below zero, fix this. */
+	/* If errors occurred we may well have gone below zero, fix this. */
 	if (nr_free < 0)
 		nr_free = 0;
 	ntfs_debug("Exiting.");
@@ -2561,7 +2561,7 @@ static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 	}
 	ntfs_debug("Finished reading $MFT/$BITMAP, last index = 0x%lx.",
 			index - 1);
-	/* If errors occured we may well have gone below zero, fix this. */
+	/* If errors occurred we may well have gone below zero, fix this. */
 	if (nr_free < 0)
 		nr_free = 0;
 	ntfs_debug("Exiting.");
diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index cf3e166..d368989 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -89,7 +89,7 @@ static void o2quo_fence_self(void)
 	};
 }
 
-/* Indicate that a timeout occured on a hearbeat region write. The
+/* Indicate that a timeout occurred on a hearbeat region write. The
  * other nodes in the cluster may consider us dead at that time so we
  * want to "fence" ourselves so that we don't scribble on the disk
  * after they think they've recovered us. This can't solve all
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 5d04a78..d1d0fee 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -396,7 +396,7 @@ static struct page *reiserfs_get_page(struct inode *dir, size_t n)
 	struct address_space *mapping = dir->i_mapping;
 	struct page *page;
 	/* We can deadlock if we try to free dentries,
-	   and an unlink/rmdir has just occured - GFP_NOFS avoids this */
+	   and an unlink/rmdir has just occurred - GFP_NOFS avoids this */
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	page = read_mapping_page(mapping, n >> PAGE_CACHE_SHIFT, NULL);
 	if (!IS_ERR(page)) {
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fc48f37..6618fcb 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -652,7 +652,7 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
 		iinfo->i_lenExtents += inode->i_sb->s_blocksize;
 	}
 
-	/* if the extent the requsted block is located in contains multiple
+	/* if the extent the requested block is located in contains multiple
 	 * blocks, split the extent into at most three extents. blocks prior
 	 * to requested block, requested block, and blocks after requested
 	 * block */
diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index ba8ad42..f79b6fd 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -788,7 +788,7 @@ write_retry:
 		/*
 		 * If this was a direct or synchronous I/O that failed (such
 		 * as ENOSPC) then part of the I/O may have been written to
-		 * disk before the error occured.  In this case the on-disk
+		 * disk before the error occurred.  In this case the on-disk
 		 * file size may have been adjusted beyond the in-memory file
 		 * size and now needs to be truncated back.
 		 */
diff --git a/fs/xfs/quota/xfs_qm_bhv.c b/fs/xfs/quota/xfs_qm_bhv.c
index 45b5cb1..a133058 100644
--- a/fs/xfs/quota/xfs_qm_bhv.c
+++ b/fs/xfs/quota/xfs_qm_bhv.c
@@ -135,7 +135,7 @@ xfs_qm_newmount(
 		 */
 		if (quotaondisk && !XFS_QM_NEED_QUOTACHECK(mp)) {
 			/*
-			 * If an error occured, qm_mount_quotas code
+			 * If an error occurred, qm_mount_quotas code
 			 * has already disabled quotas. So, just finish
 			 * mounting, and get on with the boring life
 			 * without disk quotas.
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 966d3f9..0269abe 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -90,7 +90,7 @@ xlog_get_bp(
 	/*
 	 * We do log I/O in units of log sectors (a power-of-2
 	 * multiple of the basic block size), so we round up the
-	 * requested size to acommodate the basic blocks required
+	 * requested size to accommodate the basic blocks required
 	 * for complete log sectors.
 	 *
 	 * In addition, the buffer may be used for a non-sector-
@@ -101,7 +101,7 @@ xlog_get_bp(
 	 * an issue.  Nor will this be a problem if the log I/O is
 	 * done in basic blocks (sector size 1).  But otherwise we
 	 * extend the buffer by one extra log sector to ensure
-	 * there's space to accomodate this possiblility.
+	 * there's space to accommodate this possiblility.
 	 */
 	if (nbblks > 1 && log->l_sectBBsize > 1)
 		nbblks += log->l_sectBBsize;
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 8e0c848..8a0534c 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -243,9 +243,9 @@ struct ttm_mem_type_manager_func {
 	 * @mem::mm_node should be set to a non-null value, and
 	 * @mem::start should be set to a value identifying the beginning
 	 * of the range allocated, and the function should return zero.
-	 * If the memory region accomodate the buffer object, @mem::mm_node
+	 * If the memory region accommodate the buffer object, @mem::mm_node
 	 * should be set to NULL, and the function should return 0.
-	 * If a system error occured, preventing the request to be fulfilled,
+	 * If a system error occurred, preventing the request to be fulfilled,
 	 * the function should return a negative error code.
 	 *
 	 * Note that @mem::mm_node will only be dereferenced by
diff --git a/include/linux/atmlec.h b/include/linux/atmlec.h
index 39c917f..48a2257 100644
--- a/include/linux/atmlec.h
+++ b/include/linux/atmlec.h
@@ -82,7 +82,7 @@ struct atmlec_msg {
 			__u16 lec_id;				/* requestor lec_id  */
 			__u32 tran_id;				/* transaction id    */
 			unsigned char mac_addr[ETH_ALEN];	/* dst mac addr      */
-			unsigned char atm_addr[ATM_ESA_LEN];	/* reqestor ATM addr */
+			unsigned char atm_addr[ATM_ESA_LEN];	/* requestor ATM addr */
 		} proxy;	/*
 				 * For mapping LE_ARP requests to responses. Filled by
 				 * zeppelin, returned by kernel. Used only when proxying
diff --git a/include/linux/can/error.h b/include/linux/can/error.h
index d4127fd..5958074 100644
--- a/include/linux/can/error.h
+++ b/include/linux/can/error.h
@@ -51,7 +51,7 @@
 #define CAN_ERR_PROT_BIT1        0x10 /* unable to send recessive bit */
 #define CAN_ERR_PROT_OVERLOAD    0x20 /* bus overload */
 #define CAN_ERR_PROT_ACTIVE      0x40 /* active error announcement */
-#define CAN_ERR_PROT_TX          0x80 /* error occured on transmission */
+#define CAN_ERR_PROT_TX          0x80 /* error occurred on transmission */
 
 /* error in CAN protocol (location) / data[3] */
 #define CAN_ERR_PROT_LOC_UNSPEC  0x00 /* unspecified */
diff --git a/include/linux/fb.h b/include/linux/fb.h
index d1631d3..b6ad4ff 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -532,14 +532,14 @@ struct fb_cursor_user {
 #define FB_EVENT_GET_CONSOLE_MAP        0x07
 /*      CONSOLE-SPECIFIC: set console to framebuffer mapping */
 #define FB_EVENT_SET_CONSOLE_MAP        0x08
-/*      A hardware display blank change occured */
+/*      A hardware display blank change occurred */
 #define FB_EVENT_BLANK                  0x09
 /*      Private modelist is to be replaced */
 #define FB_EVENT_NEW_MODELIST           0x0A
 /*	The resolution of the passed in fb_info about to change and
         all vc's should be changed         */
 #define FB_EVENT_MODE_CHANGE_ALL	0x0B
-/*	A software display blank change occured */
+/*	A software display blank change occurred */
 #define FB_EVENT_CONBLANK               0x0C
 /*      Get drawing requirements        */
 #define FB_EVENT_GET_REQ                0x0D
diff --git a/include/linux/spi/spidev.h b/include/linux/spi/spidev.h
index bf0570a..52d9ed0 100644
--- a/include/linux/spi/spidev.h
+++ b/include/linux/spi/spidev.h
@@ -66,7 +66,7 @@
  * are in a different address space (and may be of different sizes in some
  * cases, such as 32-bit i386 userspace over a 64-bit x86_64 kernel).
  * Zero-initialize the structure, including currently unused fields, to
- * accomodate potential future updates.
+ * accommodate potential future updates.
  *
  * SPI_IOC_MESSAGE gives userspace the equivalent of kernel spi_sync().
  * Pass it an array of related transfers, they'll execute together.
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 5a3085b..6121d7f 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -142,7 +142,7 @@ static inline void svc_get(struct svc_serv *serv)
 extern u32 svc_max_payload(const struct svc_rqst *rqstp);
 
 /*
- * RPC Requsts and replies are stored in one or more pages.
+ * RPC Requests and replies are stored in one or more pages.
  * We maintain an array of pages for each server thread.
  * Requests are copied into these pages as they arrive.  Remaining
  * pages are available to write the reply into.
diff --git a/include/linux/usb.h b/include/linux/usb.h
index a28eb25..e27a267 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -796,7 +796,7 @@ struct usbdrv_wrap {
  *	usb_set_intfdata() to associate driver-specific data with the
  *	interface.  It may also use usb_set_interface() to specify the
  *	appropriate altsetting.  If unwilling to manage the interface,
- *	return -ENODEV, if genuine IO errors occured, an appropriate
+ *	return -ENODEV, if genuine IO errors occurred, an appropriate
  *	negative errno value.
  * @disconnect: Called when the interface is no longer accessible, usually
  *	because its device has been (or is being) disconnected or the
diff --git a/include/linux/uwb.h b/include/linux/uwb.h
index 7fc9746..645d1e1 100644
--- a/include/linux/uwb.h
+++ b/include/linux/uwb.h
@@ -702,7 +702,7 @@ void edc_init(struct edc *edc)
 	edc->timestart = jiffies;
 }
 
-/* Called when an error occured.
+/* Called when an error occurred.
  * This is way to determine if the number of acceptable errors per time
  * period has been exceeded. It is not accurate as there are cases in which
  * this scheme will not work, for example if there are periodic occurences
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 83ba6a4..59b5df5 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -101,7 +101,7 @@ enum p9_req_status_t {
  * Transport use an array to track outstanding requests
  * instead of a list.  While this may incurr overhead during initial
  * allocation or expansion, it makes request lookup much easier as the
- * tag id is a index into an array.  (We use tag+1 so that we can accomodate
+ * tag id is a index into an array.  (We use tag+1 so that we can accommodate
  * the -1 tag for the T_VERSION request).
  * This also has the nice effect of only having to allocate wait_queues
  * once, instead of constantly allocating and freeing them.  Its possible
diff --git a/include/sound/cs8427.h b/include/sound/cs8427.h
index f862cff..79f7017 100644
--- a/include/sound/cs8427.h
+++ b/include/sound/cs8427.h
@@ -151,7 +151,7 @@
 #define CS8427_PRO		(1<<3)	/* Channel status block format indicator */
 #define CS8427_AUDIO		(1<<2)	/* Audio indicator (0 = audio, 1 = nonaudio */
 #define CS8427_COPY		(1<<1)	/* 0 = copyright asserted, 1 = copyright not asserted */
-#define CS8427_ORIG		(1<<0)	/* SCMS generation indicator, 0 = 1st generation or highter, 1 = original */
+#define CS8427_ORIG		(1<<0)	/* SCMS generation indicator, 0 = 1st generation or higher, 1 = original */
 
 /* CS8427_REG_RECVERRORS */
 /* CS8427_REG_RECVERRMASK for CS8427_RERR */
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index 17110a4..4e4ef68 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -153,7 +153,7 @@ static inline void store_stacktrace(struct task_struct *tsk,
 }
 
 /**
- * __account_scheduler_latency - record an occured latency
+ * __account_scheduler_latency - record an occurred latency
  * @tsk - the task struct of the task hitting the latency
  * @usecs - the duration of the latency in microseconds
  * @inter - 1 if the sleep was interruptible, 0 if uninterruptible
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 7b5db6a..27616cb 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -227,7 +227,7 @@ power_attr(state);
  * writing to 'state'.  It first should read from 'wakeup_count' and store
  * the read value.  Then, after carrying out its own preparations for the system
  * transition to a sleep state, it should write the stored value to
- * 'wakeup_count'.  If that fails, at least one wakeup event has occured since
+ * 'wakeup_count'.  If that fails, at least one wakeup event has occurred since
  * 'wakeup_count' was read and 'state' should not be written to.  Otherwise, it
  * is allowed to write to 'state', but the transition will be aborted if there
  * are any wakeup events detected after 'wakeup_count' was written to.
diff --git a/kernel/user-return-notifier.c b/kernel/user-return-notifier.c
index eb27fd3..92cb706 100644
--- a/kernel/user-return-notifier.c
+++ b/kernel/user-return-notifier.c
@@ -20,7 +20,7 @@ EXPORT_SYMBOL_GPL(user_return_notifier_register);
 
 /*
  * Removes a registered user return notifier.  Must be called from atomic
- * context, and from the same cpu registration occured in.
+ * context, and from the same cpu registration occurred in.
  */
 void user_return_notifier_unregister(struct user_return_notifier *urn)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8585524..13a0c08 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -907,7 +907,7 @@ struct page *alloc_huge_page_node(struct hstate *h, int nid)
 }
 
 /*
- * Increase the hugetlb pool such that it can accomodate a reservation
+ * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
  */
 static int gather_surplus_pages(struct hstate *h, int delta)
@@ -955,7 +955,7 @@ retry:
 
 	/*
 	 * The surplus_list now contains _at_least_ the number of extra pages
-	 * needed to accomodate the reservation.  Add the appropriate number
+	 * needed to accommodate the reservation.  Add the appropriate number
 	 * of pages to the hugetlb pool and free the extras back to the buddy
 	 * allocator.  Commit the entire reservation here to prevent another
 	 * process from stealing the pages as they are added to the pool but
@@ -2531,7 +2531,7 @@ static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	/*
 	 * Currently, we are forced to kill the process in the event the
 	 * original mapper has unmapped pages from the child due to a failed
-	 * COW. Warn that such a situation has occured as it may not be obvious
+	 * COW. Warn that such a situation has occurred as it may not be obvious
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
 		printk(KERN_WARNING
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index bd9bc21..018f5ea 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -263,7 +263,7 @@ static void kmemleak_disable(void);
 } while (0)
 
 /*
- * Macro invoked when a serious kmemleak condition occured and cannot be
+ * Macro invoked when a serious kmemleak condition occurred and cannot be
  * recovered from. Kmemleak will be disabled and further allocation/freeing
  * tracing no longer available.
  */
@@ -1003,7 +1003,7 @@ static bool update_checksum(struct kmemleak_object *object)
 
 /*
  * Memory scanning is a long process and it needs to be interruptable. This
- * function checks whether such interrupt condition occured.
+ * function checks whether such interrupt condition occurred.
  */
 static int scan_should_stop(void)
 {
@@ -1730,7 +1730,7 @@ static int __init kmemleak_late_init(void)
 
 	if (atomic_read(&kmemleak_error)) {
 		/*
-		 * Some error occured and kmemleak was disabled. There is a
+		 * Some error occurred and kmemleak was disabled. There is a
 		 * small chance that kmemleak_disable() was called immediately
 		 * after setting kmemleak_initialized and we may end up with
 		 * two clean-up threads but serialized by scan_mutex.
diff --git a/mm/percpu.c b/mm/percpu.c
index efe8168..f5dcd3c 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -346,7 +346,7 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
  * @chunk: chunk of interest
  *
  * Determine whether area map of @chunk needs to be extended to
- * accomodate a new allocation.
+ * accommodate a new allocation.
  *
  * CONTEXT:
  * pcpu_lock.
@@ -435,7 +435,7 @@ out_unlock:
  * depending on @head, is reduced by @tail bytes and @tail byte block
  * is inserted after the target block.
  *
- * @chunk->map must have enough free slots to accomodate the split.
+ * @chunk->map must have enough free slots to accommodate the split.
  *
  * CONTEXT:
  * pcpu_lock.
@@ -1440,7 +1440,7 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 	/*
 	 * Determine min_unit_size, alloc_size and max_upa such that
 	 * alloc_size is multiple of atom_size and is the smallest
-	 * which can accomodate 4k aligned segments which are equal to
+	 * which can accommodate 4k aligned segments which are equal to
 	 * or larger than min_unit_size.
 	 */
 	min_unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
diff --git a/net/9p/client.c b/net/9p/client.c
index a848bca..cb6a360 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -178,7 +178,7 @@ free_and_return:
  * @tag: numeric id for transaction
  *
  * this is a simple array lookup, but will grow the
- * request_slots as necessary to accomodate transaction
+ * request_slots as necessary to accommodate transaction
  * ids which did not previously have a slot.
  *
  * this code relies on the client spinlock to manage locks, its
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 61c2463..6900aa8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -73,7 +73,7 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
 	tcp_advance_send_head(sk, skb);
 	tp->snd_nxt = TCP_SKB_CB(skb)->end_seq;
 
-	/* Don't override Nagle indefinately with F-RTO */
+	/* Don't override Nagle indefinitely with F-RTO */
 	if (tp->frto_counter == 2)
 		tp->frto_counter = 3;
 
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 99abfb5..befa8e2 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -65,7 +65,7 @@ static unsigned int ipv6_defrag(unsigned int hooknum,
 	if (reasm == NULL)
 		return NF_STOLEN;
 
-	/* error occured or not fragmented */
+	/* error occurred or not fragmented */
 	if (reasm == skb)
 		return NF_ACCEPT;
 
diff --git a/net/irda/irlap_event.c b/net/irda/irlap_event.c
index d434c88..85b84f4 100644
--- a/net/irda/irlap_event.c
+++ b/net/irda/irlap_event.c
@@ -708,7 +708,7 @@ static int irlap_state_reply(struct irlap_cb *self, IRLAP_EVENT event,
 
 				self->frame_sent = TRUE;
 			}
-			/* Readjust our timer to accomodate devices
+			/* Readjust our timer to accommodate devices
 			 * doing faster or slower discovery than us...
 			 * Jean II */
 			irlap_start_query_timer(self, info->S, info->s);
diff --git a/net/irda/timer.c b/net/irda/timer.c
index 0335ba0..f418cb2 100644
--- a/net/irda/timer.c
+++ b/net/irda/timer.c
@@ -59,7 +59,7 @@ void irlap_start_query_timer(struct irlap_cb *self, int S, int s)
 	 * slot time, plus add some extra time to properly receive the last
 	 * discovery packet (which is longer due to extra discovery info),
 	 * to avoid messing with for incomming connections requests and
-	 * to accomodate devices that perform discovery slower than us.
+	 * to accommodate devices that perform discovery slower than us.
 	 * Jean II */
 	timeout = ((sysctl_slot_timeout * HZ / 1000) * (S - s)
 		   + XIDEXTRA_TIMEOUT + SMALLBUSY_TIMEOUT);
diff --git a/net/mac80211/rc80211_pid.h b/net/mac80211/rc80211_pid.h
index 1a873f0..8d8a141 100644
--- a/net/mac80211/rc80211_pid.h
+++ b/net/mac80211/rc80211_pid.h
@@ -80,7 +80,7 @@ union rc_pid_event_data {
 };
 
 struct rc_pid_event {
-	/* The time when the event occured */
+	/* The time when the event occurred */
 	unsigned long timestamp;
 
 	/* Event ID number */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 27a5ea6..423761b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -880,7 +880,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	ret = l3proto->get_l4proto(skb, skb_network_offset(skb),
 				   &dataoff, &protonum);
 	if (ret <= 0) {
-		pr_debug("not prepared to track yet or error occured\n");
+		pr_debug("not prepared to track yet or error occurred\n");
 		NF_CT_STAT_INC_ATOMIC(net, error);
 		NF_CT_STAT_INC_ATOMIC(net, invalid);
 		ret = -ret;
diff --git a/net/rds/iw_cm.c b/net/rds/iw_cm.c
index 712cf2d..3a60a15 100644
--- a/net/rds/iw_cm.c
+++ b/net/rds/iw_cm.c
@@ -181,7 +181,7 @@ static int rds_iw_init_qp_attrs(struct ib_qp_init_attr *attr,
 	unsigned int send_size, recv_size;
 	int ret;
 
-	/* The offset of 1 is to accomodate the additional ACK WR. */
+	/* The offset of 1 is to accommodate the additional ACK WR. */
 	send_size = min_t(unsigned int, rds_iwdev->max_wrs, rds_iw_sysctl_max_send_wr + 1);
 	recv_size = min_t(unsigned int, rds_iwdev->max_wrs, rds_iw_sysctl_max_recv_wr + 1);
 	rds_iw_ring_resize(send_ring, send_size - 1);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index dfcab5a..956df28 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -504,7 +504,7 @@ static int xs_nospace(struct rpc_task *task)
  *   EAGAIN:	The socket was blocked, please call again later to
  *		complete the request
  * ENOTCONN:	Caller needs to invoke connect logic then call again
- *    other:	Some other error occured, the request was not sent
+ *    other:	Some other error occurred, the request was not sent
  */
 static int xs_udp_send_request(struct rpc_task *task)
 {
@@ -590,7 +590,7 @@ static inline void xs_encode_tcp_record_marker(struct xdr_buf *buf)
  *   EAGAIN:	The socket was blocked, please call again later to
  *		complete the request
  * ENOTCONN:	Caller needs to invoke connect logic then call again
- *    other:	Some other error occured, the request was not sent
+ *    other:	Some other error occurred, the request was not sent
  *
  * XXX: In the case of soft timeouts, should we eventually give up
  *	if sendmsg is not able to make progress?
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 489a85a..532f196 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2245,7 +2245,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	switch (sbp->s_magic) {
 	case SMACK_MAGIC:
 		/*
-		 * Casey says that it's a little embarassing
+		 * Casey says that it's a little embarrassing
 		 * that the smack file system doesn't do
 		 * extended attributes.
 		 */
diff --git a/sound/pci/ctxfi/cthw20k1.c b/sound/pci/ctxfi/cthw20k1.c
index 0cf400f..f58d5af 100644
--- a/sound/pci/ctxfi/cthw20k1.c
+++ b/sound/pci/ctxfi/cthw20k1.c
@@ -82,7 +82,7 @@ static void hw_write_pci(struct hw *hw, u32 reg, u32 data);
 
 #define SRCLA_LA	0x03FFFFFF
 
-/* Mixer Parameter Ring ram Low and Hight register.
+/* Mixer Parameter Ring ram Low and High register.
  * Fixed-point value in 8.24 format for parameter channel */
 #define MPRLH_PITCH	0xFFFFFFFF
 
diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
index b6b11bf..c7bb374 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -80,7 +80,7 @@ static void hw_write_20kx(struct hw *hw, u32 reg, u32 data);
 
 #define SRCLA_LA	0x0FFFFFFF
 
-/* Mixer Parameter Ring ram Low and Hight register.
+/* Mixer Parameter Ring ram Low and High register.
  * Fixed-point value in 8.24 format for parameter channel */
 #define MPRLH_PITCH	0xFFFFFFFF
 
diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
index 833e718..304411c 100644
--- a/sound/pci/pcxhr/pcxhr_core.c
+++ b/sound/pci/pcxhr/pcxhr_core.c
@@ -1042,11 +1042,11 @@ void pcxhr_msg_tasklet(unsigned long arg)
 	int i, j;
 
 	if (mgr->src_it_dsp & PCXHR_IRQ_FREQ_CHANGE)
-		snd_printdd("TASKLET : PCXHR_IRQ_FREQ_CHANGE event occured\n");
+		snd_printdd("TASKLET : PCXHR_IRQ_FREQ_CHANGE event occurred\n");
 	if (mgr->src_it_dsp & PCXHR_IRQ_TIME_CODE)
-		snd_printdd("TASKLET : PCXHR_IRQ_TIME_CODE event occured\n");
+		snd_printdd("TASKLET : PCXHR_IRQ_TIME_CODE event occurred\n");
 	if (mgr->src_it_dsp & PCXHR_IRQ_NOTIFY)
-		snd_printdd("TASKLET : PCXHR_IRQ_NOTIFY event occured\n");
+		snd_printdd("TASKLET : PCXHR_IRQ_NOTIFY event occurred\n");
 	if (mgr->src_it_dsp & (PCXHR_IRQ_FREQ_CHANGE | PCXHR_IRQ_TIME_CODE)) {
 		/* clear events FREQ_CHANGE and TIME_CODE */
 		pcxhr_init_rmh(prmh, CMD_TEST_IT);
@@ -1055,7 +1055,7 @@ void pcxhr_msg_tasklet(unsigned long arg)
 			    err, prmh->stat[0]);
 	}
 	if (mgr->src_it_dsp & PCXHR_IRQ_ASYNC) {
-		snd_printdd("TASKLET : PCXHR_IRQ_ASYNC event occured\n");
+		snd_printdd("TASKLET : PCXHR_IRQ_ASYNC event occurred\n");
 
 		pcxhr_init_rmh(prmh, CMD_ASYNC);
 		prmh->cmd[0] |= 1;	/* add SEL_ASYNC_EVENTS */
@@ -1233,7 +1233,7 @@ irqreturn_t pcxhr_interrupt(int irq, void *dev_id)
 	reg = PCXHR_INPL(mgr, PCXHR_PLX_L2PCIDB);
 	PCXHR_OUTPL(mgr, PCXHR_PLX_L2PCIDB, reg);
 
-	/* timer irq occured */
+	/* timer irq occurred */
 	if (reg & PCXHR_IRQ_TIMER) {
 		int timer_toggle = reg & PCXHR_IRQ_TIMER;
 		/* is a 24 bit counter */
@@ -1288,7 +1288,7 @@ irqreturn_t pcxhr_interrupt(int irq, void *dev_id)
 	if (reg & PCXHR_IRQ_MASK) {
 		if (reg & PCXHR_IRQ_ASYNC) {
 			/* as we didn't request any async notifications,
-			 * some kind of xrun error will probably occured
+			 * some kind of xrun error will probably occurred
 			 */
 			/* better resynchronize all streams next interrupt : */
 			mgr->dsp_time_last = PCXHR_DSP_TIME_INVALID;
diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
index 581a670..1213456 100644
--- a/sound/ppc/snd_ps3.c
+++ b/sound/ppc/snd_ps3.c
@@ -358,7 +358,7 @@ static irqreturn_t snd_ps3_interrupt(int irq, void *dev_id)
 		 * filling dummy data, serial automatically start to
 		 * consume them and then will generate normal buffer
 		 * empty interrupts.
-		 * If both buffer underflow and buffer empty are occured,
+		 * If both buffer underflow and buffer empty are occurred,
 		 * it is better to do nomal data transfer than empty one
 		 */
 		snd_ps3_program_dma(card,
diff --git a/sound/ppc/snd_ps3_reg.h b/sound/ppc/snd_ps3_reg.h
index 03fdee4..a7962c5 100644
--- a/sound/ppc/snd_ps3_reg.h
+++ b/sound/ppc/snd_ps3_reg.h
@@ -316,13 +316,13 @@ DISABLED=Interrupt generation disabled.
 
 /*
 Audio Port Interrupt Status Register
-Indicates Interrupt status, which interrupt has occured, and can clear
+Indicates Interrupt status, which interrupt has occurred, and can clear
 each interrupt in this register.
 Writing 1b to a field containing 1b clears field and de-asserts interrupt.
 Writing 0b to a field has no effect.
 Field vaules are the following:
-0 - Interrupt hasn't occured.
-1 - Interrupt has occured.
+0 - Interrupt hasn't occurred.
+1 - Interrupt has occurred.
 
 
  31            24 23           16 15            8 7             0
@@ -756,7 +756,7 @@ The STATUS field can be used to monitor the progress of a DMA request.
 DONE indicates the previous request has completed.
 EVENT indicates that the DMA engine is waiting for the EVENT to occur.
 PENDING indicates that the DMA engine has not started processing this
-request, but the EVENT has occured.
+request, but the EVENT has occurred.
 DMA indicates that the data transfer is in progress.
 NOTIFY indicates that the notifier signalling end of transfer is being written.
 CLEAR indicated that the previous transfer was cleared.
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 1304ca9..d40fa55 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3610,7 +3610,7 @@ static int wm8962_gpio_request(struct gpio_chip *chip, unsigned offset)
 
 	/* The WM8962 GPIOs aren't linearly numbered.  For simplicity
 	 * we export linear numbers and error out if the unsupported
-	 * ones are requsted.
+	 * ones are requested.
 	 */
 	switch (offset + 1) {
 	case 2:
-- 
1.7.2.2

