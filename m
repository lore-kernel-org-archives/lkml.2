Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1I0JRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 05:17:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1I0JRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 05:17:24 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tools/perf: Fix sched script command documentation
Date: Tue, 27 Sep 2011 11:16:35 +0200
Message-Id: <1317114995-4534-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed leftover from trace -> script rename.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-sched.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
index 46822d5..5b212b5 100644
--- a/tools/perf/Documentation/perf-sched.txt
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -8,7 +8,7 @@ perf-sched - Tool to trace/measure scheduler properties (latencies)
 SYNOPSIS
 --------
 [verse]
-'perf sched' {record|latency|map|replay|trace}
+'perf sched' {record|latency|map|replay|script}
 
 DESCRIPTION
 -----------
@@ -20,8 +20,8 @@ There are five variants of perf sched:
   'perf sched latency' to report the per task scheduling latencies
   and other scheduling properties of the workload.
 
-  'perf sched trace' to see a detailed trace of the workload that
-  was recorded.
+  'perf sched script' to see a detailed trace of the workload that
+   was recorded (aliased to 'perf script' for now).
 
   'perf sched replay' to simulate the workload that was recorded
   via perf sched record. (this is done by starting up mockup threads
-- 
1.7.4

