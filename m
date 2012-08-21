Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab2HUP3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:29:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59803 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab2HUP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:29:18 -0400
Date: Tue, 21 Aug 2012 08:29:04 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-75bc5ca89827fe3f2399321b2920a30bcf658049@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1344361396-7237-6-git-send-email-robert.richter@amd.com>
References: <1344361396-7237-6-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf list:
  Update documentation about raw event setup
Git-Commit-ID: 75bc5ca89827fe3f2399321b2920a30bcf658049
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:29:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75bc5ca89827fe3f2399321b2920a30bcf658049
Gitweb:     http://git.kernel.org/tip/75bc5ca89827fe3f2399321b2920a30bcf658049
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 7 Aug 2012 19:43:15 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Aug 2012 12:41:53 -0300

perf list: Update documentation about raw event setup

It was missing that only certain bit fields are passed to the config
value which confused users. Updating it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1344361396-7237-6-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index ddc2252..232be51 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -15,6 +15,7 @@ DESCRIPTION
 This command displays the symbolic event types which can be selected in the
 various perf commands with the -e option.
 
+[[EVENT_MODIFIERS]]
 EVENT MODIFIERS
 ---------------
 
@@ -44,6 +45,11 @@ layout of IA32_PERFEVTSELx MSRs (see [Intel® 64 and IA-32 Architectures Softwar
 of IA32_PERFEVTSELx MSRs) or AMD's PerfEvtSeln (see [AMD64 Architecture Programmer’s Manual Volume 2: System Programming], Page 344,
 Figure 13-7 Performance Event-Select Register (PerfEvtSeln)).
 
+Note: Only the following bit fields can be set in x86 counter
+registers: event, umask, edge, inv, cmask. Esp. guest/host only and
+OS/user mode flags must be setup using <<EVENT_MODIFIERS, EVENT
+MODIFIERS>>.
+
 Example:
 
 If the Intel docs for a QM720 Core i7 describe an event as:
