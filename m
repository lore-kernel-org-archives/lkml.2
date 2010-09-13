Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0IMSym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:54:42 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:53273 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab0IMSyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:54:40 -0400
Date: Mon, 13 Sep 2010 20:54:36 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 2.6.36
Message-ID: <alpine.DEB.2.00.1009132053060.22518@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 49553c2ef88749dd502687f4eb9c258bb10a4f44:
  Linus Torvalds (1):
        Linux 2.6.36-rc4

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (1):
      m68k,m68knommu: Wire up fanotify_init, fanotify_mark, and prlimit64

 arch/m68k/include/asm/unistd.h       |    5 ++++-
 arch/m68k/kernel/entry.S             |    3 +++
 arch/m68knommu/kernel/syscalltable.S |    3 +++
 3 files changed, 10 insertions(+), 1 deletions(-)

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
