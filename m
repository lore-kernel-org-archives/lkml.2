Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161265Ab2KNQ1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:27:06 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39817 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161162Ab2KNQ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:27:04 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 0/4] cputime: Even more cleanups
Date: Wed, 14 Nov 2012 17:26:49 +0100
Message-Id: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While working on full dynticks, I realized some more cleanups needed to be
done. Here is it. If no comment arise, I'll send a pull request to Ingo
in a week.

Thanks.

Frederic Weisbecker (4):
  vtime: Remove the underscore prefix invasion
  vtime: Explicitly account pending user time on process tick
  vtime: Consolidate a bit the ctx switch code
  vtime: No need to disable irqs on vtime_account()

 arch/ia64/include/asm/cputime.h    |    2 ++
 arch/ia64/kernel/time.c            |   24 ++++--------------------
 arch/powerpc/include/asm/cputime.h |    2 ++
 arch/powerpc/kernel/time.c         |   22 ++++++++--------------
 arch/s390/include/asm/cputime.h    |    1 +
 arch/s390/kernel/vtime.c           |   11 ++++++++---
 include/linux/kernel_stat.h        |    8 ++++++++
 include/linux/kvm_host.h           |    4 ++--
 include/linux/vtime.h              |    9 +++++----
 kernel/sched/cputime.c             |   31 +++++++++++++++++++------------
 10 files changed, 59 insertions(+), 55 deletions(-)

-- 
1.7.5.4

