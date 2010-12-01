Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0LAB6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:58:54 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56724 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0LAB6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o4qrzhumAkHhZLfCR8uViPnetS5nXHFKfBkfT0xG3CerL9ixaolWlmULnWWLLMc+Wq
         jkYtly87jJ3FrRkk66mGB6YFZbTY6zct7G7FAgeJ+aEARVdiT1+A60KGsVV5eeJZTV2j
         4rU9BU8JxhvpkbZPTXhG1tSu/WNQ6xSc35VvY=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 13/14] perf: Document missing top options
Date: Tue, 30 Nov 2010 19:57:21 -0600
Message-Id: <1291168642-11402-14-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
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
1.7.3.2

