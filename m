Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab0CXQ76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271Ab0CXQ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:59:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Patch b26b2d49 added lines with a missing semicolons
To: torvalds@osdl.org, akpm@linux-foundation.org, linux@dominikbrodowski.net
Cc: linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com,
       linux-pci@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 24 Mar 2010 16:59:36 +0000
Message-ID: <20100324165935.10443.51423.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch added lines with a missing semicolons:

	commit b26b2d494b659f988b4d75eb394dfa0ddac415c9
	Author: Dominik Brodowski <linux@dominikbrodowski.net>
	Date:   Fri Jan 1 17:40:49 2010 +0100

	resource/PCI: align functions now return start of resource

Add the missing semicolons to the FRV and CRIS arch code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/cris/arch-v32/drivers/pci/bios.c |    2 +-
 arch/frv/mb93090-mb00/pci-frv.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/cris/arch-v32/drivers/pci/bios.c b/arch/cris/arch-v32/drivers/pci/bios.c
index d4b9c36..bc0cfda 100644
--- a/arch/cris/arch-v32/drivers/pci/bios.c
+++ b/arch/cris/arch-v32/drivers/pci/bios.c
@@ -50,7 +50,7 @@ pcibios_align_resource(void *data, const struct resource *res,
 	if ((res->flags & IORESOURCE_IO) && (start & 0x300))
 		start = (start + 0x3ff) & ~0x3ff;
 
-	return start
+	return start;
 }
 
 int pcibios_enable_resources(struct pci_dev *dev, int mask)
diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
index 1ed15d7..0960e6d 100644
--- a/arch/frv/mb93090-mb00/pci-frv.c
+++ b/arch/frv/mb93090-mb00/pci-frv.c
@@ -41,7 +41,7 @@ pcibios_align_resource(void *data, const struct resource *res,
 	if ((res->flags & IORESOURCE_IO) && (start & 0x300))
 		start = (start + 0x3ff) & ~0x3ff;
 
-	return start
+	return start;
 }
 
 

