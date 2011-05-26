Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab1EZSGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:06:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:56663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab1EZSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:06:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Dave Jones <davej@redhat.com>, David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Kees Cook <kees.cook@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Thu, 26 May 2011 15:05:32 -0300
Message-Id: <1306433134-31869-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf symbols: Handle /proc/sys/kernel/kptr_restrict
  perf tools: Fix build on older systems

 tools/perf/Makefile                   |    2 +
 tools/perf/builtin-record.c           |   13 +++++++++
 tools/perf/builtin-report.c           |   26 ++++++++++++++++++
 tools/perf/util/event.c               |   15 ++++++++--
 tools/perf/util/header.c              |    8 ++++-
 tools/perf/util/include/linux/const.h |    1 +
 tools/perf/util/symbol.c              |   48 +++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h              |    3 +-
 8 files changed, 110 insertions(+), 6 deletions(-)
 create mode 100644 tools/perf/util/include/linux/const.h

