Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab0FQUko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:40:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:49960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375Ab0FQUkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:40:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Andy Isaacson <adi@hexapodia.org>, Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Chase Douglas <chase.douglas@canonical.com>,
       "David S. Miller" <davem@davemloft.net>,
       Eric B Munson <ebmunson@us.ibm.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Kirill Smelkov <kirr@landau.phys.spbu.ru>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/7] perf/core improvements and fixes for 2.6.36
Date: Thu, 17 Jun 2010 17:39:57 -0300
Message-Id: <1276807204-22512-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Andy Isaacson (2):
  perf debug: fix hex dump partial final line
  perf session: fix error message on failure to open perf.data

Chase Douglas (1):
  perf probe: Add kernel source path option

Eric B Munson (1):
  perf symbols: Function descriptor symbol lookup

Kirill Smelkov (1):
  perf tools: .gitignore += config.make config.make.autogen

Stephane Eranian (2):
  perf record: Avoid synthesizing mmap() for all processes in per-thread mode
  perf record: Add option to avoid updating buildid cache

 tools/perf/.gitignore                    |    2 +
 tools/perf/Documentation/perf-probe.txt  |    4 ++
 tools/perf/Documentation/perf-record.txt |    6 +++
 tools/perf/builtin-probe.c               |    2 +
 tools/perf/builtin-record.c              |    7 +++-
 tools/perf/util/debug.c                  |   10 ++---
 tools/perf/util/header.c                 |   10 +++++-
 tools/perf/util/probe-finder.c           |   58 ++++++++++++++++++++++++++++--
 tools/perf/util/session.c                |    6 ++-
 tools/perf/util/symbol.c                 |   37 +++++++++++++++++--
 tools/perf/util/symbol.h                 |    1 +
 tools/perf/util/util.h                   |    1 +
 12 files changed, 128 insertions(+), 16 deletions(-)

