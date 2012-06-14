Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab2FNX5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:57:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2FNX5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:57:45 -0400
Message-Id: <20120614235644.410709680@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 01/20] char/agp: add another Ironlake host bridge
In-Reply-To: <20120614235648.GA6552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit 67384fe3fd450536342330f684ea1f7dcaef8130 upstream.

This seems to come on Gigabyte H55M-S2V and was discovered through the
https://bugs.freedesktop.org/show_bug.cgi?id=50381 debugging.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50381
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/agp/intel-agp.c |    1 +
 drivers/char/agp/intel-agp.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -897,6 +897,7 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_B43_HB),
 	ID(PCI_DEVICE_ID_INTEL_B43_1_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB),
+	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_D2_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_MC2_HB),
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -211,6 +211,7 @@
 #define PCI_DEVICE_ID_INTEL_G41_HB          0x2E30
 #define PCI_DEVICE_ID_INTEL_G41_IG          0x2E32
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB	    0x0040
+#define PCI_DEVICE_ID_INTEL_IRONLAKE_D2_HB	    0x0069
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_D_IG	    0x0042
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB	    0x0044
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB	    0x0062


