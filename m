Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0LHBBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:09 -0500
Received: from kroah.org ([198.145.64.141]:48903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218Ab0LHBA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:58 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:32 2010
Message-Id: <20101208005732.872178468@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [115/289] agp/intel: Also add B43.1 to list of supported devices
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 3dde04b0152634d42994b34b86bbf3c70fbc6b19 upstream.

This was a missing piece from 41a5142 that dropped recognition of the
AGP module for the second B43 variant.

Reported-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1049,6 +1049,7 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_G45_HB),
 	ID(PCI_DEVICE_ID_INTEL_G41_HB),
 	ID(PCI_DEVICE_ID_INTEL_B43_HB),
+	ID(PCI_DEVICE_ID_INTEL_B43_1_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB),


