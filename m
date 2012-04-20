Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2DTQx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:53:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:49983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2DTQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:53:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Avi Kivity <avi@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/4] perf/urgent fixes
Date: Fri, 20 Apr 2012 13:53:03 -0300
Message-Id: <1334940787-16174-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

Regards,

- Arnaldo

The following changes since commit 7ea6411f4ceb62e5e53170d59d10996dca20c599:

  Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2012-04-15 08:02:36 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent

for you to fetch changes up to 33ff581eddf744ea91a50d46c2f0961b375a9595:

  perf symbols: Read plt symbols from proper symtab_type binary (2012-04-20 13:34:49 -0300)

----------------------------------------------------------------
Fixes for perf/urgent

. Read PLT symbols from the same DSO as the main symtab, fix from Jiri Olsa.

. Add back the 'g' and 'h' event modifiers, they were dropped during the
  conversion to use bison. Fix from Gleb Natapov

. Drop CROSS_COMPILE from flex and bison calls, not really needed. From
  Otavio Salvador

. A kernel map variable can be NULL, but was being used despite the earlier
  check. Fix from David Ahern

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
David Ahern (1):
      perf report: Fix crash showing warning related to kernel maps

Gleb Natapov (1):
      perf tools: Add 'G' and 'H' modifiers to event parsing

Jiri Olsa (1):
      perf symbols: Read plt symbols from proper symtab_type binary

Otavio Salvador (1):
      perf tools: Drop CROSS_COMPILE from flex and bison calls

 tools/perf/Makefile            |    4 ++--
 tools/perf/builtin-report.c    |   17 ++++++++++++-----
 tools/perf/builtin-test.c      |   30 ++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.l |    2 +-
 tools/perf/util/symbol.c       |   13 ++++++-------
 5 files changed, 51 insertions(+), 15 deletions(-)
