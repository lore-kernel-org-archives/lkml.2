Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0C3XRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:17:49 -0400
Received: from kroah.org ([198.145.64.141]:51876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab0C3XRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:46 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:16 2010
Message-Id: <20100330225616.469592673@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Srinivas <satyasrinivasp@hcl.in>, Andy Yan <ayan@marvell.com>,
       James Bottomley <James.Bottomley@suse.de>, Thomas Voegtle <tv@lio96.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [029/116] [SCSI] mvsas: add support for Adaptec ASC-1045/1405 SAS/SATA HBA
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Srinivas <satyasrinivasp@hcl.in>

commit 7ec4ad0125db0222e397508c190b01c8f2b5f7cd upstream.

This is support for Adaptec ASC-1045/1405 SAS/SATA HBA on mvsas, which
is based on Marvell 88SE6440 chipset.

Signed-off-by: Srinivas <satyasrinivasp@hcl.in>
Cc: Andy Yan <ayan@marvell.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: Thomas Voegtle <tv@lio96.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mvsas/mv_init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -657,6 +657,7 @@ static struct pci_device_id __devinitdat
 	{ PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
 
 	{ }	/* terminate list */
 };


