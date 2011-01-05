Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab1AERij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:38:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:32959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab1AERih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:38:37 -0500
Date: Wed, 5 Jan 2011 17:38:04 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Make some lists static
Message-ID: <tip-eccdfe2d245a882feacc4630c9bc29805e9929c8@git.kernel.org>
Git-Commit-ID: eccdfe2d245a882feacc4630c9bc29805e9929c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 Jan 2011 17:38:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eccdfe2d245a882feacc4630c9bc29805e9929c8
Gitweb:     http://git.kernel.org/tip/eccdfe2d245a882feacc4630c9bc29805e9929c8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 4 Jan 2011 16:32:52 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Jan 2011 14:53:59 -0200

perf script: Make some lists static

Not accessed outside builtin-script, so make them static.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 27d568d..150a606 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -137,7 +137,7 @@ struct script_spec {
 	char			spec[0];
 };
 
-LIST_HEAD(script_specs);
+static LIST_HEAD(script_specs);
 
 static struct script_spec *script_spec__new(const char *spec,
 					    struct scripting_ops *ops)
@@ -319,7 +319,7 @@ struct script_desc {
 	char			*args;
 };
 
-LIST_HEAD(script_descs);
+static LIST_HEAD(script_descs);
 
 static struct script_desc *script_desc__new(const char *name)
 {
