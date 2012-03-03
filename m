Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2CCTUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 14:20:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38923 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2CCTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 14:20:30 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Sat,  3 Mar 2012 16:20:04 -0300
Message-Id: <1330802407-22721-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 1018faa6cf23b256bf25919ef203cd7c129f06f2:

  perf/x86/kvm: Fix Host-Only/Guest-Only counting with SVM disabled (2012-03-02 12:16:39 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to bc76efe64533305b55d1f0834fd03414da8a12b2:

  perf tools: Handle kernels that don't support attr.exclude_{guest,host} (2012-03-03 12:19:56 -0300)

----------------------------------------------------------------
Cherry picked fixes from perf/core, together with the kernel fix (1018faa),
the sampling tools (top, record) are back working on AMD systems.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf tools: Handle kernels that don't support attr.exclude_{guest,host}

David Ahern (1):
      perf record: No build id option fails

Joerg Roedel (1):
      perf tools: Change perf_guest default back to false

 tools/perf/builtin-record.c |   33 ++++++++++++++++++++++-----------
 tools/perf/builtin-top.c    |   23 +++++++++++++++++------
 tools/perf/perf.h           |    1 +
 tools/perf/util/top.h       |    1 +
 tools/perf/util/util.c      |    2 +-
 5 files changed, 42 insertions(+), 18 deletions(-)
