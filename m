Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1KSMuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 07:50:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62076 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1KSMug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 07:50:36 -0500
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 0/3] Suggested patches for v3.0.9-rt26
Date: Sat, 19 Nov 2011 13:50:25 +0100
Message-Id: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steve Rostedt and rt-folks

I would also suggest the following three patches for v3.0.9-rt26 in addition
to the ones you already posted.

The two patches from Thomas Gleixner are in v3.2-rc2-rt3
and the patch from Paul McKenney is upstream. (non-rt)

You can pull them from my tree.
git://git.kernel.org:/pub/scm/linux/kernel/git/jkacur/linux-rt.git
branch: v3.0-rt-fixes

Thank You
John Kacur

Paul E. McKenney (1):
  rcu: Drive configuration directly from SMP and PREEMPT

Thomas Gleixner (2):
  rcu-more-fallout.patch
  sysctl-include-fix.patch

 include/linux/sysctl.h |    1 +
 init/Kconfig           |    6 +++---
 kernel/rcutiny.c       |    2 ++
 3 files changed, 6 insertions(+), 3 deletions(-)

-- 
1.7.2.3

