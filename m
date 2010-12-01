Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0LAB6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:58:45 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50611 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab0LAB6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mNUpiS1ULNMUj1jD19cvWlUs8er//Sf6KL/xeLhjHwBgiheUMek97GaV02bgFVBxdM
         7D/FnEQ1QMhInFyaGlH0Vngp0mOYhRGBKJHWEct/dxgTFF6kQZOUbRumkDYrnFu7MF/j
         AfAyC/34xr9fMJ31qpRD1v6tRI9OpjwNtSF6A=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 08/14] perf: Document missing record options
Date: Tue, 30 Nov 2010 19:57:16 -0600
Message-Id: <1291168642-11402-9-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 tools/perf/Documentation/perf-record.txt |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index a91f9f9..0ad1bc7 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -39,15 +39,24 @@ OPTIONS
           be passed as follows: '\mem:addr[:[r][w][x]]'.
           If you want to profile read-write accesses in 0x1000, just set
           'mem:0x1000:rw'.
+
+--filter=<filter>::
+        Event filter.
+
 -a::
-        System-wide collection.
+--all-cpus::
+        System-wide collection from all CPUs.
 
 -l::
         Scale counter values.
 
 -p::
 --pid=::
-	Record events on existing pid.
+	Record events on existing process ID.
+
+-t::
+--tid=::
+        Record events on existing thread ID.
 
 -r::
 --realtime=::
@@ -109,8 +118,8 @@ Collect raw sample records from all opened counters (default for tracepoint coun
 
 -C::
 --cpu::
-Collect samples only on the list of cpus provided. Multiple CPUs can be provided as a
-comma-sperated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2.
+Collect samples only on the list of CPUs provided. Multiple CPUs can be provided as a
+comma-separated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2.
 In per-thread mode with inheritance mode on (default), samples are captured only when
 the thread executes on the designated CPUs. Default is to monitor all CPUs.
 
-- 
1.7.3.2

