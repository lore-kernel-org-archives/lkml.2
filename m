Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab2IELBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 07:01:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab2IELBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 07:01:17 -0400
Date: Wed, 5 Sep 2012 04:01:01 -0700
From: tip-bot for Joe Millenbach <jmillenbach@gmail.com>
Message-ID: <tip-4454d32749465ffa77d82bc1fdd196d6dedc544b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jmillenbach@gmail.com, josh@joshtriplett.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jmillenbach@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org
In-Reply-To: <1346632700-29113-1-git-send-email-jmillenbach@gmail.com>
References: <1346632700-29113-1-git-send-email-jmillenbach@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/kconfig:
  Remove outdated reference to Intel CPUs in CONFIG_SWIOTLB
Git-Commit-ID: 4454d32749465ffa77d82bc1fdd196d6dedc544b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 04:01:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4454d32749465ffa77d82bc1fdd196d6dedc544b
Gitweb:     http://git.kernel.org/tip/4454d32749465ffa77d82bc1fdd196d6dedc544b
Author:     Joe Millenbach <jmillenbach@gmail.com>
AuthorDate: Sun, 2 Sep 2012 17:38:20 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 11:05:01 +0200

x86/kconfig: Remove outdated reference to Intel CPUs in CONFIG_SWIOTLB

Deleted the no longer valid example of which x86 CPUs lack a
hardware IOMMU, and moved the "If unsure..." statement to a new
line to follow the style of surrounding options.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: team-fjord@googlegroups.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1346632700-29113-1-git-send-email-jmillenbach@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..50a1d1f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -746,10 +746,10 @@ config SWIOTLB
 	def_bool y if X86_64
 	---help---
 	  Support for software bounce buffers used on x86-64 systems
-	  which don't have a hardware IOMMU (e.g. the current generation
-	  of Intel's x86-64 CPUs). Using this PCI devices which can only
-	  access 32-bits of memory can be used on systems with more than
-	  3 GB of memory. If unsure, say Y.
+	  which don't have a hardware IOMMU. Using this PCI devices
+	  which can only access 32-bits of memory can be used on systems
+	  with more than 3 GB of memory.
+	  If unsure, say Y.
 
 config IOMMU_HELPER
 	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
