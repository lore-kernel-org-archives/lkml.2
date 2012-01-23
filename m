Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2AWXrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:47:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431Ab2AWXrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:47:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:24 2012
Message-Id: <20120123234024.581910853@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Williamson <alex.williamson@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [19/90] PCI: Fix PCI_EXP_TYPE_RC_EC value
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 1830ea91c20b06608f7cdb2455ce05ba834b3214 upstream.

Spec shows this as 1010b = 0xa

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/pci_regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


