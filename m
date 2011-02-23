Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1BWIfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:35:22 -0500
Received: from smtp151.dfw.emailsrvr.com ([67.192.241.151]:56750 "EHLO
	smtp151.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab1BWIfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:35:21 -0500
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Feb 2011 03:35:21 EST
From: HighPoint Linux Team <linux@highpoint-tech.com>
Organization: HighPoint Technologies, Inc.
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH][SCSI] mvsas: Add support for HighPoint RR27xx series HBA
Date: Wed, 23 Feb 2011 16:28:44 +0800
User-Agent: KMail/1.5.3
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <200902121128.31303.linux@highpoint-tech.com>
In-Reply-To: <200902121128.31303.linux@highpoint-tech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102231628.44678.linux@highpoint-tech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to add support for HighPoint RR27xx SAS/SATA HBA which is based on Marvell 88SE9480 chipset.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>

 drivers/scsi/mvsas/mv_init.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -urN linux-2.6.37.orig/drivers/scsi/mvsas/mv_init.c linux-2.6.37/drivers/scsi/mvsas/mv_init.c
--- linux-2.6.37.orig/drivers/scsi/mvsas/mv_init.c	2011-02-11 08:10:46.000000000 -0500
+++ linux-2.6.37/drivers/scsi/mvsas/mv_init.c	2011-02-11 10:47:01.000000000 -0500
@@ -663,6 +663,13 @@
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
 	{ PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
+	{ PCI_VDEVICE(TTI, 0x2710), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2720), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2721), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2722), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2740), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2744), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2760), chip_9480 },
 
 	{ }	/* terminate list */
 };


