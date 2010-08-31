Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab0HaGcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:32:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:25625 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab0HaGcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:32:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,297,1280732400"; 
   d="scan'208";a="652820349"
Date: Tue, 31 Aug 2010 14:14:16 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Feng Tang <feng.tang@intel.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] spi/dw_spi: Enable Intel Moorestown SPI controller 1
Message-ID: <20100831061416.GA5904@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable Intel Moorestown SPI controller 1

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
---
 drivers/spi/dw_spi_pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/dw_spi_pci.c b/drivers/spi/dw_spi_pci.c
index 1f52755..eec9d0b 100644
--- a/drivers/spi/dw_spi_pci.c
+++ b/drivers/spi/dw_spi_pci.c
@@ -142,6 +142,8 @@ static int spi_resume(struct pci_dev *pdev)
 static const struct pci_device_id pci_ids[] __devinitdata = {
 	/* Intel Moorestown platform SPI controller 0 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0800) },
+	/* Intel Moorestown platform SPI controller 1 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0801) },
 	{},
 };
 
-- 
1.5.5.1

