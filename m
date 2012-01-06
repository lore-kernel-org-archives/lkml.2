Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030678Ab2AFVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:16:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60450 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030619Ab2AFVQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:16:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/6] perf/core cleanups, fixes and improvements
Date: Fri,  6 Jan 2012 19:15:58 -0200
Message-Id: <1325884564-23322-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.GIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

Regards,

- Arnaldo

The following changes since commit 9e183426bfb52bb44bf3c443d6587e4d02478603:

  perf kvm: Fix copy & paste error in description (2012-01-03 15:17:14 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

Arnaldo Carvalho de Melo (3):
      perf hists: Rename total_session to total_period
      perf hists: Stop using 'self' for struct hist_entry
      perf top: Don't update total_period on process_sample

Joerg Roedel (2):
      perf kvm: Do guest-only counting by default
      perf tools: Add support for guest/host-only profiling

Sebastian Andrzej Siewior (1):
      perf tools: Add const.h to MANIFEST to make perf-tar-src-pkg work again

 tools/perf/Documentation/perf-list.txt |    2 +
 tools/perf/MANIFEST                    |    1 +
 tools/perf/builtin-kvm.c               |    6 +-
 tools/perf/builtin-top.c               |    1 -
 tools/perf/util/evlist.c               |    5 +-
 tools/perf/util/hist.c                 |   97 ++++++++++++++++---------------
 tools/perf/util/hist.h                 |    7 +--
 tools/perf/util/parse-events.c         |   15 ++++-
 tools/perf/util/util.c                 |   15 +++++
 tools/perf/util/util.h                 |    4 +
 10 files changed, 93 insertions(+), 60 deletions(-)

