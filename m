Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1C2JQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:16:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:41379 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab1C2JQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:16:36 -0400
Date: Tue, 29 Mar 2011 09:16:16 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4D8FA213.5050108@openvz.org>
References: <4D8FA213.5050108@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: P4 PMU - clean up the code a bit
Message-ID: <tip-1d321881afb955bba1e0a8f50d3a04e111fcb581@git.kernel.org>
Git-Commit-ID: 1d321881afb955bba1e0a8f50d3a04e111fcb581
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Mar 2011 09:16:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d321881afb955bba1e0a8f50d3a04e111fcb581
Gitweb:     http://git.kernel.org/tip/1d321881afb955bba1e0a8f50d3a04e111fcb581
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Mon, 28 Mar 2011 00:46:11 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 29 Mar 2011 09:36:33 +0200

perf, x86: P4 PMU - clean up the code a bit

No change on the functional level, just align the table properly.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <4D8FA213.5050108@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index c2520e1..8ff882f 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -468,7 +468,7 @@ static struct p4_event_bind p4_event_bind_map[] = {
 		.opcode		= P4_OPCODE(P4_EVENT_MISPRED_BRANCH_RETIRED),
 		.escr_msr	= { MSR_P4_CRU_ESCR0, MSR_P4_CRU_ESCR1 },
 		.escr_emask	=
-		P4_ESCR_EMASK_BIT(P4_EVENT_MISPRED_BRANCH_RETIRED, NBOGUS),
+			P4_ESCR_EMASK_BIT(P4_EVENT_MISPRED_BRANCH_RETIRED, NBOGUS),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_X87_ASSIST] = {
