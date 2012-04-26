Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2DZMRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:17:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab2DZMRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:17:33 -0400
Date: Thu, 26 Apr 2012 05:17:14 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-10c250234c98928d1e15c4cea1c44b9a25354ccf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333643084-26776-2-git-send-email-robert.richter@amd.com>
References: <1333643084-26776-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Trivial cleanup of duplicate code
Git-Commit-ID: 10c250234c98928d1e15c4cea1c44b9a25354ccf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Apr 2012 05:17:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10c250234c98928d1e15c4cea1c44b9a25354ccf
Gitweb:     http://git.kernel.org/tip/10c250234c98928d1e15c4cea1c44b9a25354ccf
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 5 Apr 2012 18:24:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Apr 2012 13:52:50 +0200

perf: Trivial cleanup of duplicate code

Removing duplicate code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333643084-26776-2-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bb8e034..e33e9cf 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -484,9 +484,6 @@ static int __x86_pmu_event_init(struct perf_event *event)
 
 	/* mark unused */
 	event->hw.extra_reg.idx = EXTRA_REG_NONE;
-
-	/* mark not used */
-	event->hw.extra_reg.idx = EXTRA_REG_NONE;
 	event->hw.branch_reg.idx = EXTRA_REG_NONE;
 
 	return x86_pmu.hw_config(event);
