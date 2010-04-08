Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0DHOjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:39:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36258 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783Ab0DHOjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:39:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerra <paulus@samba.org>, s@infradead.org
Subject: [PATCH 4/6] perf bench: fix spello
Date: Thu,  8 Apr 2010 11:38:47 -0300
Message-Id: <1270737529-24258-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270737529-24258-1-git-send-email-acme@infradead.org>
References: <1270737529-24258-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

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
-- 
1.6.2.5

