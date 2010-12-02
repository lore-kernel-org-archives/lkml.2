Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab0LBLpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:45:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:53689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab0LBLpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:45:40 -0500
Date: Thu, 2 Dec 2010 11:45:18 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-9-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-9-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Document missing options
Message-ID: <tip-08dbd7e3fa2398910713b21399cca7c6e4b43011@git.kernel.org>
Git-Commit-ID: 08dbd7e3fa2398910713b21399cca7c6e4b43011
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:45:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08dbd7e3fa2398910713b21399cca7c6e4b43011
Gitweb:     http://git.kernel.org/tip/08dbd7e3fa2398910713b21399cca7c6e4b43011
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:16 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:47 -0200

perf record: Document missing options

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-9-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
 
