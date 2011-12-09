Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1LIUHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:07:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46273 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1LIUHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:07:48 -0500
Date: Fri, 9 Dec 2011 12:07:24 -0800
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-d059f24a9680805bd73fc5675504d465bfe28b72@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <1322594083-14507-1-git-send-email-bp@amd64.org>
References: <1322594083-14507-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, CPU: Drop superfluous get_cpu_cap() prototype
Git-Commit-ID: d059f24a9680805bd73fc5675504d465bfe28b72
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 12:07:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d059f24a9680805bd73fc5675504d465bfe28b72
Gitweb:     http://git.kernel.org/tip/d059f24a9680805bd73fc5675504d465bfe28b72
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Tue, 29 Nov 2011 20:14:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Dec 2011 08:00:53 +0100

x86, CPU: Drop superfluous get_cpu_cap() prototype

The get_cpu_cap() external function prototype was declared twice
so lose one of them.

Clean up the header guard while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1322594083-14507-1-git-send-email-bp@amd64.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
