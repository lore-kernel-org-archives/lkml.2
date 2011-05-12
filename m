Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab1ELUcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:32:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40208 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab1ELUcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VYeY8CvS+0Bn1Lh5RneckIQqlQIo76qclMDKb2i8LjcotxjvkAWiQ/96Mu1WTf+uws
         x4KYxOCPZj7WuTLk8HO7luFKTAxihIftaxHwN0mNdKl08p0mp5MKOBhCf3/fu4MVq4Co
         cpQ9BezoLA8ZEY+8HIaIoejfwV8ZWDm4UxZ7I=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Richard Weinberger <richard@nod.at>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Soeren Sandmann Pedersen <ssp@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, x86 <x86@kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [GIT PULL] x86 stacktrace updates
Date: Thu, 12 May 2011 22:32:04 +0200
Message-Id: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/stacktrace branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/stacktrace

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      x86: Make the x86-64 stacktrace code safely callable from scheduler

Richard Weinberger (1):
      x86: Remove warning and warning_symbol from struct stacktrace_ops


 arch/x86/include/asm/stacktrace.h |    3 ---
 arch/x86/kernel/cpu/perf_event.c  |   13 -------------
 arch/x86/kernel/dumpstack.c       |   16 ----------------
 arch/x86/kernel/dumpstack_64.c    |   14 ++++++++++----
 arch/x86/kernel/stacktrace.c      |   13 -------------
 arch/x86/oprofile/backtrace.c     |   13 -------------
 6 files changed, 10 insertions(+), 62 deletions(-)
