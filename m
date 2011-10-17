Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab1JQNya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:54:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:57512 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1JQNy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:54:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/3] perf/core fixes
Date: Mon, 17 Oct 2011 11:54:16 -0200
Message-Id: <1318859659-1171-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf top: Honour --hide_{user,kernel}_symbols and the 'U' hotkey
  perf top: Fix the 'E' hotkey, select among multiple events

Mike Galbraith (1):
  perf hists browser: Add missing stdarg.h include

 tools/perf/builtin-top.c      |    9 +++++++--
 tools/perf/util/hist.c        |   17 +++++++++++------
 tools/perf/util/hist.h        |    5 +++--
 tools/perf/util/ui/helpline.h |    1 +
 4 files changed, 22 insertions(+), 10 deletions(-)

