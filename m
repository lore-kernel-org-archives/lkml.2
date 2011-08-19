Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1HSTmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:42:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42541 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab1HSTmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:42:32 -0400
From: Arun Thomas <arun.thomas@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andre Przywara <andre.przywara@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Arun Thomas <arun.thomas@gmail.com>
Subject: [PATCH] x86, cpu: Add cpufeature flag for PCIDs
Date: Fri, 19 Aug 2011 21:42:23 +0200
Message-Id: <1313782943-3898-1-git-send-email-arun.thomas@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a flag for Process-Context Identifiers (PCIDs) aka
Address Space Identifiers (ASIDs) aka Tagged TLB support.

Signed-off-by: Arun Thomas <arun.thomas@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4258aac..f24ed51 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -114,6 +114,7 @@
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_PDCM	(4*32+15) /* Performance Capabilities */
+#define X86_FEATURE_PCID	(4*32+17) /* Process Context Identifiers */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
 #define X86_FEATURE_XMM4_1	(4*32+19) /* "sse4_1" SSE-4.1 */
 #define X86_FEATURE_XMM4_2	(4*32+20) /* "sse4_2" SSE-4.2 */
-- 
1.7.4.1

