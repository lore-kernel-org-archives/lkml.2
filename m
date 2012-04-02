Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2DBQ4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:56:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41216 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2DBQz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:55:59 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: tiwai@suse.de, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Fix typo in tty, arm, hotplug, sound and others.
Date: Tue,  3 Apr 2012 01:55:48 +0900
Message-Id: <1333385748-27692-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.rc3.1.gb306
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix multiple typo on printk messages on tty, arm, hotplug
sound and others.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/kernel/kprobes-test.c     |    2 +-
 arch/arm/mach-imx/iomux-imx31.c    |    2 +-
 arch/arm/mach-imx/mach-pca100.c    |    2 +-
 arch/ia64/Makefile                 |    2 +-
 arch/openrisc/README.openrisc      |    2 +-
 arch/x86/kernel/test_rodata.c      |    2 +-
 drivers/edac/i5000_edac.c          |    2 +-
 drivers/firewire/ohci.c            |    2 +-
 drivers/pci/hotplug/ibmphp_core.c  |    2 +-
 drivers/pci/hotplug/ibmphp_ebda.c  |    2 +-
 drivers/pci/hotplug/ibmphp_pci.c   |    2 +-
 drivers/ps3/ps3-lpm.c              |    2 +-
 drivers/tty/ehv_bytechan.c         |    4 ++--
 drivers/tty/hvc/hvc_opal.c         |    2 +-
 drivers/tty/hvc/hvc_vio.c          |    2 +-
 drivers/tty/serial/68328serial.h   |    2 +-
 drivers/tty/serial/bfin_uart.c     |    2 +-
 drivers/tty/serial/crisv10.c       |    4 ++--
 drivers/tty/serial/icom.c          |    2 +-
 drivers/tty/serial/kgdboc.c        |    2 +-
 drivers/tty/serial/msm_serial_hs.c |    4 ++--
 fs/befs/ChangeLog                  |    4 ++--
 fs/cifs/README                     |    2 +-
 fs/hpfs/inode.c                    |    2 +-
 fs/qnx6/inode.c                    |    2 +-
 scripts/basic/fixdep.c             |    2 +-
 sound/soc/codecs/wm5100.c          |    6 +++---
 sound/soc/codecs/wm8994.c          |    8 ++++----
 sound/soc/codecs/wm8996.c          |   10 +++++-----
 sound/soc/omap/overo.c             |    2 +-
 sound/usb/6fire/firmware.c         |    2 +-
 31 files changed, 44 insertions(+), 44 deletions(-)

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
 
diff --git a/arch/arm/mach-imx/iomux-imx31.c b/arch/arm/mach-imx/iomux-imx31.c
index 82bd440..a440f06 100644
--- a/arch/arm/mach-imx/iomux-imx31.c
+++ b/arch/arm/mach-imx/iomux-imx31.c
@@ -101,7 +101,7 @@ int mxc_iomux_alloc_pin(unsigned int pin, const char *label)
 	unsigned pad = pin & IOMUX_PADNUM_MASK;
 
 	if (pad >= (PIN_MAX + 1)) {
-		printk(KERN_ERR "mxc_iomux: Attempt to request nonexistant pin %u for \"%s\"\n",
+		printk(KERN_ERR "mxc_iomux: Attempt to request nonexistent pin %u for \"%s\"\n",
 			pad, label ? label : "?");
 		return -EINVAL;
 	}
diff --git a/arch/arm/mach-imx/mach-pca100.c b/arch/arm/mach-imx/mach-pca100.c
index 541152e..a40e237 100644
--- a/arch/arm/mach-imx/mach-pca100.c
+++ b/arch/arm/mach-imx/mach-pca100.c
@@ -250,7 +250,7 @@ static int pca100_sdhc2_init(struct device *dev, irq_handler_t detect_irq,
 			  "imx-mmc-detect", data);
 	if (ret)
 		printk(KERN_ERR
-			"pca100: Failed to reuest irq for sd/mmc detection\n");
+			"pca100: Failed to request irq for sd/mmc detection\n");
 
 	return ret;
 }
diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index be7bfa1..5aa10a7 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -34,7 +34,7 @@ GAS_STATUS	= $(shell $(srctree)/arch/ia64/scripts/check-gas "$(CC)" "$(OBJDUMP)"
 KBUILD_CPPFLAGS += $(shell $(srctree)/arch/ia64/scripts/toolchain-flags "$(CC)" "$(OBJDUMP)" "$(READELF)")
 
 ifeq ($(GAS_STATUS),buggy)
-$(error Sorry, you need a newer version of the assember, one that is built from	\
+$(error Sorry, you need a newer version of the assembler, one that is built from	\
 	a source-tree that post-dates 18-Dec-2002.  You can find a pre-compiled	\
 	static binary of such an assembler at:					\
 										\
diff --git a/arch/openrisc/README.openrisc b/arch/openrisc/README.openrisc
index c9f7edf..828173a 100644
--- a/arch/openrisc/README.openrisc
+++ b/arch/openrisc/README.openrisc
@@ -92,7 +92,7 @@ History
 	port to 2.6.x
 
 30. 11. 2004	Matjaz Breskvar (phoenix@bsemi.com)
-	lots of bugfixes and enhancments.
+	lots of bugfixes and enhancements.
 	added opencores framebuffer driver.
 
 09. 10. 2010    Jonas Bonn (jonas@southpole.se)
diff --git a/arch/x86/kernel/test_rodata.c b/arch/x86/kernel/test_rodata.c
index c29e235..d87d22f 100644
--- a/arch/x86/kernel/test_rodata.c
+++ b/arch/x86/kernel/test_rodata.c
@@ -63,7 +63,7 @@ int rodata_test(void)
 	/* test 3: check the value hasn't changed */
 	/* If this test fails, we managed to overwrite the data */
 	if (!rodata_test_data) {
-		printk(KERN_ERR "rodata_test: Test 3 failes (end data)\n");
+		printk(KERN_ERR "rodata_test: Test 3 fails (end data)\n");
 		return -ENODEV;
 	}
 	/* test 4: check if the rodata section is 4Kb aligned */
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index a2680d8..4716e6d 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -83,7 +83,7 @@
 
 #define		FERR_NF_FBD		0xA0
 
-/* Thermal and SPD or BFD errors */
+/* Thermal and SPD or FBDIMM errors */
 #define			FERR_NF_M28ERR	0x01000000
 #define			FERR_NF_M27ERR	0x00800000
 #define			FERR_NF_M26ERR	0x00400000
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 2b54600..233ba97 100644
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
diff --git a/drivers/ps3/ps3-lpm.c b/drivers/ps3/ps3-lpm.c
index 643697f..52396b4 100644
--- a/drivers/ps3/ps3-lpm.c
+++ b/drivers/ps3/ps3-lpm.c
@@ -412,7 +412,7 @@ u32 ps3_read_pm(u32 cpu, enum pm_reg_name reg)
 		result = lv1_set_lpm_interval(lpm_priv->lpm_id, 0, 0, &val);
 		if (result) {
 			val = 0;
-			dev_dbg(sbd_core(), "%s:%u: lv1 set_inteval failed: "
+			dev_dbg(sbd_core(), "%s:%u: lv1 set_interval failed: "
 				"reg %u, %s\n", __func__, __LINE__, reg,
 				ps3_result(result));
 		}
diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index 4813684..5c0a256 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -364,7 +364,7 @@ console_initcall(ehv_bc_console_init);
 /******************************** TTY DRIVER ********************************/
 
 /*
- * byte channel receive interupt handler
+ * byte channel receive interrupt handler
  *
  * This ISR is called whenever data is available on a byte channel.
  */
@@ -471,7 +471,7 @@ static void ehv_bc_tx_dequeue(struct ehv_bc_data *bc)
 }
 
 /*
- * byte channel transmit interupt handler
+ * byte channel transmit interrupt handler
  *
  * This ISR is called whenever space becomes available for transmitting
  * characters on a byte channel.
diff --git a/drivers/tty/hvc/hvc_opal.c b/drivers/tty/hvc/hvc_opal.c
index ced26c8..27359c5 100644
--- a/drivers/tty/hvc/hvc_opal.c
+++ b/drivers/tty/hvc/hvc_opal.c
@@ -178,7 +178,7 @@ static int __devinit hvc_opal_probe(struct platform_device *dev)
 		proto = HV_PROTOCOL_HVSI;
 		ops = &hvc_opal_hvsi_ops;
 	} else {
-		pr_err("hvc_opal: Unkown protocol for %s\n",
+		pr_err("hvc_opal: Unknown protocol for %s\n",
 		       dev->dev.of_node->full_name);
 		return -ENXIO;
 	}
diff --git a/drivers/tty/hvc/hvc_vio.c b/drivers/tty/hvc/hvc_vio.c
index ee30779..56e9725 100644
--- a/drivers/tty/hvc/hvc_vio.c
+++ b/drivers/tty/hvc/hvc_vio.c
@@ -250,7 +250,7 @@ static int __devinit hvc_vio_probe(struct vio_dev *vdev,
 		proto = HV_PROTOCOL_HVSI;
 		ops = &hvterm_hvsi_ops;
 	} else {
-		pr_err("hvc_vio: Unkown protocol for %s\n", vdev->dev.of_node->full_name);
+		pr_err("hvc_vio: Unknown protocol for %s\n", vdev->dev.of_node->full_name);
 		return -ENXIO;
 	}
 
diff --git a/drivers/tty/serial/68328serial.h b/drivers/tty/serial/68328serial.h
index 3d2faab..522f54a 100644
--- a/drivers/tty/serial/68328serial.h
+++ b/drivers/tty/serial/68328serial.h
@@ -96,7 +96,7 @@ struct serial_struct {
  * at least at 115200 baud
  *
  * If your board is busy doing other stuff, you might consider to use
- * RXRE (data ready intrrupt) instead.
+ * RXRE (data ready interrupt) instead.
  *
  * The other option is to make these INTR masks run-time configurable, so
  * that people can dynamically adapt them according to the current usage.
diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 5832fde..05507c0 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -819,7 +819,7 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 		lcr = WLS(5);
 		break;
 	default:
-		printk(KERN_ERR "%s: word lengh not supported\n",
+		printk(KERN_ERR "%s: word length not supported\n",
 			__func__);
 	}
 
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 5b07c0c..ff60719 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -61,7 +61,7 @@ static char *serial_version = "$Revision: 1.25 $";
 #endif
 
 /*
- * All of the compatibilty code so we can compile serial.c against
+ * All of the compatibility code so we can compile serial.c against
  * older kernels is hidden in serial_compat.h
  */
 #if defined(LOCAL_HEADERS)
@@ -965,7 +965,7 @@ static const struct control_pins e100_modem_pins[NR_PORTS] =
 static unsigned char *tmp_buf;
 static DEFINE_MUTEX(tmp_buf_mutex);
 
-/* Calculate the chartime depending on baudrate, numbor of bits etc. */
+/* Calculate the chartime depending on baudrate, number of bits etc. */
 static void update_char_time(struct e100_serial * info)
 {
 	tcflag_t cflags = info->port.tty->termios->c_cflag;
diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index defc4e3..6131516 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -505,7 +505,7 @@ static void load_code(struct icom_port *icom_port)
 		/* Stop processor */
 		stop_processor(icom_port);
 
-		dev_err(&icom_port->adapter->pci_dev->dev,"Port not opertional\n");
+		dev_err(&icom_port->adapter->pci_dev->dev,"Port not operational\n");
 	}
 
 	if (new_page != NULL)
diff --git a/drivers/tty/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
index 2b42a01..83e7f80 100644
--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -45,7 +45,7 @@ static int kgdboc_reset_connect(struct input_handler *handler,
 {
 	input_reset_device(dev);
 
-	/* Retrun an error - we do not want to bind, just to reset */
+	/* Return an error - we do not want to bind, just to reset */
 	return -ENODEV;
 }
 
diff --git a/drivers/tty/serial/msm_serial_hs.c b/drivers/tty/serial/msm_serial_hs.c
index fca13dc..d7239cc 100644
--- a/drivers/tty/serial/msm_serial_hs.c
+++ b/drivers/tty/serial/msm_serial_hs.c
@@ -408,7 +408,7 @@ static int __devexit msm_hs_remove(struct platform_device *pdev)
 	struct device *dev;
 
 	if (pdev->id < 0 || pdev->id >= UARTDM_NR) {
-		printk(KERN_ERR "Invalid plaform device ID = %d\n", pdev->id);
+		printk(KERN_ERR "Invalid platform device ID = %d\n", pdev->id);
 		return -EINVAL;
 	}
 
@@ -1624,7 +1624,7 @@ static int __devinit msm_hs_probe(struct platform_device *pdev)
 						pdev->dev.platform_data;
 
 	if (pdev->id < 0 || pdev->id >= UARTDM_NR) {
-		printk(KERN_ERR "Invalid plaform device ID = %d\n", pdev->id);
+		printk(KERN_ERR "Invalid platform device ID = %d\n", pdev->id);
 		return -EINVAL;
 	}
 
diff --git a/fs/befs/ChangeLog b/fs/befs/ChangeLog
index 75a461c..08e1f75 100644
--- a/fs/befs/ChangeLog
+++ b/fs/befs/ChangeLog
@@ -170,7 +170,7 @@ Version 0.50 (2001-11-13)
 * Fixed a couple of compile warnings due to use of malloc.h, when slab.h 
 	is the new way. (inode.c, super.c) [WD]
 
-* Fixed erronous includes of linux/befs_fs_i.h and linux/befs_fs_sb.h 
+* Fixed erroneous includes of linux/befs_fs_i.h and linux/befs_fs_sb.h 
 	in inode.c [WD]
 
 Version 0.45 (2001-10-29)
@@ -298,7 +298,7 @@ Version 0.4 (2001-10-28)
 * Rewrote datastream handleing.
 
 * Created io.c, for io related functions.
-	Previously, the befs_bread() funtions lived in file.c
+	Previously, the befs_bread() functions lived in file.c
 	Created the befs_read_brun() function.
 
 
diff --git a/fs/cifs/README b/fs/cifs/README
index b7d782b..89e3d53 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -480,7 +480,7 @@ A partial list of the supported mount options follows:
 		Unicode on the wire.
  nomapchars     Do not translate any of these seven characters (default).
  nocase         Request case insensitive path name matching (case
-		sensitive is the default if the server suports it).
+		sensitive is the default if the server supports it).
 		(mount option "ignorecase" is identical to "nocase")
  posixpaths     If CIFS Unix extensions are supported, attempt to
 		negotiate posix path name support which allows certain
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
diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index b9c185c..10e7781 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2073,9 +2073,9 @@ static void wm5100_micd_irq(struct wm5100_priv *wm5100)
 		return;
 	}
 
-	/* If we detected a lower impedence during initial startup
+	/* If we detected a lower impedance during initial startup
 	 * then we probably have the wrong polarity, flip it.  Don't
-	 * do this for the lowest impedences to speed up detection of
+	 * do this for the lowest impedances to speed up detection of
 	 * plain headphones and give up if neither polarity looks
 	 * sensible.
 	 */
@@ -2091,7 +2091,7 @@ static void wm5100_micd_irq(struct wm5100_priv *wm5100)
 	}
 
 	/* Don't distinguish between buttons, just report any low
-	 * impedence as BTN_0.
+	 * impedance as BTN_0.
 	 */
 	if (val & 0x3fc) {
 		if (wm5100->jack_mic) {
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 7c49642..1787bcd 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3225,7 +3225,7 @@ static void wm8958_default_micdet(u16 status, void *data)
 		return;
 	}
 
-	/* If the measurement is showing a high impedence we've got a
+	/* If the measurement is showing a high impedance we've got a
 	 * microphone.
 	 */
 	if (wm8994->mic_detecting && (status & 0x600)) {
@@ -3329,7 +3329,7 @@ static irqreturn_t wm1811_jackdet_irq(int irq, void *data)
 				    WM1811_JACKDET_DB, 0);
 
 		/*
-		 * Start off measument of microphone impedence to find
+		 * Start off measument of microphone impedance to find
 		 * out what's actually there.
 		 */
 		wm8994->mic_detecting = true;
@@ -3489,7 +3489,7 @@ static irqreturn_t wm8958_mic_irq(int irq, void *data)
 	if (!(snd_soc_read(codec, WM8958_MIC_DETECT_1) & WM8958_MICD_ENA))
 		return IRQ_HANDLED;
 
-	/* We may occasionally read a detection without an impedence
+	/* We may occasionally read a detection without an impedance
 	 * range being provided - if that happens loop again.
 	 */
 	count = 10;
@@ -3514,7 +3514,7 @@ static irqreturn_t wm8958_mic_irq(int irq, void *data)
 	} while (count--);
 
 	if (count == 0)
-		dev_warn(codec->dev, "No impedence range reported for jack\n");
+		dev_warn(codec->dev, "No impedance range reported for jack\n");
 
 #ifndef CONFIG_SND_SOC_WM8994_MODULE
 	trace_snd_soc_jack_irq(dev_name(codec->dev));
diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index 1fd6354..70105a6 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -2488,7 +2488,7 @@ static void wm8996_hpdet_irq(struct snd_soc_codec *codec)
 
 	dev_dbg(codec->dev, "HPDET measured %d ohms\n", val);
 
-	/* If we've got high enough impedence then report as line,
+	/* If we've got high enough impedance then report as line,
 	 * otherwise assume headphone.
 	 */
 	if (val >= 126)
@@ -2615,11 +2615,11 @@ static void wm8996_micd(struct snd_soc_codec *codec)
 		return;
 	}
 
-	/* If we detected a lower impedence during initial startup
+	/* If we detected a lower impedance during initial startup
 	 * then we probably have the wrong polarity, flip it.  Don't
-	 * do this for the lowest impedences to speed up detection of
+	 * do this for the lowest impedances to speed up detection of
 	 * plain headphones.  If both polarities report a low
-	 * impedence then give up and report headphones.
+	 * impedance then give up and report headphones.
 	 */
 	if (wm8996->detecting && (val & 0x3f0)) {
 		wm8996->jack_flips++;
@@ -2647,7 +2647,7 @@ static void wm8996_micd(struct snd_soc_codec *codec)
 	}
 
 	/* Don't distinguish between buttons, just report any low
-	 * impedence as BTN_0.
+	 * impedance as BTN_0.
 	 */
 	if (val & 0x3fc) {
 		if (wm8996->jack_mic) {
diff --git a/sound/soc/omap/overo.c b/sound/soc/omap/overo.c
index 6ac3e0c..0c32ad4 100644
--- a/sound/soc/omap/overo.c
+++ b/sound/soc/omap/overo.c
@@ -84,7 +84,7 @@ static int __init overo_soc_init(void)
 	int ret;
 
 	if (!(machine_is_overo() || machine_is_cm_t35())) {
-		pr_debug("Incomatible machine!\n");
+		pr_debug("Incompatible machine!\n");
 		return -ENODEV;
 	}
 	printk(KERN_INFO "overo SoC init\n");
diff --git a/sound/usb/6fire/firmware.c b/sound/usb/6fire/firmware.c
index 6f9715a..7ac8401 100644
--- a/sound/usb/6fire/firmware.c
+++ b/sound/usb/6fire/firmware.c
@@ -346,7 +346,7 @@ static int usb6fire_fw_check(u8 *version)
 		if (!memcmp(version, known_fw_versions + i, 4))
 			return 0;
 
-	snd_printk(KERN_ERR PREFIX "invalid fimware version in device: "
+	snd_printk(KERN_ERR PREFIX "invalid firmware version in device: "
 			"%02x %02x %02x %02x. "
 			"please reconnect to power. if this failure "
 			"still happens, check your firmware installation.",
-- 
1.7.10.rc3.1.gb306

