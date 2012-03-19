Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab2CSTNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:13:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40446 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274Ab2CSTND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:13:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Colin Walters <walters@verbum.org>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/core fixes and improvements
Date: Mon, 19 Mar 2012 16:12:45 -0300
Message-Id: <1332184368-1655-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling, now there are two pull request worth of
changesets in my perf/core branch,

- Arnaldo

The following changes since commit 6db6127c4dad634ab98709b81e2f2770890b0d53:

  perf report: Treat an argument as a symbol filter (2012-03-16 16:44:36 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to c31a94570552dcaa517c4f7a043ffd28835016be:

  perf report: Add a simple GTK2-based 'perf report' browser (2012-03-19 15:13:29 -0300)

----------------------------------------------------------------
Fixes for the last batch from Namhyung and the initial GTK report browser
from Pekka.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Namhyung Kim (2):
      perf ui browser: Clean lines inside of the input window
      perf report: Document --symbol-filter option

Pekka Enberg (1):
      perf report: Add a simple GTK2-based 'perf report' browser

 tools/perf/Documentation/perf-report.txt |    5 +
 tools/perf/Makefile                      |   14 +++
 tools/perf/builtin-report.c              |   19 ++-
 tools/perf/config/feature-tests.mak      |   15 +++
 tools/perf/util/cache.h                  |   12 ++
 tools/perf/util/gtk/browser.c            |  189 ++++++++++++++++++++++++++++++
 tools/perf/util/gtk/gtk.h                |    8 ++
 tools/perf/util/hist.h                   |   17 +++
 tools/perf/util/ui/util.c                |   10 +-
 9 files changed, 282 insertions(+), 7 deletions(-)
 create mode 100644 tools/perf/util/gtk/browser.c
 create mode 100644 tools/perf/util/gtk/gtk.h
