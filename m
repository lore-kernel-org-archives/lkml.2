Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2ETCRW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:17:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:47706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354Ab2ETCQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:16:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/6] perf/core fixes
Date: Sat, 19 May 2012 23:16:30 -0300
Message-Id: <1337480196-761-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	This also includes a merge with tip/perf/urgent, please consider
pulling,

- Arnaldo

The following changes since commit 978da300c7a65494692b329a6a4cbf364afc37c5:

  perf/x86/ibs: Fix undefined reference to `get_ibs_caps' (2012-05-14 14:31:35 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

for you to fetch changes up to 5e1c81d98a5621007824b49dde556fead5ff9c6c:

  perf evsel: Create events initially disabled -- again (2012-05-18 16:02:42 -0300)

----------------------------------------------------------------
Fixes for perf/core:

. Rename some perf_target methods to avoid double negation, from Namhyung Kim.

. Revert change to use per task events with inheritance, from Namhyung Kim.

. Events should start disabled till children starts running, from David Ahern.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      Merge remote-tracking branch 'tip/perf/urgent' into perf/core

David Ahern (1):
      perf evsel: Create events initially disabled -- again

Jiri Olsa (2):
      perf hists: Fix callchain ip printf format
      perf tools: Split term type into value type and term type

Namhyung Kim (3):
      perf target: Rename functions to avoid double negation
      Revert 'perf evlist: Fix creation of cpu map'
      perf target: Add uses_mmap field
