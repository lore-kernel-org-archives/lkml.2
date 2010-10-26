Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0JZA3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:29:30 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33992 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0JZA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:29:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/5] perf python script improvements
Date: Mon, 25 Oct 2010 22:29:12 -0200
Message-Id: <1288052957-14087-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	Tested on RHEL6 Beta x86_64, Fedora 11 x86_64 and Fedora 13 i386.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (5):
  perf python scripting: Improve the failed-syscalls-by-pid script
  perf python scripting: Improve the syscalls-counts script
  perf python scripting: print the syscall name on sctop
  perf python scripting: Improve the syscalls-by-pid script
  perf python scripting: Support fedora 11 (audit 1.7.17)

 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |   40 ++++++++++++++++++++
 .../perf/scripts/python/failed-syscalls-by-pid.py  |   21 ++++++----
 tools/perf/scripts/python/sctop.py                 |    7 +--
 tools/perf/scripts/python/syscall-counts-by-pid.py |   21 ++++++----
 tools/perf/scripts/python/syscall-counts.py        |    5 +-
 5 files changed, 71 insertions(+), 23 deletions(-)
