Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab1LGTjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:39:11 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:43241 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab1LGTjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:39:09 -0500
Date: Wed, 7 Dec 2011 20:39:05 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.2
Message-ID: <alpine.DEB.2.00.1112072037330.13769@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following change since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:
  Linus Torvalds (1):
        Linux 3.2-rc4

is available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (1):
      m68k: Wire up process_vm_{read,write}v

 arch/m68k/include/asm/unistd.h  |    4 +++-
 arch/m68k/kernel/syscalltable.S |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
