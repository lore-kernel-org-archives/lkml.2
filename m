Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0ELC3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:29:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:33151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0ELC3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:29:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/2] perf: improve report/annotation integration in newt browser
Date: Tue, 11 May 2010 23:29:30 -0300
Message-Id: <1273631372-8206-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
LKML-Reference: <new-submission>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	Besides these the three on my previous pull request are there as well.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf ui: Add ui_helpline methods
  perf report: Librarize the annotation code and use it in the newt browser

 tools/perf/Makefile           |    5 +
 tools/perf/builtin-annotate.c |  198 +-------------------
 tools/perf/builtin-report.c   |   19 ++-
 tools/perf/util/hist.c        |  184 ++++++++++++++++++
 tools/perf/util/hist.h        |   29 +++
 tools/perf/util/newt.c        |  421 ++++++++++++++++++++++++++++++++++-------
 tools/perf/util/sort.h        |    6 -
 7 files changed, 594 insertions(+), 268 deletions(-)

