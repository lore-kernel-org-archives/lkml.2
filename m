Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab0KSVau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:30:50 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59412 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab0KSVaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:30:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Matt Fleming <matt@console-pimps.org>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Morell <rmorell@nvidia.com>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/3] perf tools improvements
Date: Fri, 19 Nov 2010 19:29:39 -0200
Message-Id: <1290202186-25352-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf tools: Change my maintainer address

Robert Morell (1):
  perf tools: Remove hardcoded include paths for elfutils

Stephane Eranian (1):
  perf stat: Add no-aggregation mode to -a

 CREDITS                                |    2 -
 MAINTAINERS                            |    2 +-
 tools/perf/Documentation/perf-stat.txt |    5 +
 tools/perf/Makefile                    |    4 +-
 tools/perf/builtin-stat.c              |  169 +++++++++++++++++++++++++++-----
 tools/perf/feature-tests.mak           |    4 +-
 tools/perf/util/probe-finder.h         |    6 +-
 7 files changed, 157 insertions(+), 35 deletions(-)

