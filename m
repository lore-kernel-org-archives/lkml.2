Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0FLVja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 17:39:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61483 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0FLVj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 17:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iRe6UN5O7+ou6IJTaHIbpab1fvZR2zOwoAHGh5WJcNM/B0RPxDCghN0EWm5guwYWU4
         KaU6IM5cUZL4irEVcMakSm5h+tRffUMypXS9Pb68Cc6VdGhFH3SMFz8asqT9/rnwDJ+8
         zUxGxZuzpKWaZcKLNmrk7kc+SymjzpxUbmha8=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de, abbotti@mev.co.uk
Cc: wfp5p@virginia.edu, andre.goddard@gmail.com, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH] Staging: comedi: drivers: fix coding style issues in me4000.c
Date: Sat, 12 Jun 2010 16:39:18 -0500
Message-Id: <1276378758-14533-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the me4000.c file that fixes up the following
issues:

ERROR: space required after that close brace '}' 		   x 13
ERROR: spaces required around that ':' (ctx:VxV) 		   x  3
WARNING: line over 80 characters                 		   x 96
WARNING: braces {} are not necessary for any arm of this statement x  2

Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/comedi/drivers/me4000.c |  416 +++++++++++++++++--------------
 1 files changed, 227 insertions(+), 189 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 8b9fa0f..ab4ab75 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -91,22 +91,22 @@ static DEFINE_PCI_DEVICE_TABLE(me4000_pci_table) = {
 MODULE_DEVICE_TABLE(pci, me4000_pci_table);
 
 static const struct me4000_board me4000_boards[] = {
-	{"ME-4650", 0x4650, {0, 0}, {16, 0, 0, 0}, {4}, {0}},
+	{"ME-4650", 0x4650, {0, 0}, {16, 0, 0, 0}, {4}, {0} },
 
-	{"ME-4660", 0x4660, {0, 0}, {32, 0, 16, 0}, {4}, {3}},
-	{"ME-4660i", 0x4661, {0, 0}, {32, 0, 16, 0}, {4}, {3}},
-	{"ME-4660s", 0x4662, {0, 0}, {32, 8, 16, 0}, {4}, {3}},
-	{"ME-4660is", 0x4663, {0, 0}, {32, 8, 16, 0}, {4}, {3}},
+	{"ME-4660", 0x4660, {0, 0}, {32, 0, 16, 0}, {4}, {3} },
+	{"ME-4660i", 0x4661, {0, 0}, {32, 0, 16, 0}, {4}, {3} },
+	{"ME-4660s", 0x4662, {0, 0}, {32, 8, 16, 0}, {4}, {3} },
+	{"ME-4660is", 0x4663, {0, 0}, {32, 8, 16, 0}, {4}, {3} },
 
-	{"ME-4670", 0x4670, {4, 0}, {32, 0, 16, 1}, {4}, {3}},
-	{"ME-4670i", 0x4671, {4, 0}, {32, 0, 16, 1}, {4}, {3}},
-	{"ME-4670s", 0x4672, {4, 0}, {32, 8, 16, 1}, {4}, {3}},
-	{"ME-4670is", 0x4673, {4, 0}, {32, 8, 16, 1}, {4}, {3}},
+	{"ME-4670", 0x4670, {4, 0}, {32, 0, 16, 1}, {4}, {3} },
+	{"ME-4670i", 0x4671, {4, 0}, {32, 0, 16, 1}, {4}, {3} },
+	{"ME-4670s", 0x4672, {4, 0}, {32, 8, 16, 1}, {4}, {3} },
+	{"ME-4670is", 0x4673, {4, 0}, {32, 8, 16, 1}, {4}, {3} },
 
-	{"ME-4680", 0x4680, {4, 4}, {32, 0, 16, 1}, {4}, {3}},
-	{"ME-4680i", 0x4681, {4, 4}, {32, 0, 16, 1}, {4}, {3}},
-	{"ME-4680s", 0x4682, {4, 4}, {32, 8, 16, 1}, {4}, {3}},
-	{"ME-4680is", 0x4683, {4, 4}, {32, 8, 16, 1}, {4}, {3}},
+	{"ME-4680", 0x4680, {4, 4}, {32, 0, 16, 1}, {4}, {3} },
+	{"ME-4680i", 0x4681, {4, 4}, {32, 0, 16, 1}, {4}, {3} },
+	{"ME-4680s", 0x4682, {4, 4}, {32, 8, 16, 1}, {4}, {3} },
+	{"ME-4680is", 0x4683, {4, 4}, {32, 8, 16, 1}, {4}, {3} },
 
 	{0},
 };
@@ -120,10 +120,10 @@ static int me4000_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
 static int me4000_detach(struct comedi_device *dev);
 static struct comedi_driver driver_me4000 = {
-driver_name:"me4000",
-module:THIS_MODULE,
-attach:me4000_attach,
-detach:me4000_detach,
+driver_name: "me4000",
+module : THIS_MODULE,
+attach : me4000_attach,
+detach : me4000_detach,
 };
 
 /*-----------------------------------------------------------------------------
@@ -302,8 +302,8 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			if (request_irq(info->irq, me4000_ai_isr,
 					IRQF_SHARED, "ME-4000", dev)) {
 				printk
-				    ("comedi%d: me4000: me4000_attach(): Unable to allocate irq\n",
-				     dev->minor);
+				    ("comedi%d: me4000: me4000_attach(): "
+				     "Unable to allocate irq\n", dev->minor);
 			} else {
 				dev->read_subdev = s;
 				s->subdev_flags |= SDF_CMD_READ;
@@ -313,8 +313,8 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			}
 		} else {
 			printk(KERN_WARNING
-			       "comedi%d: me4000: me4000_attach(): No interrupt available\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_attach(): "
+			       "No interrupt available\n", dev->minor);
 		}
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
@@ -409,10 +409,16 @@ static int me4000_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 			for (i = 0; i < ME4000_BOARD_VERSIONS; i++) {
 				if (me4000_boards[i].device_id ==
 				    pci_device->device) {
-					/* Was a particular bus/slot requested? */
+					/*
+					 * Was a particular
+					 * bus/slot requested?
+					 */
 					if ((it->options[0] != 0)
 					    || (it->options[1] != 0)) {
-						/* Are we on the wrong bus/slot? */
+						/*
+						 * Are we on the wrong
+						 * bus/slot?
+						 */
 						if (pci_device->bus->number !=
 						    it->options[0]
 						    ||
@@ -433,14 +439,16 @@ static int me4000_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	printk(KERN_ERR
-	       "comedi%d: me4000: me4000_probe(): No supported board found (req. bus/slot : %d/%d)\n",
+	       "comedi%d: me4000: me4000_probe(): "
+	       "No supported board found (req. bus/slot : %d/%d)\n",
 	       dev->minor, it->options[0], it->options[1]);
 	return -ENODEV;
 
 found:
 
 	printk(KERN_INFO
-	       "comedi%d: me4000: me4000_probe(): Found %s at PCI bus %d, slot %d\n",
+	       "comedi%d: me4000: me4000_probe(): "
+	       "Found %s at PCI bus %d, slot %d\n",
 	       dev->minor, me4000_boards[i].name, pci_device->bus->number,
 	       PCI_SLOT(pci_device->devfn));
 
@@ -451,8 +459,8 @@ found:
 	result = comedi_pci_enable(pci_device, dev->board_name);
 	if (result) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_probe(): Cannot enable PCI device and request I/O regions\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_probe(): Cannot enable PCI "
+		       "device and request I/O regions\n", dev->minor);
 		return result;
 	}
 
@@ -460,16 +468,16 @@ found:
 	result = get_registers(dev, pci_device);
 	if (result) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_probe(): Cannot get registers\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_probe(): "
+		       "Cannot get registers\n", dev->minor);
 		return result;
 	}
 	/* Initialize board info */
 	result = init_board_info(dev, pci_device);
 	if (result) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_probe(): Cannot init baord info\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_probe(): "
+		       "Cannot init baord info\n", dev->minor);
 		return result;
 	}
 
@@ -477,8 +485,8 @@ found:
 	result = init_ao_context(dev);
 	if (result) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_probe(): Cannot init ao context\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_probe(): "
+		       "Cannot init ao context\n", dev->minor);
 		return result;
 	}
 
@@ -486,8 +494,8 @@ found:
 	result = init_ai_context(dev);
 	if (result) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_probe(): Cannot init ai context\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_probe(): "
+		       "Cannot init ai context\n", dev->minor);
 		return result;
 	}
 
@@ -495,8 +503,8 @@ found:
 	result = init_dio_context(dev);
 	if (result) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_probe(): Cannot init dio context\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_probe(): "
+		       "Cannot init dio context\n", dev->minor);
 		return result;
 	}
 
@@ -504,8 +512,8 @@ found:
 	result = init_cnt_context(dev);
 	if (result) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_probe(): Cannot init cnt context\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_probe(): "
+		       "Cannot init cnt context\n", dev->minor);
 		return result;
 	}
 
@@ -513,8 +521,8 @@ found:
 	result = xilinx_download(dev);
 	if (result) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_probe(): Can't download firmware\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_probe(): "
+		       "Can't download firmware\n", dev->minor);
 		return result;
 	}
 
@@ -535,24 +543,24 @@ static int get_registers(struct comedi_device *dev, struct pci_dev *pci_dev_p)
 
 	CALL_PDEBUG("In get_registers()\n");
 
-    /*--------------------------- plx regbase ---------------------------------*/
+    /*--------------------------- plx regbase -------------------------------*/
 
 	info->plx_regbase = pci_resource_start(pci_dev_p, 1);
 	if (info->plx_regbase == 0) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: get_registers(): PCI base address 1 is not available\n",
-		       dev->minor);
+		       "comedi%d: me4000: get_registers(): "
+		       "PCI base address 1 is not available\n", dev->minor);
 		return -ENODEV;
 	}
 	info->plx_regbase_size = pci_resource_len(pci_dev_p, 1);
 
-    /*--------------------------- me4000 regbase ------------------------------*/
+    /*--------------------------- me4000 regbase ----------------------------*/
 
 	info->me4000_regbase = pci_resource_start(pci_dev_p, 2);
 	if (info->me4000_regbase == 0) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: get_registers(): PCI base address 2 is not available\n",
-		       dev->minor);
+		       "comedi%d: me4000: get_registers(): "
+		       "PCI base address 2 is not available\n", dev->minor);
 		return -ENODEV;
 	}
 	info->me4000_regbase_size = pci_resource_len(pci_dev_p, 2);
@@ -562,19 +570,19 @@ static int get_registers(struct comedi_device *dev, struct pci_dev *pci_dev_p)
 	info->timer_regbase = pci_resource_start(pci_dev_p, 3);
 	if (info->timer_regbase == 0) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: get_registers(): PCI base address 3 is not available\n",
-		       dev->minor);
+		       "comedi%d: me4000: get_registers(): "
+		       "PCI base address 3 is not available\n", dev->minor);
 		return -ENODEV;
 	}
 	info->timer_regbase_size = pci_resource_len(pci_dev_p, 3);
 
-    /*--------------------------- program regbase ------------------------------*/
+    /*--------------------------- program regbase ----------------------------*/
 
 	info->program_regbase = pci_resource_start(pci_dev_p, 5);
 	if (info->program_regbase == 0) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: get_registers(): PCI base address 5 is not available\n",
-		       dev->minor);
+		       "comedi%d: me4000: get_registers(): "
+		       "PCI base address 5 is not available\n", dev->minor);
 		return -ENODEV;
 	}
 	info->program_regbase_size = pci_resource_len(pci_dev_p, 5);
@@ -800,8 +808,8 @@ static int xilinx_download(struct comedi_device *dev)
 	udelay(20);
 	if (!(inl(info->plx_regbase + PLX_INTCSR) & 0x20)) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: xilinx_download(): Can't init Xilinx\n",
-		       dev->minor);
+		       "comedi%d: me4000: xilinx_download(): "
+		       "Can't init Xilinx\n", dev->minor);
 		return -EIO;
 	}
 
@@ -810,8 +818,8 @@ static int xilinx_download(struct comedi_device *dev)
 	value &= ~0x100;
 	outl(value, info->plx_regbase + PLX_ICR);
 	if (FIRMWARE_NOT_AVAILABLE) {
-		comedi_error(dev,
-			     "xilinx firmware unavailable due to licensing, aborting");
+		comedi_error(dev, "xilinx firmware unavailable "
+			     "due to licensing, aborting");
 		return -EIO;
 	} else {
 		/* Download Xilinx firmware */
@@ -826,7 +834,8 @@ static int xilinx_download(struct comedi_device *dev)
 			/* Check if BUSY flag is low */
 			if (inl(info->plx_regbase + PLX_ICR) & 0x20) {
 				printk(KERN_ERR
-				       "comedi%d: me4000: xilinx_download(): Xilinx is still busy (idx = %d)\n",
+				       "comedi%d: me4000: xilinx_download(): "
+				       "Xilinx is still busy (idx = %d)\n",
 				       dev->minor, idx);
 				return -EIO;
 			}
@@ -837,11 +846,11 @@ static int xilinx_download(struct comedi_device *dev)
 	if (inl(info->plx_regbase + PLX_ICR) & 0x4) {
 	} else {
 		printk(KERN_ERR
-		       "comedi%d: me4000: xilinx_download(): DONE flag is not set\n",
-		       dev->minor);
+		       "comedi%d: me4000: xilinx_download(): "
+		       "DONE flag is not set\n", dev->minor);
 		printk(KERN_ERR
-		       "comedi%d: me4000: xilinx_download(): Download not successful\n",
-		       dev->minor);
+		       "comedi%d: me4000: xilinx_download(): "
+		       "Download not successful\n", dev->minor);
 		return -EIO;
 	}
 
@@ -902,7 +911,10 @@ static int reset_board(struct comedi_device *dev)
 	me4000_outl(dev, ME4000_AO_DEMUX_ADJUST_VALUE,
 		    info->me4000_regbase + ME4000_AO_DEMUX_ADJUST_REG);
 
-	/* Set digital I/O direction for port 0 to output on isolated versions */
+	/*
+	 * Set digital I/O direction for port 0
+	 * to output on isolated versions
+	 */
 	if (!(me4000_inl(dev, info->me4000_regbase + ME4000_DIO_DIR_REG) & 0x1)) {
 		me4000_outl(dev, 0x1,
 			    info->me4000_regbase + ME4000_DIO_CTRL_REG);
@@ -950,8 +962,8 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 		return 0;
 	} else if (insn->n > 1) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_insn_read(): Invalid instruction length %d\n",
-		       dev->minor, insn->n);
+		       "comedi%d: me4000: me4000_ai_insn_read(): "
+		       "Invalid instruction length %d\n", dev->minor, insn->n);
 		return -EINVAL;
 	}
 
@@ -970,8 +982,8 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 		break;
 	default:
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_insn_read(): Invalid range specified\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_insn_read(): "
+		       "Invalid range specified\n", dev->minor);
 		return -EINVAL;
 	}
 
@@ -980,8 +992,8 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 	case AREF_COMMON:
 		if (chan >= thisboard->ai.count) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_insn_read(): Analog input is not available\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_insn_read(): "
+			       "Analog input is not available\n", dev->minor);
 			return -EINVAL;
 		}
 		entry |= ME4000_AI_LIST_INPUT_SINGLE_ENDED | chan;
@@ -990,23 +1002,24 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 	case AREF_DIFF:
 		if (rang == 0 || rang == 1) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_insn_read(): Range must be bipolar when aref = diff\n",
+			       "comedi%d: me4000: me4000_ai_insn_read(): "
+			       "Range must be bipolar when aref = diff\n",
 			       dev->minor);
 			return -EINVAL;
 		}
 
 		if (chan >= thisboard->ai.diff_count) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_insn_read(): Analog input is not available\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_insn_read(): "
+			       "Analog input is not available\n", dev->minor);
 			return -EINVAL;
 		}
 		entry |= ME4000_AI_LIST_INPUT_DIFFERENTIAL | chan;
 		break;
 	default:
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_insn_read(): Invalid aref specified\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_insn_read(): "
+		       "Invalid aref specified\n", dev->minor);
 		return -EINVAL;
 	}
 
@@ -1045,8 +1058,8 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 	    (me4000_inl(dev, info->ai_context.status_reg) &
 	     ME4000_AI_STATUS_BIT_EF_DATA)) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_insn_read(): Value not available after wait\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_insn_read(): "
+		       "Value not available after wait\n", dev->minor);
 		return -EIO;
 	}
 
@@ -1086,24 +1099,24 @@ static int ai_check_chanlist(struct comedi_device *dev,
 	/* Check whether a channel list is available */
 	if (!cmd->chanlist_len) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: ai_check_chanlist(): No channel list available\n",
-		       dev->minor);
+		       "comedi%d: me4000: ai_check_chanlist(): "
+		       "No channel list available\n", dev->minor);
 		return -EINVAL;
 	}
 
 	/* Check the channel list size */
 	if (cmd->chanlist_len > ME4000_AI_CHANNEL_LIST_COUNT) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: ai_check_chanlist(): Channel list is to large\n",
-		       dev->minor);
+		       "comedi%d: me4000: ai_check_chanlist(): "
+		       "Channel list is to large\n", dev->minor);
 		return -EINVAL;
 	}
 
 	/* Check the pointer */
 	if (!cmd->chanlist) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: ai_check_chanlist(): NULL pointer to channel list\n",
-		       dev->minor);
+		       "comedi%d: me4000: ai_check_chanlist(): "
+		       "NULL pointer to channel list\n", dev->minor);
 		return -EFAULT;
 	}
 
@@ -1112,7 +1125,8 @@ static int ai_check_chanlist(struct comedi_device *dev,
 	for (i = 0; i < cmd->chanlist_len; i++) {
 		if (CR_AREF(cmd->chanlist[i]) != aref) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: ai_check_chanlist(): Mode is not equal for all entries\n",
+			       "comedi%d: me4000: ai_check_chanlist(): "
+			       "Mode is not equal for all entries\n",
 			       dev->minor);
 			return -EINVAL;
 		}
@@ -1124,8 +1138,8 @@ static int ai_check_chanlist(struct comedi_device *dev,
 			if (CR_CHAN(cmd->chanlist[i]) >=
 			    thisboard->ai.diff_count) {
 				printk(KERN_ERR
-				       "comedi%d: me4000: ai_check_chanlist(): Channel number to high\n",
-				       dev->minor);
+				       "comedi%d: me4000: ai_check_chanlist():"
+				       " Channel number to high\n", dev->minor);
 				return -EINVAL;
 			}
 		}
@@ -1133,8 +1147,8 @@ static int ai_check_chanlist(struct comedi_device *dev,
 		for (i = 0; i < cmd->chanlist_len; i++) {
 			if (CR_CHAN(cmd->chanlist[i]) >= thisboard->ai.count) {
 				printk(KERN_ERR
-				       "comedi%d: me4000: ai_check_chanlist(): Channel number to high\n",
-				       dev->minor);
+				       "comedi%d: me4000: ai_check_chanlist(): "
+				       "Channel number to high\n", dev->minor);
 				return -EINVAL;
 			}
 		}
@@ -1146,7 +1160,9 @@ static int ai_check_chanlist(struct comedi_device *dev,
 			if (CR_RANGE(cmd->chanlist[i]) != 1 &&
 			    CR_RANGE(cmd->chanlist[i]) != 2) {
 				printk(KERN_ERR
-				       "comedi%d: me4000: ai_check_chanlist(): Bipolar is not selected in differential mode\n",
+				       "comedi%d: me4000: ai_check_chanlist(): "
+				       "Bipolar is not selected in "
+				       "differential mode\n",
 				       dev->minor);
 				return -EINVAL;
 			}
@@ -1330,21 +1346,19 @@ static int ai_write_chanlist(struct comedi_device *dev,
 
 		entry = chan;
 
-		if (rang == 0) {
+		if (rang == 0)
 			entry |= ME4000_AI_LIST_RANGE_UNIPOLAR_2_5;
-		} else if (rang == 1) {
+		else if (rang == 1)
 			entry |= ME4000_AI_LIST_RANGE_UNIPOLAR_10;
-		} else if (rang == 2) {
+		else if (rang == 2)
 			entry |= ME4000_AI_LIST_RANGE_BIPOLAR_2_5;
-		} else {
+		else
 			entry |= ME4000_AI_LIST_RANGE_BIPOLAR_10;
-		}
 
-		if (aref == SDF_DIFF) {
+		if (aref == SDF_DIFF)
 			entry |= ME4000_AI_LIST_INPUT_DIFFERENTIAL;
-		} else {
+		else
 			entry |= ME4000_AI_LIST_INPUT_SINGLE_ENDED;
-		}
 
 		me4000_outl(dev, entry, info->ai_context.channel_list_reg);
 	}
@@ -1454,8 +1468,8 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		break;
 	default:
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid start source\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "Invalid start source\n", dev->minor);
 		cmd->start_src = TRIG_NOW;
 		err++;
 	}
@@ -1470,8 +1484,8 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		break;
 	default:
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid scan begin source\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "Invalid scan begin source\n", dev->minor);
 		cmd->scan_begin_src = TRIG_FOLLOW;
 		err++;
 	}
@@ -1485,8 +1499,8 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		break;
 	default:
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid convert source\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "Invalid convert source\n", dev->minor);
 		cmd->convert_src = TRIG_TIMER;
 		err++;
 	}
@@ -1500,8 +1514,8 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		break;
 	default:
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid scan end source\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "Invalid scan end source\n", dev->minor);
 		cmd->scan_end_src = TRIG_NONE;
 		err++;
 	}
@@ -1515,8 +1529,8 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		break;
 	default:
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid stop source\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "Invalid stop source\n", dev->minor);
 		cmd->stop_src = TRIG_NONE;
 		err++;
 	}
@@ -1546,8 +1560,8 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		   cmd->convert_src == TRIG_EXT) {
 	} else {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid start trigger combination\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "Invalid start trigger combination\n", dev->minor);
 		cmd->start_src = TRIG_NOW;
 		cmd->scan_begin_src = TRIG_FOLLOW;
 		cmd->convert_src = TRIG_TIMER;
@@ -1563,8 +1577,8 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		   cmd->scan_end_src == TRIG_COUNT) {
 	} else {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid stop trigger combination\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "Invalid stop trigger combination\n", dev->minor);
 		cmd->stop_src = TRIG_NONE;
 		cmd->scan_end_src = TRIG_NONE;
 		err++;
@@ -1577,29 +1591,29 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 	 */
 	if (cmd->chanlist_len < 1) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): No channel list\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "No channel list\n", dev->minor);
 		cmd->chanlist_len = 1;
 		err++;
 	}
 	if (init_ticks < 66) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): Start arg to low\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "Start arg to low\n", dev->minor);
 		cmd->start_arg = 2000;
 		err++;
 	}
 	if (scan_ticks && scan_ticks < 67) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): Scan begin arg to low\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "Scan begin arg to low\n", dev->minor);
 		cmd->scan_begin_arg = 2031;
 		err++;
 	}
 	if (chan_ticks < 66) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_do_cmd_test(): Convert arg to low\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+		       "Convert arg to low\n", dev->minor);
 		cmd->convert_arg = 2000;
 		err++;
 	}
@@ -1617,23 +1631,25 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		/* Check timer arguments */
 		if (init_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid start arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid start arg\n", dev->minor);
 			cmd->start_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
 		if (chan_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid convert arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid convert arg\n", dev->minor);
 			cmd->convert_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
 		if (scan_ticks <= cmd->chanlist_len * chan_ticks) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid scan end arg\n",
-			       dev->minor);
-			cmd->scan_end_arg = 2000 * cmd->chanlist_len + 31;	/*  At least one tick more */
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid scan end arg\n", dev->minor);
+
+			/*  At least one tick more */
+			cmd->scan_end_arg = 2000 * cmd->chanlist_len + 31;
 			err++;
 		}
 	} else if (cmd->start_src == TRIG_NOW &&
@@ -1643,15 +1659,15 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		/* Check timer arguments */
 		if (init_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid start arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid start arg\n", dev->minor);
 			cmd->start_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
 		if (chan_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid convert arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid convert arg\n", dev->minor);
 			cmd->convert_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
@@ -1662,23 +1678,25 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		/* Check timer arguments */
 		if (init_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid start arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid start arg\n", dev->minor);
 			cmd->start_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
 		if (chan_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid convert arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid convert arg\n", dev->minor);
 			cmd->convert_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
 		if (scan_ticks <= cmd->chanlist_len * chan_ticks) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid scan end arg\n",
-			       dev->minor);
-			cmd->scan_end_arg = 2000 * cmd->chanlist_len + 31;	/*  At least one tick more */
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid scan end arg\n", dev->minor);
+
+			/*  At least one tick more */
+			cmd->scan_end_arg = 2000 * cmd->chanlist_len + 31;
 			err++;
 		}
 	} else if (cmd->start_src == TRIG_EXT &&
@@ -1688,15 +1706,15 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		/* Check timer arguments */
 		if (init_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid start arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid start arg\n", dev->minor);
 			cmd->start_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
 		if (chan_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid convert arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid convert arg\n", dev->minor);
 			cmd->convert_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
@@ -1707,15 +1725,15 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		/* Check timer arguments */
 		if (init_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid start arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid start arg\n", dev->minor);
 			cmd->start_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
 		if (chan_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid convert arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid convert arg\n", dev->minor);
 			cmd->convert_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
@@ -1726,8 +1744,8 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 		/* Check timer arguments */
 		if (init_ticks < ME4000_AI_MIN_TICKS) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid start arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid start arg\n", dev->minor);
 			cmd->start_arg = 2000;	/*  66 ticks at least */
 			err++;
 		}
@@ -1735,8 +1753,8 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 	if (cmd->stop_src == TRIG_COUNT) {
 		if (cmd->stop_arg == 0) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid stop arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid stop arg\n", dev->minor);
 			cmd->stop_arg = 1;
 			err++;
 		}
@@ -1744,8 +1762,8 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 	if (cmd->scan_end_src == TRIG_COUNT) {
 		if (cmd->scan_end_arg == 0) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_do_cmd_test(): Invalid scan end arg\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_do_cmd_test(): "
+			       "Invalid scan end arg\n", dev->minor);
 			cmd->scan_end_arg = 1;
 			err++;
 		}
@@ -1786,8 +1804,8 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 	/* Check if irq number is right */
 	if (irq != ai_context->irq) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ai_isr(): Incorrect interrupt num: %d\n",
-		       dev->minor, irq);
+		       "comedi%d: me4000: me4000_ai_isr(): "
+		       "Incorrect interrupt num: %d\n", dev->minor, irq);
 		return IRQ_HANDLED;
 	}
 
@@ -1806,7 +1824,10 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 			ISR_PDEBUG("me4000_ai_isr(): Fifo full\n");
 			c = ME4000_AI_FIFO_COUNT;
 
-			/* FIFO overflow, so stop conversion and disable all interrupts */
+			/*
+			 * FIFO overflow, so stop conversion
+			 * and disable all interrupts
+			 */
 			tmp |= ME4000_AI_CTRL_BIT_IMMEDIATE_STOP;
 			tmp &= ~(ME4000_AI_CTRL_BIT_HF_IRQ |
 				 ME4000_AI_CTRL_BIT_SC_IRQ);
@@ -1815,8 +1836,8 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 			s->async->events |= COMEDI_CB_ERROR | COMEDI_CB_EOA;
 
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_isr(): FIFO overflow\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_isr(): "
+			       "FIFO overflow\n", dev->minor);
 		} else if ((tmp & ME4000_AI_STATUS_BIT_FF_DATA)
 			   && !(tmp & ME4000_AI_STATUS_BIT_HF_DATA)
 			   && (tmp & ME4000_AI_STATUS_BIT_EF_DATA)) {
@@ -1827,11 +1848,14 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 			c = ME4000_AI_FIFO_COUNT / 2;
 		} else {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_isr(): Can't determine state of fifo\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_isr(): "
+			       "Can't determine state of fifo\n", dev->minor);
 			c = 0;
 
-			/* Undefined state, so stop conversion and disable all interrupts */
+			/*
+			 * Undefined state, so stop conversion
+			 * and disable all interrupts
+			 */
 			tmp |= ME4000_AI_CTRL_BIT_IMMEDIATE_STOP;
 			tmp &= ~(ME4000_AI_CTRL_BIT_HF_IRQ |
 				 ME4000_AI_CTRL_BIT_SC_IRQ);
@@ -1840,8 +1864,8 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 			s->async->events |= COMEDI_CB_ERROR | COMEDI_CB_EOA;
 
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_ai_isr(): Undefined FIFO state\n",
-			       dev->minor);
+			       "comedi%d: me4000: me4000_ai_isr(): "
+			       "Undefined FIFO state\n", dev->minor);
 		}
 
 		ISR_PDEBUG("me4000_ai_isr(): Try to read %d values\n", c);
@@ -1852,7 +1876,10 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 			lval ^= 0x8000;
 
 			if (!comedi_buf_put(s->async, lval)) {
-				/* Buffer overflow, so stop conversion and disable all interrupts */
+				/*
+				 * Buffer overflow, so stop conversion
+				 * and disable all interrupts
+				 */
 				tmp |= ME4000_AI_CTRL_BIT_IMMEDIATE_STOP;
 				tmp &= ~(ME4000_AI_CTRL_BIT_HF_IRQ |
 					 ME4000_AI_CTRL_BIT_SC_IRQ);
@@ -1861,8 +1888,8 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 				s->async->events |= COMEDI_CB_OVERFLOW;
 
 				printk(KERN_ERR
-				       "comedi%d: me4000: me4000_ai_isr(): Buffer overflow\n",
-				       dev->minor);
+				       "comedi%d: me4000: me4000_ai_isr(): "
+				       "Buffer overflow\n", dev->minor);
 
 				break;
 			}
@@ -1883,7 +1910,10 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 
 		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOA;
 
-		/* Acquisition is complete, so stop conversion and disable all interrupts */
+		/*
+		 * Acquisition is complete, so stop
+		 * conversion and disable all interrupts
+		 */
 		tmp = me4000_inl(dev, ai_context->ctrl_reg);
 		tmp |= ME4000_AI_CTRL_BIT_IMMEDIATE_STOP;
 		tmp &= ~(ME4000_AI_CTRL_BIT_HF_IRQ | ME4000_AI_CTRL_BIT_SC_IRQ);
@@ -1897,8 +1927,8 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 
 			if (!comedi_buf_put(s->async, lval)) {
 				printk(KERN_ERR
-				       "comedi%d: me4000: me4000_ai_isr(): Buffer overflow\n",
-				       dev->minor);
+				       "comedi%d: me4000: me4000_ai_isr(): "
+				       "Buffer overflow\n", dev->minor);
 				s->async->events |= COMEDI_CB_OVERFLOW;
 				break;
 			}
@@ -1941,29 +1971,29 @@ static int me4000_ao_insn_write(struct comedi_device *dev,
 		return 0;
 	} else if (insn->n > 1) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ao_insn_write(): Invalid instruction length %d\n",
-		       dev->minor, insn->n);
+		       "comedi%d: me4000: me4000_ao_insn_write(): "
+		       "Invalid instruction length %d\n", dev->minor, insn->n);
 		return -EINVAL;
 	}
 
 	if (chan >= thisboard->ao.count) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ao_insn_write(): Invalid channel %d\n",
-		       dev->minor, insn->n);
+		       "comedi%d: me4000: me4000_ao_insn_write(): "
+		       "Invalid channel %d\n", dev->minor, insn->n);
 		return -EINVAL;
 	}
 
 	if (rang != 0) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ao_insn_write(): Invalid range %d\n",
-		       dev->minor, insn->n);
+		       "comedi%d: me4000: me4000_ao_insn_write(): "
+		       "Invalid range %d\n", dev->minor, insn->n);
 		return -EINVAL;
 	}
 
 	if (aref != AREF_GROUND && aref != AREF_COMMON) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_ao_insn_write(): Invalid aref %d\n",
-		       dev->minor, insn->n);
+		       "comedi%d: me4000: me4000_ao_insn_write(): "
+		       "Invalid aref %d\n", dev->minor, insn->n);
 		return -EINVAL;
 	}
 
@@ -1994,8 +2024,8 @@ static int me4000_ao_insn_read(struct comedi_device *dev,
 		return 0;
 	} else if (insn->n > 1) {
 		printk
-		    ("comedi%d: me4000: me4000_ao_insn_read(): Invalid instruction length\n",
-		     dev->minor);
+		    ("comedi%d: me4000: me4000_ao_insn_read(): "
+		     "Invalid instruction length\n", dev->minor);
 		return -EINVAL;
 	}
 
@@ -2021,8 +2051,8 @@ static int me4000_dio_insn_bits(struct comedi_device *dev,
 
 	if (insn->n != 2) {
 		printk
-		    ("comedi%d: me4000: me4000_dio_insn_bits(): Invalid instruction length\n",
-		     dev->minor);
+		    ("comedi%d: me4000: me4000_dio_insn_bits(): "
+		     "Invalid instruction length\n", dev->minor);
 		return -EINVAL;
 	}
 
@@ -2095,8 +2125,9 @@ static int me4000_dio_insn_config(struct comedi_device *dev,
 			tmp |= ME4000_DIO_CTRL_BIT_MODE_0;
 		} else if (chan < 16) {
 			/*
-			 * Chech for optoisolated ME-4000 version. If one the first
-			 * port is a fixed output port and the second is a fixed input port.
+			 * Chech for optoisolated ME-4000 version.
+			 * If one the first port is a fixed output
+			 * port and the second is a fixed input port.
 			 */
 			if (!me4000_inl(dev, info->dio_context.dir_reg))
 				return -ENODEV;
@@ -2121,8 +2152,9 @@ static int me4000_dio_insn_config(struct comedi_device *dev,
 	} else {
 		if (chan < 8) {
 			/*
-			 * Chech for optoisolated ME-4000 version. If one the first
-			 * port is a fixed output port and the second is a fixed input port.
+			 * Chech for optoisolated ME-4000 version.
+			 * If one the first port is a fixed output
+			 * port and the second is a fixed input port.
 			 */
 			if (!me4000_inl(dev, info->dio_context.dir_reg))
 				return -ENODEV;
@@ -2257,7 +2289,8 @@ static int me4000_cnt_insn_config(struct comedi_device *dev,
 	case GPCT_RESET:
 		if (insn->n != 1) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_cnt_insn_config(): Invalid instruction length%d\n",
+			       "comedi%d: me4000: me4000_cnt_insn_config(): "
+			       "Invalid instruction length%d\n",
 			       dev->minor, insn->n);
 			return -EINVAL;
 		}
@@ -2269,7 +2302,8 @@ static int me4000_cnt_insn_config(struct comedi_device *dev,
 	case GPCT_SET_OPERATION:
 		if (insn->n != 2) {
 			printk(KERN_ERR
-			       "comedi%d: me4000: me4000_cnt_insn_config(): Invalid instruction length%d\n",
+			       "comedi%d: me4000: me4000_cnt_insn_config(): "
+			       "Invalid instruction length%d\n",
 			       dev->minor, insn->n);
 			return -EINVAL;
 		}
@@ -2280,8 +2314,8 @@ static int me4000_cnt_insn_config(struct comedi_device *dev,
 		break;
 	default:
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_cnt_insn_config(): Invalid instruction\n",
-		       dev->minor);
+		       "comedi%d: me4000: me4000_cnt_insn_config(): "
+		       "Invalid instruction\n", dev->minor);
 		return -EINVAL;
 	}
 
@@ -2302,7 +2336,8 @@ static int me4000_cnt_insn_read(struct comedi_device *dev,
 
 	if (insn->n > 1) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_cnt_insn_read(): Invalid instruction length %d\n",
+		       "comedi%d: me4000: me4000_cnt_insn_read(): "
+		       "Invalid instruction length %d\n",
 		       dev->minor, insn->n);
 		return -EINVAL;
 	}
@@ -2328,7 +2363,8 @@ static int me4000_cnt_insn_read(struct comedi_device *dev,
 		break;
 	default:
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_cnt_insn_read(): Invalid channel %d\n",
+		       "comedi%d: me4000: me4000_cnt_insn_read(): "
+		       "Invalid channel %d\n",
 		       dev->minor, insn->chanspec);
 		return -EINVAL;
 	}
@@ -2349,7 +2385,8 @@ static int me4000_cnt_insn_write(struct comedi_device *dev,
 		return 0;
 	} else if (insn->n > 1) {
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_cnt_insn_write(): Invalid instruction length %d\n",
+		       "comedi%d: me4000: me4000_cnt_insn_write(): "
+		       "Invalid instruction length %d\n",
 		       dev->minor, insn->n);
 		return -EINVAL;
 	}
@@ -2375,7 +2412,8 @@ static int me4000_cnt_insn_write(struct comedi_device *dev,
 		break;
 	default:
 		printk(KERN_ERR
-		       "comedi%d: me4000: me4000_cnt_insn_write(): Invalid channel %d\n",
+		       "comedi%d: me4000: me4000_cnt_insn_write(): "
+		       "Invalid channel %d\n",
 		       dev->minor, insn->chanspec);
 		return -EINVAL;
 	}
-- 
1.5.4.3

