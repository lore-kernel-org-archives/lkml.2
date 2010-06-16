Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063Ab0FPSib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:38:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53832 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab0FPSia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tf1OI2rKV38rETjJgee3WDg1CTzoRS7ulzrnK6MEydZNteVOT0Wq+zhMsqm1vPGIF3
         +xWtFiThWhksft8K1tKLBhg/hVGVbYOKCIQXvOKVaOQzNacQS5c1l+0+pr5ag6SkkcAz
         BafdmXcavWoVEkTVDuHHUexYW7iIr5vVR69I0=
From: John Sheehan <john.d.sheehan@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, rich.folsom@gmail.com,
       mithlesh@linsyssoft.com, jirislaby@gmail.com, john.d.sheehan@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: comedi: fix code warnings in adl_pci9111.c
Date: Wed, 16 Jun 2010 19:30:44 +0100
Message-Id: <1276713044-8534-1-git-send-email-john.d.sheehan@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sheehan <john.d.sheehan@gmail.com>

fix some warnings in adl_pci9111.c reported by
checkpatch.pl tool
-printk() should include KERN_ facility level
-no space before tabs

Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   72 ++++++++++++-------------
 1 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index b9501ce..97c308c 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -83,12 +83,12 @@ TODO:
 #include "comedi_pci.h"
 #include "comedi_fc.h"
 
-#define PCI9111_DRIVER_NAME 	"adl_pci9111"
-#define PCI9111_HR_DEVICE_ID 	0x9111
+#define PCI9111_DRIVER_NAME		"adl_pci9111"
+#define PCI9111_HR_DEVICE_ID	0x9111
 
 /*  TODO: Add other pci9111 board id */
 
-#define PCI9111_IO_RANGE 	0x0100
+#define PCI9111_IO_RANGE		0x0100
 
 #define PCI9111_FIFO_HALF_SIZE	512
 
@@ -134,27 +134,27 @@ TODO:
 
 /* IO address map */
 
-#define PCI9111_REGISTER_AD_FIFO_VALUE 			0x00	/*  AD Data stored in FIFO */
-#define PCI9111_REGISTER_DA_OUTPUT 			0x00
-#define PCI9111_REGISTER_DIGITAL_IO 			0x02
-#define PCI9111_REGISTER_EXTENDED_IO_PORTS 		0x04
-#define PCI9111_REGISTER_AD_CHANNEL_CONTROL 		0x06	/*  Channel selection */
-#define PCI9111_REGISTER_AD_CHANNEL_READBACK 		0x06
-#define PCI9111_REGISTER_INPUT_SIGNAL_RANGE 		0x08
-#define PCI9111_REGISTER_RANGE_STATUS_READBACK 		0x08
-#define PCI9111_REGISTER_TRIGGER_MODE_CONTROL 		0x0A
-#define PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK 	0x0A
-#define PCI9111_REGISTER_SOFTWARE_TRIGGER 		0x0E
-#define PCI9111_REGISTER_INTERRUPT_CONTROL 		0x0C
-#define PCI9111_REGISTER_8254_COUNTER_0			0x40
-#define PCI9111_REGISTER_8254_COUNTER_1			0x42
-#define PCI9111_REGISTER_8254_COUNTER_2 		0X44
-#define PCI9111_REGISTER_8254_CONTROL			0x46
-#define PCI9111_REGISTER_INTERRUPT_CLEAR 		0x48
-
-#define PCI9111_TRIGGER_MASK 				0x0F
-#define PCI9111_PTRG_OFF 				(0 << 3)
-#define PCI9111_PTRG_ON 				(1 << 3)
+#define PCI9111_REGISTER_AD_FIFO_VALUE	0x00 /* AD Data stored in FIFO */
+#define PCI9111_REGISTER_DA_OUTPUT		0x00
+#define PCI9111_REGISTER_DIGITAL_IO		0x02
+#define PCI9111_REGISTER_EXTENDED_IO_PORTS		0x04
+#define PCI9111_REGISTER_AD_CHANNEL_CONTROL		0x06 /* Channel selection */
+#define PCI9111_REGISTER_AD_CHANNEL_READBACK	0x06
+#define PCI9111_REGISTER_INPUT_SIGNAL_RANGE		0x08
+#define PCI9111_REGISTER_RANGE_STATUS_READBACK	0x08
+#define PCI9111_REGISTER_TRIGGER_MODE_CONTROL	0x0A
+#define PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK	0x0A
+#define PCI9111_REGISTER_SOFTWARE_TRIGGER	0x0E
+#define PCI9111_REGISTER_INTERRUPT_CONTROL	0x0C
+#define PCI9111_REGISTER_8254_COUNTER_0		0x40
+#define PCI9111_REGISTER_8254_COUNTER_1		0x42
+#define PCI9111_REGISTER_8254_COUNTER_2		0X44
+#define PCI9111_REGISTER_8254_CONTROL		0x46
+#define PCI9111_REGISTER_INTERRUPT_CLEAR	0x48
+
+#define PCI9111_TRIGGER_MASK	0x0F
+#define PCI9111_PTRG_OFF		(0 << 3)
+#define PCI9111_PTRG_ON			(1 << 3)
 #define PCI9111_EITS_EXTERNAL				(1 << 2)
 #define PCI9111_EITS_INTERNAL				(0 << 2)
 #define PCI9111_TPST_SOFTWARE_TRIGGER			(0 << 1)
@@ -164,9 +164,9 @@ TODO:
 
 #define PCI9111_ISC0_SET_IRQ_ON_ENDING_OF_AD_CONVERSION (0 << 0)
 #define PCI9111_ISC0_SET_IRQ_ON_FIFO_HALF_FULL		(1 << 0)
-#define PCI9111_ISC1_SET_IRQ_ON_TIMER_TICK  		(0 << 1)
-#define PCI9111_ISC1_SET_IRQ_ON_EXT_TRG 		(1 << 1)
-#define PCI9111_FFEN_SET_FIFO_ENABLE 			(0 << 2)
+#define PCI9111_ISC1_SET_IRQ_ON_TIMER_TICK			(0 << 1)
+#define PCI9111_ISC1_SET_IRQ_ON_EXT_TRG				(1 << 1)
+#define PCI9111_FFEN_SET_FIFO_ENABLE				(0 << 2)
 #define PCI9111_FFEN_SET_FIFO_DISABLE			(1 << 2)
 
 #define PCI9111_CHANNEL_MASK				0x0F
@@ -366,7 +366,7 @@ struct pci9111_private_data {
 	short ai_bounce_buffer[2 * PCI9111_FIFO_HALF_SIZE];
 };
 
-#define dev_private 	((struct pci9111_private_data *)dev->private)
+#define dev_private		((struct pci9111_private_data *)dev->private)
 
 /*  ------------------------------------------------------------------ */
 /*  PLX9050 SECTION */
@@ -1222,7 +1222,7 @@ static int pci9111_attach(struct comedi_device *dev,
 		return -ENOMEM;
 	/*  Probe the device to determine what device in the series it is. */
 
-	printk("comedi%d: " PCI9111_DRIVER_NAME " driver\n", dev->minor);
+	printk(KERN_INFO "comedi%d: " PCI9111_DRIVER_NAME " driver\n", dev->minor);
 
 	for (pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
 	     pci_device != NULL;
@@ -1255,13 +1255,13 @@ static int pci9111_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
+	printk(KERN_INFO "comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
 	       dev->minor, it->options[0], it->options[1]);
 	return -EIO;
 
 found:
 
-	printk("comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
+	printk(KERN_INFO "comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
 	       dev->minor,
 	       pci9111_boards[i].name,
 	       pci_device->bus->number,
@@ -1275,14 +1275,12 @@ found:
 	lcr_io_base = pci_resource_start(pci_device, 1);
 	lcr_io_range = pci_resource_len(pci_device, 1);
 
-	printk
-	    ("comedi%d: local configuration registers at address 0x%4lx [0x%4lx]\n",
+	printk(KERN_INFO "comedi%d: local configuration registers at address 0x%4lx [0x%4lx]\n",
 	     dev->minor, lcr_io_base, lcr_io_range);
 
 	/*  Enable PCI device and request regions */
 	if (comedi_pci_enable(pci_device, PCI9111_DRIVER_NAME) < 0) {
-		printk
-		    ("comedi%d: Failed to enable PCI device and request regions\n",
+		printk(KERN_ERR "comedi%d: Failed to enable PCI device and request regions\n",
 		     dev->minor);
 		return -EIO;
 	}
@@ -1291,7 +1289,7 @@ found:
 	io_base = pci_resource_start(pci_device, 2);
 	io_range = pci_resource_len(pci_device, 2);
 
-	printk("comedi%d: 6503 registers at address 0x%4lx [0x%4lx]\n",
+	printk(KERN_INFO "comedi%d: 6503 registers at address 0x%4lx [0x%4lx]\n",
 	       dev->minor, io_base, io_range);
 
 	dev->iobase = io_base;
@@ -1309,7 +1307,7 @@ found:
 	if (pci_device->irq > 0) {
 		if (request_irq(pci_device->irq, pci9111_interrupt,
 				IRQF_SHARED, PCI9111_DRIVER_NAME, dev) != 0) {
-			printk("comedi%d: unable to allocate irq  %u\n",
+			printk(KERN_INFO "comedi%d: unable to allocate irq  %u\n",
 			       dev->minor, pci_device->irq);
 			return -EINVAL;
 		}
-- 
1.7.0.4

