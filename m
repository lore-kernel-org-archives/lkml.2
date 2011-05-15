Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147Ab1EOQig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:38:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:48944 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab1EOQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:38:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Sun, 15 May 2011 13:38:18 -0300
Message-Id: <1305477500-20739-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf tools: Honour the cpu list parameter when also monitoring a thread list
  perf evlist: Fix per thread mmap setup

 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-test.c   |    2 +-
 tools/perf/builtin-top.c    |    8 +-
 tools/perf/util/evlist.c    |  153 ++++++++++++++++++++++++++++++-------------
 tools/perf/util/evlist.h    |    3 +-
 tools/perf/util/python.c    |    2 +-
 6 files changed, 116 insertions(+), 54 deletions(-)

