Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab1I2WyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:54:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:44112 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab1I2WyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:54:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/1] perf/urgent fix
Date: Thu, 29 Sep 2011 19:53:46 -0300
Message-Id: <1317336827-19810-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/urgent

	This is on top of the request I sent to Linus, that was basically
grafted from v3.1-rc7. Perhaps you may want to first merge Linus and then
this, up to ya.

Regards,

- Arnaldo


Jiri Olsa (1):
  perf tools: Fix raw sample reading

 tools/perf/util/evsel.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

