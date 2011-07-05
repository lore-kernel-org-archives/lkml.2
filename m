Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1GEQEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:04:37 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52178 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab1GEQEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:04:36 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Zankel <chris@zankel.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] sched/preempt fixes
Date: Tue,  5 Jul 2011 18:04:25 +0200
Message-Id: <1309881868-9483-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the sched/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	sched/core

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      m32r: Use generic PREEMPT config
      h8300: Use generic config PREEMPT definition
      xtensa: Use generic config PREEMPT definition


 arch/h8300/Kconfig.cpu |    4 +---
 arch/m32r/Kconfig      |   12 +-----------
 arch/xtensa/Kconfig    |   13 +------------
 3 files changed, 3 insertions(+), 26 deletions(-)
