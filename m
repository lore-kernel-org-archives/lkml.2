Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab0ESCJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:09:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:52431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab0ESCIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:08:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL v2 0/5] perf tools fixes and improvements
Date: Tue, 18 May 2010 23:08:15 -0300
Message-Id: <1274234900-12162-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	The probe ones have the issues pointed out by Masami addressed,
please let me know if now it is ok, thanks for reviewing them!

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf tools: Remove some unused functions
  perf probe: Fix some error exit paths
  perf probe: Don't call die()
  perf tools: remove xstrndup, xmalloc, xzalloc

Stephane Eranian (1):
  perf stat: add perf stat -B to pretty print large numbers

 tools/perf/Documentation/perf-stat.txt |    3 +
 tools/perf/builtin-probe.c             |   10 +-
 tools/perf/builtin-record.c            |    1 +
 tools/perf/builtin-stat.c              |   18 +-
 tools/perf/util/abspath.c              |   81 ------
 tools/perf/util/cache.h                |   55 +----
 tools/perf/util/config.c               |  461 +-------------------------------
 tools/perf/util/exec_cmd.c             |    6 +-
 tools/perf/util/exec_cmd.h             |    1 -
 tools/perf/util/help.c                 |   30 +--
 tools/perf/util/path.c                 |  204 +--------------
 tools/perf/util/probe-finder.c         |   29 ++-
 tools/perf/util/quote.c                |  433 +------------------------------
 tools/perf/util/quote.h                |   39 ---
 tools/perf/util/run-command.c          |   90 ------
 tools/perf/util/run-command.h          |   30 --
 tools/perf/util/session.c              |    1 +
 tools/perf/util/sigchain.c             |    2 +-
 tools/perf/util/sigchain.h             |    1 -
 tools/perf/util/strbuf.c               |  229 +----------------
 tools/perf/util/strbuf.h               |   45 ---
 tools/perf/util/util.h                 |  162 -----------
 tools/perf/util/wrapper.c              |  110 --------
 23 files changed, 65 insertions(+), 1976 deletions(-)

