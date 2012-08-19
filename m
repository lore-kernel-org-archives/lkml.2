Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2HSC52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:57:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:30195 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab2HSC5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="188218646"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/74] sections: Add __visible to ia64 sections
Date: Sat, 18 Aug 2012 19:56:00 -0700
Message-Id: <1345345030-22211-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/ia64/include/asm/sections.h |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/include/asm/sections.h b/arch/ia64/include/asm/sections.h
index 1a873b3..68b8f3a 100644
--- a/arch/ia64/include/asm/sections.h
+++ b/arch/ia64/include/asm/sections.h
@@ -10,21 +10,21 @@
 #include <linux/uaccess.h>
 #include <asm-generic/sections.h>
 
-extern char __per_cpu_start[], __per_cpu_end[], __phys_per_cpu_start[];
+extern __visible char __per_cpu_start[], __per_cpu_end[], __phys_per_cpu_start[];
 #ifdef	CONFIG_SMP
-extern char __cpu0_per_cpu[];
+extern __visible char __cpu0_per_cpu[];
 #endif
-extern char __start___vtop_patchlist[], __end___vtop_patchlist[];
-extern char __start___rse_patchlist[], __end___rse_patchlist[];
-extern char __start___mckinley_e9_bundles[], __end___mckinley_e9_bundles[];
-extern char __start___phys_stack_reg_patchlist[], __end___phys_stack_reg_patchlist[];
-extern char __start_gate_section[];
-extern char __start_gate_mckinley_e9_patchlist[], __end_gate_mckinley_e9_patchlist[];
-extern char __start_gate_vtop_patchlist[], __end_gate_vtop_patchlist[];
-extern char __start_gate_fsyscall_patchlist[], __end_gate_fsyscall_patchlist[];
-extern char __start_gate_brl_fsys_bubble_down_patchlist[], __end_gate_brl_fsys_bubble_down_patchlist[];
-extern char __start_unwind[], __end_unwind[];
-extern char __start_ivt_text[], __end_ivt_text[];
+extern __visible char __start___vtop_patchlist[], __end___vtop_patchlist[];
+extern __visible char __start___rse_patchlist[], __end___rse_patchlist[];
+extern __visible char __start___mckinley_e9_bundles[], __end___mckinley_e9_bundles[];
+extern __visible char __start___phys_stack_reg_patchlist[], __end___phys_stack_reg_patchlist[];
+extern __visible char __start_gate_section[];
+extern __visible char __start_gate_mckinley_e9_patchlist[], __end_gate_mckinley_e9_patchlist[];
+extern __visible char __start_gate_vtop_patchlist[], __end_gate_vtop_patchlist[];
+extern __visible char __start_gate_fsyscall_patchlist[], __end_gate_fsyscall_patchlist[];
+extern __visible char __start_gate_brl_fsys_bubble_down_patchlist[], __end_gate_brl_fsys_bubble_down_patchlist[];
+extern __visible char __start_unwind[], __end_unwind[];
+extern __visible char __start_ivt_text[], __end_ivt_text[];
 
 #undef dereference_function_descriptor
 static inline void *dereference_function_descriptor(void *ptr)
-- 
1.7.7.6

