Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2AGR0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:26:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2AGRZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:25:52 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] perf annotate: Fix usage string
Date: Sun,  8 Jan 2012 02:25:30 +0900
Message-Id: <1325957132-10600-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The annotate command doesn't take non-option arguments.
In fact, it can take last argument as a symbol filter
though, but that's a special case and, IMHO, it should
be discouraged in favor of the -s option.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 214ba7f9f577..3ec2496f1e35 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -235,7 +235,7 @@ out_delete:
 }
 
 static const char * const annotate_usage[] = {
-	"perf annotate [<options>] <command>",
+	"perf annotate [<options>]",
 	NULL
 };
 
-- 
1.7.6

