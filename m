Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab2HQPn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:43:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57224 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249Ab2HQPns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:43:48 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Fix typo in various printk
Date: Sat, 18 Aug 2012 00:43:40 +0900
Message-Id: <1345218220-14429-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in various printk

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/ata/libata-core.c                        | 2 +-
 drivers/ata/sata_fsl.c                           | 2 +-
 drivers/bluetooth/ath3k.c                        | 2 +-
 drivers/edac/mpc85xx_edac.c                      | 4 ++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 2 +-
 drivers/scsi/mvumi.c                             | 8 ++++----
 drivers/scsi/vmw_pvscsi.c                        | 4 ++--
 drivers/w1/masters/ds1wm.c                       | 2 +-
 fs/hpfs/inode.c                                  | 2 +-
 10 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2d479b6..4ab5d1c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1705,7 +1705,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
  *	@dev: Device to which the command is sent
  *	@tf: Taskfile registers for the command and the result
  *	@cdb: CDB for packet command
- *	@dma_dir: Data tranfer direction of the command
+ *	@dma_dir: Data transfer direction of the command
  *	@buf: Data buffer of the command
  *	@buflen: Length of data buffer
  *	@timeout: Timeout in msecs (0 for default)
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index d6577b9..facac6c 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -309,7 +309,7 @@ static void fsl_sata_set_irq_coalescing(struct ata_host *host,
 	intr_coalescing_ticks = ticks;
 	spin_unlock(&host->lock);
 
-	DPRINTK("intrrupt coalescing, count = 0x%x, ticks = %x\n",
+	DPRINTK("interrupt coalescing, count = 0x%x, ticks = %x\n",
 			intr_coalescing_count, intr_coalescing_ticks);
 	DPRINTK("ICC register status: (hcr base: 0x%x) = 0x%x\n",
 			hcr_base, ioread32(hcr_base + ICC));
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 11f36e5..282026d 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -336,7 +336,7 @@ static int ath3k_load_syscfg(struct usb_device *udev)
 
 	ret = ath3k_get_state(udev, &fw_state);
 	if (ret < 0) {
-		BT_ERR("Can't get state to change to load configration err");
+		BT_ERR("Can't get state to change to load configuration err");
 		return -EBUSY;
 	}
 
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index a1e791e..9482c3a 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -291,7 +291,7 @@ static int __devinit mpc85xx_pci_err_probe(struct platform_device *op)
 				       "[EDAC] PCI err", pci);
 		if (res < 0) {
 			printk(KERN_ERR
-			       "%s: Unable to requiest irq %d for "
+			       "%s: Unable to request irq %d for "
 			       "MPC85xx PCI err\n", __func__, pdata->irq);
 			irq_dispose_mapping(pdata->irq);
 			res = -ENODEV;
@@ -593,7 +593,7 @@ static int __devinit mpc85xx_l2_err_probe(struct platform_device *op)
 				       "[EDAC] L2 err", edac_dev);
 		if (res < 0) {
 			printk(KERN_ERR
-			       "%s: Unable to requiest irq %d for "
+			       "%s: Unable to request irq %d for "
 			       "MPC85xx L2 err\n", __func__, pdata->irq);
 			irq_dispose_mapping(pdata->irq);
 			res = -ENODEV;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
index 0bcda9c..6149655 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
@@ -422,7 +422,7 @@ int qlcnic_pinit_from_rom(struct qlcnic_adapter *adapter)
 	QLCWR32(adapter, CRB_CMDPEG_STATE, 0);
 	QLCWR32(adapter, CRB_RCVPEG_STATE, 0);
 
-	/* Halt all the indiviual PEGs and other blocks */
+	/* Halt all the individual PEGs and other blocks */
 	/* disable all I2Q */
 	QLCWR32(adapter, QLCNIC_CRB_I2Q + 0x10, 0x0);
 	QLCWR32(adapter, QLCNIC_CRB_I2Q + 0x14, 0x0);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 212c121..c5510e1 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -982,7 +982,7 @@ static int qlcnic_check_npar_opertional(struct qlcnic_adapter *adapter)
 	}
 	if (!npar_opt_timeo) {
 		dev_err(&adapter->pdev->dev,
-			"Waiting for NPAR state to opertional timeout\n");
+			"Waiting for NPAR state to operational timeout\n");
 		return -EIO;
 	}
 	return 0;
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 88cf1db..2eb911e 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -122,7 +122,7 @@ static struct mvumi_res *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
 
 	if (!res) {
 		dev_err(&mhba->pdev->dev,
-			"Failed to allocate memory for resouce manager.\n");
+			"Failed to allocate memory for resource manager.\n");
 		return NULL;
 	}
 
@@ -194,7 +194,7 @@ static void mvumi_release_mem_resource(struct mvumi_hba *mhba)
  * @mhba:		Adapter soft state
  * @scmd:		SCSI command from the mid-layer
  * @sgl_p:		SGL to be filled in
- * @sg_count		return the number of SG elements
+ * @sg_count:		return the number of SG elements
  *
  * If successful, this function returns 0. otherwise, it returns -1.
  */
@@ -1007,13 +1007,13 @@ static int mvumi_handshake(struct mvumi_hba *mhba)
 		tmp |= INT_MAP_COMAOUT | INT_MAP_COMAERR;
 		iowrite32(tmp, regs + CPU_ENPOINTA_MASK_REG);
 		iowrite32(mhba->list_num_io, mhba->ib_shadow);
-		/* Set InBound List Avaliable count shadow */
+		/* Set InBound List Available count shadow */
 		iowrite32(lower_32_bits(mhba->ib_shadow_phys),
 					regs + CLA_INB_AVAL_COUNT_BASEL);
 		iowrite32(upper_32_bits(mhba->ib_shadow_phys),
 					regs + CLA_INB_AVAL_COUNT_BASEH);
 
-		/* Set OutBound List Avaliable count shadow */
+		/* Set OutBound List Available count shadow */
 		iowrite32((mhba->list_num_io-1) | CL_POINTER_TOGGLE,
 						mhba->ob_shadow);
 		iowrite32(lower_32_bits(mhba->ob_shadow_phys), regs + 0x5B0);
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 4411d42..20b3a48 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -295,7 +295,7 @@ static void ll_adapter_reset(const struct pvscsi_adapter *adapter)
 
 static void ll_bus_reset(const struct pvscsi_adapter *adapter)
 {
-	dev_dbg(pvscsi_dev(adapter), "Reseting bus on %p\n", adapter);
+	dev_dbg(pvscsi_dev(adapter), "Resetting bus on %p\n", adapter);
 
 	pvscsi_write_cmd_desc(adapter, PVSCSI_CMD_RESET_BUS, NULL, 0);
 }
@@ -304,7 +304,7 @@ static void ll_device_reset(const struct pvscsi_adapter *adapter, u32 target)
 {
 	struct PVSCSICmdDescResetDevice cmd = { 0 };
 
-	dev_dbg(pvscsi_dev(adapter), "Reseting device: target=%u\n", target);
+	dev_dbg(pvscsi_dev(adapter), "Resetting device: target=%u\n", target);
 
 	cmd.target = target;
 
diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 530a2d3..7c294f4 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -349,7 +349,7 @@ static void ds1wm_search(void *data, struct w1_master *master_dev,
 			"pass: %d entering ASM\n", pass);
 		ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_SRA);
 		dev_dbg(&ds1wm_data->pdev->dev,
-			"pass: %d begining nibble loop\n", pass);
+			"pass: %d beginning nibble loop\n", pass);
 
 		r_prime = 0;
 		d = 0;
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index ed671e0..5a4a64c 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -146,7 +146,7 @@ static void hpfs_write_inode_ea(struct inode *i, struct fnode *fnode)
 	/*if (le32_to_cpu(fnode->acl_size_l) || le16_to_cpu(fnode->acl_size_s)) {
 		   Some unknown structures like ACL may be in fnode,
 		   we'd better not overwrite them
-		hpfs_error(i->i_sb, "fnode %08x has some unknown HPFS386 stuctures", i->i_ino);
+		hpfs_error(i->i_sb, "fnode %08x has some unknown HPFS386 structures", i->i_ino);
 	} else*/ if (hpfs_sb(i->i_sb)->sb_eas >= 2) {
 		__le32 ea;
 		if ((i->i_uid != hpfs_sb(i->i_sb)->sb_uid) || hpfs_inode->i_ea_uid) {
-- 
1.7.12.rc3

