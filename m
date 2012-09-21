Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2IUTnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:43:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:49306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290Ab2IUTnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225201998"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 05/11] x86, alternative: Add header guards to <asm/alternative-asm.h>
Date: Fri, 21 Sep 2012 12:43:09 -0700
Message-Id: <1348256595-29119-6-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Add header guards to protect <asm/alternative-asm.h> against multiple
inclusion.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/alternative-asm.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 018d29f..372231c 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_X86_ALTERNATIVE_ASM_H
+#define _ASM_X86_ALTERNATIVE_ASM_H
+
 #ifdef __ASSEMBLY__
 
 #include <asm/asm.h>
@@ -24,3 +27,5 @@
 .endm
 
 #endif  /*  __ASSEMBLY__  */
+
+#endif /* _ASM_X86_ALTERNATIVE_ASM_H */
-- 
1.7.6.5

