Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab2DKVJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:09:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49827 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761199Ab2DKVFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:05:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/13] perf stat: Declare some references static
Date: Wed, 11 Apr 2012 18:05:23 -0300
Message-Id: <1334178325-19148-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334178325-19148-1-git-send-email-acme@infradead.org>
References: <1334178325-19148-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

This references are not exported, use static declaration.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1333643188-26895-4-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

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
1.7.9.2.358.g22243

