Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab1ERB5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:57:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:10398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab1ERB5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,228,1304319600"; 
   d="scan'208";a="437959951"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Avi Kivity" <avi@redhat.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v3 2/4] x86, cpu: Add SMEP CPU feature in CR4
Date: Tue, 17 May 2011 18:44:27 -0700
Message-Id: <1305683069-25394-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305683069-25394-1-git-send-email-fenghua.yu@intel.com>
References: <1305683069-25394-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Add support for newly documented SMEP (Supervisor Mode Execution Protection)
CPU feature in CR4.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/processor-flags.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor-flags.h b/arch/x86/include/asm/processor-flags.h
index a898a2b..59ab4df 100644
--- a/arch/x86/include/asm/processor-flags.h
+++ b/arch/x86/include/asm/processor-flags.h
@@ -60,6 +60,7 @@
 #define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
 #define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
 #define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
+#define X86_CR4_SMEP	0x00100000 /* enable SMEP support */
 
 /*
  * x86-64 Task Priority Register, CR8
-- 
1.7.2

