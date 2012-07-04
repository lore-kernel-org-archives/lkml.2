Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab2GDFih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:38:37 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48781 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab2GDFie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:38:34 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-6f-4ff3d6d8bfd3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Subject: [GIT PULL 00/16] tools lib traceevent: Pending backports of libparseevent
Date: Wed,  4 Jul 2012 14:34:28 +0900
Message-Id: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

Please pull pending libparseevent improvements from my tree. All
patches in the tree got acked or signed-off by Steven. They were
originally in the trace-cmd tree, and format-patched + path name
adjusted and re-applied.

I've fixed the committer note and Link positions as you requested.  
(I put the Links right before Steven's s-o-b as he's the original
committer.) Also changelogs are reflowed (to fit to 70 column width
that is the default value of emacs fill-paragraph function).

Thanks,
Namhyung


The following changes since commit 17d7a1123f0f6d532830152564cc812cc73db2f3:

  perf bench: Fix confused variable namings and descriptions in mem subsystem (2012-07-02 14:35:45 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git 

for you to fetch changes up to f6ced60fb6c0ee115982157457c47e48802d6e1d:

  tools lib traceevent: Cleanup realloc use (2012-07-04 13:40:31 +0900)

----------------------------------------------------------------
libtraceevent/core improvements

* Remaining backport of trace-cmd's libparseevent

Signed-off-by: Namhyung Kim <namhyung@kernel.org>

----------------------------------------------------------------
Namhyung Kim (10):
      tools lib traceevent: Fix printk_cmp()
      tools lib traceevent: Introduce extend_token()
      tools lib traceevent: Handle strdup failure cases
      tools lib traceevent: Handle realloc() failure path
      tools lib traceevent: Pass string type argument to args
      tools lib traceevent: Do not call add_event() again if allocation failed
      tools lib traceevent: Fix some comments
      tools lib traceevent: Check result of malloc() during reading token
      tools lib traceevent: Check return value of arg_to_str()
      tools lib traceevent: Cleanup realloc use

Peter Huewe (1):
      tools lib traceevent: Add missing break in make_bprint_args

Steven Rostedt (4):
      tools lib traceevent: Let filtering numbers by string use function names
      tools lib traceevent: Add support for "%.*s" in bprintk events
      tools lib traceevent: Add support to show migrate disable counter
      tools lib traceevent: Fix %pM print format arg handling

Wolfgang Mauerer (1):
      tools lib traceevent: Fix trace_printk for long integers

 tools/lib/traceevent/event-parse.c  |  287 +++++++++++++++++++++++------------
 tools/lib/traceevent/parse-filter.c |   86 +++++++----
 2 files changed, 251 insertions(+), 122 deletions(-)

-- 
1.7.10.4

