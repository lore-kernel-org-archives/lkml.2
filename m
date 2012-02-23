Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2BWE6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 23:58:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:52179 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab2BWE6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 23:58:12 -0500
Message-ID: <1329973080.20389.23.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 23 Feb 2012 15:58:00 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few more powerpc bits for you. A stupid regression I
introduced with my previous commit to "fix" program check exceptions
(brown paper bag for me), fix the cpuidle default, a bug fix for
something that isn't strictly speaking a regression but some
upstream changes causes it to show in lockdep now while it didn't
before, and finally a trivial one for rusty to make his life
easier later on removing the old cpumask cruft.

Cheers,
Ben.

The following changes since commit 27e74da9800289e69ba907777df1e2085231eff7:

  i387: export 'fpu_owner_task' per-cpu variable (2012-02-20 19:34:10 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 18b246fa60dd4bfc71c78d669e2ffaa5df454d6a:

  powerpc: Fix various issues with return to userspace (2012-02-22 16:48:53 +1100)

----------------------------------------------------------------
Benjamin Herrenschmidt (2):
      cpuidle: Default y on powerpc pSeries
      powerpc: Fix various issues with return to userspace

Michael Ellerman (1):
      powerpc: Fix program check handling when lockdep is enabled

Rusty Russell (1):
      powerpc: Remove references to cpu_*_map

 arch/powerpc/kernel/entry_32.S       |    2 +-
 arch/powerpc/kernel/entry_64.S       |    6 +++++-
 arch/powerpc/kernel/exceptions-64s.S |    2 +-
 arch/powerpc/kernel/signal.c         |   12 ++++++++----
 arch/powerpc/kernel/signal.h         |    2 +-
 arch/powerpc/platforms/wsp/smp.c     |    2 +-
 drivers/cpuidle/Kconfig              |    2 +-
 7 files changed, 18 insertions(+), 10 deletions(-)


