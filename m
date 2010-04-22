Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab0DVUNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:13:42 -0400
Received: from kroah.org ([198.145.64.141]:59928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461Ab0DVUBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:20 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:15 2010
Message-Id: <20100422195415.208334908@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Seth Heasley <seth.heasley@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       maximilian attems <max@stro.at>
Subject: [098/139] x86/PCI: irq and pci_ids patch for Intel Cougar Point DeviceIDs
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 93da6202264ce1256b04db8008a43882ae62d060 upstream.

This patch adds the Intel Cougar Point (PCH) LPC and SMBus Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/irq.c      |    2 ++
 include/linux/pci_ids.h |    3 +++
 2 files changed, 5 insertions(+)

--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -590,6 +590,8 @@ static __init int intel_router_probe(str
 	case PCI_DEVICE_ID_INTEL_ICH10_1:
 	case PCI_DEVICE_ID_INTEL_ICH10_2:
 	case PCI_DEVICE_ID_INTEL_ICH10_3:
+	case PCI_DEVICE_ID_INTEL_CPT_LPC1:
+	case PCI_DEVICE_ID_INTEL_CPT_LPC2:
 		r->name = "PIIX/ICH";
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2417,6 +2417,9 @@
 #define PCI_DEVICE_ID_INTEL_82840_HB	0x1a21
 #define PCI_DEVICE_ID_INTEL_82845_HB	0x1a30
 #define PCI_DEVICE_ID_INTEL_IOAT	0x1a38
+#define PCI_DEVICE_ID_INTEL_CPT_SMBUS	0x1c22
+#define PCI_DEVICE_ID_INTEL_CPT_LPC1	0x1c42
+#define PCI_DEVICE_ID_INTEL_CPT_LPC2	0x1c43
 #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
 #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
 #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413


