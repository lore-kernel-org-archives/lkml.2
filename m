Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0LASCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:02:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:52299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab0LASBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:01:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/15] perf top: Document missing options
Date: Wed,  1 Dec 2010 16:01:01 -0200
Message-Id: <1291226465-26337-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291226465-26337-1-git-send-email-acme@infradead.org>
References: <1291226465-26337-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Bohrer <shawn.bohrer@gmail.com>

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
-- 
1.6.2.5

