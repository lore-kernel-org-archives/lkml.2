Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab2DNREJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 13:04:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:36454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab2DNRED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 13:04:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Chanho Park <chanho61.park@samsung.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/5] perf/urgent fixes
Date: Sat, 14 Apr 2012 14:03:42 -0300
Message-Id: <1334423027-2220-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

Thanks,

- Arnaldo

The following changes since commit 7fb0a5ee8889488f7568ffddffeb66ddeb50917e:

  perf kvm: Finding struct machine fails for PERF_RECORD_MMAP (2012-04-11 11:45:12 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to e3b6193378e8549d04849eda496129f94406ed36:

  perf archive: Correct cutting of symbolic link (2012-04-14 13:52:15 -0300)

----------------------------------------------------------------
Fixes for perf/urgent:

. Properly handle ~/.debug, the build id cache, when it is a symlink,
  fix from Chanho Park

. Fixes for the parser generation process, from Jiri Olsa and Namhyung Kim

. Fix build when NO_GTK2 is specified, From Stephane Eranian

. When a machine is not found, bump the relevant error stat but return
  0, so that we correctly move to the next perf event. Fix from Jiri Olsa

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Chanho Park (1):
      perf archive: Correct cutting of symbolic link

Jiri Olsa (2):
      perf session: Skip event correctly for unknown id/machine
      perf tools: Fix parsers' rules to dependencies

Namhyung Kim (1):
      perf tools: Ignore auto-generated bison/flex files

Stephane Eranian (1):
      perf tools: fix NO_GTK2 Makefile config error

 tools/perf/.gitignore      |    2 ++
 tools/perf/Makefile        |   21 +++++++++------------
 tools/perf/perf-archive.sh |    3 ++-
 tools/perf/util/session.c  |    4 ++--
 4 files changed, 15 insertions(+), 15 deletions(-)
