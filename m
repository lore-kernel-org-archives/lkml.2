Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab2F0WBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:01:38 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:24067 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab2F0WBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:01:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1340834463!11116209!43
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/19] staging: comedi: adl_pci6208: add whitespace to the subdev init
Date: Wed, 27 Jun 2012 15:01:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271501.27338.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add whitespace to the subdev initialization and remove the
unnecessary comments to improve readability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 34 ++++++++++++++--------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index e3f459b..b65fed7 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -251,26 +251,26 @@ static int pci6208_attach(struct comedi_device *dev,
 
 	s = dev->subdevices + 0;
 	/* analog output subdevice */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE;	/* anything else to add here?? */
-	s->n_chan = thisboard->ao_chans;
-	s->maxdata = 0xffff;	/* 16-bit DAC */
-	s->range_table = &range_bipolar10;	/* this needs to be checked. */
-	s->insn_write = pci6208_ao_winsn;
-	s->insn_read = pci6208_ao_rinsn;
+	s->type		= COMEDI_SUBD_AO;
+	s->subdev_flags	= SDF_WRITABLE;
+	s->n_chan	= thisboard->ao_chans;
+	s->maxdata	= 0xffff;
+	s->range_table	= &range_bipolar10;
+	s->insn_write	= pci6208_ao_winsn;
+	s->insn_read	= pci6208_ao_rinsn;
 
 	s = dev->subdevices + 1;
 	/* digital i/o subdevice */
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	s->n_chan = 8;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = pci6208_dio_insn_bits;
-	s->insn_config = pci6208_dio_insn_config;
-
-	s->io_bits = 0x0f;
-	s->state = inw(dev->iobase + PCI6208_DIO);
+	s->type		= COMEDI_SUBD_DIO;
+	s->subdev_flags	= SDF_READABLE | SDF_WRITABLE;
+	s->n_chan	= 8;
+	s->maxdata	= 1;
+	s->range_table	= &range_digital;
+	s->insn_bits	= pci6208_dio_insn_bits;
+	s->insn_config	= pci6208_dio_insn_config;
+
+	s->io_bits	= 0x0f;
+	s->state	= inw(dev->iobase + PCI6208_DIO);
 
 	dev_info(dev->class_dev, "%s: %s, I/O base=0x%04lx\n",
 		dev->driver->driver_name, dev->board_name, dev->iobase);
-- 
1.7.11

