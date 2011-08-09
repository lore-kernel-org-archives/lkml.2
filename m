Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1HIOat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:30:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:37452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab1HIOar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:30:47 -0400
Date: Tue, 9 Aug 2011 14:30:29 GMT
From: tip-bot for Youquan Song <youquan.song@intel.com>
Message-ID: <tip-a34668f6beb4ab01e07683276d6a24bab6c175e0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, anhua.xu@intel.com, youquan.song@intel.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        youquan.song@intel.com, anhua.xu@intel.com, mingo@elte.hu
In-Reply-To: <1312264895-2010-1-git-send-email-youquan.song@intel.com>
References: <1312264895-2010-1-git-send-email-youquan.song@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Add model 45 SandyBridge support
Git-Commit-ID: a34668f6beb4ab01e07683276d6a24bab6c175e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Aug 2011 14:30:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a34668f6beb4ab01e07683276d6a24bab6c175e0
Gitweb:     http://git.kernel.org/tip/a34668f6beb4ab01e07683276d6a24bab6c175e0
Author:     Youquan Song <youquan.song@intel.com>
AuthorDate: Tue, 2 Aug 2011 14:01:35 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 9 Aug 2011 11:58:06 +0200

perf, x86: Add model 45 SandyBridge support

Add support to Romely-EP SandyBridge.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Anhua Xu <anhua.xu@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1312264895-2010-1-git-send-email-youquan.song@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 45fbb8f..f88af2c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1590,6 +1590,7 @@ static __init int intel_pmu_init(void)
 		break;
 
 	case 42: /* SandyBridge */
+	case 45: /* SandyBridge, "Romely-EP" */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
