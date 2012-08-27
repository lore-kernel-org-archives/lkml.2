Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2H0Qxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:53:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab2H0Qxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:53:43 -0400
Date: Mon, 27 Aug 2012 09:52:23 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-d45a3e00687bb52a20d9256d3d1068eea271013f@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org,
        peterz@infradead.org, penberg@kernel.org, efault@gmx.de,
        namhyung.kim@lge.com, jolsa@redhat.com, drepper@gmail.com,
        robert.richter@amd.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        sedat.dilek@gmail.com, borislav.petkov@amd.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        andi@firstfloor.org, namhyung@gmail.com, namhyung@kernel.org,
        ben@decadent.org.uk, feng.tang@intel.com, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com, efault@gmx.de,
        penberg@kernel.org, peterz@infradead.org, namhyung.kim@lge.com,
        jolsa@redhat.com, fweisbec@gmail.com, drepper@gmail.com,
        robert.richter@amd.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        borislav.petkov@amd.com, sedat.dilek@gmail.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        namhyung@kernel.org, namhyung@gmail.com, ben@decadent.org.uk,
        feng.tang@intel.com, mingo@elte.hu
In-Reply-To: <20120822083812.GC1003@krava.brq.redhat.com>
References: <20120822083812.GC1003@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix 'No libunwind found'
  make warning message
Git-Commit-ID: d45a3e00687bb52a20d9256d3d1068eea271013f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 09:52:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d45a3e00687bb52a20d9256d3d1068eea271013f
Gitweb:     http://git.kernel.org/tip/d45a3e00687bb52a20d9256d3d1068eea271013f
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 22 Aug 2012 10:38:12 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Aug 2012 13:32:13 -0300

perf tools: Fix 'No libunwind found' make warning message

Changing error message when libunwind support is not found to inform
properly to install libunwind-dev[el] package.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/20120822083812.GC1003@krava.brq.redhat.com
[ committer note: s/disable/disabling/g rewording suggested by Steven Rostedt ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6bd888d..722ddee 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -493,7 +493,7 @@ endif
 
 FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
 ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
-	msg := $(warning No libunwind found. Please install libunwind >= 0.99);
+	msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
 	NO_LIBUNWIND := 1
 endif # Libunwind support
 endif # NO_LIBUNWIND
