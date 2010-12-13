Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0LMSCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:02:10 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47527 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0LMSCH (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 13 Dec 2010 13:02:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 9/9] xen/xen-pciback: Swap over to DEFINE_PCI_DEVICE_TABLE
Date: Mon, 13 Dec 2010 13:01:43 -0500
Message-Id: <1292263303-31680-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/pciback/pci_stub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/pciback/pci_stub.c b/drivers/xen/pciback/pci_stub.c
index c8f6f29..09dd60c 100644
--- a/drivers/xen/pciback/pci_stub.c
+++ b/drivers/xen/pciback/pci_stub.c
@@ -497,7 +497,7 @@ static void pcistub_remove(struct pci_dev *dev)
 	}
 }
 
-static const struct pci_device_id pcistub_ids[] = {
+DEFINE_PCI_DEVICE_TABLE(pcistub_ids) = {
 	{
 	 .vendor = PCI_ANY_ID,
 	 .device = PCI_ANY_ID,
-- 
1.7.1

