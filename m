Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1HITnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:43:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41259 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1HITni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:43:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>, Christian Ohm <chr.ohm@gmx.net>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Jonathan Nieder <jrnieder@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, acme@ghostprotocols.net
Subject: [GIT PULL 0/4] perf/core fixes
Date: Tue,  9 Aug 2011 16:43:04 -0300
Message-Id: <1312918988-24146-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

	Now there are 8 outstanding patches in this branch.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf tools: Check $HOME/.perfconfig ownership

Jiri Olsa (3):
  perf tools: Add support to install perf python extension
  perf sched: Do not delete session object prematurely
  perf sched: Usage leftover from trace -> script rename

 tools/perf/Makefile        |   19 +++++++++++++------
 tools/perf/builtin-sched.c |   24 ++++++++++++++++--------
 tools/perf/util/config.c   |   27 +++++++++++++++++++++++----
 tools/perf/util/setup.py   |   21 ++++++++++++++++++++-
 4 files changed, 72 insertions(+), 19 deletions(-)
