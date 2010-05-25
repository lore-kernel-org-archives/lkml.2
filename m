Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0EYNpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:45:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46979 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0EYNpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=DD5ILmMeJZnauqqNlr/kdqCxMIF+2z+5kfP9AhRNX1AdfWZwQ8aIRQjOSNuvSk8P2W
         dw57f5xnWZ7cv0IdCqljmIkpETh0QmrTu0VWr57VeqPDCvDq+No//xpkmDh9TXj57NKQ
         qRrTPrL1e1jMAKm4opeW/7fqVHKYwfHo4ONyM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL] perf updates
Date: Tue, 25 May 2010 15:45:06 +0200
Message-Id: <1274795108-24496-1-git-send-regression-fweisbec@gmail.com>
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

Frederic Weisbecker (2):
      x86: Unify dumpstack.h and stacktrace.h
      perf: Drop the skip argument from perf_arch_fetch_regs_caller


 arch/powerpc/include/asm/perf_event.h |   12 +++++++
 arch/powerpc/kernel/misc.S            |   26 ---------------
 arch/sparc/include/asm/perf_event.h   |    8 +++++
 arch/sparc/kernel/helpers.S           |    6 ++--
 arch/x86/include/asm/perf_event.h     |   13 +++++++
 arch/x86/include/asm/stacktrace.h     |   49 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.c      |   18 ----------
 arch/x86/kernel/dumpstack.c           |    1 -
 arch/x86/kernel/dumpstack.h           |   56 ---------------------------------
 arch/x86/kernel/dumpstack_32.c        |    2 -
 arch/x86/kernel/dumpstack_64.c        |    1 -
 arch/x86/kernel/stacktrace.c          |    7 ++--
 include/linux/perf_event.h            |   32 ++++--------------
 include/trace/ftrace.h                |    2 +-
 kernel/perf_event.c                   |    5 ---
 kernel/trace/trace_event_perf.c       |    2 -
 16 files changed, 97 insertions(+), 143 deletions(-)
