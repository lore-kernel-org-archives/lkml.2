Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab0D0M6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:58:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:48927 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab0D0M6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:58:16 -0400
Date: Tue, 27 Apr 2010 12:57:53 GMT
From: tip-bot for William Cohen <wcohen@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, wcohen@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4BD204C5.9000504@redhat.com>
References: <4BD204C5.9000504@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Some perf-kvm documentation edits
Message-ID: <tip-cfadf9d4ac4be940595ab73d3def24c23c8b875f@git.kernel.org>
Git-Commit-ID: cfadf9d4ac4be940595ab73d3def24c23c8b875f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Apr 2010 12:57:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfadf9d4ac4be940595ab73d3def24c23c8b875f
Gitweb:     http://git.kernel.org/tip/cfadf9d4ac4be940595ab73d3def24c23c8b875f
Author:     William Cohen <wcohen@redhat.com>
AuthorDate: Fri, 23 Apr 2010 16:36:21 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sat, 24 Apr 2010 03:50:49 +0200

perf: Some perf-kvm documentation edits

asciidoc does not allow the "===" to be longer than the line
above it.
Also fix a couple types and formatting errors.

Signed-off-by: William Cohen <wcohen@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <4BD204C5.9000504@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Documentation/perf-kvm.txt |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 93400a0..d004e19 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -1,5 +1,5 @@
 perf-kvm(1)
-==============
+===========
 
 NAME
 ----
@@ -41,9 +41,9 @@ There are a couple of variants of perf kvm:
 OPTIONS
 -------
 --host=::
-        Collect host side perforamnce profile.
+        Collect host side performance profile.
 --guest=::
-        Collect guest side perforamnce profile.
+        Collect guest side performance profile.
 --guestmount=<path>::
 	Guest os root file system mount directory. Users mounts guest os
         root directories under <path> by a specific filesystem access method,
@@ -64,4 +64,5 @@ OPTIONS
 
 SEE ALSO
 --------
-linkperf:perf-top[1] perf-record[1] perf-report[1] perf-diff[1] perf-buildid-list[1]
+linkperf:perf-top[1], linkperf:perf-record[1], linkperf:perf-report[1],
+linkperf:perf-diff[1], linkperf:perf-buildid-list[1]
