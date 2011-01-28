Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1A1RN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:13:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:54636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab1A1RNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:13:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        2nddept-manager@sdl.hitachi.co.jp,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, Han Pingtian <phan@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/4] perf/core improvements and fix
Date: Fri, 28 Jan 2011 15:12:59 -0200
Message-Id: <1296234783-17491-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Han Pingtian (1):
  perf test: Fix return values checking

Masami Hiramatsu (3):
  perf tools: Add strfilter for general purpose string filter
  perf probe: Add variable filter support
  perf probe: Add filters support for available functions

 tools/perf/Documentation/perf-probe.txt |   15 +++
 tools/perf/Makefile                     |    2 +
 tools/perf/builtin-probe.c              |   43 +++++++-
 tools/perf/builtin-test.c               |    6 +-
 tools/perf/util/probe-event.c           |   89 ++++++++------
 tools/perf/util/probe-event.h           |    5 +-
 tools/perf/util/strfilter.c             |  200 +++++++++++++++++++++++++++++++
 tools/perf/util/strfilter.h             |   48 ++++++++
 8 files changed, 366 insertions(+), 42 deletions(-)
 create mode 100644 tools/perf/util/strfilter.c
 create mode 100644 tools/perf/util/strfilter.h

