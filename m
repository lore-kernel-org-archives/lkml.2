Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1GJKls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:41:48 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56929 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1GJKlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:41:46 -0400
X-AuditID: b753bd60-a3c7dba0000050a4-50-4e1981e73475
X-AuditID: b753bd60-a3c7dba0000050a4-50-4e1981e73475
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  0/5]perf probe bugfixes
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Sun, 10 Jul 2011 19:00:05 +0900
Message-ID: <20110710100005.2550.83138.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are several bugfixes of "perf probe" which I've found
recently. I think these should go into perf/urgent branch
for safe.

Thank you,

---

Masami Hiramatsu (5):
      [BUGFIX] perf probe: Warn when more than one line are given
      [BUGFIX] perf probe: Fix the order of searching scopes for variables
      [BUGFIX] perf probe: Fix to walk all inline instances
      [BUGFIX] perf probe: Fix line walker to check CU correctly
      [BUGFIX] perf-probe: Fix a memory leak for scopes array


 tools/perf/builtin-probe.c     |   14 +++++++++++---
 tools/perf/util/probe-finder.c |   36 +++++++++++++++++++++---------------
 2 files changed, 32 insertions(+), 18 deletions(-)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

