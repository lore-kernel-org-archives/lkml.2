Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0JNVTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:19:00 -0400
Received: from king.tilera.com ([72.1.168.226]:52845 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab0JNVQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:10 -0400
Message-Id: <6b945df74233386aab526cddd3593ed4b854f574.1287090282.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1287090280.git.cmetcalf@tilera.com>
References: <cover.1287090280.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 14 Oct 2010 14:54:47 -0400
Subject: [PATCH 01/14] kmemleak: add TILE to the list of supported architectures.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 14 Oct 2010 21:16:09.0434 (UTC) FILETIME=[0582EBA0:01CB6BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the necessary functionality was already there; we just need
to make it possible to select the config option.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1b4afd2..9f211b2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -366,7 +366,7 @@ config SLUB_STATS
 config DEBUG_KMEMLEAK
 	bool "Kernel memory leak detector"
 	depends on DEBUG_KERNEL && EXPERIMENTAL && !MEMORY_HOTPLUG && \
-		(X86 || ARM || PPC || S390 || SPARC64 || SUPERH || MICROBLAZE)
+		(X86 || ARM || PPC || S390 || SPARC64 || SUPERH || MICROBLAZE || TILE)
 
 	select DEBUG_FS if SYSFS
 	select STACKTRACE if STACKTRACE_SUPPORT
-- 
1.6.5.2

