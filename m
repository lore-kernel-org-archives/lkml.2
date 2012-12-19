Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2LSBwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:52:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:50674 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab2LSBwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:52:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="233627005"
From: David Cohen <david.a.cohen@intel.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        David Cohen <david.a.cohen@intel.com>
Subject: [PATCH 2/3] gpio-langwell: update pci device table
Date: Tue, 18 Dec 2012 17:52:12 -0800
Message-Id: <1355881933-15182-3-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com>
References: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Cloverview ids to pci device table.

Signed-off-by: David Cohen <david.a.cohen@intel.com>
---
 drivers/gpio/gpio-langwell.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 8220c04..dc534a9 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -231,6 +231,8 @@ static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f), .driver_data = 64 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081f), .driver_data = 96 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081a), .driver_data = 96 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08eb), .driver_data = 96 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08f7), .driver_data = 96 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
-- 
1.7.10.4

