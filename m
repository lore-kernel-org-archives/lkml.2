Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab0LMARr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:17:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35908 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0LLXqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:13 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: chris@chris-wilson.co.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [74/223] agp/intel: Also add B43.1 to list of supported devices
Message-Id: <20101212234612.E4F37B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Chris Wilson <chris@chris-wilson.co.uk>

commit 3dde04b0152634d42994b34b86bbf3c70fbc6b19 upstream.

This was a missing piece from 41a5142 that dropped recognition of the
AGP module for the second B43 variant.

Reported-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/agp/intel-agp.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/char/agp/intel-agp.c
===================================================================
--- linux.orig/drivers/char/agp/intel-agp.c
+++ linux/drivers/char/agp/intel-agp.c
@@ -1048,6 +1048,7 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_G45_HB),
 	ID(PCI_DEVICE_ID_INTEL_G41_HB),
 	ID(PCI_DEVICE_ID_INTEL_B43_HB),
+	ID(PCI_DEVICE_ID_INTEL_B43_1_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB),
