Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab0FXVkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:40:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0FXVkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=inPXfHlcORELcJjCI/noVuTo5oZFsxC7xBrgtfnjsy+RnhTbLZ9rtqONA6n67hMZMH
         YGR+MxASvsu80pfz4v0AtESNuAfO4sOIAr3/O+IUzMtHSoWqQPzKq/ww3G6sCkM4J8lv
         9o/k953yZHJvCgIEhoOT/G4sd/e9ShAgESHdM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf events and breakpoints updates
Date: Thu, 24 Jun 2010 23:40:51 +0200
Message-Id: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      hw_breakpoints: Fix per task breakpoint tracking
      x86: Set resume bit before returning from breakpoint exception
      x86: Support for instruction breakpoints
      perf: Don't use 4 bytes as a default instruction breakpoint length
      perf: Don't print traces when debugging ordering
      perf: Report lost events in perf trace debug mode

Nobuhiro Iwamatsu (1):
      perf: Fix argument of perf_arch_fetch_caller_regs


 arch/x86/include/asm/hw_breakpoint.h |    2 +-
 arch/x86/kernel/hw_breakpoint.c      |   51 ++++++++++++++++-------
 include/linux/perf_event.h           |    8 ++-
 kernel/hw_breakpoint.c               |   78 ++++++++++++++++++----------------
 tools/perf/builtin-trace.c           |   32 ++++++++++++--
 tools/perf/util/parse-events.c       |   11 ++++-
 6 files changed, 119 insertions(+), 63 deletions(-)
