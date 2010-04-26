Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab0DZTGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:06:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:40825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0DZTGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:06:51 -0400
Date: Mon, 26 Apr 2010 16:06:34 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] perf probe fixes
Message-ID: <20100426190634.GB28700@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

- Arnaldo

Masami Hiramatsu (4):
  perf tools: Initialize dso->node member in dso__new
  perf probe: Fix to use symtab only if no debuginfo
  perf probe: Fix to exit callback soon after finding too many probe
    points
  perf probe: Add --max-probes option

Stefan Hajnoczi (1):
  perf tools: Fix libdw-dev package name in error message

 tools/perf/Documentation/perf-probe.txt |    3 ++
 tools/perf/Makefile                     |    2 +-
 tools/perf/builtin-probe.c              |    9 +++++++-
 tools/perf/util/probe-event.c           |   34 +++++++++++++++++-------------
 tools/perf/util/probe-event.h           |    4 +-
 tools/perf/util/probe-finder.c          |   15 +++++++++----
 tools/perf/util/probe-finder.h          |    6 +++-
 tools/perf/util/symbol.c                |    1 +
 8 files changed, 48 insertions(+), 26 deletions(-)


