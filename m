Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835Ab0HFRGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:06:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:42632 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933750Ab0HFRGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:06:35 -0400
Date: Fri, 6 Aug 2010 17:05:59 GMT
From: tip-bot for Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        andrea.gelmini@gelma.net, fweisbec@gmail.com, tglx@linutronix.de,
        mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        andrea.gelmini@gelma.net, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <1281016299-23958-15-git-send-email-andrea.gelmini@gelma.net>
References: <1281016299-23958-15-git-send-email-andrea.gelmini@gelma.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Remove duplicated #include
Message-ID: <tip-7935f65f77e1cd19fe0a094fc1b34e258565751e@git.kernel.org>
Git-Commit-ID: 7935f65f77e1cd19fe0a094fc1b34e258565751e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 17:06:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7935f65f77e1cd19fe0a094fc1b34e258565751e
Gitweb:     http://git.kernel.org/tip/7935f65f77e1cd19fe0a094fc1b34e258565751e
Author:     Andrea Gelmini <andrea.gelmini@gelma.net>
AuthorDate: Thu, 5 Aug 2010 15:51:39 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Aug 2010 19:38:02 -0300

perf probe: Remove duplicated #include

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1281016299-23958-15-git-send-email-andrea.gelmini@gelma.net>
Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 840f1aa..6c7750d 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -33,7 +33,6 @@
 #include <ctype.h>
 #include <dwarf-regs.h>
 
-#include "string.h"
 #include "event.h"
 #include "debug.h"
 #include "util.h"
