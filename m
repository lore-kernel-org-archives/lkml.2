Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1LMNwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:52:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51711 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab1LMNwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:52:13 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Schindelin <Johannes.Schindelin@gmx.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH UPDATED 5/8] perf tools: Remove stale git headlines from top comment
Date: Tue, 13 Dec 2011 22:52:03 +0900
Message-Id: <1323784323-2150-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <20111212181343.GA2399@elte.hu>
References: <20111212181343.GA2399@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files are part of PERF not GIT although they're
come from there :)

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Schindelin <Johannes.Schindelin@gmx.de>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
v2: keep original copyright information. (sorry about that :)

 tools/perf/util/config.c |    5 ++++-
 tools/perf/util/usage.c  |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 80d9598db31a..0deac6a14b65 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -1,5 +1,8 @@
 /*
- * GIT - The information manager from hell
+ * config.c
+ *
+ * Helper functions for parsing config items.
+ * Originally copied from GIT source.
  *
  * Copyright (C) Linus Torvalds, 2005
  * Copyright (C) Johannes Schindelin, 2005
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index e16bf9a707e8..d76d1c0ff98f 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -1,5 +1,8 @@
 /*
- * GIT - The information manager from hell
+ * usage.c
+ *
+ * Various reporting routines.
+ * Originally copied from GIT source.
  *
  * Copyright (C) Linus Torvalds, 2005
  */
-- 
1.7.6

