Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424397Ab2LGU4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:56:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61045 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424380Ab2LGU4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:56:11 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Announce: the 'perf bench numa mem' NUMA performance measurement tool
Date: Fri,  7 Dec 2012 21:55:43 +0100
Message-Id: <1354913744-29902-1-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a NUMA performance measurement tool I've been honing for some time
and people expressed interest in it so here's a tidied up version of it.

I also pushed it out into the tip:perf/bench branch:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/bench

Maybe others find it useful too. I'll post a couple of perf bench
NUMA performance numbers in the next hour or so.

Thanks,

	Ingo

------------>
Ingo Molnar (1):
  perf: Add 'perf bench numa mem' NUMA performance measurement suite

 tools/perf/Makefile        |    3 +-
 tools/perf/bench/bench.h   |    1 +
 tools/perf/bench/numa.c    | 1731 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c |   13 +
 tools/perf/util/hist.h     |    2 +-
 5 files changed, 1748 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/bench/numa.c

-- 
1.7.11.7

