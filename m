Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab1LUIqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:46:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1LUIqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:46:34 -0500
Date: Wed, 21 Dec 2011 00:46:08 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-5f9273d64a5ccbd3c2b4446cc8b71123ed5d6366@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, namhyung@gmail.com,
        Johannes.Schindelin@gmx.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, Johannes.Schindelin@gmx.de, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1323784323-2150-1-git-send-email-namhyung@gmail.com>
References: <1323784323-2150-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove stale git headlines from top comment
Git-Commit-ID: 5f9273d64a5ccbd3c2b4446cc8b71123ed5d6366
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 00:46:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f9273d64a5ccbd3c2b4446cc8b71123ed5d6366
Gitweb:     http://git.kernel.org/tip/5f9273d64a5ccbd3c2b4446cc8b71123ed5d6366
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 13 Dec 2011 22:52:03 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 20 Dec 2011 13:43:36 -0200

perf tools: Remove stale git headlines from top comment

These files are part of PERF not GIT although they're come from there :)

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Schindelin <Johannes.Schindelin@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323784323-2150-1-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/config.c |    5 ++++-
 tools/perf/util/usage.c  |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 80d9598..0deac6a 100644
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
index e16bf9a..d76d1c0 100644
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
