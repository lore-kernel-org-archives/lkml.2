Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab0EVRp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:45:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:59382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab0EVRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:45:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/3] perf annotate improvements, report fix
Date: Sat, 22 May 2010 14:45:09 -0300
Message-Id: <1274550312-16600-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (3):
  perf report: Don't start the TUI if -D is used
  perf tui: Remove annotate from popup menu after failure
  perf annotate: Add TUI interface

 tools/perf/builtin-annotate.c |   61 ++++++++++++++++++++++++++++++-----------
 tools/perf/util/hist.c        |   13 +++-----
 tools/perf/util/hist.h        |   10 +++++++
 tools/perf/util/newt.c        |   61 ++++++++++++++++++++++++++++-------------
 tools/perf/util/util.h        |   15 +++++++++-
 5 files changed, 116 insertions(+), 44 deletions(-)

