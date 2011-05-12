Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab1ELQpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:45:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62690 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab1ELQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BiVzj2o0DhjUY2kOLRoE5WSceLqjHVdIu0JVMNMkwXFrMPtMqmxoD6cyWDC9QFdqQj
         sFxoKZu6/iN+uYq47YDDXCb446qsBkDcf+l6CsU1d9PMTwLNu7rLJXGLMennbWb1KMyd
         IrUkGU5OsQW/f+71AFJB7S013OqjEEYMTnjfA=
From: Stephane Pajot <pajot.stephane@gmail.com>
To: gregkh@suse.de, arun.thomas@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Stephane Pajot <pajot.stephane@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: fix tabulation and over 80 chars issues in amplc_pci224.c This is a patch to the amplc_pci224.c file that fixes up tabulation style errors and over 80 chars warning found by the checkpatch.pl tool Signed-off-by: Stephane Pajot <pajot.stephane@gmail.com>
Date: Thu, 12 May 2011 18:44:58 +0200
Message-Id: <1305218698-7889-1-git-send-email-pajot.stephane@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/amplc_pci224.c |   63 +++++++++++++------------
 1 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 1b5ba1c..2f61358 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -52,33 +52,33 @@ Supports:
 Configuration options - PCI224:
   [0] - PCI bus of device (optional).
   [1] - PCI slot of device (optional).
-          If bus/slot is not specified, the first available PCI device
-          will be used.
+	If bus/slot is not specified, the first available PCI device
+	will be used.
   [2] - Select available ranges according to jumper LK1.  All channels
-        are set to the same range:
-        0=Jumper position 1-2 (factory default), 4 software-selectable
-          internal voltage references, giving 4 bipolar and 4 unipolar
-          ranges:
-            [-10V,+10V], [-5V,+5V], [-2.5V,+2.5V], [-1.25V,+1.25V],
-            [0,+10V], [0,+5V], [0,+2.5V], [0,1.25V].
-        1=Jumper position 2-3, 1 external voltage reference, giving
-          1 bipolar and 1 unipolar range:
-            [-Vext,+Vext], [0,+Vext].
+	are set to the same range :
+	0 = Jumper position 1-2 (factory default), 4 software-selectable
+	internal voltage references, giving 4 bipolar and 4 unipolar
+	ranges :
+	[-10V, + 10V][-5V, + 5V][-2.5V, + 2.5V][-1.25V, + 1.25V]
+	[0, + 10V][0, + 5V][0, + 2.5V][0, 1.25V].
+	1 = Jumper position 2-3, 1 external voltage reference, giving
+	1 bipolar and 1 unipolar range :
+	[-Vext, + Vext][0, + Vext].
 
 Configuration options - PCI234:
   [0] - PCI bus of device (optional).
   [1] - PCI slot of device (optional).
-          If bus/slot is not specified, the first available PCI device
-          will be used.
+	If bus/slot is not specified, the first available PCI device
+	will be used.
   [2] - Select internal or external voltage reference according to
-        jumper LK1.  This affects all channels:
-        0=Jumper position 1-2 (factory default), Vref=5V internal.
-        1=Jumper position 2-3, Vref=Vext external.
+	jumper LK1.  This affects all channels :
+	0 = Jumper position 1-2 (factory default), Vref = 5V internal.
+	1 = Jumper position 2-3, Vref = Vext external.
   [3] - Select channel 0 range according to jumper LK2:
-        0=Jumper position 2-3 (factory default), range [-2*Vref,+2*Vref]
-          (10V bipolar when options[2]=0).
-        1=Jumper position 1-2, range [-Vref,+Vref]
-          (5V bipolar when options[2]=0).
+	0 = Jumper position 2-3 (factory default), range[-2*Vref, + 2*Vref]
+	(10V bipolar when options[2] = 0).
+	1 = Jumper position 1-2, range[-Vref, + Vref]
+	(5V bipolar when options[2] = 0).
   [4] - Select channel 1 range according to jumper LK3: cf. options[3].
   [5] - Select channel 2 range according to jumper LK4: cf. options[3].
   [6] - Select channel 3 range according to jumper LK5: cf. options[3].
@@ -401,7 +401,8 @@ MODULE_DEVICE_TABLE(pci, pci224_pci_table);
 
 /* this structure is for data unique to this hardware driver.  If
    several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+   feel free to suggest moving the variable
+   to the struct comedi_device struct.  */
 struct pci224_private {
 	struct pci_dev *pci_dev;	/* PCI device */
 	const unsigned short *hwrange;
@@ -678,12 +679,14 @@ static void pci224_ao_handle_fifo(struct comedi_device *dev,
 	switch (dacstat & PCI224_DACCON_FIFOFL_MASK) {
 	case PCI224_DACCON_FIFOFL_EMPTY:
 		room = PCI224_FIFO_ROOM_EMPTY;
-		if (!devpriv->ao_stop_continuous && devpriv->ao_stop_count == 0) {
-			/* FIFO empty at end of counted acquisition. */
-			pci224_ao_stop(dev, s);
-			s->async->events |= COMEDI_CB_EOA;
-			comedi_event(dev, s);
-			return;
+		if (!devpriv->ao_stop_continuous == 0) {
+			if (devpriv->ao_stop_count == 0) {
+				/* FIFO empty at end of counted acquisition. */
+				pci224_ao_stop(dev, s);
+				s->async->events |= COMEDI_CB_EOA;
+				comedi_event(dev, s);
+				return;
+			}
 		}
 		break;
 	case PCI224_DACCON_FIFOFL_ONETOHALF:
@@ -912,9 +915,9 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		if ((cmd->scan_begin_arg & CR_FLAGS_MASK &
 		     ~(CR_EDGE | CR_INVERT)) != 0) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
-						      CR_FLAGS_MASK & ~(CR_EDGE
-									|
-									CR_INVERT));
+						CR_FLAGS_MASK & ~(CR_EDGE
+						|
+						CR_INVERT));
 			err++;
 		}
 		break;
-- 
1.7.1

