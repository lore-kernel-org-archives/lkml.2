Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2AHPoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:44:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:59583 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2AHPma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:42:30 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Joerg Roedel <joerg.roedel@amd.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/9] perf/core fixes and improvements
Date: Sun,  8 Jan 2012 13:42:10 -0200
Message-Id: <1326037339-31125-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.GIT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling.

Regards,

- Arnaldo

The following changes since commit b9f616bbf4a917398aa09db89efbdf9a204e80dc:

  Merge branch 'perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2012-01-08 12:36:18 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

for you to fetch changes up to 172d1b0b73256551f100fc00c69e356d047103f5:

  perf tools: Fix compile error on x86_64 Ubuntu (2012-01-08 13:34:55 -0200)

----------------------------------------------------------------
Namhyung Kim (9):
      perf script: Add missing closedir() calls
      perf test: Change type of '-v' option to INCR
      perf top: Add error message for EMFILE
      perf kmem: Add missing closedir() calls
      perf kmem: Fix a memory leak
      perf annotate: Fix usage string
      perf annotate: Get rid of field_sep check
      perf report: Fix --stdio output alignment when --showcpuutilization used
      perf tools: Fix compile error on x86_64 Ubuntu

 tools/perf/builtin-annotate.c      |    7 +------
 tools/perf/builtin-kmem.c          |    3 +++
 tools/perf/builtin-script.c        |    4 ++++
 tools/perf/builtin-test.c          |    2 +-
 tools/perf/builtin-top.c           |    4 ++++
 tools/perf/util/hist.c             |   34 ++++++++++++++++++----------------
 tools/perf/util/trace-event-info.c |    1 -
 7 files changed, 31 insertions(+), 24 deletions(-)
