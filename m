Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab2HEFM2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 01:12:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34515 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2HEFM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 01:12:27 -0400
From: Joe Millenbach <jmillenbach@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com, Joe Millenbach <jmillenbach@gmail.com>
Subject: [PATCH] x86: Changing date reference in CONFIG_SWIOTLB help from a relative to fixed point
Date: Sat,  4 Aug 2012 22:12:01 -0700
Message-Id: <1344143521-30151-1-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SWIOTLB's existing help information refers to "the current
generation of Intel's x86-64 CPUs", but the statement is no longer
true.  After researching on Intel's ark site, I changed the statement
to the also true "all Intel CPUs released before 2008".

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..dadbfd6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -755,10 +755,10 @@ config SWIOTLB
 	def_bool y if X86_64
 	---help---
 	  Support for software bounce buffers used on x86-64 systems
-	  which don't have a hardware IOMMU (e.g. the current generation
-	  of Intel's x86-64 CPUs). Using this PCI devices which can only
-	  access 32-bits of memory can be used on systems with more than
-	  3 GB of memory. If unsure, say Y.
+	  which don't have a hardware IOMMU (e.g. all Intel CPUs released
+	  before 2008). Using this PCI devices which can only access 32-bits
+	  of memory can be used on systems with more than 3 GB of memory. If
+	  unsure, say Y.
 
 config IOMMU_HELPER
 	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
-- 
1.7.9.5

