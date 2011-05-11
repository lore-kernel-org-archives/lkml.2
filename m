Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1EKTac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:30:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:5862 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab1EKTa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,354,1301900400"; 
   d="scan'208";a="468445"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Bruce Schlobohm" <bruce.schlobohm@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 2/3] x86, cpu: Add SMEP CPU feature in CR4
Date: Wed, 11 May 2011 12:17:59 -0700
Message-Id: <1305141480-843-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305141480-843-1-git-send-email-fenghua.yu@intel.com>
References: <1305141480-843-1-git-send-email-fenghua.yu@intel.com>
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

