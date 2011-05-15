Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab1EOKe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 06:34:59 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:50142 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab1EOKe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 06:34:58 -0400
Message-ID: <4DCFAC4F.5030606@web.de>
Date: Sun, 15 May 2011 12:34:55 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH] intel-iommu: Remove obsolete comment from detect_intel_iommu
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/NL78wZlu189hnjX0CQVeYrgxYjNbZ//FEEg0f
	ou7f2p4hBcQTNwtKmUqKgX1ZgonAcdetnTHRnjO/g33Llqfdo0
	CuML5Qaq4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Since cacd4213d8, this comment no longer applies.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 drivers/pci/dmar.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 12e02bf..3dc9bef 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -698,12 +698,7 @@ int __init detect_intel_iommu(void)
 	{
 #ifdef CONFIG_INTR_REMAP
 		struct acpi_table_dmar *dmar;
-		/*
-		 * for now we will disable dma-remapping when interrupt
-		 * remapping is enabled.
-		 * When support for queued invalidation for IOTLB invalidation
-		 * is added, we will not need this any more.
-		 */
+
 		dmar = (struct acpi_table_dmar *) dmar_tbl;
 		if (ret && cpu_has_x2apic && dmar->flags & 0x1)
 			printk(KERN_INFO
-- 
1.7.1
