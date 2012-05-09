Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2EIBMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 21:12:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:49765 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab2EIBMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 21:12:21 -0400
Message-ID: <1336525930.1714.3.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 09 May 2012 11:12:10 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a couple of last minute fixes for 3.4 for regressions
introduced by my rewrite of the lazy irq masking code.

Cheers,
Ben.

The following changes since commit 810b4de25e53459323ff48957b0162b48d6cbd57:

  tty/serial/pmac_zilog: Fix "nobody cared" IRQ message (2012-04-30 10:59:58 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to a3512b2dd57cb653bb33645ca9c934436e547e3c:

  powerpc/irq: Make alignment & program interrupt behave the same (2012-05-09 09:42:33 +1000)

----------------------------------------------------------------
Benjamin Herrenschmidt (2):
      powerpc/irq: Fix bug with new lazy IRQ handling code
      powerpc/irq: Make alignment & program interrupt behave the same

 arch/powerpc/include/asm/exception-64s.h |    7 -------
 arch/powerpc/kernel/entry_64.S           |   18 ------------------
 arch/powerpc/kernel/exceptions-64s.S     |    2 +-
 arch/powerpc/kernel/irq.c                |    8 +++++++-
 arch/powerpc/kernel/traps.c              |   10 ++++++++--
 5 files changed, 16 insertions(+), 29 deletions(-)


