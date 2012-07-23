Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2GWNjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:39:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45331 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2GWNjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:39:09 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, bhelgaas@google.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] pci: hotplug: Fix typo in pci
Date: Mon, 23 Jul 2012 22:39:51 +0900
Message-Id: <1343050791-20564-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.11.3.287.ge771946
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in drivers/pci/hotplug.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/pci/hotplug/ibmphp_core.c | 2 +-
 drivers/pci/hotplug/ibmphp_ebda.c | 2 +-
 drivers/pci/hotplug/ibmphp_pci.c  | 2 +-
 drivers/pci/setup-bus.c           | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 4fda7e6..01cc054 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -760,7 +760,7 @@ static u8 bus_structure_fixup(u8 busno)
 	for (dev->devfn = 0; dev->devfn < 256; dev->devfn += 8) {
 		if (!pci_read_config_word(dev, PCI_VENDOR_ID, &l) &&
 					(l != 0x0000) && (l != 0xffff)) {
-			debug("%s - Inside bus_struture_fixup()\n",
+			debug("%s - Inside bus_structure_fixup()\n",
 							__func__);
 			pci_scan_bus(busno, ibmphp_pci_bus->ops, NULL);
 			break;
diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 714ca5c..9df78bc 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -784,7 +784,7 @@ static int __init ebda_rsrc_controller (void)
 		hpc_ptr->ctlr_relative_id = ctlr;
 		hpc_ptr->slot_count = slot_num;
 		hpc_ptr->bus_count = bus_num;
-		debug ("now enter ctlr data struture ---\n");
+		debug ("now enter ctlr data structure ---\n");
 		debug ("ctlr id: %x\n", ctlr_id);
 		debug ("ctlr_relative_id: %x\n", hpc_ptr->ctlr_relative_id);
 		debug ("count of slots controlled by this ctlr: %x\n", slot_num);
diff --git a/drivers/pci/hotplug/ibmphp_pci.c b/drivers/pci/hotplug/ibmphp_pci.c
index 7b09e16..c60f5f3 100644
--- a/drivers/pci/hotplug/ibmphp_pci.c
+++ b/drivers/pci/hotplug/ibmphp_pci.c
@@ -109,7 +109,7 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 
 		cur_func->function = function;
 
-		debug ("inside the loop, cur_func->busno = %x, cur_func->device = %x, cur_func->funcion = %x\n",
+		debug ("inside the loop, cur_func->busno = %x, cur_func->device = %x, cur_func->function = %x\n",
 			cur_func->busno, cur_func->device, cur_func->function);
 
 		pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_VENDOR_ID, &vendor_id);
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8fa2d4b..a7ba6de 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -308,7 +308,7 @@ static void __assign_resources_sorted(struct list_head *head,
 	 * Should not assign requested resources at first.
 	 *   they could be adjacent, so later reassign can not reallocate
 	 *   them one by one in parent resource window.
-	 * Try to assign requested + add_size at begining
+	 * Try to assign requested + add_size at beginning
 	 *  if could do that, could get out early.
 	 *  if could not do that, we still try to assign requested at first,
 	 *    then try to reassign add_size for some resources.
-- 
1.7.11.3.287.ge771946

