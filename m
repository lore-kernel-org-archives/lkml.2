Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0JVB5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:57:35 -0400
Received: from canuck.infradead.org ([134.117.69.58]:55635 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0JVB5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:57:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL 0/7] perf probe fixes and improvements
Date: Thu, 21 Oct 2010 23:56:57 -0200
Message-Id: <1287712624-27540-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Masami Hiramatsu (7):
  perf probe: Fix type searching
  perf probe: Fix local variable searching loop
  perf probe: Support global variables
  perf probe: Show accessible local variables
  perf probe: Function style fix
  perf probe: Show accessible global variables
  perf probe: Add basic module support

 tools/perf/Documentation/perf-probe.txt |   18 +-
 tools/perf/builtin-probe.c              |   78 ++++-
 tools/perf/util/map.h                   |   10 +
 tools/perf/util/probe-event.c           |  189 +++++++--
 tools/perf/util/probe-event.h           |   16 +-
 tools/perf/util/probe-finder.c          |  644 ++++++++++++++++++++++++-------
 tools/perf/util/probe-finder.h          |   31 ++-
 7 files changed, 793 insertions(+), 193 deletions(-)

