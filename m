Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1HPTAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:00:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38677 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1HPTAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:00:31 -0400
Date: Tue, 16 Aug 2011 16:00:23 -0300 (BRT)
From: Marcos Paulo Souza <marcos.mage@gmail.com>
X-X-Sender: marcos@odin
To: jbarnes@virtuousgeek.org
cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: pci: pci.c: Fix a warning on make htmldocs
Message-ID: <alpine.DEB.2.02.1108161552120.10249@odin>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The fucntion pcie_set_mps has a parameter called mps, and this parameter
was not documented. Instead, the documentation was about the rq parameter.
Changing rq to mps on the documentation fix this warning.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/pci/pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 466fad6..1b78afe 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3250,8 +3250,8 @@ int pcie_get_mps(struct pci_dev *dev)
 /**
  * pcie_set_mps - set PCI Express maximum payload size
  * @dev: PCI device to query
- * @rq: maximum payload size in bytes
- *    valid values are 128, 256, 512, 1024, 2048, 4096
+ * @mps: maximum payload size in bytes
+ *	valid values are 128, 256, 512, 1024, 2048, 4096
  *
  * If possible sets maximum payload size
  */
-- 
1.7.4.1
