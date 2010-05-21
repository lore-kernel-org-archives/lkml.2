Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0EUBJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:09:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab0EUBIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:08:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Russ Anderson <rja@sgi.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL v2 0/2] Allow disabling TUI per command in ~/.perfconfig
Date: Thu, 20 May 2010 22:08:39 -0300
Message-Id: <1274404121-6115-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	I noticed some problems in the previous TUI disabling patch, fixed
in this v2 series, that also includes a removal of some gettimeofday calls of
little utility submitted by Russ.

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

- Arnaldo


Arnaldo Carvalho de Melo (1):
  perf tui: Allow disabling the TUI on a per command basis in ~/.perfconfig

Russ Anderson (1):
  perf record: remove unneeded gettimeofday() call

 tools/perf/builtin-record.c |   17 +----------------
 tools/perf/builtin-report.c |    8 ++++----
 tools/perf/perf.c           |   25 +++++++++++++++++++++++--
 tools/perf/util/cache.h     |    2 +-
 tools/perf/util/newt.c      |    9 ++++++---
 5 files changed, 35 insertions(+), 26 deletions(-)

