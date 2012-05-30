Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2E3RS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:18:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:49502 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2E3RSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:18:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Wed, 30 May 2012 14:18:38 -0300
Message-Id: <1338398321-28327-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 063e04776172f93b16a5eefd5661a340c1126513:

  Merge branch 'linus' into perf/urgent (2012-05-30 10:59:04 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 79695e1bb65ba0e21488c360a1bed6e358354aaa:

  perf stat: Initialize default events wrt exclude_{guest,host} (2012-05-30 14:02:38 -0300)

----------------------------------------------------------------
Fixes for perf/urgent.

. Fix setting of KVM exclude bits on default set of events in perf stat.

. Use right symbol for annotation in non symbolic views in perf report.

. Fix annotate browser help window "Hot line" key.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (3):
      perf report: Use the right symbol for annotation
      perf annotate browser: Fix help window entry for navigating to hottest line
      perf stat: Initialize default events wrt exclude_{guest,host}

 tools/perf/builtin-report.c       |    2 +-
 tools/perf/builtin-stat.c         |    8 ++++----
 tools/perf/ui/browsers/annotate.c |    2 +-
 tools/perf/util/evlist.c          |   11 +++++++++++
 tools/perf/util/evlist.h          |    4 ++++
 5 files changed, 21 insertions(+), 6 deletions(-)
