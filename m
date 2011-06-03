Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1FCQ00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:26:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:60641 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1FCQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:26:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/4] perf/urgent fixes
Date: Fri,  3 Jun 2011 13:25:59 -0300
Message-Id: <1307118363-24092-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

	As we discussed, here are just the fixes from my last perf/core pull
request, all related to having the python binding usable again, please consider
pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (3):
  perf evlist: Remove dependency on debug routines
  perf python: Use exception to propagate errors
  perf evlist: Don't die if sample_{id_all|type} is invalid

Frederic Weisbecker (1):
  perf python: Fix argument name list of read_on_cpu()

 tools/perf/builtin-test.c |    2 +-
 tools/perf/util/event.c   |   16 ----------
 tools/perf/util/event.h   |    2 -
 tools/perf/util/evlist.c  |   68 +++++++++++++++++++++++++--------------------
 tools/perf/util/evlist.h  |    6 ++-
 tools/perf/util/evsel.c   |   16 ++++++++++
 tools/perf/util/evsel.h   |    7 ++++
 tools/perf/util/python.c  |   14 ++++-----
 tools/perf/util/session.c |   12 +++++++-
 9 files changed, 83 insertions(+), 60 deletions(-)

