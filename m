Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab0G1SnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:43:20 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:48390 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752170Ab0G1SnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:43:19 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19mVTAeqEZm6Tp2zRqv06Fg5SM8lczzMhvM3OJ2kl
	QnsrBmQsKzI9SA
From: Peter Huewe <PeterHuewe@gmx.de>
To: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] arm/mach-ixp2000: Add missing comma - fix build failure
Date: Wed, 28 Jul 2010 20:43:13 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Tejun Heo <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007282043.13561.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This trivial patch fixes a build failure [1] by adding a missing comma.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20100728

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2980895/

BF introduced by 3cad685d - ARM: 6253/1: Add 'code' parameter for
hook_fault_code()

 arch/arm/mach-ixp2000/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ixp2000/pci.c b/arch/arm/mach-ixp2000/pci.c
index 853fd90..f797c5f 100644
--- a/arch/arm/mach-ixp2000/pci.c
+++ b/arch/arm/mach-ixp2000/pci.c
@@ -209,7 +209,7 @@ ixp2000_pci_preinit(void)
 			"the needed workaround has not been configured in");
 #endif
 
-	hook_fault_code(16+6, ixp2000_pci_abort_handler, SIGBUS, 0
+	hook_fault_code(16+6, ixp2000_pci_abort_handler, SIGBUS, 0,
 				"PCI config cycle to non-existent device");
 }
 
-- 
1.7.1

