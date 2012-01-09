Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2AIH1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:27:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2AIH1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:27:16 -0500
Date: Sun, 8 Jan 2012 23:26:55 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-993452541796f3637da9f2e537b9333494b3b2a1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1325957132-10600-6-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-6-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix usage string
Git-Commit-ID: 993452541796f3637da9f2e537b9333494b3b2a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 23:27:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  993452541796f3637da9f2e537b9333494b3b2a1
Gitweb:     http://git.kernel.org/tip/993452541796f3637da9f2e537b9333494b3b2a1
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Sun, 8 Jan 2012 02:25:30 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 8 Jan 2012 13:28:48 -0200

perf annotate: Fix usage string

The annotate command doesn't take non-option arguments.

In fact, it can take last argument as a symbol filter though, but that's
a special case and, IMHO, it should be discouraged in favor of the -s
option.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325957132-10600-6-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 214ba7f..3ec2496 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -235,7 +235,7 @@ out_delete:
 }
 
 static const char * const annotate_usage[] = {
-	"perf annotate [<options>] <command>",
+	"perf annotate [<options>]",
 	NULL
 };
 
