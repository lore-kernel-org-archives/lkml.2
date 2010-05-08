Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0EHPdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:33:24 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:44503 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab0EHPdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:33:23 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf report: Document '--call-graph' better for usage
Date: Sat,  8 May 2010 18:33:03 +0300
Message-Id: <1273332783-4268-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves 'perf report -h' output for the '--call-graph' command line
option by enumerating the different output types.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f815de2..695a15e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -424,7 +424,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
-		     "Display callchains using output_type and min percent threshold. "
+		     "Display callchains using output_type (graph, flat, fractal, or none) and min percent threshold. "
 		     "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
-- 
1.6.3.3

