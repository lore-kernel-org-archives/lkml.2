Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0E2Nxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:53:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0E2Nxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:53:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Konstantin Stepanyuk <kostyas@cqg.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sam Ravnborg <sam@ravnborg.org>, Stephane Eranian <eranian@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/3] perf fix and simple improvements
Date: Sat, 29 May 2010 10:53:17 -0300
Message-Id: <1275141200-25374-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	I moved the 'perf-dist' one to a separate branch and will resend after
reworking it as showcased by Sam.

Regards,

- Arnaldo

Konstantin Stepanyuk (1):
  perf hist: fix objdump output parsing

Stephane Eranian (2):
  perf report: Make -D print sampled CPU
  perf tools: Add the ability to specify list of cpus to monitor

 tools/perf/Documentation/perf-record.txt |    7 ++++
 tools/perf/Documentation/perf-stat.txt   |    7 ++++
 tools/perf/Documentation/perf-top.txt    |    8 +++--
 tools/perf/builtin-record.c              |   23 +++++++-----
 tools/perf/builtin-report.c              |    5 ++-
 tools/perf/builtin-stat.c                |   14 +++++--
 tools/perf/builtin-top.c                 |   16 +++++---
 tools/perf/util/cpumap.c                 |   57 +++++++++++++++++++++++++++++-
 tools/perf/util/cpumap.h                 |    2 +-
 tools/perf/util/event.c                  |    3 +-
 tools/perf/util/hist.c                   |    2 +-
 11 files changed, 116 insertions(+), 28 deletions(-)

