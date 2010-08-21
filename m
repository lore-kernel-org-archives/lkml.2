Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0HUTcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 15:32:51 -0400
Received: from solo.fdn.fr ([80.67.169.19]:43337 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab0HUTco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 15:32:44 -0400
Date: Sat, 21 Aug 2010 21:32:41 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: [PATCH,TRIVIAL] Replace Configure with Enable in description of MAXSMP
Message-ID: <20100821193241.GB4760@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace Configure with Enable in description of MAXSMP

The "Configure" word tends to make user believe they have to say 'yes'
to be able to choose the number of procs/nodes.  "Enable" should be
unambiguous enough.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac7827f..cea0cd9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -754,11 +754,11 @@ config IOMMU_API
 	def_bool (AMD_IOMMU || DMAR)
 
 config MAXSMP
-	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
+	bool "Enable Maximum number of SMP Processors and NUMA Nodes"
 	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
 	select CPUMASK_OFFSTACK
 	---help---
-	  Configure maximum number of CPUS and NUMA Nodes for this architecture.
+	  Enable maximum number of CPUS and NUMA Nodes for this architecture.
 	  If unsure, say N.
 
 config NR_CPUS
