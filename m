Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1HTStq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 14:49:46 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:36382 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753989Ab1HTSto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 14:49:44 -0400
Date: Sat, 20 Aug 2011 11:49:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Cc: torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] pci: fix new kernel-doc warning in pci.c
Message-Id: <20110820114943.a6327944.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warning in pci.c:

Warning(drivers/pci/pci.c:3259): No description found for parameter 'mps'
Warning(drivers/pci/pci.c:3259): Excess function parameter 'rq' description in 'pcie_set_mps'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.1-rc2-git8.orig/drivers/pci/pci.c
+++ linux-3.1-rc2-git8/drivers/pci/pci.c
@@ -3250,7 +3250,7 @@ int pcie_get_mps(struct pci_dev *dev)
 /**
  * pcie_set_mps - set PCI Express maximum payload size
  * @dev: PCI device to query
- * @rq: maximum payload size in bytes
+ * @mps: maximum payload size in bytes
  *    valid values are 128, 256, 512, 1024, 2048, 4096
  *
  * If possible sets maximum payload size
