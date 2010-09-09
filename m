Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab0IIRHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:07:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36360 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab0IIRHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:07:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL 0/5] perf/urgent probe fixes
Date: Thu,  9 Sep 2010 14:06:40 -0300
Message-Id: <1284052005-25658-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Masami Hiramatsu (5):
  tracing/kprobe: Fix a memory leak in error case
  perf probe: Fix return probe support
  perf probe: Fix handling of arguments names
  tracing/kprobes: Fix handling of argument names
  tracing/kprobe: Fix handling of C-unlike argument names

 kernel/trace/trace_kprobe.c    |   43 +++++++++++++++++++++++----------------
 tools/perf/util/probe-event.c  |    1 +
 tools/perf/util/probe-finder.c |   42 +++++++++++++++++++++++++++------------
 3 files changed, 55 insertions(+), 31 deletions(-)

