Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216Ab0HJVx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:53:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154Ab0HJVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:53:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/4] perf/core improvements
Date: Tue, 10 Aug 2010 18:53:42 -0300
Message-Id: <1281477226-11504-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf ui: Make SPACE work as PGDN in all browsers
  perf annotate: Cycle thru sorted lines with samples
  perf ui browser: Add ui_browser__show counterpart: __hide
  perf ui hist browser: Fixup key bindings

 tools/perf/util/ui/browser.c           |   19 ++++++-
 tools/perf/util/ui/browser.h           |    4 +-
 tools/perf/util/ui/browsers/annotate.c |  101 +++++++++++++++++++++++--------
 tools/perf/util/ui/browsers/hists.c    |   20 ++++---
 tools/perf/util/ui/browsers/map.c      |   10 +--
 tools/perf/util/ui/helpline.c          |    2 +-
 tools/perf/util/ui/helpline.h          |    1 +
 7 files changed, 113 insertions(+), 44 deletions(-)

