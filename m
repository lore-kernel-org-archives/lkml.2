Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1JWP1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 11:27:46 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57422 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1JWP1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 11:27:45 -0400
Subject: [PATCH] [TRIVIAL] remove commented out Kconfig entries
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Oct 2011 17:23:54 +0200
Message-ID: <1319383434.6286.6.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These Kconfig entries have been commented out since (at least)
v2.6.12-rc2 (the first commit of the git repository). There's no
indication why they're commented out. They might as well be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
"git grep" tested only.

 arch/frv/Kconfig           |   10 ----------
 arch/mips/Kconfig          |    4 ----
 arch/mips/sgi-ip27/Kconfig |    6 ------
 drivers/parisc/Kconfig     |    7 -------
 4 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index bad27a6..c5e69ab 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -341,16 +341,6 @@ source "drivers/pci/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
-#config MATH_EMULATION
-#	bool "Math emulation support (EXPERIMENTAL)"
-#	depends on EXPERIMENTAL
-#	help
-#	  At some point in the future, this will cause floating-point math
-#	  instructions to be emulated by the kernel on machines that lack a
-#	  floating-point math coprocessor.  Thrill-seekers and chronically
-#	  sleep-deprived psychotic hacker types can say Y now, everyone else
-#	  should probably wait a while.
-
 menu "Power management options"
 
 config ARCH_SUSPEND_POSSIBLE
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b122adc..c616420 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2386,10 +2386,6 @@ config TC
 	  Linux driver support status is documented at:
 	  <http://www.linux-mips.org/wiki/DECstation>
 
-#config ACCESSBUS
-#	bool "Access.Bus support"
-#	depends on TC
-
 config MMU
 	bool
 	default y
diff --git a/arch/mips/sgi-ip27/Kconfig b/arch/mips/sgi-ip27/Kconfig
index bc5e976..4b2ea28 100644
--- a/arch/mips/sgi-ip27/Kconfig
+++ b/arch/mips/sgi-ip27/Kconfig
@@ -1,9 +1,3 @@
-#config SGI_SN0_XXL
-#	bool "IP27 XXL"
-#	depends on SGI_IP27
-#	  This options adds support for userspace processes up to 16TB size.
-#	  Normally the limit is just .5TB.
-
 choice
 	prompt "Node addressing mode"
 	depends on SGI_IP27
diff --git a/drivers/parisc/Kconfig b/drivers/parisc/Kconfig
index 553a990..6202649 100644
--- a/drivers/parisc/Kconfig
+++ b/drivers/parisc/Kconfig
@@ -108,13 +108,6 @@ config IOMMU_HELPER
 	depends on IOMMU_SBA || IOMMU_CCIO
 	default y
 
-#config PCI_EPIC
-#	bool "EPIC/SAGA PCI support"
-#	depends on PCI
-#	default y
-#	help
-#	  Say Y here for V-class PCI, DMA/IOMMU, IRQ subsystem support.
-
 source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"
-- 
1.7.4.4




