Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab1I2WwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:52:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:43940 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab1I2WsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/16] perf stat: Fix spelling in comment
Date: Thu, 29 Sep 2011 19:48:05 -0300
Message-Id: <1317336490-19437-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Link: http://lkml.kernel.org/r/1315437244-3788-6-git-send-email-jim.cromie@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 0ffbd97..b567319 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1209,7 +1209,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	 * let the spreadsheet do the pretty-printing
 	 */
 	if (csv_output) {
-		/* User explicitely passed -B? */
+		/* User explicitly passed -B? */
 		if (big_num_opt == 1) {
 			fprintf(stderr, "-B option not supported with -x\n");
 			usage_with_options(stat_usage, options);
-- 
1.6.2.5

