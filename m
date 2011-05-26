Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab1EZMBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:01:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:41953 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1EZMBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:01:43 -0400
Date: Thu, 26 May 2011 12:01:17 GMT
From: tip-bot for Jesper Juhl <jj@chaosbits.net>
Message-ID: <tip-ea7659fb2b876337aee719d9d5ddb05531dfb334@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        tom.zanussi@linux.intel.com, jj@chaosbits.net, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, tom.zanussi@linux.intel.com, jj@chaosbits.net,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LNX.2.00.1105261011290.17400@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1105261011290.17400@swampdragon.chaosbits.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Remove duplicate headers
Git-Commit-ID: ea7659fb2b876337aee719d9d5ddb05531dfb334
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 May 2011 12:01:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea7659fb2b876337aee719d9d5ddb05531dfb334
Gitweb:     http://git.kernel.org/tip/ea7659fb2b876337aee719d9d5ddb05531dfb334
Author:     Jesper Juhl <jj@chaosbits.net>
AuthorDate: Thu, 26 May 2011 10:21:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 May 2011 13:49:57 +0200

perf: Remove duplicate headers

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: trivial@kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1105261011290.17400@swampdragon.chaosbits.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c |    2 --
 tools/perf/builtin-script.c   |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e18eb7e..7b139e1 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -8,8 +8,6 @@
 #include "builtin.h"
 
 #include "util/util.h"
-
-#include "util/util.h"
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 974f6d3..22747de 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -10,7 +10,6 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/trace-event.h"
-#include "util/parse-options.h"
 #include "util/util.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
