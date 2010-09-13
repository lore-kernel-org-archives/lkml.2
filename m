Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0IMQfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:35:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0IMQfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:35:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/1] perf/core ui browser improvement
Date: Mon, 13 Sep 2010 13:34:51 -0300
Message-Id: <1284395692-11298-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	Screenshot showing how it looks like now:

http://vger.kernel.org/~acme/perf/perf-report-tui-no-windows.png

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf ui browser: Don't use windows, slang is enough

 tools/perf/util/ui/browser.c        |   24 +++++++++-----------
 tools/perf/util/ui/browsers/hists.c |   41 ++++++++++++++++------------------
 tools/perf/util/ui/browsers/map.c   |    9 +++----
 3 files changed, 34 insertions(+), 40 deletions(-)
