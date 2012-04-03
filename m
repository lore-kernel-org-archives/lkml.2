Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2DCRGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:06:16 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:60370 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab2DCRGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:06:14 -0400
Date: Tue, 3 Apr 2012 19:06:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: [git pull] m68k updates for 3.4-rc2
Message-ID: <alpine.DEB.2.00.1204031857530.27288@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

Here are a few fixes for the m68k architecture. Nothing fancy this time, just
a build fix for the asm/system.h disintegration, and two fixes for missing
platform checks (one got in during last merge window), which can cause crashes
in multi-platform kernels.

Thanks for pulling!

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:
  Linus Torvalds (1):
        Linux 3.4-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (2):
      m68k/mac: Add missing platform check before registering platform devices
      m68k/q40: Add missing platform check before registering platform devices

Greg Ungerer (1):
      m68k: include asm/cmpxchg.h in our m68k atomic.h

 arch/m68k/include/asm/atomic.h |    1 +
 arch/m68k/mac/config.c         |    3 +++
 arch/m68k/q40/config.c         |    3 +++
 3 files changed, 7 insertions(+), 0 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
