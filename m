Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1EVBp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 21:45:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45810 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1EVBpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 21:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xz1eMcu6CfoKuv5YemBgrhUvqq1v1VWLQYWX60fqnsWNALTSw3bY2UBMBNXwdQujUe
         Km2I6ufPKXBnomhklyVBQxj+fjOISLq7RhLBtcw4S/gwjjAgeV/ccwK+fqB1Wq5JdR6U
         kf1h6o+/dhVK8TyDrF0DO+BDA7kt84ZcxIMCQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] perf tools updates
Date: Sun, 22 May 2011 03:45:38 +0200
Message-Id: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Arnaldo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      perf tools: Check we are able to read the event size on mmap
      perf tools: Remove junk code in mmap size handling
      perf tools: Move evlist sample helpers to evlist area
      perf tools: Pre-check sample size before parsing
      perf tools: Robustify dynamic sample content fetch
      perf tools: Propagate event parse error handling


 tools/perf/builtin-test.c |    9 ++++++++-
 tools/perf/builtin-top.c  |    7 ++++++-
 tools/perf/util/event.c   |   16 ++++++++++++++++
 tools/perf/util/event.h   |   12 +++++++++++-
 tools/perf/util/evlist.c  |   31 +++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h  |    3 +++
 tools/perf/util/evsel.c   |   32 +++++++++++++++++++++++++++++++-
 tools/perf/util/header.c  |   31 -------------------------------
 tools/perf/util/header.h  |    2 --
 tools/perf/util/python.c  |   13 ++++++++++---
 tools/perf/util/session.c |   25 ++++++++++++++++++-------
 tools/perf/util/session.h |    2 ++
 12 files changed, 136 insertions(+), 47 deletions(-)
