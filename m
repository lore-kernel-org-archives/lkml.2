Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab1CaSKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:10:44 -0400
Received: from santostefano.inria.fr ([193.51.192.151]:37597 "HELO
	santostefano.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758792Ab1CaSKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:10:41 -0400
Subject: [PATCH 2/2] Fix a typo 'an hardware => a hardware'
From: Sylvestre Ledru <sylvestre.ledru@scilab.org>
To: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sylvestre Ledru <sylvestre.ledru@scilab.org>
Content-Type: multipart/mixed; boundary="=-CTM/qZNG3O/M+4CoKCwJ"
Date: Thu, 31 Mar 2011 20:10:39 +0200
Message-ID: <1301595039.27408.14.camel@losinj.inria.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CTM/qZNG3O/M+4CoKCwJ
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Hello,

Here is a patch which fixes an other minor typo issue.

Thanks
Sylvestre 


--=-CTM/qZNG3O/M+4CoKCwJ
Content-Disposition: attachment; filename="0002-Fix-a-typo-an-hardware-a-hardware.patch"
Content-Type: text/x-patch; name="0002-Fix-a-typo-an-hardware-a-hardware.patch"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

>From bcb06f53e88c5a767a63b04528c2c6799811abe4 Mon Sep 17 00:00:00 2001
From: Sylvestre Ledru <sylvestre.ledru@scilab.org>
Date: Thu, 31 Mar 2011 18:02:59 +0200
Subject: [PATCH 2/2] Fix a typo 'an hardware => a hardware'

Signed-off-by: Sylvestre Ledru <sylvestre.ledru@scilab.org>
---
 arch/alpha/include/asm/dma.h            |    4 ++--
 drivers/hwspinlock/omap_hwspinlock.c    |    2 +-
 drivers/message/i2o/Kconfig             |    2 +-
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 drivers/platform/x86/asus-laptop.c      |    4 ++--
 drivers/scsi/pm8001/pm8001_init.c       |    2 +-
 drivers/video/s3c-fb.c                  |    2 +-
 include/linux/mtd/nand.h                |    2 +-
 include/linux/oprofile.h                |    2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/alpha/include/asm/dma.h b/arch/alpha/include/asm/dma.h
index 87cfdbd..d7bb2c3 100644
--- a/arch/alpha/include/asm/dma.h
+++ b/arch/alpha/include/asm/dma.h
@@ -87,12 +87,12 @@
 #define ALPHA_XL_MAX_ISA_DMA_ADDRESS		0x04000000UL
 
 /* The maximum address for ISA DMA transfer on RUFFIAN,
-   due to an hardware SIO limitation, is 16MB.
+   due to a hardware SIO limitation, is 16MB.
 */
 #define ALPHA_RUFFIAN_MAX_ISA_DMA_ADDRESS	0x01000000UL
 
 /* The maximum address for ISA DMA transfer on SABLE, and some ALCORs,
-   due to an hardware SIO chip limitation, is 2GB.
+   due to a hardware SIO chip limitation, is 2GB.
 */
 #define ALPHA_SABLE_MAX_ISA_DMA_ADDRESS		0x80000000UL
 #define ALPHA_ALCOR_MAX_ISA_DMA_ADDRESS		0x80000000UL
diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index a8f0273..6eeb3f5 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -77,7 +77,7 @@ static void omap_hwspinlock_unlock(struct hwspinlock *lock)
  * just over half of the time that a requester would be
  * expected to hold the lock.
  *
- * The number below is taken from an hardware specs example,
+ * The number below is taken from a hardware specs example,
  * obviously it is somewhat arbitrary.
  */
 static void omap_hwspinlock_relax(struct hwspinlock *lock)
diff --git a/drivers/message/i2o/Kconfig b/drivers/message/i2o/Kconfig
index 5afa0e3..a21ce63 100644
--- a/drivers/message/i2o/Kconfig
+++ b/drivers/message/i2o/Kconfig
@@ -5,7 +5,7 @@ menuconfig I2O
 	---help---
 	  The Intelligent Input/Output (I2O) architecture allows hardware
 	  drivers to be split into two parts: an operating system specific
-	  module called the OSM and an hardware specific module called the
+	  module called the OSM and a hardware specific module called the
 	  HDM. The OSM can talk to a whole range of HDM's, and ideally the
 	  HDM's are not OS dependent. This allows for the same HDM driver to
 	  be used under different operating systems if the relevant OSM is in
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 329f328..603964c 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1531,7 +1531,7 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #endif /* CONFIG_RT2X00_LIB_LEDS */
 
 	/*
-	 * Detect if this device has an hardware controlled radio.
+	 * Detect if this device has a hardware controlled radio.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5827787..b6360a7 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1682,7 +1682,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #endif /* CONFIG_RT2X00_LIB_LEDS */
 
 	/*
-	 * Detect if this device has an hardware controlled radio.
+	 * Detect if this device has a hardware controlled radio.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 979fe65..a9c47a4 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1516,7 +1516,7 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 #endif /* CONFIG_RT2X00_LIB_LEDS */
 
 	/*
-	 * Detect if this device has an hardware controlled radio.
+	 * Detect if this device has a hardware controlled radio.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index c53b3ff..55bd9dd 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -641,7 +641,7 @@ static ssize_t show_infos(struct device *dev,
 		len += sprintf(page + len, "SFUN value         : %#x\n",
 			       (uint) temp);
 	/*
-	 * The HWRS method return informations about the hardware.
+	 * The HWRS method returns information about the hardware.
 	 * 0x80 bit is for WLAN, 0x100 for Bluetooth.
 	 * The significance of others is yet to be found.
 	 * If we don't find the method, we assume the device are present.
@@ -1334,7 +1334,7 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 		pr_notice("  %s model detected\n", string);
 
 	/*
-	 * The HWRS method return informations about the hardware.
+	 * The HWRS method returns information about the hardware.
 	 * 0x80 bit is for WLAN, 0x100 for Bluetooth,
 	 * 0x40 for WWAN, 0x10 for WIMAX.
 	 * The significance of others is yet to be found.
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 002360d..cabb568 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -614,7 +614,7 @@ intx:
  * @ent: pci device id
  *
  * This function is the main initialization function, when register a new
- * pci driver it is invoked, all struct an hardware initilization should be done
+ * pci driver it is invoked, all struct a hardware initilization should be done
  * here, also, register interrupt
  */
 static int __devinit pm8001_pci_probe(struct pci_dev *pdev,
diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 6817d18..116d3a4 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -1161,7 +1161,7 @@ static void s3c_fb_release_win(struct s3c_fb *sfb, struct s3c_fb_win *win)
 }
 
 /**
- * s3c_fb_probe_win() - register an hardware window
+ * s3c_fb_probe_win() - register a hardware window
  * @sfb: The base resources for the hardware
  * @variant: The variant information for this window.
  * @res: Pointer to where to place the resultant window.
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index ae67ef5..ec88c09 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -342,7 +342,7 @@ struct nand_hw_control {
  * @layout:	ECC layout control struct pointer
  * @priv:	pointer to private ecc control data
  * @hwctl:	function to control hardware ecc generator. Must only
- *		be provided if an hardware ECC is available
+ *		be provided if a hardware ECC is available
  * @calculate:	function for ecc calculation or readback from ecc hardware
  * @correct:	function for ecc correction, matching to ecc generator (sw/hw)
  * @read_page_raw:	function to read a raw page without ECC
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 7f5cfd3..3cf9881 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -107,7 +107,7 @@ void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 				unsigned long event, int is_kernel);
 
 /**
- * Add an hardware sample.
+ * Add a hardware sample.
  */
 void oprofile_add_ext_hw_sample(unsigned long pc, struct pt_regs * const regs,
 	unsigned long event, int is_kernel,
-- 
1.7.4.1


--=-CTM/qZNG3O/M+4CoKCwJ--

