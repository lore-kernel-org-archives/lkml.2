Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2ELTyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:54:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:35563 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2ELTxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:53:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/8] Annotation weekly ponies delivery
Date: Sat, 12 May 2012 16:52:59 -0300
Message-Id: <1336852387-16322-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 5dcefda0fd87fefa440abc9b9d3f1089229f8911:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2012-05-11 08:13:55 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 54e7a4e88eed9ac423e22a259ec51a973fd59bab:

  perf annotate browser: Add key bindings help window (2012-05-12 16:36:55 -0300)

----------------------------------------------------------------
Arjan & Linus Annotation Edition

More like Linus', but hey at least an attempt at implementing a suggestion by
Arjan made this time around!

. Fix indirect calls beautifier, reported by Linus.

. Use the objdump comments to nuke specificities about how access to a well
  know variable is encoded, suggested by Linus.

. Show the number of places that jump to a target, requested by Arjan.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (8):
      perf annotate: Use raw form for register indirect call instructions
      perf annotate: Resolve symbols using objdump comment
      perf annotate: Resolve symbols using objdump comment for single op ins
      perf annotate: Augment lock instruction output
      perf annotate: Introduce ->free() method in ins_ops
      perf annotate browser: Count the numbers of jump sources to a target
      perf annotate browser: Show 'jumpy' functions
      perf annotate browser: Add key bindings help window

 tools/perf/ui/browsers/annotate.c |   94 ++++++++++--
 tools/perf/util/annotate.c        |  303 +++++++++++++++++++++++++++++++++----
 tools/perf/util/annotate.h        |   15 +-
 3 files changed, 369 insertions(+), 43 deletions(-)
