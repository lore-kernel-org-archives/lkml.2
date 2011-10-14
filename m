Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1JNS2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:28:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55614 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1JNS2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:28:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/5] perf/core improvements and fixes
Date: Fri, 14 Oct 2011 15:27:48 -0300
Message-Id: <1318616873-26739-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

	These are in addition to the ones you reported being problematic
with perf top segfaulting sometimes, that problem should be fixed by the
first patch below.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf hists browser: Invalidate ui_browser->top after timer calls
  perf annotate browser: Exit when pressing ESC or the left arrow
  perf ui browser: Add filter method
  perf annotate browser: Allow toggling the visualization of source code lines

Thomas Jarosch (1):
  perf buildid: Fix possible unterminated readlink() result buffer

 tools/perf/util/header.c               |    2 +-
 tools/perf/util/ui/browser.c           |   52 +++++++++++++++++----
 tools/perf/util/ui/browser.h           |    1 +
 tools/perf/util/ui/browsers/annotate.c |   78 +++++++++++++++++++++++++++++--
 tools/perf/util/ui/browsers/hists.c    |   15 +++++-
 5 files changed, 131 insertions(+), 17 deletions(-)

