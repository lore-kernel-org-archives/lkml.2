Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2BQJuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:50:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38672 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2BQJuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:50:19 -0500
Date: Fri, 17 Feb 2012 01:49:33 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-3bd2b8d1095d41254d3bdc3d62622c7fd5e143b8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1328836217-9118-2-git-send-email-namhyung.kim@lge.com>
References: <1328836217-9118-2-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: ctype.c only wants util.h
Git-Commit-ID: 3bd2b8d1095d41254d3bdc3d62622c7fd5e143b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:50:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bd2b8d1095d41254d3bdc3d62622c7fd5e143b8
Gitweb:     http://git.kernel.org/tip/3bd2b8d1095d41254d3bdc3d62622c7fd5e143b8
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 10 Feb 2012 10:10:16 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 23:17:40 -0200

perf tools: ctype.c only wants util.h

The implementation of sane ctype macros only depends on symbols in
util.h not cache.h.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328836217-9118-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ctype.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ctype.c b/tools/perf/util/ctype.c
index 3507362..aada3ac 100644
--- a/tools/perf/util/ctype.c
+++ b/tools/perf/util/ctype.c
@@ -3,7 +3,7 @@
  *
  * No surprises, and works with signed and unsigned chars.
  */
-#include "cache.h"
+#include "util.h"
 
 enum {
 	S = GIT_SPACE,
