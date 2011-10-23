Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab1JWTMp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:12:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:45177 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1JWTMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:12:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Blanchard <anton@samba.org>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Neil Horman <nhorman@tuxdriver.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/4] perf/core fixes and improvements
Date: Sun, 23 Oct 2011 17:12:19 -0200
Message-Id: <1319397143-20301-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf ui browser: Use libslang to read keys
  perf hists browser: Refuse 'a' hotkey on non symbolic views

Jiri Olsa (1):
  perf tools: Fix tracing info recording

Ricardo Ribalda Delgado (1):
  perf symbols: Increase symbol KSYM_NAME_LEN size

 tools/perf/Makefile                    |    1 +
 tools/perf/builtin-annotate.c          |    8 +-
 tools/perf/util/header.c               |   27 +++++++-
 tools/perf/util/hist.h                 |    9 +--
 tools/perf/util/symbol.c               |    2 +-
 tools/perf/util/trace-event-info.c     |  112 +++++++++++++++++++++++++-------
 tools/perf/util/trace-event.h          |   13 ++++-
 tools/perf/util/ui/browser.c           |   79 +++++++++++++++-------
 tools/perf/util/ui/browsers/annotate.c |   19 ++---
 tools/perf/util/ui/browsers/hists.c    |   40 +++++++-----
 tools/perf/util/ui/keysyms.h           |   25 +++++++
 tools/perf/util/ui/libslang.h          |    2 +
 tools/perf/util/ui/setup.c             |   13 ++++
 13 files changed, 256 insertions(+), 94 deletions(-)
 create mode 100644 tools/perf/util/ui/keysyms.h

