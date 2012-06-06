Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2FFG7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:59:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35759 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2FFG7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:59:36 -0400
Date: Tue, 5 Jun 2012 23:59:11 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-z3mjj74927xvqwhlmu18kj80@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de, borislav.petkov@amd.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix make tarballs
Git-Commit-ID: f1439c315b328bbb3f7f6fdd814a7057f9e130d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 23:59:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1439c315b328bbb3f7f6fdd814a7057f9e130d5
Gitweb:     http://git.kernel.org/tip/f1439c315b328bbb3f7f6fdd814a7057f9e130d5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 30 May 2012 15:02:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 May 2012 15:05:59 -0300

perf tools: Fix make tarballs

The patch series that introduced the top level tools/ makefile and the
libtraceevent broke this feature where files needed to build in a
detached tarball were not included in the MANIFEST file and thus not
included in the tarball.

Fix it by adding the relevant files to the MANIFEST.

Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-z3mjj74927xvqwhlmu18kj80@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/MANIFEST |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 5476bc0..b4b572e 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,4 +1,6 @@
 tools/perf
+tools/scripts
+tools/lib/traceevent
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
