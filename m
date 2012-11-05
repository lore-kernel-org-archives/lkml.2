Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2KEXPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:15:52 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35311 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab2KEXFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:30 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 054/104] drivers/iommu: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:11 -0800
Message-Id: <1352156701-4038-55-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Joerg Roedel <joerg.roedel@amd.com>
CC: Hiroshi DOYU <hdoyu@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>
CC: Jiri Kosina <jkosina@suse.cz>
CC: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/iommu/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e39f9db..0106898 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -65,8 +65,8 @@ config AMD_IOMMU_STATS
 	  If unsure, say N.
 
 config AMD_IOMMU_V2
-	tristate "AMD IOMMU Version 2 driver (EXPERIMENTAL)"
-	depends on AMD_IOMMU && PROFILING && EXPERIMENTAL
+	tristate "AMD IOMMU Version 2 driver"
+	depends on AMD_IOMMU && PROFILING
 	select MMU_NOTIFIER
 	---help---
 	  This option enables support for the AMD IOMMUv2 features of the IOMMU
@@ -119,8 +119,8 @@ config INTEL_IOMMU_FLOPPY_WA
 	  16MiB to make floppy (an ISA device) work.
 
 config IRQ_REMAP
-	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
-	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
+	bool "Support for Interrupt Remapping"
+	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI
 	select DMAR_TABLE
 	---help---
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
-- 
1.7.9.5

