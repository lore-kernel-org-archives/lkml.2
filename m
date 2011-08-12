Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1HLQ3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:29:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45402 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1HLQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:29:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Avi Kivity <avi@redhat.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        yrl.pp-manager.tt@hitachi.com, acme@ghostprotocols.net
Subject: [GIT PULL 00/12] perf fixes
Date: Fri, 12 Aug 2011 13:28:52 -0300
Message-Id: <1313166544-6209-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf top browser: Remove spurious helpline update

Jiri Olsa (1):
  perf report: Use properly build_id kernel binaries

Masami Hiramatsu (9):
  perf probe: Fix a memory leak for scopes array
  perf probe: Fix line walker to check CU correctly
  perf probe: Fix to search nested inlined functions in CU
  perf probe: Fix to walk all inline instances
  perf probe: Warn when more than one line are given
  perf probe: Fix to search local variables in appropriate scope
  perf probe: Avoid searching variables in intermediate scopes
  perf probe: Search concrete out-of-line instances
  perf probe: Filter out redundant inline-instances

Vasiliy Kulikov (1):
  perf: fix temporary file ownership check

 tools/perf/builtin-probe.c        |   14 ++-
 tools/perf/util/dwarf-aux.c       |  210 +++++++++++++++++++++++++++++++---
 tools/perf/util/dwarf-aux.h       |   11 ++
 tools/perf/util/header.c          |   11 ++-
 tools/perf/util/probe-finder.c    |  231 +++++++++++++++++++++++--------------
 tools/perf/util/probe-finder.h    |    2 +-
 tools/perf/util/symbol.c          |   59 ++++++----
 tools/perf/util/symbol.h          |    1 -
 tools/perf/util/ui/browsers/top.c |    1 -
 9 files changed, 403 insertions(+), 137 deletions(-)

