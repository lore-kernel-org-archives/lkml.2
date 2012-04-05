Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2DEQZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:25:12 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:16249
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755246Ab2DEQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:25:07 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20LLI-01-4HS-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/4] perf: Trivial cleanup of duplicate code
Date: Thu, 5 Apr 2012 18:24:41 +0200
Message-ID: <1333643084-26776-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333643084-26776-1-git-send-email-robert.richter@amd.com>
References: <1333643084-26776-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing duplicate code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 56ae3af..16726a9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -485,9 +485,6 @@ static int __x86_pmu_event_init(struct perf_event *event)
 
 	/* mark unused */
 	event->hw.extra_reg.idx = EXTRA_REG_NONE;
-
-	/* mark not used */
-	event->hw.extra_reg.idx = EXTRA_REG_NONE;
 	event->hw.branch_reg.idx = EXTRA_REG_NONE;
 
 	return x86_pmu.hw_config(event);
-- 
1.7.8.4


