Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab0EMUUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:20:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58362 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905Ab0EMUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:19:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Kirill Smelkov <kirr@mns.spb.ru>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/4] perf tools fixes
Date: Thu, 13 May 2010 17:19:20 -0300
Message-Id: <1273781964-29552-1-git-send-email-acme@infradead.org>
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


Frederic Weisbecker (2):
  perf hist: Fix hists__browse no-newt case
  perf hist: Fix missing getline declaration

Kirill Smelkov (1):
  perf trace scripts: Fix typos in perf-trace-python.txt

Stephane Eranian (1):
  perf tools: change event inheritance logic in stat and record

 tools/perf/Documentation/perf-record.txt       |    4 ++--
 tools/perf/Documentation/perf-stat.txt         |    4 ++--
 tools/perf/Documentation/perf-trace-python.txt |    4 ++--
 tools/perf/builtin-record.c                    |   12 ++++++------
 tools/perf/builtin-stat.c                      |   10 +++++-----
 tools/perf/util/hist.c                         |    1 +
 tools/perf/util/hist.h                         |    2 +-
 7 files changed, 19 insertions(+), 18 deletions(-)

