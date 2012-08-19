Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab2HSC72 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:59:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:48688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab2HSC5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422048"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/74] sections: Add __visible to sh sections
Date: Sat, 18 Aug 2012 19:56:03 -0700
Message-Id: <1345345030-22211-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/sh/include/asm/sections.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sh/include/asm/sections.h b/arch/sh/include/asm/sections.h
index 1b61997..e18e132 100644
--- a/arch/sh/include/asm/sections.h
+++ b/arch/sh/include/asm/sections.h
@@ -3,10 +3,10 @@
 
 #include <asm-generic/sections.h>
 
-extern long __nosave_begin, __nosave_end;
-extern long __machvec_start, __machvec_end;
-extern char __uncached_start, __uncached_end;
-extern char __start_eh_frame[], __stop_eh_frame[];
+extern __visible long __nosave_begin, __nosave_end;
+extern __visible long __machvec_start, __machvec_end;
+extern __visible char __uncached_start, __uncached_end;
+extern __visible char __start_eh_frame[], __stop_eh_frame[];
 
 #endif /* __ASM_SH_SECTIONS_H */
 
-- 
1.7.7.6

