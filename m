Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab0ETQLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:11:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0ETQK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:10:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/2] perf fixes and improvements
Date: Thu, 20 May 2010 13:10:43 -0300
Message-Id: <1274371845-27784-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
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
  perf TUI: Make 'space' be an alias to 'PgDn'
  perf annotate: Use build-ids to find the right DSO

 tools/perf/util/build-id.c  |   22 ++++++++++++++++++++++
 tools/perf/util/build-id.h  |    2 ++
 tools/perf/util/callchain.c |    1 +
 tools/perf/util/callchain.h |    1 -
 tools/perf/util/hist.c      |   34 ++++++++++++++++++++++++++--------
 tools/perf/util/newt.c      |    2 ++
 tools/perf/util/symbol.c    |   12 +++---------
 7 files changed, 56 insertions(+), 18 deletions(-)

