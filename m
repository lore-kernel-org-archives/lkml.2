Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0C3LY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:24:29 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:39475 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab0C3LY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=Ejw8XPZj3jeQe8ZGMoGh8qCy+isr4k+yj0hH88vf9SMVA9UoRwmPZqCMJiWWde/7+n
         /0CMUOVpk/ALvzu4ydrkkKQ6jrvDpdFSkMGGR9KhPiYiC9Z+Q28u92mS2Xt5YkIORVP8
         75rMQQWcyfsrO9DG3XjNmGMJ/OhomJY3OPU6s=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 26/26] Staging: comedi: fix brace, print(k) and over 80 character coding style issues in adv_pci1723.c
Date: Tue, 30 Mar 2010 12:24:14 +0100
Message-Id: <1269948254-2863-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a Patch to the adv_pci1723.c file that fixes up brace, print(k) and over 80 character warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adv_pci1723.c |  149 +++++++++++++++-----------
 1 files changed, 87 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 6b0b7ed..1644490 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -60,35 +60,57 @@ TODO:
 #define IORANGE_1723  0x2A
 
 /* all the registers for the pci1723 board */
-#define PCI1723_DA(N)   ((N)<<1)	/* W:   D/A register N (0 to 7) */
-
-#define PCI1723_SYN_SET  0x12	/*synchronized set register       */
-#define PCI1723_ALL_CHNNELE_SYN_STROBE  0x12	/*synchronized status register    */
-
-#define PCI1723_RANGE_CALIBRATION_MODE 0x14	/* range and calibration mode   */
-#define PCI1723_RANGE_CALIBRATION_STATUS 0x14	/* range and calibration status */
-
-#define PCI1723_CONTROL_CMD_CALIBRATION_FUN 0x16	/* SADC control command for calibration function */
-#define PCI1723_STATUS_CMD_CALIBRATION_FUN 0x16	/* SADC control status for calibration function */
-
-#define PCI1723_CALIBRATION_PARA_STROBE 0x18	/* Calibration parameter strobe */
+#define PCI1723_DA(N)   ((N)<<1)	/* W: D/A register N (0 to 7) */
+
+#define PCI1723_SYN_SET  0x12		/* synchronized set register */
+#define PCI1723_ALL_CHNNELE_SYN_STROBE  0x12
+					/* synchronized status register */
+
+#define PCI1723_RANGE_CALIBRATION_MODE 0x14
+					/* range and calibration mode */
+#define PCI1723_RANGE_CALIBRATION_STATUS 0x14
+					/* range and calibration status */
+
+#define PCI1723_CONTROL_CMD_CALIBRATION_FUN 0x16
+						/*
+						 * SADC control command for
+						 * calibration function
+						 */
+#define PCI1723_STATUS_CMD_CALIBRATION_FUN 0x16
+						/*
+						 * SADC control status for
+						 * calibration function
+						 */
+
+#define PCI1723_CALIBRATION_PARA_STROBE 0x18
+					/* Calibration parameter strobe */
 
 #define PCI1723_DIGITAL_IO_PORT_SET 0x1A	/* Digital I/O port setting */
 #define PCI1723_DIGITAL_IO_PORT_MODE 0x1A	/* Digital I/O port mode */
 
-#define PCI1723_WRITE_DIGITAL_OUTPUT_CMD 0x1C	/* Write digital output command */
+#define PCI1723_WRITE_DIGITAL_OUTPUT_CMD 0x1C
+					/* Write digital output command */
 #define PCI1723_READ_DIGITAL_INPUT_DATA 0x1C	/* Read digital input data */
 
-#define PCI1723_WRITE_CAL_CMD 0x1E	/* Write calibration command */
-#define PCI1723_READ_CAL_STATUS 0x1E	/* Read calibration status */
+#define PCI1723_WRITE_CAL_CMD 0x1E		/* Write calibration command */
+#define PCI1723_READ_CAL_STATUS 0x1E		/* Read calibration status */
 
-#define PCI1723_SYN_STROBE 0x20	/* Synchronized strobe */
+#define PCI1723_SYN_STROBE 0x20			/* Synchronized strobe */
 
-#define PCI1723_RESET_ALL_CHN_STROBE 0x22	/* Reset all D/A channels strobe */
+#define PCI1723_RESET_ALL_CHN_STROBE 0x22
+					/* Reset all D/A channels strobe */
 
-#define PCI1723_RESET_CAL_CONTROL_STROBE 0x24	/* Reset the calibration controller strobe */
+#define PCI1723_RESET_CAL_CONTROL_STROBE 0x24
+						/*
+						 * Reset the calibration
+						 * controller strobe
+						 */
 
-#define PCI1723_CHANGE_CHA_OUTPUT_TYPE_STROBE 0x26	/* Change D/A channels output type strobe */
+#define PCI1723_CHANGE_CHA_OUTPUT_TYPE_STROBE 0x26
+						/*
+						 * Change D/A channels output
+						 * type strobe
+						 */
 
 #define PCI1723_SELECT_CALIBRATION 0x28	/* Select the calibration Ref_V */
 
@@ -104,14 +126,14 @@ static const struct comedi_lrange range_pci1723 = { 1, {
  */
 struct pci1723_board {
 	const char *name;
-	int vendor_id;		/*  PCI vendor a device ID of card */
+	int vendor_id;		/* PCI vendor a device ID of card */
 	int device_id;
 	int iorange;
 	char cardtype;
-	int n_aochan;		/*  num of D/A chans */
-	int n_diochan;		/*  num of DIO chans */
-	int ao_maxdata;		/*  resolution of D/A */
-	const struct comedi_lrange *rangelist_ao;	/*  rangelist for D/A */
+	int n_aochan;		/* num of D/A chans */
+	int n_diochan;		/* num of DIO chans */
+	int ao_maxdata;		/* resolution of D/A */
+	const struct comedi_lrange *rangelist_ao;	/* rangelist for D/A */
 };
 
 static const struct pci1723_board boardtypes[] = {
@@ -128,8 +150,10 @@ static const struct pci1723_board boardtypes[] = {
 	 },
 };
 
-/* This is used by modprobe to translate PCI IDs to drivers.  Should
- * only be used for PCI and ISA-PnP devices */
+/*
+ * This is used by modprobe to translate PCI IDs to drivers.
+ * Should only be used for PCI and ISA-PnP devices
+ */
 static DEFINE_PCI_DEVICE_TABLE(pci1723_pci_table) = {
 	{
 	PCI_VENDOR_ID_ADVANTECH, 0x1723, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
@@ -157,47 +181,47 @@ static struct comedi_driver driver_pci1723 = {
 	.detach = pci1723_detach,
 };
 
-/* this structure is for data unique to this hardware driver. */
+/* This structure is for data unique to this hardware driver. */
 struct pci1723_private {
 	int valid;		/* card is usable; */
 
 	struct pci_dev *pcidev;
-	unsigned char da_range[8];	/*  D/A output range for each channel */
+	unsigned char da_range[8];	/* D/A output range for each channel */
 
-	short ao_data[8];	/*  data output buffer */
+	short ao_data[8];	/* data output buffer */
 };
 
-/*the following macro to make it easy to
-* access the private structure.
-*/
+/* The following macro to make it easy to access the private structure. */
 #define devpriv ((struct pci1723_private *)dev->private)
 
 #define this_board boardtypes
 
 /*
- *   the pci1723 card reset;
+ * The pci1723 card reset;
  */
 static int pci1723_reset(struct comedi_device *dev)
 {
 	int i;
 	DPRINTK("adv_pci1723 EDBG: BGN: pci1723_reset(...)\n");
 
-	outw(0x01, dev->iobase + PCI1723_SYN_SET);	/*  set synchronous output mode */
+	outw(0x01, dev->iobase + PCI1723_SYN_SET);
+					       /* set synchronous output mode */
 
 	for (i = 0; i < 8; i++) {
-		/*  set all outputs to 0V */
+		/* set all outputs to 0V */
 		devpriv->ao_data[i] = 0x8000;
 		outw(devpriv->ao_data[i], dev->iobase + PCI1723_DA(i));
-		/*  set all ranges to +/- 10V */
+		/* set all ranges to +/- 10V */
 		devpriv->da_range[i] = 0;
 		outw(((devpriv->da_range[i] << 4) | i),
 		     PCI1723_RANGE_CALIBRATION_MODE);
 	}
 
-	outw(0, dev->iobase + PCI1723_CHANGE_CHA_OUTPUT_TYPE_STROBE);	/*  update ranges */
-	outw(0, dev->iobase + PCI1723_SYN_STROBE);	/*  update outputs */
+	outw(0, dev->iobase + PCI1723_CHANGE_CHA_OUTPUT_TYPE_STROBE);
+							    /* update ranges */
+	outw(0, dev->iobase + PCI1723_SYN_STROBE);	    /* update outputs */
 
-	/*  set asynchronous output mode */
+	/* set asynchronous output mode */
 	outw(0, dev->iobase + PCI1723_SYN_SET);
 
 	DPRINTK("adv_pci1723 EDBG: END: pci1723_reset(...)\n");
@@ -251,11 +275,11 @@ static int pci1723_dio_insn_config(struct comedi_device *dev,
 	unsigned short dio_mode;
 
 	mask = 1 << CR_CHAN(insn->chanspec);
-	if (mask & 0x00FF) {
+	if (mask & 0x00FF)
 		bits = 0x00FF;
-	} else {
+	else
 		bits = 0xFF00;
-	}
+
 	switch (data[0]) {
 	case INSN_CONFIG_DIO_INPUT:
 		s->io_bits &= ~bits;
@@ -270,12 +294,12 @@ static int pci1723_dio_insn_config(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	/*  update hardware DIO mode */
-	dio_mode = 0x0000;	/*  low byte output, high byte output */
+	/* update hardware DIO mode */
+	dio_mode = 0x0000;	/* low byte output, high byte output */
 	if ((s->io_bits & 0x00FF) == 0)
-		dio_mode |= 0x0001;	/*  low byte input */
+		dio_mode |= 0x0001;	/* low byte input */
 	if ((s->io_bits & 0xFF00) == 0)
-		dio_mode |= 0x0002;	/*  high byte input */
+		dio_mode |= 0x0002;	/* high byte input */
 	outw(dio_mode, dev->iobase + PCI1723_DIGITAL_IO_PORT_SET);
 	return 1;
 }
@@ -311,7 +335,8 @@ static int pci1723_attach(struct comedi_device *dev,
 	int opt_bus, opt_slot;
 	const char *errstr;
 
-	printk("comedi%d: adv_pci1723: board=%s", dev->minor, this_board->name);
+	printk(KERN_ERR "comedi%d: adv_pci1723: board=%s",
+						dev->minor, this_board->name);
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
@@ -349,10 +374,10 @@ static int pci1723_attach(struct comedi_device *dev,
 
 	if (!pcidev) {
 		if (opt_bus || opt_slot) {
-			printk(" - Card at b:s %d:%d %s\n",
-			       opt_bus, opt_slot, errstr);
+			printk(KERN_ERR " - Card at b:s %d:%d %s\n",
+						     opt_bus, opt_slot, errstr);
 		} else {
-			printk(" - Card %s\n", errstr);
+			printk(KERN_ERR " - Card %s\n", errstr);
 		}
 		return -EIO;
 	}
@@ -362,8 +387,8 @@ static int pci1723_attach(struct comedi_device *dev,
 	pci_func = PCI_FUNC(pcidev->devfn);
 	iobase = pci_resource_start(pcidev, 2);
 
-	printk(", b:s:f=%d:%d:%d, io=0x%4x", pci_bus, pci_slot, pci_func,
-	       iobase);
+	printk(KERN_ERR ", b:s:f=%d:%d:%d, io=0x%4x",
+					   pci_bus, pci_slot, pci_func, iobase);
 
 	dev->iobase = iobase;
 
@@ -398,22 +423,23 @@ static int pci1723_attach(struct comedi_device *dev,
 		s->insn_write = pci1723_ao_write_winsn;
 		s->insn_read = pci1723_insn_read_ao;
 
-		/*  read DIO config */
-		switch (inw(dev->iobase + PCI1723_DIGITAL_IO_PORT_MODE) & 0x03) {
-		case 0x00:	/*  low byte output, high byte output */
+		/* read DIO config */
+		switch (inw(dev->iobase + PCI1723_DIGITAL_IO_PORT_MODE)
+								       & 0x03) {
+		case 0x00:	/* low byte output, high byte output */
 			s->io_bits = 0xFFFF;
 			break;
-		case 0x01:	/*  low byte input, high byte output */
+		case 0x01:	/* low byte input, high byte output */
 			s->io_bits = 0xFF00;
 			break;
-		case 0x02:	/*  low byte output, high byte input */
+		case 0x02:	/* low byte output, high byte input */
 			s->io_bits = 0x00FF;
 			break;
-		case 0x03:	/*  low byte input, high byte input */
+		case 0x03:	/* low byte input, high byte input */
 			s->io_bits = 0x0000;
 			break;
 		}
-		/*  read DIO port state */
+		/* read DIO port state */
 		s->state = inw(dev->iobase + PCI1723_READ_DIGITAL_INPUT_DATA);
 
 		subdev++;
@@ -450,16 +476,15 @@ static int pci1723_attach(struct comedi_device *dev,
  */
 static int pci1723_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: pci1723: remove\n", dev->minor);
+	printk(KERN_ERR "comedi%d: pci1723: remove\n", dev->minor);
 
 	if (dev->private) {
 		if (devpriv->valid)
 			pci1723_reset(dev);
 
 		if (devpriv->pcidev) {
-			if (dev->iobase) {
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pcidev);
-			}
 			pci_dev_put(devpriv->pcidev);
 		}
 	}
-- 
1.6.3.3

