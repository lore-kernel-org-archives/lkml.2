Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab2FQSWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50086 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757905Ab2FQSWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:03 -0400
Message-Id: <20120617175942.061097551@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 05/69] char/agp: add another Ironlake host bridge
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit 67384fe3fd450536342330f684ea1f7dcaef8130 upstream.

This seems to come on Gigabyte H55M-S2V and was discovered through the
https://bugs.freedesktop.org/show_bug.cgi?id=50381 debugging.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50381
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/agp/intel-agp.c |    1 +
 drivers/char/agp/intel-agp.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 764f70c..0a41852 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -898,6 +898,7 @@ static struct pci_device_id agp_intel_pci_table[] = {
 	ID(PCI_DEVICE_ID_INTEL_B43_HB),
 	ID(PCI_DEVICE_ID_INTEL_B43_1_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB),
+	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_D2_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_MC2_HB),
diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index c009175..8e2d914 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -212,6 +212,7 @@
 #define PCI_DEVICE_ID_INTEL_G41_HB          0x2E30
 #define PCI_DEVICE_ID_INTEL_G41_IG          0x2E32
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB	    0x0040
+#define PCI_DEVICE_ID_INTEL_IRONLAKE_D2_HB	    0x0069
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_D_IG	    0x0042
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB	    0x0044
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB	    0x0062


