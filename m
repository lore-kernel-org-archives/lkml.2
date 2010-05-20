Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0ETJoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:44:22 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33374 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab0ETJoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=VlkreNDpw/UE3kq8P1cGpBsQC3OO8ZoTZwXOsV9WlEveWLAdyYeypeXO5hxCSIdwcT
         bg9GjaHUsXa0GFmSm+mS6UQb3B6s1clJAu/6zGdzB1cPjLEW/oBDUqu84JdDsV7v+wUX
         37BnUQLwGFcC6bKFOwA8M3J9XnYh9y8qcdncc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf fixes
Date: Thu, 20 May 2010 11:44:16 +0200
Message-Id: <1274348659-15417-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      perf: Comply with new rcu checks API
      perf: Fix unaligned accesses while fetching trace values

Tom Zanussi (1):
      perf: Use read() instead of lseek() in trace_event_read.c:skip()


 kernel/perf_event.c                |   58 ++++++++++++++++++++++++++++-------
 tools/perf/util/trace-event-read.c |   19 ++++++++----
 tools/perf/util/trace-event.h      |    7 ++++-
 3 files changed, 65 insertions(+), 19 deletions(-)
