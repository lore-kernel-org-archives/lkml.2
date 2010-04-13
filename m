Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0DMKoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 06:44:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:37028 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab0DMKoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:44:01 -0400
Date: Tue, 13 Apr 2010 10:43:40 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, randy.dunlap@oracle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, randy.dunlap@oracle.com
In-Reply-To: <20100331113056.2c7df509.randy.dunlap@oracle.com>
References: <20100331113056.2c7df509.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: fix spello
Message-ID: <tip-f0e9c4fcefa42b5d28b915768dab81a7fdbbc00c@git.kernel.org>
Git-Commit-ID: f0e9c4fcefa42b5d28b915768dab81a7fdbbc00c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 13 Apr 2010 10:43:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0e9c4fcefa42b5d28b915768dab81a7fdbbc00c
Gitweb:     http://git.kernel.org/tip/f0e9c4fcefa42b5d28b915768dab81a7fdbbc00c
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Wed, 31 Mar 2010 11:30:56 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Apr 2010 11:34:26 -0300

perf bench: fix spello

Fix spello in user message.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
Cc: Paul Mackerra <paulus@samba.org>s
LKML-Reference: <20100331113056.2c7df509.randy.dunlap@oracle.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 tools/perf/bench/sched-pipe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 4f77c7c..d9ab3ce 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -93,7 +93,7 @@ int bench_sched_pipe(int argc, const char **argv,
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
-		printf("# Extecuted %d pipe operations between two tasks\n\n",
+		printf("# Executed %d pipe operations between two tasks\n\n",
 			loops);
 
 		result_usec = diff.tv_sec * 1000000;
