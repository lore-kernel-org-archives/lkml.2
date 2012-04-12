Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934921Ab2DLWH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:07:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:38865 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934761Ab2DLWH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:07:26 -0400
Date: Fri, 13 Apr 2012 00:07:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] perf fixes for 3.4
Message-ID: <alpine.LFD.2.02.1204130006280.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

Thanks,

	tglx

------------------>
Markus Trippelsdorf (1):
      perf tools: Fix getrusage() related build failure on glibc trunk


 tools/perf/builtin-sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index fb8b5f8..1cad3af 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -17,6 +17,7 @@
 #include "util/debug.h"
 
 #include <sys/prctl.h>
+#include <sys/resource.h>
 
 #include <semaphore.h>
 #include <pthread.h>
