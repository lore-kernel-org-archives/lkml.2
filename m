Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab2JANEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:04:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58736 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab2JANEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:04:32 -0400
Date: Mon, 1 Oct 2012 15:04:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fix for v3.7
Message-ID: <20121001130426.GA22347@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 402537fd9f5499d1a50a6f20cdd9031d24ee2e47 perf/x86: Fix typo in uncore_pmu_to_box

Leftover perf/urgent fix from the v3.6 cycle.

 Thanks,

	Ingo

------------------>
Yan, Zheng (1):
      perf/x86: Fix typo in uncore_pmu_to_box


 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 38e4894..c7c55e7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1950,7 +1950,7 @@ struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cp
 static struct intel_uncore_box *
 uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
 {
-	static struct intel_uncore_box *box;
+	struct intel_uncore_box *box;
 
 	box = *per_cpu_ptr(pmu->box, cpu);
 	if (box)
