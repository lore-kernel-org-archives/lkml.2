Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1DVITN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:19:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:46218 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab1DVITI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:19:08 -0400
Date: Fri, 22 Apr 2011 08:18:53 GMT
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-b2508e828d71baacd9a743dd48dcbf85d96affdd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1303429715-10202-1-git-send-email-andi@firstfloor.org>
References: <1303429715-10202-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Support Xeon E7's via the Westmere PMU driver
Git-Commit-ID: b2508e828d71baacd9a743dd48dcbf85d96affdd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 08:18:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2508e828d71baacd9a743dd48dcbf85d96affdd
Gitweb:     http://git.kernel.org/tip/b2508e828d71baacd9a743dd48dcbf85d96affdd
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 21 Apr 2011 16:48:35 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 08:27:29 +0200

perf: Support Xeon E7's via the Westmere PMU driver

There's a new model number public, 47, for Xeon E7 (aka Westmere EX).

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/1303429715-10202-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8fc2b2c..586cced 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1425,6 +1425,7 @@ static __init int intel_pmu_init(void)
 
 	case 37: /* 32 nm nehalem, "Clarkdale" */
 	case 44: /* 32 nm nehalem, "Gulftown" */
+	case 47: /* 32 nm Xeon E7 */
 		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
