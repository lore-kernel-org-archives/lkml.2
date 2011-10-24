Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1JXT0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:26:37 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:45894 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1JXT0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:26:36 -0400
Date: Mon, 24 Oct 2011 21:26:33 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg Ungerer <gerg@uclinux.org>, Greg Ungerer <gerg@snapgear.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.2
Message-ID: <alpine.DEB.2.00.1110242118500.9114@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

This is my first pull request for the m68k changes for 3.2.

I'd also like to get in the long-overdue conversion of m68k to the generic
hardirq framework, but that's pending on (a) a conflict resolution with the
m68knommu tree, and (b) a run in -next. So for now that's still in my
for-3.3 branch.

The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:
  Linus Torvalds (1):
        Linux 3.1

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  (aka for-3.2)
  git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Finn Thain (2):
      m68k/mac: Fix compiler warning in via_read_time()
      m68k/mac: Fix mac_irq_pending() for PSC MACE and SCC

Jim Rotmalm (1):
      zorro: Fix four checkpatch warnings

Kirill Tkhai (1):
      m68k: Finally remove leftover markers sections

 arch/m68k/kernel/vmlinux.lds_no.S |    1 -
 arch/m68k/mac/macints.c           |    2 +-
 arch/m68k/mac/misc.c              |   40 +++++++++++++++++++++---------------
 drivers/zorro/zorro-driver.c      |    8 +++---
 include/asm-generic/vmlinux.lds.h |    1 -
 5 files changed, 28 insertions(+), 24 deletions(-)

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
