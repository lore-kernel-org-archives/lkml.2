Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0ESTuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:50:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44761
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549Ab0ESTuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:50:12 -0400
Date: Wed, 19 May 2010 12:50:21 -0700 (PDT)
Message-Id: <20100519.125021.51256632.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a few small things, and explicitly set ARCH_SLAB_MINALIGN like we
always should have.

Please pull, thanks!

The following changes since commit 024a6b95181f2df6090975c8a293499d24bf8b28:
  Linus Torvalds (1):
        Merge branch 'davinci-for-linus' of git://git.kernel.org/.../khilman/linux-davinci

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (3):
      sparc64: Show stack backtrace from show_regs() just like other platforms.
      sparc64: Fix stack dumping and tracing when function graph is enabled.
      sparc: Define ARCH_SLAB_MINALIGN

Jan Blunck (1):
      drivers/sbus/char/flash.c: flash_read should update ppos instead of file->f_pos

 arch/sparc/include/asm/cache.h |    2 ++
 arch/sparc/kernel/perf_event.c |   14 ++++++++++++++
 arch/sparc/kernel/process_64.c |    1 +
 arch/sparc/kernel/stacktrace.c |   23 ++++++++++++++++++++++-
 arch/sparc/kernel/traps_64.c   |   14 ++++++++++++++
 drivers/sbus/char/flash.c      |    6 +++---
 6 files changed, 56 insertions(+), 4 deletions(-)
