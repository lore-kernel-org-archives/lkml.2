Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab0LBLoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:44:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:53577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347Ab0LBLoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:44:10 -0500
Date: Thu, 2 Dec 2010 11:43:35 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-4-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-4-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Fix displacement and modules options short flag
Message-ID: <tip-342955593af08f185279e074b3d77719d2f23b82@git.kernel.org>
Git-Commit-ID: 342955593af08f185279e074b3d77719d2f23b82
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:43:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  342955593af08f185279e074b3d77719d2f23b82
Gitweb:     http://git.kernel.org/tip/342955593af08f185279e074b3d77719d2f23b82
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:11 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:45 -0200

perf diff: Fix displacement and modules options short flag

The --displacement and --modules options to perf diff both use -m as a
short flag.  Change --displacement to use -M since other perf commands
use -m, --modules.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-4-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index fca1d44..221b823 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -173,7 +173,7 @@ static const char * const diff_usage[] = {
 static const struct option options[] = {
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('m', "displacement", &show_displacement,
+	OPT_BOOLEAN('M', "displacement", &show_displacement,
 		    "Show position displacement relative to baseline"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
