Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0JUKLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:11:30 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41873 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab0JUKL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:11:28 -0400
X-AuditID: b753bd60-a6b32ba000000226-ed-4cc011cdce1d
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  0/7] Perf probe update (--vars/--module)
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Date: Thu, 21 Oct 2010 19:12:43 +0900
Message-ID: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series fixes several variable-access problems, a style issue 
and adds two features; showing available variables and
module probing support. :)

Thank you,

---

Masami Hiramatsu (7):
      perf probe: Add basic module support
      perf probe: Show accessible global variables
      perf probe: Function style fix
      perf probe: Show accessible local variables
      perf probe: Support global variables
      [BUGFIX] perf probe: Fix local variable searching loop
      [BUGFIX] perf probe: Fix type searching


 tools/perf/Documentation/perf-probe.txt |   18 +
 tools/perf/builtin-probe.c              |   78 +++-
 tools/perf/util/map.h                   |   10 
 tools/perf/util/probe-event.c           |  189 +++++++--
 tools/perf/util/probe-event.h           |   16 +
 tools/perf/util/probe-finder.c          |  644 +++++++++++++++++++++++++------
 tools/perf/util/probe-finder.h          |   31 +
 7 files changed, 793 insertions(+), 193 deletions(-)

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

