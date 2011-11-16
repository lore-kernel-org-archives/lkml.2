Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1KPOwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:52:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:39888 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1KPOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:52:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Blanchard <anton@samba.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Wed, 16 Nov 2011 12:51:37 -0200
Message-Id: <1321455099-7110-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf python: Fix undefined symbol problem

David Ahern (1):
  perf session: Fix crash with invalid CPU list

 tools/perf/util/evsel.c   |   10 ++++++++++
 tools/perf/util/hist.c    |   10 ----------
 tools/perf/util/hist.h    |    2 --
 tools/perf/util/session.c |    4 ++++
 4 files changed, 14 insertions(+), 12 deletions(-)

-- 
1.7.8.rc0.35.gee6df

