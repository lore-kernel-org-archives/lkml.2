Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1K2TOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:14:49 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55677 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab1K2TOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:14:48 -0500
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86, CPU: Drop superfluous get_cpu_cap prototype
Date: Tue, 29 Nov 2011 20:14:43 +0100
Message-Id: <1322594083-14507-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

get_cpu_cap() external function prototype was declared twice so lose one
of them.

Cleanup header while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/cpu.h |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 1b22dcc..8bacc78 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -1,5 +1,4 @@
 #ifndef ARCH_X86_CPU_H
-
 #define ARCH_X86_CPU_H
 
 struct cpu_model_info {
@@ -35,6 +34,4 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
-extern void get_cpu_cap(struct cpuinfo_x86 *c);
-
-#endif
+#endif /* ARCH_X86_CPU_H */
-- 
1.7.8.rc0

