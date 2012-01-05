Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2AERJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:09:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60213 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab2AERJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:09:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/3] perf/core cleanups and fixes
Date: Thu,  5 Jan 2012 15:08:59 -0200
Message-Id: <1325783342-20273-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
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

Arnaldo Carvalho de Melo (3):
  perf hists: Rename total_session to total_period
  perf hists: Stop using 'self' for struct hist_entry
  perf top: Don't update total_period on process_sample

 tools/perf/builtin-top.c |    1 -
 tools/perf/util/hist.c   |   97 +++++++++++++++++++++++----------------------
 tools/perf/util/hist.h   |    7 +--
 3 files changed, 52 insertions(+), 53 deletions(-)

-- 
1.7.8.rc0.35.gee6df

