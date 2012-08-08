Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030654Ab2HHRQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:16:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:45857 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030590Ab2HHROA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:14:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: =?UTF-8?q?=5BPATCH=2005/11=5D=20perf=20list=3A=20Update=20documentation=20about=20raw=20event=20setup?=
Date: Wed,  8 Aug 2012 14:13:42 -0300
Message-Id: <1344446028-21381-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344446028-21381-1-git-send-email-acme@infradead.org>
References: <1344446028-21381-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

It was missing that only certain bit fields are passed to the config
value which confused users. Updating it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1344361396-7237-6-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |    6 ++++++
 1 file changed, 6 insertions(+)

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
-- 
1.7.9.2.358.g22243

