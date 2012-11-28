Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab2K1Rw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:52:27 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57921 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab2K1Rw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:52:26 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/4] cputime: Cleanups on adjusted cputime code v2
Date: Wed, 28 Nov 2012 18:52:16 +0100
Message-Id: <1354125140-9294-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v1 address Steven Rostedt and Paul Gortmaker reviews:

- More comments to distinguish struct cputime / struct task_cputime [3/4]
- Comment the reasons and the details for cputime adjustment [4/4]

Thanks.

Frederic Weisbecker (4):
  cputime: Move thread_group_cputime() to sched code
  cputime: Rename thread_group_times to thread_group_cputime_adjusted
  cputime: Consolidate cputime adjustment code
  cputime: Comment cputime's adjusting code

 fs/proc/array.c           |    4 +-
 include/linux/sched.h     |   27 ++++++++++---
 kernel/exit.c             |    4 +-
 kernel/fork.c             |    2 +-
 kernel/posix-cpu-timers.c |   24 -----------
 kernel/sched/cputime.c    |   98 ++++++++++++++++++++++++++++++++-------------
 kernel/sys.c              |    6 +-
 7 files changed, 99 insertions(+), 66 deletions(-)

-- 
1.7.5.4

