Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0LAB6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:58:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50611 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab0LAB6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tE8h94g3g0KAZreDQ/LOB9FlQFApbUnWvOMg3pf2q7tJ9CZYo1gOC3EdZsjtLmyUy4
         c2V+9WfxjEOL8bX3awEvAP1XsuyJfs5w5Dq2JZXsNDqU4hJHNPLazLYsqjgPuGeoUv06
         37KckNRAm8WyOIsBYUUTjHUeHMhOttxenAcWw=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 03/14] perf: fix diff displacement and modules options short flag
Date: Tue, 30 Nov 2010 19:57:11 -0600
Message-Id: <1291168642-11402-4-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --displacement and --modules options to perf diff both use -m as a
short flag.  Change --displacement to use -M since other perf commands
use -m, --modules.

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
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
-- 
1.7.3.2

