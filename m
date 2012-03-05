Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2CEPzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:55:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:53813 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2CEPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:55:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/7] perf/core improvements and fixes
Date: Mon,  5 Mar 2012 12:55:25 -0300
Message-Id: <1330962932-1796-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 737f24bda723fdf89ecaacb99fa2bf5683c32799:

  Merge branch 'perf/urgent' into perf/core (2012-03-05 09:20:08 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to ff2a6617c2acd6a8dc468c90ab8708a6ad112bb0:

  perf annotate: Add missing newline on error message (2012-03-05 10:15:50 -0300)

----------------------------------------------------------------
Improvements for 'perf annotate' from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Namhyung Kim (7):
      perf evlist: Restore original errno after open failed
      perf tools: Add descriptions of missing Makefile arguments
      perf annotate: Print asm code as blue when source code is displayed
      perf annotate: Handle lower case key code in annotate_browser__run()
      perf annotate: Restore title when came back to original symbol
      perf annotate: Fix help string on tui
      perf annotate: Add missing newline on error message

 tools/perf/Makefile                    |   14 ++++++++++++++
 tools/perf/util/annotate.c             |    2 +-
 tools/perf/util/evlist.c               |    1 +
 tools/perf/util/ui/browsers/annotate.c |   18 ++++++++++++------
 4 files changed, 28 insertions(+), 7 deletions(-)
