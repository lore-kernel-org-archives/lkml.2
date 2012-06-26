Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2FZARG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:17:06 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:39802 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab2FZARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:17:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1340669783!11496665!18
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 27/33] staging: comedi: cb_das16_cs: add whitespace to the subdev init
Date: Mon, 25 Jun 2012 17:16:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251716.54264.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some whitespace to the subdev initialization to improve
readability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 48 ++++++++++++++--------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index c92e232..11dc9b1 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -475,39 +475,39 @@ static int das16cs_attach(struct comedi_device *dev,
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
 	/* analog input subdevice */
-	s->type = COMEDI_SUBD_AI;
-	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
-	s->n_chan = 16;
-	s->maxdata = 0xffff;
-	s->range_table = &das16cs_ai_range;
-	s->len_chanlist = 16;
-	s->insn_read = das16cs_ai_rinsn;
-	s->do_cmd = das16cs_ai_cmd;
-	s->do_cmdtest = das16cs_ai_cmdtest;
+	s->type		= COMEDI_SUBD_AI;
+	s->subdev_flags	= SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
+	s->n_chan	= 16;
+	s->maxdata	= 0xffff;
+	s->range_table	= &das16cs_ai_range;
+	s->len_chanlist	= 16;
+	s->insn_read	= das16cs_ai_rinsn;
+	s->do_cmd	= das16cs_ai_cmd;
+	s->do_cmdtest	= das16cs_ai_cmdtest;
 
 	s = dev->subdevices + 1;
 	/* analog output subdevice */
 	if (thisboard->n_ao_chans) {
-		s->type = COMEDI_SUBD_AO;
-		s->subdev_flags = SDF_WRITABLE;
-		s->n_chan = thisboard->n_ao_chans;
-		s->maxdata = 0xffff;
-		s->range_table = &range_bipolar10;
-		s->insn_write = &das16cs_ao_winsn;
-		s->insn_read = &das16cs_ao_rinsn;
+		s->type		= COMEDI_SUBD_AO;
+		s->subdev_flags	= SDF_WRITABLE;
+		s->n_chan	= thisboard->n_ao_chans;
+		s->maxdata	= 0xffff;
+		s->range_table	= &range_bipolar10;
+		s->insn_write	= &das16cs_ao_winsn;
+		s->insn_read	= &das16cs_ao_rinsn;
 	} else {
-		s->type = COMEDI_SUBD_UNUSED;
+		s->type		= COMEDI_SUBD_UNUSED;
 	}
 
 	s = dev->subdevices + 2;
 	/* digital i/o subdevice */
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	s->n_chan = 8;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = das16cs_dio_insn_bits;
-	s->insn_config = das16cs_dio_insn_config;
+	s->type		= COMEDI_SUBD_DIO;
+	s->subdev_flags	= SDF_READABLE | SDF_WRITABLE;
+	s->n_chan	= 8;
+	s->maxdata	= 1;
+	s->range_table	= &range_digital;
+	s->insn_bits	= das16cs_dio_insn_bits;
+	s->insn_config	= das16cs_dio_insn_config;
 
 	dev_info(dev->class_dev, "%s: %s, I/O base=0x%04lx, irq=%u\n",
 		dev->driver->driver_name, dev->board_name,
-- 
1.7.11

