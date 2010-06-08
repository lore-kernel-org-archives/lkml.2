Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0FHQ0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 12:26:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38353 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755067Ab0FHQ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 12:26:15 -0400
Subject: [RFC PATCH 2/3] ARM: Mark CPU_32v6K as depended on CPU_V7
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Date: Tue, 08 Jun 2010 17:26:03 +0100
Message-ID: <20100608162603.21870.11086.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100608162046.21870.5615.stgit@e102109-lin.cambridge.arm.com>
References: <20100608162046.21870.5615.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 16:26:03.0712 (UTC) FILETIME=[4A048400:01CB0727]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU_32v6K is selected by CPU_V7 but it only depends on CPU_V6.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/arm/mm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 9f10a9b..a4909db 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -398,7 +398,7 @@ config CPU_V6
 # ARMv6k
 config CPU_32v6K
 	bool "Support ARM V6K processor extensions" if !SMP
-	depends on CPU_V6
+	depends on CPU_V6 || CPU_V7
 	default y if SMP && !(ARCH_MX3 || ARCH_OMAP2)
 	help
 	  Say Y here if your ARMv6 processor supports the 'K' extension.

