Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab2AaBVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:21:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:44277 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2AaBVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:21:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, David Daney <david.daney@cavium.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Mon, 30 Jan 2012 23:21:16 -0200
Message-Id: <1327972879-29214-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The following changes since commit d0caf292505d051b1026e85faf3a85e907566f31:

  x86/dumpstack: Remove unneeded check in dump_trace() (2012-01-28 13:09:06 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-urgent-for-mingo

for you to fetch changes up to 509605dbe9395ce1abbfac1dba375f074ff57a53:

  perf top: Fix number of samples displayed (2012-01-30 22:29:49 -0200)

----------------------------------------------------------------
Fixes cherry picked from perf/core.

----------------------------------------------------------------
David Daney (1):
      perf tools: Fix broken build by defining _GNU_SOURCE in Makefile

Stephane Eranian (2):
      perf tools: Fix strlen() bug in perf_event__synthesize_event_type()
      perf top: Fix number of samples displayed

 tools/perf/Makefile                 |    7 ++-----
 tools/perf/builtin-probe.c          |    2 --
 tools/perf/builtin-top.c            |   13 ++++++++++---
 tools/perf/util/header.c            |    2 +-
 tools/perf/util/probe-event.c       |    2 --
 tools/perf/util/symbol.c            |    1 -
 tools/perf/util/trace-event-parse.c |    3 +--
 tools/perf/util/ui/browsers/hists.c |    2 --
 tools/perf/util/ui/helpline.c       |    1 -
 tools/perf/util/util.h              |    1 -
 10 files changed, 14 insertions(+), 20 deletions(-)
