Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab2GBSII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:08:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:40744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2GBSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:08:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Mon,  2 Jul 2012 15:07:48 -0300
Message-Id: <1341252471-7834-1-git-send-email-acme@infradead.org>
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

The following changes since commit 662f5cedb38c4b88e1cebfd54a88159f2f7ab7b9:

  Merge branch 'urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile into perf/urgent (2012-06-24 19:08:49 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 7ed97ad41ffa94040dfd593948962a7e9e7b0db9:

  perf kvm: Fix segfault with report and mixed guestmount use (2012-07-02 14:03:50 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. Fix creation of guest machine objects when build ids are disabled,
  from David Ahern

. The kvm tool was trying to access an uninitialized guestmount variable, fix
  from David Ahern.

. Restore perf script output to pre-libparseevent merge format, removing
  duplicated info, fix from David Ahern

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
David Ahern (3):
      perf script: Fix format regression due to libtraceevent merge
      perf kvm: Fix regression with guest machine creation
      perf kvm: Fix segfault with report and mixed guestmount use

 tools/perf/util/map.c               |   29 +++++++++++++++--------------
 tools/perf/util/session.c           |    2 +-
 tools/perf/util/trace-event-parse.c |    3 +--
 3 files changed, 17 insertions(+), 17 deletions(-)
