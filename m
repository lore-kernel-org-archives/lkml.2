Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2FLS7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:59:33 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:26411 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2FLS7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:59:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1339527544!4437784!38
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] staging: comedi: remove the "Allocate the subdevice..." comments
Date: Tue, 12 Jun 2012 11:59:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201206121159.15611.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8d64162758d994937590c97f8f1e926af3e349f1 Mon Sep 17 00:00:00 2001
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Date: Tue, 12 Jun 2012 10:46:36 -0700
Subject: [PATCH 6/8] staging: comedi: remove the "Allocate the subdevice..."
 comments

These comments are redundant. The function name 'comedi_alloc_subdevices'
provides this information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <ian@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../staging/comedi/drivers/addi-data/addi_common.c |    1 -
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    1 -
 drivers/staging/comedi/drivers/adq12b.c            |    4 ----
 drivers/staging/comedi/drivers/amplc_pci224.c      |    1 -
 drivers/staging/comedi/drivers/amplc_pci230.c      |    5 +----
 drivers/staging/comedi/drivers/c6xdigio.c          |    1 -
 drivers/staging/comedi/drivers/cb_pcidas.c         |    3 ---
 drivers/staging/comedi/drivers/cb_pcidda.c         |    3 ---
 drivers/staging/comedi/drivers/cb_pcidio.c         |    4 ----
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    4 ----
 drivers/staging/comedi/drivers/cb_pcimdda.c        |    4 ----
 drivers/staging/comedi/drivers/comedi_bond.c       |    4 ----
 drivers/staging/comedi/drivers/dmm32at.c           |    4 ----
 drivers/staging/comedi/drivers/dt9812.c            |    1 -
 drivers/staging/comedi/drivers/ke_counter.c        |    1 -
 drivers/staging/comedi/drivers/me4000.c            |    5 -----
 drivers/staging/comedi/drivers/mpc624.c            |    1 -
 drivers/staging/comedi/drivers/pcmda12.c           |    7 -------
 drivers/staging/comedi/drivers/pcmmio.c            |    7 +------
 drivers/staging/comedi/drivers/pcmuio.c            |    8 +-------
 drivers/staging/comedi/drivers/rtd520.c            |    4 ----
 drivers/staging/comedi/drivers/s526.c              |    4 ----
 drivers/staging/comedi/drivers/skel.c              |    4 ----
 drivers/staging/comedi/drivers/ssv_dnp.c           |    3 ---
 drivers/staging/comedi/drivers/usbdux.c            |    1 -
 drivers/staging/comedi/drivers/usbduxfast.c        |    1 -
 drivers/staging/comedi/drivers/usbduxsigma.c       |    1 -
 27 files changed, 3 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 274990a..46c590b 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -1686,7 +1686,6 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		devpriv->s_BoardInfos.ui_Address = io_addr[2];
 #endif
 	} else {
-		/* Update-0.7.57->0.7.68dev->n_subdevices = 7; */
 		n_subdevices = 7;
 		ret = comedi_alloc_subdevices(dev, n_subdevices);
 		if (ret < 0)
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
index 9632ca1..aa390b0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
@@ -62,7 +62,6 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	int ret = 0;
 	int n_subdevices = 9;
 
-	/* Update-0.7.57->0.7.68dev->n_subdevices = 9; */
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret < 0)
 		return;
diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index ca8892e..afc6815 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -267,10 +267,6 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->last_channel = -1;
 	devpriv->last_range = -1;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
 	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 7dd4057..d6e0d01 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1382,7 +1382,6 @@ static int pci224_attach_common(struct comedi_device *dev,
 	outw(devpriv->daccon | PCI224_DACCON_FIFORESET,
 	     dev->iobase + PCI224_DACCON);
 
-	/* Allocate subdevices.  There is only one!  */
 	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 03c83e4..c9d8d5b 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2840,10 +2840,7 @@ static int pci230_attach_common(struct comedi_device *dev,
 		dev_dbg(dev->class_dev, "registered irq %u\n",
 			devpriv->pci_dev->irq);
 	}
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 */
+
 	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index 72b000f..5fa344b 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -433,7 +433,6 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	dev->board_name = "c6xdigio";
 
-	/* 3 subdevices with encoder_init write */
 	result = comedi_alloc_subdevices(dev, 2);
 	if (result < 0)
 		return result;
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 435f3aa..e1bd99a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -614,9 +614,6 @@ found:
 	/* Initialize dev->board_name */
 	dev->board_name = thisboard->name;
 
-/*
- * Allocate the subdevice structures.
- */
 	if (comedi_alloc_subdevices(dev, 7) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 4ab3584..fedaf55 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -333,9 +333,6 @@ found:
  */
 	dev->board_name = thisboard->name;
 
-/*
- * Allocate the subdevice structures.
- */
 	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 56c1d09..f2fff4f 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -177,10 +177,6 @@ found:
 	    pci_resource_start(devpriv->pci_dev,
 			       pcidio_boards[index].dioregs_badrindex);
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
 	if (comedi_alloc_subdevices(dev, thisboard->n_8255) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 6acb319..0ada8b9 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -269,10 +269,6 @@ found:
 	/* Initialize dev->board_name */
 	dev->board_name = thisboard->name;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
 	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index abb6008..b401aec 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -236,10 +236,6 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
  */
 	dev->board_name = thisboard->name;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
 	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index d56eec4..96e5b35 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -358,10 +358,6 @@ static int bonding_attach(struct comedi_device *dev,
 	 */
 	dev->board_name = devpriv->name;
 
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 */
 	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 40d7bef..6b637a2 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -371,10 +371,6 @@ static int dmm32at_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct dmm32at_private)) < 0)
 		return -ENOMEM;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
 	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 56af2f2..678fa50 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -1035,7 +1035,6 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	devpriv->serial = it->options[0];
 
-	/* Allocate subdevices */
 	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index bcb1eb4..7c256f4 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -189,7 +189,6 @@ found:
 	io_base = pci_resource_start(pci_device, 0);
 	dev->iobase = io_base;
 
-	/* allocate the subdevice structures */
 	error = comedi_alloc_subdevices(dev, 1);
 	if (error < 0)
 		return error;
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 8d011cb..2ca8d8b 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -2190,11 +2190,6 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (result)
 		return result;
 
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.  It relies on
-	 * n_subdevices being set correctly.
-	 */
 	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/mpc624.c b/drivers/staging/comedi/drivers/mpc624.c
index 48ba6b9..9750336 100644
--- a/drivers/staging/comedi/drivers/mpc624.c
+++ b/drivers/staging/comedi/drivers/mpc624.c
@@ -348,7 +348,6 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		devpriv->ulConvertionRate = MPC624_SPEED_3_52_kHz;
 	}
 
-	/*  Subdevices structures */
 	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index e1b30cc..87faa03 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -190,13 +190,6 @@ static int pcmda12_attach(struct comedi_device *dev,
 
 	devpriv->simultaneous_xfer_mode = it->options[1];
 
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 *
-	 * Allocate 2 subdevs (32 + 16 DIO lines) or 3 32 DIO subdevs for the
-	 * 96-channel version of the board.
-	 */
 	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index abaf6c7..3105303 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -1071,12 +1071,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				dev->minor);
 		return -ENOMEM;
 	}
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 *
-	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
-	 */
+
 	if (comedi_alloc_subdevices(dev, n_subdevs) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index e4153bd..33ab4c6 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -800,13 +800,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		dev_warn(dev->hw_dev, "cannot allocate subdevice private data structures\n");
 		return -ENOMEM;
 	}
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 *
-	 * Allocate 2 subdevs (32 + 16 DIO lines) or 3 32 DIO subdevs for the
-	 * 96-channel version of the board.
-	 */
+
 	if (comedi_alloc_subdevices(dev, n_subdevs) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 7d248a7..445333b 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1999,10 +1999,6 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* Show board configuration */
 	printk(KERN_INFO "%s:", dev->board_name);
 
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 */
 	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index dbbff70..6a30537 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -774,10 +774,6 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct s526_private)) < 0)
 		return -ENOMEM;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
 	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 16947c8..ca10b1a 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -233,10 +233,6 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct skel_private)) < 0)
 		return -ENOMEM;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
 	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 5eaef84..130e4bd 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -197,9 +197,6 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct dnp_private_data)) < 0)
 		return -ENOMEM;
 
-	/* Allocate the subdevice structures. alloc_subdevice() is a         */
-	/* convenient macro defined in comedidev.h.                          */
-
 	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 79df200..a6cf134 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2645,7 +2645,6 @@ static int usbdux_attach_common(struct comedi_device *dev,
 		n_subdevs = 4;
 	}
 
-	/* allocate space for the subdevices */
 	ret = comedi_alloc_subdevices(dev, n_subdevs);
 	if (ret < 0) {
 		up(&udev->sem);
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 660dd4e..f7d4f56 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1666,7 +1666,6 @@ static int usbduxfast_attach(struct comedi_device *dev,
 
 	dev->board_name = BOARDNAME;
 
-	/* allocate space for the subdevices */
 	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0) {
 		up(&(usbduxfastsub[index].sem));
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index f37e96c..f23fad9 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -2690,7 +2690,6 @@ static int usbduxsigma_attach(struct comedi_device *dev,
 		n_subdevs = 3;
 	}
 
-	/* allocate space for the subdevices */
 	ret = comedi_alloc_subdevices(dev, n_subdevs);
 	if (ret < 0) {
 		up(&udev->sem);
-- 
1.7.7

