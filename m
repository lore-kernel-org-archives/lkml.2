Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0LVWhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:37:34 -0500
Received: from canuck.infradead.org ([134.117.69.58]:36648 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0LVWg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:36:57 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/3] perf/core fixes and improvements
Date: Wed, 22 Dec 2010 20:36:33 -0200
Message-Id: <1293057396-21124-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf symbols: Improve kallsyms symbol end addr calculation
  perf test: Look forward for symbol aliases

Franck Bui-Huu (1):
  perf probe: Fix wrong warning in __show_one_line() if read(1) errors
    happen

 tools/perf/builtin-test.c     |   23 ++++++++++++++---
 tools/perf/util/event.c       |    3 +-
 tools/perf/util/probe-event.c |    2 +-
 tools/perf/util/symbol.c      |   56 ++++++++++++++++++++++++++++++----------
 tools/perf/util/symbol.h      |    2 +-
 5 files changed, 65 insertions(+), 21 deletions(-)

