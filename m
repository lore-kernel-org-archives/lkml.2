Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1AJSLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:11:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab1AJSLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:11:10 -0500
Date: Mon, 10 Jan 2011 13:10:52 -0500
From: Dave Jones <davej@redhat.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: correct fucked grammar in mips ops-bridge.c
Message-ID: <20110110181052.GA20090@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had no idea just how broken IOC3 was until I read this.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/mips/pci/ops-bridge.c b/arch/mips/pci/ops-bridge.c
index b46b3e2..4383194 100644
--- a/arch/mips/pci/ops-bridge.c
+++ b/arch/mips/pci/ops-bridge.c
@@ -56,7 +56,7 @@ static int pci_conf0_read_config(struct pci_bus *bus, unsigned int devfn,
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't even give the
+	 * IOC3 is fucking fucked beyond belief ...  Don't even give the
 	 * generic PCI code a chance to look at it for real ...
 	 */
 	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16)))
@@ -76,7 +76,7 @@ static int pci_conf0_read_config(struct pci_bus *bus, unsigned int devfn,
 oh_my_gawd:
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't even give the
+	 * IOC3 is fucking fucked beyond belief ...  Don't even give the
 	 * generic PCI code a chance to look at the wrong register.
 	 */
 	if ((where >= 0x14 && where < 0x40) || (where >= 0x48)) {
@@ -85,7 +85,7 @@ oh_my_gawd:
 	}
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't try to access
+	 * IOC3 is fucking fucked beyond belief ...  Don't try to access
 	 * anything but 32-bit words ...
 	 */
 	addr = &bridge->b_type0_cfg_dev[slot].f[fn].l[where >> 2];
@@ -118,7 +118,7 @@ static int pci_conf1_read_config(struct pci_bus *bus, unsigned int devfn,
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't even give the
+	 * IOC3 is fucking fucked beyond belief ...  Don't even give the
 	 * generic PCI code a chance to look at it for real ...
 	 */
 	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16)))
@@ -139,7 +139,7 @@ static int pci_conf1_read_config(struct pci_bus *bus, unsigned int devfn,
 oh_my_gawd:
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't even give the
+	 * IOC3 is fucking fucked beyond belief ...  Don't even give the
 	 * generic PCI code a chance to look at the wrong register.
 	 */
 	if ((where >= 0x14 && where < 0x40) || (where >= 0x48)) {
@@ -148,7 +148,7 @@ oh_my_gawd:
 	}
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't try to access
+	 * IOC3 is fucking fucked beyond belief ...  Don't try to access
 	 * anything but 32-bit words ...
 	 */
 	bridge->b_pci_cfg = (busno << 16) | (slot << 11);
@@ -189,7 +189,7 @@ static int pci_conf0_write_config(struct pci_bus *bus, unsigned int devfn,
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't even give the
+	 * IOC3 is fucking fucked beyond belief ...  Don't even give the
 	 * generic PCI code a chance to look at it for real ...
 	 */
 	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16)))
@@ -213,14 +213,14 @@ static int pci_conf0_write_config(struct pci_bus *bus, unsigned int devfn,
 oh_my_gawd:
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't even give the
+	 * IOC3 is fucking fucked beyond belief ...  Don't even give the
 	 * generic PCI code a chance to touch the wrong register.
 	 */
 	if ((where >= 0x14 && where < 0x40) || (where >= 0x48))
 		return PCIBIOS_SUCCESSFUL;
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't try to access
+	 * IOC3 is fucking fucked beyond belief ...  Don't try to access
 	 * anything but 32-bit words ...
 	 */
 	addr = &bridge->b_type0_cfg_dev[slot].f[fn].l[where >> 2];
@@ -257,7 +257,7 @@ static int pci_conf1_write_config(struct pci_bus *bus, unsigned int devfn,
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't even give the
+	 * IOC3 is fucking fucked beyond belief ...  Don't even give the
 	 * generic PCI code a chance to look at it for real ...
 	 */
 	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16)))
@@ -281,14 +281,14 @@ static int pci_conf1_write_config(struct pci_bus *bus, unsigned int devfn,
 oh_my_gawd:
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't even give the
+	 * IOC3 is fucking fucked beyond belief ...  Don't even give the
 	 * generic PCI code a chance to touch the wrong register.
 	 */
 	if ((where >= 0x14 && where < 0x40) || (where >= 0x48))
 		return PCIBIOS_SUCCESSFUL;
 
 	/*
-	 * IOC3 is fucked fucked beyond believe ...  Don't try to access
+	 * IOC3 is fucking fucked beyond belief ...  Don't try to access
 	 * anything but 32-bit words ...
 	 */
 	addr = &bridge->b_type0_cfg_dev[slot].f[fn].l[where >> 2];
