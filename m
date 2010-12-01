Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab0LAB61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:58:27 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50611 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0LAB60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BvJxdqJ/oQoKBqamWeSMMW/7oSarej0DfPRzcOBPEiKml0JxwLrnTRKI32RGjGUK+9
         U/j0rhTH8CyuUDEeRl8bYn1TNBwpwR1coCGybbMBcmy97KtmgHldoHRLUkp/0hnYO4Vm
         dHzFr1re6oil9tXuVAr6/em04A+kjYFTeAf18=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 00/14] perf documentation updates
Date: Tue, 30 Nov 2010 19:57:08 -0600
Message-Id: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While using perf I found that many of the commands had options that were
not documented in their man pages.  The following patches update all of
the man pages to include the missing options each command supports.
Additionally there are a few spelling fixes, and a fix for perf diff
which had two options that used the same flag.

Shawn Bohrer (14):
  perf: Document missing annotate options.
  perf: Document missing buildid-list options.
  perf: fix diff displacement and modules options short flag
  perf: Document missing diff options
  perf: Document missing kvm options
  perf: Document missing lock options
  perf: Fix spelling mistake in probe documentation
  perf: Document missing record options
  perf: Document missing report options
  perf: Document missing sched options
  perf: Document missing stat options
  perf: Fix spelling mistake in test documentation
  perf: Document missing top options
  perf: Document missing trace options

 tools/perf/Documentation/perf-annotate.txt     |   37 +++++++++++++++++-
 tools/perf/Documentation/perf-buildid-list.txt |    3 +
 tools/perf/Documentation/perf-diff.txt         |   19 +++++++++-
 tools/perf/Documentation/perf-kvm.txt          |    8 +++-
 tools/perf/Documentation/perf-lock.txt         |   15 +++++++
 tools/perf/Documentation/perf-probe.txt        |    2 +-
 tools/perf/Documentation/perf-record.txt       |   17 ++++++--
 tools/perf/Documentation/perf-report.txt       |   49 ++++++++++++++++++++++--
 tools/perf/Documentation/perf-sched.txt        |   18 ++++++++-
 tools/perf/Documentation/perf-stat.txt         |   34 +++++++++++++---
 tools/perf/Documentation/perf-test.txt         |    2 +-
 tools/perf/Documentation/perf-top.txt          |   28 ++++++++++++--
 tools/perf/Documentation/perf-trace.txt        |    7 +++
 tools/perf/builtin-diff.c                      |    2 +-
 14 files changed, 214 insertions(+), 27 deletions(-)

-- 
1.7.3.2

