Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1IGQa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:30:27 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47059 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1IGQaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:30:21 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 5/5] pata_sis: code style cleanups for consistency
Date: Wed,  7 Sep 2011 11:23:22 -0500
Message-Id: <1315412602-6560-6-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1315412602-6560-1-git-send-email-dpmcgee@gmail.com>
References: <1315412602-6560-1-git-send-email-dpmcgee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a lot of '  ' (double spaces) as well as ensuring use of tabs vs.
spaces is appropriate and consistent.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 drivers/ata/pata_sis.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index d886b0b..b0edc7d 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -55,7 +55,7 @@ static const struct sis_laptop sis_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
 	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
-	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
+	{ 0x5513, 0x1071, 0x8640 },	/* EasyNote K5305 */
 	/* end marker */
 	{ 0, }
 };
@@ -76,7 +76,7 @@ static int sis_short_ata40(struct pci_dev *dev)
 }
 
 /**
- *	sis_old_port_base		-	return PCI configuration base for dev
+ *	sis_old_port_base - return PCI configuration base for dev
  *	@adev: device
  *
  *	Returns the base of the PCI configuration registers for this port
@@ -85,11 +85,11 @@ static int sis_short_ata40(struct pci_dev *dev)
 
 static int sis_old_port_base(struct ata_device *adev)
 {
-	return  0x40 + (4 * adev->link->ap->port_no) +  (2 * adev->devno);
+	return 0x40 + (4 * adev->link->ap->port_no) + (2 * adev->devno);
 }
 
 /**
- *	sis_port_base		-	return PCI configuration base for dev
+ *	sis_port_base - return PCI configuration base for dev
  *	@adev: device
  *
  *	Returns the base of the PCI configuration registers for this port
@@ -112,7 +112,7 @@ static int sis_port_base(struct ata_device *adev)
 }
 
 /**
- *	sis_133_cable_detect	-	check for 40/80 pin
+ *	sis_133_cable_detect - check for 40/80 pin
  *	@ap: Port
  *	@deadline: deadline jiffies for the operation
  *
@@ -133,7 +133,7 @@ static int sis_133_cable_detect(struct ata_port *ap)
 }
 
 /**
- *	sis_66_cable_detect	-	check for 40/80 pin
+ *	sis_66_cable_detect - check for 40/80 pin
  *	@ap: Port
  *
  *	Perform cable detection on the UDMA66, UDMA100 and early UDMA133
@@ -155,7 +155,7 @@ static int sis_66_cable_detect(struct ata_port *ap)
 
 
 /**
- *	sis_pre_reset		-	probe begin
+ *	sis_pre_reset - probe begin
  *	@link: ATA link
  *	@deadline: deadline jiffies for the operation
  *
@@ -183,7 +183,7 @@ static int sis_pre_reset(struct ata_link *link, unsigned long deadline)
 
 
 /**
- *	sis_set_fifo	-	Set RWP fifo bits for this device
+ *	sis_set_fifo - Set RWP fifo bits for this device
  *	@ap: Port
  *	@adev: Device
  *
@@ -226,7 +226,7 @@ static void sis_set_fifo(struct ata_port *ap, struct ata_device *adev)
 
 static void sis_old_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int port = sis_old_port_base(adev);
 	u8 t1, t2;
 	int speed = adev->pio_mode - XFER_PIO_0;
@@ -263,7 +263,7 @@ static void sis_old_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int port = sis_old_port_base(adev);
 	int speed = adev->pio_mode - XFER_PIO_0;
 
@@ -288,7 +288,7 @@ static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int port;
 	u32 t1;
 	int speed = adev->pio_mode - XFER_PIO_0;
@@ -336,7 +336,7 @@ static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
@@ -375,7 +375,7 @@ static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
@@ -414,7 +414,7 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_100_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
 	u8 timing;
@@ -448,7 +448,7 @@ static void sis_100_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_133_early_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
 	u8 timing;
@@ -481,7 +481,7 @@ static void sis_133_early_set_dmamode (struct ata_port *ap, struct ata_device *a
 
 static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int port;
 	u32 t1;
 
@@ -710,7 +710,7 @@ static void sis_fixup(struct pci_dev *pdev, struct sis_chipset *sis)
  *	@pdev: PCI device to register
  *	@ent: Entry in sis_pci_tbl matching with @pdev
  *
- *	Called from kernel PCI layer.  We probe for combined mode (sigh),
+ *	Called from kernel PCI layer. We probe for combined mode (sigh),
  *	and then hand over control to libata, for it to do the rest.
  *
  *	LOCKING:
@@ -820,10 +820,10 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 			}
 			break;
 		case 0x0180:	/* SIS 965/965L */
-			chipset =  &sis133;
+			chipset = &sis133;
 			break;
 		case 0x1180:	/* SIS 966/966L */
-			chipset =  &sis133;
+			chipset = &sis133;
 			break;
 		}
 	}
-- 
1.7.6.1

