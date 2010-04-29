Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab0D3R3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:29:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725Ab0D3R3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:29:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] perf: Initial regression testing command
Date: Thu, 29 Apr 2010 19:14:02 -0300
Message-Id: <1272579244-3981-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

	Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	Now there are 7 patches in that repo.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf symbols: Add machine helper routines
  perf test: Initial regression testing command

 tools/perf/Documentation/perf-test.txt |   22 +++
 tools/perf/Makefile                    |    1 +
 tools/perf/builtin-kmem.c              |    2 +-
 tools/perf/builtin-test.c              |  281 ++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                   |    1 +
 tools/perf/command-list.txt            |    1 +
 tools/perf/perf.c                      |    1 +
 tools/perf/util/map.h                  |   25 +++-
 tools/perf/util/symbol.c               |   77 +++++++---
 tools/perf/util/symbol.h               |    7 +
 10 files changed, 393 insertions(+), 25 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-test.txt
 create mode 100644 tools/perf/builtin-test.c

