Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1KPQYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:24:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab1KPQYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:24:17 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] PCI: Fix PCI_EXP_TYPE_RC_EC value
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Date: Wed, 16 Nov 2011 09:24:16 -0700
Message-ID: <20111116162350.7705.28083.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spec shows this as 1010b = 0xa

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 include/linux/pci_regs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 090d3a9..9e37250 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -392,7 +392,7 @@
 #define  PCI_EXP_TYPE_DOWNSTREAM 0x6	/* Downstream Port */
 #define  PCI_EXP_TYPE_PCI_BRIDGE 0x7	/* PCI/PCI-X Bridge */
 #define  PCI_EXP_TYPE_RC_END	0x9	/* Root Complex Integrated Endpoint */
-#define  PCI_EXP_TYPE_RC_EC	0x10	/* Root Complex Event Collector */
+#define  PCI_EXP_TYPE_RC_EC	0xa	/* Root Complex Event Collector */
 #define PCI_EXP_FLAGS_SLOT	0x0100	/* Slot implemented */
 #define PCI_EXP_FLAGS_IRQ	0x3e00	/* Interrupt message number */
 #define PCI_EXP_DEVCAP		4	/* Device capabilities */

