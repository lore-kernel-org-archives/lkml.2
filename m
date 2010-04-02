Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab0DBQyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab0DBQyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:54:39 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/4] perf-probe bugfixes
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 02 Apr 2010 12:50:31 -0400
Message-ID: <20100402165031.23551.14034.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Before introducing new patches, I'd like to push some bugfixes.
(I'll update previous series and post again.)

Thank you,

---

Masami Hiramatsu (4):
      [BUGFIX][RESEND] perf probe: Fix to close dwarf when failing to analyze it
      [BUGFIX] perf probe: Correct error message for non-structure type
      [BUGFIX] perf probe: Fix not to return non-matched file
      [BUGFIX] perf probe: Fix --line syntax help and document


 tools/perf/Documentation/perf-probe.txt |    2 +-
 tools/perf/builtin-probe.c              |    2 +-
 tools/perf/util/probe-finder.c          |   20 ++++++++++++++------
 3 files changed, 16 insertions(+), 8 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
