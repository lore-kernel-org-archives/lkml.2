Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2HUOjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:39:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:45732 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2HUOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:39:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Carretero?= <cJ-ko@zougloub.eu>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/1] perf/urgent fix
Date: Tue, 21 Aug 2012 11:39:20 -0300
Message-Id: <1345559961-7964-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 5c65ca75209de8cc1802e7d3761b404957689cda:

  Merge branch 'tip/perf/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent (2012-08-21 11:49:37 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 3ab484b8622b7b890ca8d2ab5ee034c217ee4eeb:

  perf tools: Add missing files to build the python binding (2012-08-21 10:31:40 -0300)

----------------------------------------------------------------
perf/urgent fix:

. Add missing object files needed to use the python binding, cherry-picked
  from perf/core, got a report it affects Linus's too, fix it.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf tools: Add missing files to build the python binding

 tools/perf/util/python-ext-sources |    2 ++
 1 file changed, 2 insertions(+)
