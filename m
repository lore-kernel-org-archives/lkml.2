Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2GSBrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:47:06 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:10549 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab2GSBrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:47:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1342662420!14754685!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 49/90] staging: comedi: cb_pcimdas: remove the debug print of the pci bars
Date: Wed, 18 Jul 2012 18:46:50 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181846.50532.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the dev_dbg output of the pci addresses. It's just add noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 1b6ebb7..3400067 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -250,12 +250,6 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	devpriv->BADR3 = pci_resource_start(devpriv->pci_dev, 3);
 	devpriv->BADR4 = pci_resource_start(devpriv->pci_dev, 4);
 
-	dev_dbg(dev->class_dev, "devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
-	dev_dbg(dev->class_dev, "devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
-	dev_dbg(dev->class_dev, "devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
-	dev_dbg(dev->class_dev, "devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
-	dev_dbg(dev->class_dev, "devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
-
 /* Dont support IRQ yet */
 /*  get irq */
 /* if(request_irq(devpriv->pci_dev->irq, cb_pcimdas_interrupt, IRQF_SHARED, "cb_pcimdas", dev )) */
-- 
1.7.11

