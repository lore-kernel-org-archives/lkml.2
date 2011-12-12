Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1LLPRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:17:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33919 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1LLPRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:17:30 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Schindelin <johannes.schindelin@gmx.de>
Subject: [PATCH 5/8] perf tools: Remove stale git headlines from top comment
Date: Tue, 13 Dec 2011 00:16:54 +0900
Message-Id: <1323703017-6060-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files are parts of PERF not GIT, although they're
coming from there :)

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Schindelin <johannes.schindelin@gmx.de>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/config.c |    7 -------
 tools/perf/util/usage.c  |    5 -----
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 80d9598db31a..3c1dc8f43ac2 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -1,10 +1,3 @@
-/*
- * GIT - The information manager from hell
- *
- * Copyright (C) Linus Torvalds, 2005
- * Copyright (C) Johannes Schindelin, 2005
- *
- */
 #include "util.h"
 #include "cache.h"
 #include "exec_cmd.h"
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index e16bf9a707e8..b4a868f95138 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -1,8 +1,3 @@
-/*
- * GIT - The information manager from hell
- *
- * Copyright (C) Linus Torvalds, 2005
- */
 #include "util.h"
 
 static void report(const char *prefix, const char *err, va_list params)
-- 
1.7.6

