Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031317Ab2HIQES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:04:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:62991 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758624Ab2HIQEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:04:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,741,1336374000"; 
   d="scan'208";a="178041127"
From: james.d.ralston@intel.com
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>
Subject: [PATCH 1/5] ahci: Add Device IDs for Intel Lynx Point-LP PCH
Date: Thu,  9 Aug 2012 09:02:31 -0700
Message-Id: <1344528151-2306-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Ralston <james.d.ralston@intel.com>

This patch adds the AHCI-mode SATA Device IDs for the Intel Lynx Point-LP PCH

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 drivers/ata/ahci.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ebaf67e..c590259 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -267,6 +267,14 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x8c07), board_ahci }, /* Lynx Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c0e), board_ahci }, /* Lynx Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c0f), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c02), board_ahci }, /* Lynx Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c03), board_ahci }, /* Lynx Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c04), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c05), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c06), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c07), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c0e), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c0f), board_ahci }, /* Lynx Point-LP RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-- 
1.7.7.6

