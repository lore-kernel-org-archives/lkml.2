Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab2I0VS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:18:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:49017 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2I0VS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:18:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/core improvements and fixes
Date: Thu, 27 Sep 2012 18:18:03 -0300
Message-Id: <1348780686-16108-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acmeinfradead.org>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 9ec60972a38011ad8a5676f4cd5e51ac508c36b6:

  perf hists: Add missing period_* fields when collapsing a hist entry (2012-09-26 20:44:11 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to aec1930b0f6f281a0ca038cd03aceace3fe0bb61:

  perf trace: Add aliases for some syscalls (2012-09-27 13:18:49 -0300)

----------------------------------------------------------------
perf/core improvements and fixes

. Improve listing of accessible enum perf probe variables, from Hyeoncheol Lee.

. Don't stop the build if the audit libraries are not installed, fix from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf trace: Add aliases for some syscalls

Hyeoncheol Lee (1):
      perf probe: Print an enum type variable in "enum variable-name" format when showing accessible variables

Namhyung Kim (1):
      perf tools: Check libaudit availability for perf-trace builtin

 tools/perf/Makefile                 |   16 ++++++++++++++--
 tools/perf/builtin-trace.c          |   26 ++++++++++++++++++--------
 tools/perf/config/feature-tests.mak |   11 +++++++++++
 tools/perf/perf.c                   |    2 ++
 tools/perf/util/dwarf-aux.c         |    2 ++
 5 files changed, 47 insertions(+), 10 deletions(-)
