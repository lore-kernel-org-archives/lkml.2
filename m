Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1BPWzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:55:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1BPWzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:55:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        2nddept-manager@sdl.hitachi.co.jp, Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/6] perf/core improvements and fixes
Date: Wed, 16 Feb 2011 20:54:41 -0200
Message-Id: <1297896887-9983-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (3):
  perf ui: Serialize screen updates
  perf annotate: Check if offset is less than symbol size
  perf annotate browser: Use the percent color for the whole line

Jesse Brandeburg (1):
  perf tools: Update Makefile with some help

Masami Hiramatsu (2):
  perf probe: Support function@filename syntax for --line
  perf probe: Show filename which contains target function

 tools/perf/Documentation/Makefile       |   19 ++++++++++---------
 tools/perf/Documentation/perf-probe.txt |    7 ++++---
 tools/perf/Makefile                     |   31 +++++++++++++++++++++++++++++++
 tools/perf/util/annotate.c              |    3 ++-
 tools/perf/util/probe-event.c           |   17 +++++++++++++----
 tools/perf/util/ui/browser.c            |    7 +++++++
 tools/perf/util/ui/browsers/annotate.c  |    5 +++--
 tools/perf/util/ui/helpline.c           |    5 ++++-
 tools/perf/util/ui/setup.c              |    3 +++
 tools/perf/util/ui/ui.h                 |    8 ++++++++
 10 files changed, 85 insertions(+), 20 deletions(-)
 create mode 100644 tools/perf/util/ui/ui.h

