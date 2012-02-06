Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2BFVga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:36:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47368 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2BFVg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:36:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Clark Williams <williams@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stable@kernel.org,
        arnaldo.melo@gmail.com
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Mon,  6 Feb 2012 19:36:06 -0200
Message-Id: <1328564169-26517-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 84f2b9b2edc09595569c7397cc3c888764ffd78b:

  perf: Remove deprecated WARN_ON_ONCE() (2012-02-03 08:24:40 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-urgent-for-mingo

for you to fetch changes up to a4a03fc7ef89020baca4f19174e6a43767c6d78a:

  perf evsel: Fix an issue where perf report fails to show the proper percentage (2012-02-06 18:59:38 -0200)

----------------------------------------------------------------
Fixes for some long standing problems.

----------------------------------------------------------------
Jiri Olsa (2):
      perf tools: Fix perf stack to non executable on x86_64
      perf tools: Fix prefix matching for kernel maps

Naveen N. Rao (1):
      perf evsel: Fix an issue where perf report fails to show the proper percentage

 tools/perf/bench/mem-memcpy-x86-64-asm.S |    6 ++++++
 tools/perf/util/event.c                  |    2 +-
 tools/perf/util/evsel.c                  |    1 +
 3 files changed, 8 insertions(+), 1 deletions(-)
