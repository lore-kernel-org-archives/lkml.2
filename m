Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab0ELHzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 03:55:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:57758 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab0ELHzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 03:55:17 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 17:46:36 +1000
Message-ID: <1273650396.21352.121.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Please pull this perf event fix from Paulus. Without it, using perf event
can potentially oops the machine at any time.

Thanks !

Cheers,
Ben.

The following changes since commit cea0d767c29669bf89f86e4aee46ef462d2ebae8:
  Linus Torvalds (1):
        Merge branch 'hwmon-for-linus' of git://git.kernel.org/.../jdelvare/staging

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Paul Mackerras (1):
      powerpc/perf_event: Fix oops due to perf_event_do_pending call

 arch/powerpc/include/asm/hw_irq.h |   38 -----------------------
 arch/powerpc/kernel/asm-offsets.c |    1 -
 arch/powerpc/kernel/entry_64.S    |    9 -----
 arch/powerpc/kernel/irq.c         |    6 ----
 arch/powerpc/kernel/time.c        |   60 +++++++++++++++++++++++++++++-------
 5 files changed, 48 insertions(+), 66 deletions(-)


