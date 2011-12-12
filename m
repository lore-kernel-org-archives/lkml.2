Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1LLPRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:17:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33919 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1LLPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:17:37 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] perf report: Fix usage string
Date: Tue, 13 Dec 2011 00:16:56 +0900
Message-Id: <1323703017-6060-8-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf report does not take a command from command line.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b2654c9fb5c6..9051f6bfaa7e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -432,7 +432,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
-		"perf report [<options>] <command>",
+		"perf report [<options>]",
 		NULL
 	};
 	struct perf_report report = {
-- 
1.7.6

