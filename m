Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2DEQ1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:27:06 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:14191 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287Ab2DEQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:26:40 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20LOA-01-4MZ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/4] perf tools: Declare some references static in builtin-stat.c
Date: Thu, 5 Apr 2012 18:26:27 +0200
Message-ID: <1333643188-26895-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
References: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This references are not exported, use static declaration.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-stat.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c941bb6..dde9e17 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -173,7 +173,7 @@ static struct perf_event_attr very_very_detailed_attrs[] = {
 
 
 
-struct perf_evlist		*evsel_list;
+static struct perf_evlist	*evsel_list;
 
 static bool			system_wide			=  false;
 static int			run_idx				=  0;
@@ -265,18 +265,18 @@ static double stddev_stats(struct stats *stats)
 	return sqrt(variance_mean);
 }
 
-struct stats			runtime_nsecs_stats[MAX_NR_CPUS];
-struct stats			runtime_cycles_stats[MAX_NR_CPUS];
-struct stats			runtime_stalled_cycles_front_stats[MAX_NR_CPUS];
-struct stats			runtime_stalled_cycles_back_stats[MAX_NR_CPUS];
-struct stats			runtime_branches_stats[MAX_NR_CPUS];
-struct stats			runtime_cacherefs_stats[MAX_NR_CPUS];
-struct stats			runtime_l1_dcache_stats[MAX_NR_CPUS];
-struct stats			runtime_l1_icache_stats[MAX_NR_CPUS];
-struct stats			runtime_ll_cache_stats[MAX_NR_CPUS];
-struct stats			runtime_itlb_cache_stats[MAX_NR_CPUS];
-struct stats			runtime_dtlb_cache_stats[MAX_NR_CPUS];
-struct stats			walltime_nsecs_stats;
+static struct stats runtime_nsecs_stats[MAX_NR_CPUS];
+static struct stats runtime_cycles_stats[MAX_NR_CPUS];
+static struct stats runtime_stalled_cycles_front_stats[MAX_NR_CPUS];
+static struct stats runtime_stalled_cycles_back_stats[MAX_NR_CPUS];
+static struct stats runtime_branches_stats[MAX_NR_CPUS];
+static struct stats runtime_cacherefs_stats[MAX_NR_CPUS];
+static struct stats runtime_l1_dcache_stats[MAX_NR_CPUS];
+static struct stats runtime_l1_icache_stats[MAX_NR_CPUS];
+static struct stats runtime_ll_cache_stats[MAX_NR_CPUS];
+static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
+static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
+static struct stats walltime_nsecs_stats;
 
 static int create_perf_stat_counter(struct perf_evsel *evsel,
 				    struct perf_evsel *first)
-- 
1.7.8.4


