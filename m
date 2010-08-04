Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813Ab0HDV0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:26:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41367 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759276Ab0HDV0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:26:18 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Blanchard <anton@samba.org>,
        Dave Martin <dave.martin@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: [GIT PULL 0/3] perf/core fixes and improvements
Date: Wed,  4 Aug 2010 18:26:01 -0300
Message-Id: <1280957164-14274-1-git-send-email-acme@infradead.org>
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

Dave Martin (1):
  perf events: Fix mmap offset determination

Srikar Dronamraju (2):
  perf: expose event__process function
  tracing/kprobes: unregister_trace_probe needs to be called under mutex

 kernel/trace/trace_kprobe.c |    3 +++
 tools/perf/builtin-top.c    |   20 --------------------
 tools/perf/util/event.c     |   28 +++++++++++++++++++++-------
 tools/perf/util/event.h     |    1 +
 4 files changed, 25 insertions(+), 27 deletions(-)

