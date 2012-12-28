Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2L1RAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 12:00:19 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36330 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2L1RAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 12:00:16 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: al@alarsen.net, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] [trivial]treewide: Fix typo in various drivers
Date: Sat, 29 Dec 2012 02:00:09 +0900
Message-Id: <1356714009-8015-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.1.rc3.27.g3b73c7d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in printk within various drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/bluetooth/ath3k.c                        | 2 +-
 drivers/devfreq/exynos4_bus.c                    | 2 +-
 drivers/firewire/ohci.c                          | 2 +-
 drivers/gpu/drm/i915/i915_debugfs.c              | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 2 +-
 drivers/rpmsg/virtio_rpmsg_bus.c                 | 2 +-
 drivers/target/sbp/sbp_target.c                  | 2 +-
 drivers/vhost/tcm_vhost.c                        | 2 +-
 drivers/xen/xen-pciback/pci_stub.c               | 2 +-
 fs/cifs/link.c                                   | 2 +-
 fs/hpfs/inode.c                                  | 2 +-
 fs/ocfs2/cluster/tcp.c                           | 2 +-
 fs/qnx6/inode.c                                  | 2 +-
 include/linux/dma-buf.h                          | 2 +-
 net/caif/cfcnfg.c                                | 2 +-
 scripts/basic/fixdep.c                           | 2 +-
 tools/kvm/kvm.c                                  | 2 +-
 17 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index fc2de55..9cd3cb8 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -338,7 +338,7 @@ static int ath3k_load_syscfg(struct usb_device *udev)
 
 	ret = ath3k_get_state(udev, &fw_state);
 	if (ret < 0) {
-		BT_ERR("Can't get state to change to load configration err");
+		BT_ERR("Can't get state to change to load configuration err");
 		return -EBUSY;
 	}
 
diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 88ddc77..e1ac076 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -636,7 +636,7 @@ static int exynos4_bus_target(struct device *dev, unsigned long *_freq,
 	if (old_freq == freq)
 		return 0;
 
-	dev_dbg(dev, "targetting %lukHz %luuV\n", freq, opp_get_voltage(opp));
+	dev_dbg(dev, "targeting %lukHz %luuV\n", freq, opp_get_voltage(opp));
 
 	mutex_lock(&data->lock);
 
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 834e71d..14e1fe5 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -329,7 +329,7 @@ module_param_named(quirks, param_quirks, int, 0644);
 MODULE_PARM_DESC(quirks, "Chip quirks (default = 0"
 	", nonatomic cycle timer = "	__stringify(QUIRK_CYCLE_TIMER)
 	", reset packet generation = "	__stringify(QUIRK_RESET_PACKET)
-	", AR/selfID endianess = "	__stringify(QUIRK_BE_HEADERS)
+	", AR/selfID endianness = "	__stringify(QUIRK_BE_HEADERS)
 	", no 1394a enhancements = "	__stringify(QUIRK_NO_1394A)
 	", disable MSI = "		__stringify(QUIRK_NO_MSI)
 	", TI SLLZ059 erratum = "	__stringify(QUIRK_TI_SLLZ059)
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index dde8b50..6b39e48 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1449,7 +1449,7 @@ static const char *swizzle_string(unsigned swizzle)
 	case I915_BIT_6_SWIZZLE_9_10_17:
 		return "bit9/bit10/bit17";
 	case I915_BIT_6_SWIZZLE_UNKNOWN:
-		return "unkown";
+		return "unknown";
 	}
 
 	return "bug";
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 24ad17e..4c3b67c 100644
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
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 027096f..d72b06b 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -839,7 +839,7 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 		/* farewell, ept, we don't need you anymore */
 		kref_put(&ept->refcount, __ept_release);
 	} else
-		dev_warn(dev, "msg received with no recepient\n");
+		dev_warn(dev, "msg received with no recipient\n");
 
 	/* publish the real size of the buffer */
 	sg_init_one(&sg, msg, RPMSG_BUF_SIZE);
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 0d6d7c1..be79388 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1718,7 +1718,7 @@ static struct se_node_acl *sbp_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	nacl = kzalloc(sizeof(struct sbp_nacl), GFP_KERNEL);
 	if (!nacl) {
-		pr_err("Unable to alocate struct sbp_nacl\n");
+		pr_err("Unable to allocate struct sbp_nacl\n");
 		return NULL;
 	}
 
diff --git a/drivers/vhost/tcm_vhost.c b/drivers/vhost/tcm_vhost.c
index aa31692..509ed1a 100644
--- a/drivers/vhost/tcm_vhost.c
+++ b/drivers/vhost/tcm_vhost.c
@@ -231,7 +231,7 @@ static struct se_node_acl *tcm_vhost_alloc_fabric_acl(
 
 	nacl = kzalloc(sizeof(struct tcm_vhost_nacl), GFP_KERNEL);
 	if (!nacl) {
-		pr_err("Unable to alocate struct tcm_vhost_nacl\n");
+		pr_err("Unable to allocate struct tcm_vhost_nacl\n");
 		return NULL;
 	}
 
diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 961d664..68dcc59 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -360,7 +360,7 @@ static int __devinit pcistub_init_device(struct pci_dev *dev)
 	if (!dev_data->pci_saved_state)
 		dev_err(&dev->dev, "Could not store PCI conf saved state!\n");
 	else {
-		dev_dbg(&dev->dev, "reseting (FLR, D3, etc) the device\n");
+		dev_dbg(&dev->dev, "resetting (FLR, D3, etc) the device\n");
 		__pci_reset_function_locked(dev);
 		pci_restore_state(dev);
 	}
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 51dc2fb..9f6c4c4 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -76,7 +76,7 @@ symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 	}
 	rc = crypto_shash_update(&sdescmd5->shash, link_str, link_len);
 	if (rc) {
-		cERROR(1, "%s: Could not update iwth link_str", __func__);
+		cERROR(1, "%s: Could not update with link_str", __func__);
 		goto symlink_hash_err;
 	}
 	rc = crypto_shash_final(&sdescmd5->shash, md5_hash);
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 804a9a8..405ab77 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -147,7 +147,7 @@ static void hpfs_write_inode_ea(struct inode *i, struct fnode *fnode)
 	/*if (le32_to_cpu(fnode->acl_size_l) || le16_to_cpu(fnode->acl_size_s)) {
 		   Some unknown structures like ACL may be in fnode,
 		   we'd better not overwrite them
-		hpfs_error(i->i_sb, "fnode %08x has some unknown HPFS386 stuctures", i->i_ino);
+		hpfs_error(i->i_sb, "fnode %08x has some unknown HPFS386 structures", i->i_ino);
 	} else*/ if (hpfs_sb(i->i_sb)->sb_eas >= 2) {
 		__le32 ea;
 		if (!uid_eq(i->i_uid, hpfs_sb(i->i_sb)->sb_uid) || hpfs_inode->i_ea_uid) {
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 1bfe880..a1d83c5 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -870,7 +870,7 @@ int o2net_register_handler(u32 msg_type, u32 key, u32 max_len,
 		/* we've had some trouble with handlers seemingly vanishing. */
 		mlog_bug_on_msg(o2net_handler_tree_lookup(msg_type, key, &p,
 							  &parent) == NULL,
-			        "couldn't find handler we *just* registerd "
+			        "couldn't find handler we *just* registered "
 				"for type %u key %08x\n", msg_type, key);
 	}
 	write_unlock(&o2net_handler_lock);
diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index b6addf5..57199a5 100644
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
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index eb48f38..139e673 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -53,7 +53,7 @@ struct dma_buf_attachment;
  * @begin_cpu_access: [optional] called before cpu access to invalidate cpu
  * 		      caches and allocate backing storage (if not yet done)
  * 		      respectively pin the objet into memory.
- * @end_cpu_access: [optional] called after cpu access to flush cashes.
+ * @end_cpu_access: [optional] called after cpu access to flush caches.
  * @kmap_atomic: maps a page from the buffer into kernel address
  * 		 space, users may not block until the subsequent unmap call.
  * 		 This callback must not sleep.
diff --git a/net/caif/cfcnfg.c b/net/caif/cfcnfg.c
index ba9cfd4..f1dbddb 100644
--- a/net/caif/cfcnfg.c
+++ b/net/caif/cfcnfg.c
@@ -402,7 +402,7 @@ cfcnfg_linkup_rsp(struct cflayer *layer, u8 channel_id, enum cfctrl_srv serv,
 
 	phyinfo = cfcnfg_get_phyinfo_rcu(cnfg, phyid);
 	if (phyinfo == NULL) {
-		pr_err("ERROR: Link Layer Device dissapeared"
+		pr_err("ERROR: Link Layer Device disappeared"
 				"while connecting\n");
 		goto unlock;
 	}
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
diff --git a/tools/kvm/kvm.c b/tools/kvm/kvm.c
index b283171..242948c 100644
--- a/tools/kvm/kvm.c
+++ b/tools/kvm/kvm.c
@@ -238,7 +238,7 @@ int kvm__init(struct kvm *kvm)
 	}
 
 	if (kvm__check_extensions(kvm)) {
-		pr_err("A required KVM extention is not supported by OS");
+		pr_err("A required KVM extension is not supported by OS");
 		ret = -ENOSYS;
 		goto err_vm_fd;
 	}
-- 
1.8.1.rc3.27.g3b73c7d

