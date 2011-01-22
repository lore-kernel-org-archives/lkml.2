Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1AVNHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:07:53 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38722 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1AVNHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:07:51 -0500
From: Lars Randers <lars@nstec.dk>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars Randers <lars@nstec.dk>
Subject: [PATCH] drivers/ata/ahci.c: add device code for marvell 88se6141
Date: Sat, 22 Jan 2011 14:03:13 +0100
Message-Id: <1295701393-11417-1-git-send-email-lars@nstec.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the pci device code for the Marvell 88SE6141 SATA controller.

Signed-off-by: Lars Randers <lars@nstec.dk>
---
 drivers/ata/ahci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 3288263..b29a64d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -377,6 +377,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
+	{ PCI_VDEVICE(MARVELL, 0x6141), board_ahci_mv },	/* 6141 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
 	{ PCI_DEVICE(0x1b4b, 0x9123),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
-- 
1.7.1

