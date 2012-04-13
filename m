Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2DMSWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:22:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2DMSW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:22:28 -0400
Date: Fri, 13 Apr 2012 11:22:15 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-666e6d48c57921874008d97aac13f6ee3e24fd55@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1333643188-26895-4-git-send-email-robert.richter@amd.com>
References: <1333643188-26895-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Declare some references static
Git-Commit-ID: 666e6d48c57921874008d97aac13f6ee3e24fd55
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:22:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  666e6d48c57921874008d97aac13f6ee3e24fd55
Gitweb:     http://git.kernel.org/tip/666e6d48c57921874008d97aac13f6ee3e24fd55
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 5 Apr 2012 18:26:27 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 17:37:16 -0300

perf stat: Declare some references static

This references are not exported, use static declaration.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1333643188-26895-4-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
