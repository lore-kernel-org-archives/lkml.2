Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab2JQFF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:05:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36369 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab2JQFFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:05:25 -0400
Date: Wed, 17 Oct 2012 01:05:24 -0400 (EDT)
Message-Id: <20121017.010524.778858011941892565.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two sparc64 perf bug fixes and add a sysrq facility so I can diagnose
these kinds of problems more quickly in the future.

Please pull, thanks a lot.

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to e793d8c6740f8fe704fa216e95685f4d92c4c4b9:

  sparc64: Fix bit twiddling in sparc_pmu_enable_event(). (2012-10-16 13:05:25 -0700)

----------------------------------------------------------------
David S. Miller (3):
      sparc64: Like x86 we should check current->mm during perf backtrace generation.
      sparc64: Add global PMU register dumping via sysrq.
      sparc64: Fix bit twiddling in sparc_pmu_enable_event().

 Documentation/sysrq.txt         |   1 +
 arch/sparc/include/asm/ptrace.h |  13 +++++++-
 arch/sparc/include/asm/smp_64.h |   2 ++
 arch/sparc/kernel/perf_event.c  |  15 +++++----
 arch/sparc/kernel/process_64.c  | 120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++------------
 arch/sparc/kernel/smp_64.c      |  11 +++++++
 arch/sparc/mm/ultra.S           |  64 ++++++++++++++++++++++++++++++++++--
 drivers/tty/sysrq.c             |   1 +
 8 files changed, 198 insertions(+), 29 deletions(-)
