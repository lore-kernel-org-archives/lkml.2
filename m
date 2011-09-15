Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873Ab1IOUPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:15:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:34423 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934682Ab1IOUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="54168359"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, gregkh@suse.de
Subject: [PATCH 22/27] Initconst section fixes for TTY
Date: Thu, 15 Sep 2011 13:09:49 -0700
Message-Id: <1316117394-21666-23-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: gregkh@suse.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/tty/serial/mfd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/mfd.c b/drivers/tty/serial/mfd.c
index cab52f4..29fc6aa 100644
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -1423,7 +1423,7 @@ static void serial_hsu_remove(struct pci_dev *pdev)
 }
 
 /* First 3 are UART ports, and the 4th is the DMA */
-static const struct pci_device_id pci_ids[] __devinitdata = {
+static const struct pci_device_id pci_ids[] __devinitconst = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081B) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081C) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081D) },
-- 
1.7.4.4

