Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0EXBb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:31:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab0EXBbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:31:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/2] perf annotate fix and report improvoment
Date: Sun, 23 May 2010 22:31:09 -0300
Message-Id: <1274664671-27385-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
LKML-Reference: <new-submission>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf report: Support multiple events on the TUI
  perf annotate: Fix up usage of the build id cache

 tools/perf/builtin-report.c |   60 +++++++++++++++++++++--------------
 tools/perf/util/hist.c      |   13 ++++++-
 tools/perf/util/hist.h      |   14 +++++++-
 tools/perf/util/newt.c      |   74 ++++++++++++++++++++++++++++++++++--------
 4 files changed, 119 insertions(+), 42 deletions(-)

