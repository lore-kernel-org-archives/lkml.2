Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965814Ab2JaOth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:49:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43899 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965797Ab2JaOtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:49:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <ak@linux.intel.com>, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Ahern <dsahern@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Joonsoo Kim <js1304@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/6] perf/core improvements and fixes
Date: Wed, 31 Oct 2012 12:48:57 -0200
Message-Id: <1351694943-7188-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 95d18aa2b6c05351181934b3bc34ce038cc7b637:

  perf/x86: Fix sparse warnings (2012-10-30 10:10:52 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to ffadcf090d468e9c4938b718649f38dd10cfdb02:

  perf annotate: Handle XBEGIN like a jump (2012-10-31 12:18:26 -0200)

----------------------------------------------------------------
perf/core improvements and fixes

. Handle XBEGIN like a jump in the annotate browser, from Andi Kleen

. Build speedups for --version, from Ingo Molnar.

. Add info about cross compiling for Android ARM, from Joonsoo Kim.

. Warn about missing libelf, from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (1):
      perf annotate: Handle XBEGIN like a jump

Arnaldo Carvalho de Melo (1):
      perf tools: Handle --version string generation on machines without git

Ingo Molnar (2):
      perf tools: Speed up the perf build time by simplifying the perf --version string generation
      perf tools: Further speed up the perf build

Joonsoo Kim (1):
      perf tools: Add info about cross compiling for Android ARM

Namhyung Kim (1):
      perf tools: Warn about missing libelf

 tools/perf/Documentation/android.txt |    5 ++++-
 tools/perf/Makefile                  |    2 ++
 tools/perf/util/PERF-VERSION-GEN     |   14 +++++---------
 tools/perf/util/annotate.c           |    2 ++
 4 files changed, 13 insertions(+), 10 deletions(-)
