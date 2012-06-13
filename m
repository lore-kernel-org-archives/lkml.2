Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab2FMP3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:29:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41001 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2FMP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:29:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jim Cromie <jim.cromie@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Wed, 13 Jun 2012 12:29:24 -0300
Message-Id: <1339601367-17834-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 9ee6ddc9dada9cc4b2201631bc74fbf203183a10:

  Merge branch 'tip/perf/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent (2012-06-08 12:23:22 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to cb9dd49e11f83d548c822d7022ac180b0518b25c:

  perf tools: Fix synthesizing tracepoint names from the perf.data headers (2012-06-12 11:28:09 -0300)

----------------------------------------------------------------
Fixes for perf/urgent

. Set name of tracepoints when reading the perf.data headers, so that
  we don't end up using the local ones, from /sys.

. Fix default output file for perf stat, from Stephane Eranian.

. Fix endian handling of features bitmask in perf.data header, from David Ahern

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf tools: Fix synthesizing tracepoint names from the perf.data headers

David Ahern (1):
      perf tools: Fix endianity swapping for adds_features bitmask

Stephane Eranian (1):
      perf stat: Fix default output file

 tools/perf/builtin-stat.c              |    8 +++++-
 tools/perf/util/header.c               |   48 +++++++++++++++++++++++++++-----
 tools/perf/util/include/linux/bitops.h |    2 ++
 tools/perf/util/session.c              |   10 +++++++
 tools/perf/util/session.h              |    1 +
 5 files changed, 61 insertions(+), 8 deletions(-)
