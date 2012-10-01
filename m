Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2JATcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:32:32 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:54046 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2JATca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:32:30 -0400
Date: Mon, 1 Oct 2012 21:32:25 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.7
Message-ID: <alpine.DEB.2.00.1210012130130.30878@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:
  Linus Torvalds (1):
        Linux 3.6

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (1):
      m68k/apollo: Remove disabled definitions in apollohw.h

Thomas Meyer (3):
      m68k/amiga: Use PTR_RET rather than if(IS_ERR(...)) + PTR_ERR
      m68k/q40: Use PTR_RET rather than if(IS_ERR(...)) + PTR_ERR
      m68k: Use PTR_RET rather than if(IS_ERR(...)) + PTR_ERR

All pretty boring, seems like all of us had better things to do last summer...

Thanks for pulling!

 arch/m68k/amiga/platform.c       |    5 +----
 arch/m68k/include/asm/apollohw.h |   12 ------------
 arch/m68k/kernel/time.c          |    5 +----
 arch/m68k/q40/config.c           |    5 +----
 4 files changed, 3 insertions(+), 24 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
