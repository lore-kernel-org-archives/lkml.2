Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab2EXQkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:40:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49185 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab2EXQkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:40:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Avi Kivity <avi@redhat.com>, Borislav Petkov <bp@alien8.de>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/6] perf/urgent fixes for libtraceevent
Date: Thu, 24 May 2012 13:40:07 -0300
Message-Id: <1337877613-15133-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo


The following changes since commit e76df19bd986656e3c9f4a62e3dd15e7d69b607a:

  Merge branch 'perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2012-05-24 12:28:14 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to eaec12d7f526694f24d581a4ad23de6ce0315cd2:

  tools lib traceevent: Fix signature of create_arg_item() (2012-05-24 11:36:05 -0300)

----------------------------------------------------------------
Fixes for the recently merged libtraceevent

. Selected fixes for libtraceevent, from various contributors, submitter by
  Namhyung Kim in agreement with Steven Rostedt, all from the trace-cmd repo,
  i.e. they have been in use for quite a while in trace-cmd.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Namhyung Kim (5):
      tools lib traceevent: Fix a possible memory leak
      tools lib traceevent: Fix a possibly wrong memory dereference
      tools lib traceevent: Fix freeing arg on process_dynamic_array()
      tools lib traceevent: Use proper function parameter type
      tools lib traceevent: Fix signature of create_arg_item()

Stefan Hajnoczi (1):
      tools lib traceevent: Allow expressions in __print_symbolic() fields

 tools/lib/traceevent/event-parse.c  |   22 ++++++++++++++++++----
 tools/lib/traceevent/parse-filter.c |    5 ++---
 2 files changed, 20 insertions(+), 7 deletions(-)
