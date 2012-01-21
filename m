Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab2AUSEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:04:37 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:38065 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751134Ab2AUSEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:08 -0500
Message-ID: <4F1B0BCB.4090901@xenotime.net>
Date: Sat, 21 Jan 2012 11:02:35 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 3/14] kernel-doc: fix new warnings in pci
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warnings:

Warning(drivers/pci/pci.c:2811): No description found for parameter 'dev'
Warning(drivers/pci/pci.c:2811): Excess function parameter 'pdev' description in 'pci_intx_mask_supported'
Warning(drivers/pci/pci.c:2894): No description found for parameter 'dev'
Warning(drivers/pci/pci.c:2894): Excess function parameter 'pdev' description in 'pci_check_and_mask_intx'
Warning(drivers/pci/pci.c:2908): No description found for parameter 'dev'
Warning(drivers/pci/pci.c:2908): Excess function parameter 'pdev' description in 'pci_check_and_unmask_intx'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- lnx-33-rc1.orig/drivers/pci/pci.c
+++ lnx-33-rc1/drivers/pci/pci.c
@@ -2802,7 +2802,7 @@ pci_intx(struct pci_dev *pdev, int enabl
 
 /**
  * pci_intx_mask_supported - probe for INTx masking support
- * @pdev: the PCI device to operate on
+ * @dev: the PCI device to operate on
  *
  * Check if the device dev support INTx masking via the config space
  * command word.
@@ -2884,7 +2884,7 @@ done:
 
 /**
  * pci_check_and_mask_intx - mask INTx on pending interrupt
- * @pdev: the PCI device to operate on
+ * @dev: the PCI device to operate on
  *
  * Check if the device dev has its INTx line asserted, mask it and
  * return true in that case. False is returned if not interrupt was
@@ -2898,7 +2898,7 @@ EXPORT_SYMBOL_GPL(pci_check_and_mask_int
 
 /**
  * pci_check_and_mask_intx - unmask INTx of no interrupt is pending
- * @pdev: the PCI device to operate on
+ * @dev: the PCI device to operate on
  *
  * Check if the device dev has its INTx line asserted, unmask it if not
  * and return true. False is returned and the mask remains active if
