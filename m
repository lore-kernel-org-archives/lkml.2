Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2AGRZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:25:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2AGRZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:25:41 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] perf test: Change type of '-v' option to INCR
Date: Sun,  8 Jan 2012 02:25:26 +0900
Message-Id: <1325957132-10600-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The '-v' option is usually defined via OPT_INCR not _INTEGER.
Follow the trend :).

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 2b9a7f497a20..3854e869dce1 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1396,7 +1396,7 @@ int cmd_test(int argc, const char **argv, const char *prefix __used)
 	NULL,
 	};
 	const struct option test_options[] = {
-	OPT_INTEGER('v', "verbose", &verbose,
+	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_END()
 	};
-- 
1.7.6

