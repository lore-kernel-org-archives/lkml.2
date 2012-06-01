Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965774Ab2FAWT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:19:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:59513 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965566Ab2FAWQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:16:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 02/15] perf tools: Fix make tarballs
Date: Fri,  1 Jun 2012 19:16:26 -0300
Message-Id: <1338588999-32509-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338588999-32509-1-git-send-email-acme@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.7.1

