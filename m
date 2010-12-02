Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab0LBLqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:46:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:60946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0LBLqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:46:49 -0500
Date: Thu, 2 Dec 2010 11:46:20 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-14-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-14-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Document missing options
Message-ID: <tip-2e7a988198b11877d844d147ec81c7caea82c314@git.kernel.org>
Git-Commit-ID: 2e7a988198b11877d844d147ec81c7caea82c314
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:46:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e7a988198b11877d844d147ec81c7caea82c314
Gitweb:     http://git.kernel.org/tip/2e7a988198b11877d844d147ec81c7caea82c314
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:21 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:48 -0200

perf top: Document missing options

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-14-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-top.txt |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 1f96876..f6eb1cd 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-This command generates and displays a performance counter profile in realtime.
+This command generates and displays a performance counter profile in real time.
 
 
 OPTIONS
@@ -27,8 +27,8 @@ OPTIONS
 
 -C <cpu-list>::
 --cpu=<cpu>::
-Monitor only on the list of cpus provided. Multiple CPUs can be provided as a
-comma-sperated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2.
+Monitor only on the list of CPUs provided. Multiple CPUs can be provided as a
+comma-separated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2.
 Default is to monitor all CPUS.
 
 -d <seconds>::
@@ -50,6 +50,10 @@ Default is to monitor all CPUS.
 --count-filter=<count>::
 	Only display functions with more events than this.
 
+-g::
+--group::
+        Put the counters into a counter group.
+
 -F <freq>::
 --freq=<freq>::
 	Profile at this frequency.
@@ -68,7 +72,11 @@ Default is to monitor all CPUS.
 
 -p <pid>::
 --pid=<pid>::
-	Profile events on existing pid.
+	Profile events on existing Process ID.
+
+-t <tid>::
+--tid=<tid>::
+        Profile events on existing thread ID.
 
 -r <priority>::
 --realtime=<priority>::
@@ -78,6 +86,18 @@ Default is to monitor all CPUS.
 --sym-annotate=<symbol>::
         Annotate this symbol.
 
+-K::
+--hide_kernel_symbols::
+        Hide kernel symbols.
+
+-U::
+--hide_user_symbols::
+        Hide user symbols.
+
+-D::
+--dump-symtab::
+        Dump the symbol table used for profiling.
+
 -v::
 --verbose::
 	Be more verbose (show counter open errors, etc).
