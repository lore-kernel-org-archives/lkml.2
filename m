Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab0HURps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:45:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:36915 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab0HURpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:45:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/2] perf/core improvements
Date: Sat, 21 Aug 2010 14:45:10 -0300
Message-Id: <1282412712-3547-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf tools: Add --tui and --stdio to choose the UI

Kirill A. Shutemov (1):
  perf tools: add test for strlcpy()

 tools/perf/Documentation/perf-annotate.txt |   11 +++++++++--
 tools/perf/Documentation/perf-report.txt   |    7 +++++++
 tools/perf/Makefile                        |    9 +++++++++
 tools/perf/builtin-annotate.c              |    9 ++++++++-
 tools/perf/builtin-report.c                |   11 ++++++++++-
 tools/perf/feature-tests.mak               |   11 +++++++++++
 tools/perf/util/cache.h                    |    2 ++
 tools/perf/util/path.c                     |    3 ++-
 8 files changed, 58 insertions(+), 5 deletions(-)

