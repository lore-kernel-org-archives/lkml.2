Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1JTNGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:06:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53576 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1JTNGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:06:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/4] perf/core improvements and fixes
Date: Thu, 20 Oct 2011 11:05:44 -0200
Message-Id: <1319115948-12060-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf hists browser: Honour symbol_conf.show_{nr_samples,total_period}
  perf hists: Don't decay total_period for filtered entries
  perf hists: Don't consider filtered entries when calculating column widths
  perf hists browser: Elide DSO column when it is set to just one DSO, ditto for threads

 tools/perf/util/hist.c              |   14 ++++++++++----
 tools/perf/util/sort.c              |    4 +++-
 tools/perf/util/ui/browsers/hists.c |   14 ++++++++++++++
 3 files changed, 27 insertions(+), 5 deletions(-)

