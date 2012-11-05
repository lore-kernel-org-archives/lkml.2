Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2KEOas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:30:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43496 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab2KEOaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:30:46 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Fix typo in multiple drivers
Date: Mon,  5 Nov 2012 23:30:40 +0900
Message-Id: <1352125840-16269-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in multiple drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/kernel/kprobes-test.c       | 2 +-
 arch/blackfin/mm/sram-alloc.c        | 2 +-
 drivers/isdn/hardware/mISDN/hfcpci.c | 2 +-
 drivers/isdn/hisax/hfc_pci.c         | 2 +-
 drivers/isdn/hisax/hfc_sx.c          | 2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c   | 2 +-
 drivers/usb/gadget/tcm_usb_gadget.c  | 2 +-
 drivers/vhost/tcm_vhost.c            | 2 +-
 drivers/xen/xen-pciback/pci_stub.c   | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 1862d8f..0cd63d0 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -1598,7 +1598,7 @@ static int __init run_all_tests(void)
 {
 	int ret = 0;
 
-	pr_info("Begining kprobe tests...\n");
+	pr_info("Beginning kprobe tests...\n");
 
 #ifndef CONFIG_THUMB2_KERNEL
 
diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
index 342e378..1f3b3ef 100644
--- a/arch/blackfin/mm/sram-alloc.c
+++ b/arch/blackfin/mm/sram-alloc.c
@@ -191,7 +191,7 @@ static irqreturn_t l2_ecc_err(int irq, void *dev_id)
 {
 	int status;
 
-	printk(KERN_ERR "L2 ecc error happend\n");
+	printk(KERN_ERR "L2 ecc error happened\n");
 	status = bfin_read32(L2CTL0_STAT);
 	if (status & 0x1)
 		printk(KERN_ERR "Core channel error type:0x%x, addr:0x%x\n",
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 81363ff..6e99d73 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -490,7 +490,7 @@ receive_dmsg(struct hfc_pci *hc)
 		    (df->data[le16_to_cpu(zp->z1)])) {
 			if (dch->debug & DEBUG_HW)
 				printk(KERN_DEBUG
-				       "empty_fifo hfcpci paket inv. len "
+				       "empty_fifo hfcpci packet inv. len "
 				       "%d or crc %d\n",
 				       rcnt,
 				       df->data[le16_to_cpu(zp->z1)]);
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index 334fa90..f60d4be 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -354,7 +354,7 @@ receive_dmsg(struct IsdnCardState *cs)
 		if ((rcnt > MAX_DFRAME_LEN + 3) || (rcnt < 4) ||
 		    (df->data[zp->z1])) {
 			if (cs->debug & L1_DEB_WARN)
-				debugl1(cs, "empty_fifo hfcpci paket inv. len %d or crc %d", rcnt, df->data[zp->z1]);
+				debugl1(cs, "empty_fifo hfcpci packet inv. len %d or crc %d", rcnt, df->data[zp->z1]);
 #ifdef ERROR_STATISTIC
 			cs->err_rx++;
 #endif
diff --git a/drivers/isdn/hisax/hfc_sx.c b/drivers/isdn/hisax/hfc_sx.c
index 4db846b..4ec279c 100644
--- a/drivers/isdn/hisax/hfc_sx.c
+++ b/drivers/isdn/hisax/hfc_sx.c
@@ -270,7 +270,7 @@ read_fifo(struct IsdnCardState *cs, u_char fifo, int trans_max)
 
 		if ((count > fifo_size) || (count < 4)) {
 			if (cs->debug & L1_DEB_WARN)
-				debugl1(cs, "hfcsx_read_fifo %d paket inv. len %d ", fifo , count);
+				debugl1(cs, "hfcsx_read_fifo %d packet inv. len %d ", fifo , count);
 			while (count) {
 				count--; /* empty fifo */
 				Read_hfc(cs, HFCSX_FIF_DRD);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 2358c16..c0b682c 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -367,7 +367,7 @@ static struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(
 
 	nacl = kzalloc(sizeof(struct tcm_qla2xxx_nacl), GFP_KERNEL);
 	if (!nacl) {
-		pr_err("Unable to alocate struct tcm_qla2xxx_nacl\n");
+		pr_err("Unable to allocate struct tcm_qla2xxx_nacl\n");
 		return NULL;
 	}
 
diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index 97e68b3..3849218 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1384,7 +1384,7 @@ static struct se_node_acl *usbg_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	nacl = kzalloc(sizeof(struct usbg_nacl), GFP_KERNEL);
 	if (!nacl) {
-		printk(KERN_ERR "Unable to alocate struct usbg_nacl\n");
+		printk(KERN_ERR "Unable to allocate struct usbg_nacl\n");
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
-- 
1.8.0.rc3.16.g8ead1bf

