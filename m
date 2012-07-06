Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GFNs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:48:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54072 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2GFNs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:48:27 -0400
Date: Fri, 6 Jul 2012 06:48:15 -0700
From: tip-bot for Pekka Enberg <penberg@kernel.org>
Message-ID: <tip-c3b7cdf180090d2686239a75bb0ae408108ed749@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, penberg@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, tglx@linutronix.de
In-Reply-To: <1341568786-7045-1-git-send-email-penberg@kernel.org>
References: <1341568786-7045-1-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix intel_perfmon_event_mapformatting
Git-Commit-ID: c3b7cdf180090d2686239a75bb0ae408108ed749
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 06:48:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3b7cdf180090d2686239a75bb0ae408108ed749
Gitweb:     http://git.kernel.org/tip/c3b7cdf180090d2686239a75bb0ae408108ed749
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Fri, 6 Jul 2012 12:59:46 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 6 Jul 2012 13:16:15 +0200

perf/x86: Fix intel_perfmon_event_mapformatting

Use tabs for "intel_perfmon_event_map" formatting in
perf_event_intel.c.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/r/1341568786-7045-1-git-send-email-penberg@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 5fdedb4..1f4c8ad 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -21,14 +21,14 @@
  */
 static u64 intel_perfmon_event_map[PERF_COUNT_HW_MAX] __read_mostly =
 {
-  [PERF_COUNT_HW_CPU_CYCLES]		= 0x003c,
-  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x4f2e,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x412e,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
-  [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
-  [PERF_COUNT_HW_REF_CPU_CYCLES]	= 0x0300, /* pseudo-encoding */
+	[PERF_COUNT_HW_CPU_CYCLES]		= 0x003c,
+	[PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
+	[PERF_COUNT_HW_CACHE_REFERENCES]	= 0x4f2e,
+	[PERF_COUNT_HW_CACHE_MISSES]		= 0x412e,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
+	[PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
+	[PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
+	[PERF_COUNT_HW_REF_CPU_CYCLES]		= 0x0300, /* pseudo-encoding */
 };
 
 static struct event_constraint intel_core_event_constraints[] __read_mostly =
