Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab1HZPhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:37:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38961 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab1HZPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:37:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Blanchard <anton@samba.org>, David Ahern <dsahern@gmail.com>,
        Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, yrl.pp-manager.tt@hitachi.com,
        arnaldo.melo@gmail.com
Subject: [GIT PULL 0/6] perf/urgent fixes
Date: Fri, 26 Aug 2011 12:37:05 -0300
Message-Id: <1314373031-6687-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent

Regards,

- Arnaldo

Anton Blanchard (4):
  perf symbols: Fix ppc64 SEGV in dso__load_sym with debuginfo files
  perf symbols: /proc/kallsyms does not sort module symbols
  perf symbols: Preserve symbol scope when parsing /proc/kallsyms
  perf symbols: Add some heuristics for choosing the best duplicate symbol

David Ahern (1):
  perf record: Create events initially disabled and enable after init

Masami Hiramatsu (1):
  perf probe: Fix regression of variable finder

 tools/perf/builtin-record.c    |    3 +
 tools/perf/util/evlist.c       |   13 ++++
 tools/perf/util/evlist.h       |    1 +
 tools/perf/util/probe-finder.c |    2 +-
 tools/perf/util/symbol.c       |  129 ++++++++++++++++++++++++++++++++--------
 5 files changed, 123 insertions(+), 25 deletions(-)

