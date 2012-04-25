Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2DYQPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:15:12 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:53954 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2DYQPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:15:10 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Fix typo in various drivers
Date: Thu, 26 Apr 2012 01:14:49 +0900
Message-Id: <1335370489-25790-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.280.gaa39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling typo in printk within various drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/powerpc/platforms/ps3/device-init.c |    2 +-
 drivers/ata/sata_fsl.c                   |    2 +-
 drivers/bluetooth/ath3k.c                |    2 +-
 drivers/dma/ppc4xx/adma.c                |    2 +-
 drivers/firewire/ohci.c                  |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c |    2 +-
 drivers/mfd/tps65911-comparator.c        |    2 +-
 drivers/modem_shm/shm_boot.c             |    2 +-
 drivers/remoteproc/remoteproc_core.c     |    4 ++--
 drivers/spi/spi-topcliff-pch.c           |    2 +-
 drivers/target/target_core_transport.c   |    2 +-
 drivers/w1/masters/ds1wm.c               |    2 +-
 fs/befs/ChangeLog                        |    6 +++---
 fs/hpfs/inode.c                          |    2 +-
 fs/qnx6/inode.c                          |    2 +-
 scripts/basic/fixdep.c                   |    2 +-
 16 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/device-init.c b/arch/powerpc/platforms/ps3/device-init.c
index 3f175e8..7ccc449 100644
--- a/arch/powerpc/platforms/ps3/device-init.c
+++ b/arch/powerpc/platforms/ps3/device-init.c
@@ -62,7 +62,7 @@ static int __init ps3_register_lpm_devices(void)
 		&dev->lpm.rights);
 
 	if (result) {
-		pr_debug("%s:%d: ps3_repository_read_lpm_privleges failed \n",
+		pr_debug("%s:%d: ps3_repository_read_lpm_privileges failed \n",
 			__func__, __LINE__);
 		goto fail_read_repo;
 	}
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
index 57fd867..c129dcc 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -325,7 +325,7 @@ static int ath3k_load_syscfg(struct usb_device *udev)
 
 	ret = ath3k_get_state(udev, &fw_state);
 	if (ret < 0) {
-		BT_ERR("Can't get state to change to load configration err");
+		BT_ERR("Can't get state to change to load configuration err");
 		return -EBUSY;
 	}
 
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index ced9882..f72348d 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -4446,7 +4446,7 @@ static int __devinit ppc440spe_adma_probe(struct platform_device *ofdev)
 		ret = -ENOMEM;
 		goto err_dma_alloc;
 	}
-	dev_dbg(&ofdev->dev, "allocted descriptor pool virt 0x%p phys 0x%llx\n",
+	dev_dbg(&ofdev->dev, "allocated descriptor pool virt 0x%p phys 0x%llx\n",
 		adev->dma_desc_pool_virt, (u64)adev->dma_desc_pool);
 
 	regs = ioremap(res.start, resource_size(&res));
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index c1af05e..b903c78 100644
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
diff --git a/drivers/gpu/drm/exynos/exynos_drm_hdmi.c b/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
index 3424463..ea8fdda 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
@@ -199,7 +199,7 @@ static void drm_hdmi_dpms(struct device *subdrv_dev, int mode)
 			hdmi_ops->disable(ctx->hdmi_ctx->ctx);
 		break;
 	default:
-		DRM_DEBUG_KMS("unkown dps mode: %d\n", mode);
+		DRM_DEBUG_KMS("unknown dps mode: %d\n", mode);
 		break;
 	}
 }
diff --git a/drivers/mfd/tps65911-comparator.c b/drivers/mfd/tps65911-comparator.c
index 5a62e6b..0b6e361 100644
--- a/drivers/mfd/tps65911-comparator.c
+++ b/drivers/mfd/tps65911-comparator.c
@@ -136,7 +136,7 @@ static __devinit int tps65911_comparator_probe(struct platform_device *pdev)
 
 	ret = comp_threshold_set(tps65910, COMP2, pdata->vmbch2_threshold);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "cannot set COMP2 theshold\n");
+		dev_err(&pdev->dev, "cannot set COMP2 threshold\n");
 		return ret;
 	}
 
diff --git a/drivers/modem_shm/shm_boot.c b/drivers/modem_shm/shm_boot.c
index 87ff053..3d382a3 100644
--- a/drivers/modem_shm/shm_boot.c
+++ b/drivers/modem_shm/shm_boot.c
@@ -643,7 +643,7 @@ static int do_commit(struct shm_modem *modem)
 	}
 
 	if (modem->commited) {
-		pr_devel("already commited\n");
+		pr_devel("already committed\n");
 		modem->config_error = true;
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
 
diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index ec47d3b..cbd0316 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -505,7 +505,7 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
 	}
 
 	if (unlikely(pspi->max_speed_hz == 0)) {
-		dev_err(&pspi->dev, "%s pch_spi_tranfer maxspeed=%d\n",
+		dev_err(&pspi->dev, "%s pch_spi_transfer maxspeed=%d\n",
 			__func__, pspi->max_speed_hz);
 		retval = -EINVAL;
 		goto err_out;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 28945d9..5a7c8b5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4339,7 +4339,7 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	cmd->transport_state &= ~(CMD_T_ACTIVE | CMD_T_STOP);
 
-	pr_debug("wait_for_tasks: Stopped wait_for_compltion("
+	pr_debug("wait_for_tasks: Stopped wait_for_completion("
 		"&cmd->t_transport_stop_comp) for ITT: 0x%08x\n",
 		cmd->se_tfo->get_task_tag(cmd));
 
diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index a0c8965..649eb0b 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -347,7 +347,7 @@ static void ds1wm_search(void *data, struct w1_master *master_dev,
 			"pass: %d entering ASM\n", pass);
 		ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_SRA);
 		dev_dbg(&ds1wm_data->pdev->dev,
-			"pass: %d begining nibble loop\n", pass);
+			"pass: %d beginning nibble loop\n", pass);
 
 		r_prime = 0;
 		d = 0;
diff --git a/fs/befs/ChangeLog b/fs/befs/ChangeLog
index 75a461c..2e6c155 100644
--- a/fs/befs/ChangeLog
+++ b/fs/befs/ChangeLog
@@ -170,7 +170,7 @@ Version 0.50 (2001-11-13)
 * Fixed a couple of compile warnings due to use of malloc.h, when slab.h 
 	is the new way. (inode.c, super.c) [WD]
 
-* Fixed erronous includes of linux/befs_fs_i.h and linux/befs_fs_sb.h 
+* Fixed erroneous includes of linux/befs_fs_i.h and linux/befs_fs_sb.h 
 	in inode.c [WD]
 
 Version 0.45 (2001-10-29)
@@ -229,7 +229,7 @@ Version 0.4 (2001-10-28)
 * Generic_read_file() is now used to read regular file data. 
 	It doesn't chew up the buffer cache (it does page io instead), and seems 
 	to be about as fast (even though it has to look up each file block 
-	indivdualy). And it knows about doing readahead, which is a major plus. 
+	individually). And it knows about doing readahead, which is a major plus. 
 	So it does i/o in much larger chunks. It is the correct linux way. It 
 	uses befs_get_block() by way of befs_readpage() to find the disk offsets 
 	of blocks, which in turn calls befs_fpos2brun() in datastream.c to do 
@@ -311,7 +311,7 @@ Version 0.4 (2001-10-28)
 2001-09-05
 ==========
 * Fixed a misunderstanding of the inode fields. 
-	This fixed the problmem with wrong file sizes from du and others.
+	This fixed the problem with wrong file sizes from du and others.
 	The i_blocks field of the inode struct is not the number of blocks for the
 	inode, it is the number of blocks for the file.	Also, i_blksize is not
 	necessarily the size of the inode, although in  practice it works out.
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 3b2cec2..ff5836c 100644
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
diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index e44012d..40ed7bf 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -285,7 +285,7 @@ static struct buffer_head *qnx6_check_first_superblock(struct super_block *s,
 		if (fs32_to_cpu(sbi, sb->sb_magic) == QNX6_SUPER_MAGIC) {
 			/* we got a big endian fs */
 			QNX6DEBUG((KERN_INFO "qnx6: fs got different"
-					" endianess.\n"));
+					" endianness.\n"));
 			return bh;
 		} else
 			sbi->s_bytesex = BYTESEX_LE;
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
1.7.10.280.gaa39

