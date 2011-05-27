Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab1E0WbC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 18:31:02 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55591
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478Ab1E0WbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 18:31:00 -0400
X-Greylist: delayed 2706 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 May 2011 18:31:00 EDT
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/5] perf/urgent fixes
Date: Fri, 27 May 2011 18:45:31 -0300
Message-Id: <1306532736-3790-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf tools: Make sure kptr_restrict warnings fit 80 col terms
  perf top: Remove unused macro
  perf top: Handle kptr_restrict
  perf top: Don't stop if no kernel symtab is found

David Ahern (1):
  perf events: initialize fd array to -1 instead of 0

 tools/perf/builtin-record.c |   19 ++++++++-----------
 tools/perf/builtin-report.c |   17 +++++++----------
 tools/perf/builtin-top.c    |   37 ++++++++++++++++++++++++++++++-------
 tools/perf/util/evsel.c     |   10 ++++++++++
 4 files changed, 55 insertions(+), 28 deletions(-)

