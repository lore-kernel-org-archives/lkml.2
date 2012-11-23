Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2KWOVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:21:34 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40646 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2KWOVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:21:31 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/3] cputime: Cleanups on adjusted cputime code
Date: Fri, 23 Nov 2012 15:21:21 +0100
Message-Id: <1353680484-7302-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Not vtime related that time, just a few supplementary cleanups on the part
that computes the adjusted cputime values.

Thanks.

Frederic Weisbecker (3):
  cputime: Move thread_group_cputime() to sched code
  cputime: Rename thread_group_times to thread_group_cputime_adjusted
  cputime: Consolidate cputime adjustment code

 fs/proc/array.c           |    4 +-
 include/linux/sched.h     |   13 +++++--
 kernel/exit.c             |    4 +-
 kernel/fork.c             |    2 +-
 kernel/posix-cpu-timers.c |   24 -------------
 kernel/sched/cputime.c    |   80 ++++++++++++++++++++++++++++++--------------
 kernel/sys.c              |    6 ++--
 7 files changed, 71 insertions(+), 62 deletions(-)

-- 
1.7.5.4

