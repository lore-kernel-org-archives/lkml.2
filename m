Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab0LQNQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:16:40 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47257 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0LQNQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:16:39 -0500
X-AuditID: b753bd60-a30f9ba000000f8d-60-4d0b62b4ff3c
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  0/4][BUGFIX] Perf probe bugfixes
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Date: Fri, 17 Dec 2010 22:11:49 +0900
Message-ID: <20101217131149.24123.96128.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series fixes several bugs and cleanup messages
(reported by Arnaldo) on perf-tools.

Thank you,

---

Masami Hiramatsu (4):
      [BUGFIX]perf probe: Fix to support libdwfl older than 0.148
      [CLEANUP]perf probe: cleanup messages
      [BUGFIX]perf: Fix strlist__parse_list to handle const string
      [BUGFIX]perf: Fix lazy wildcard matching


 tools/perf/util/probe-event.c  |   30 +++++----
 tools/perf/util/probe-finder.c |  127 ++++++++++++++++++++++++----------------
 tools/perf/util/string.c       |    2 -
 tools/perf/util/strlist.c      |   14 +++-
 4 files changed, 104 insertions(+), 69 deletions(-)

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

