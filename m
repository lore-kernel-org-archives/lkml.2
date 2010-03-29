Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0C2S5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:57:46 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:56825 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0C2S5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:57:43 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2010 14:57:42 EDT
Date: Mon, 29 Mar 2010 20:52:37 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 2.6.34
Message-ID: <alpine.DEB.2.00.1003292048530.3832@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

Please pull to receive 2 more m68k updates for 2.6.34:
  - The first one fixes a build problem we started seeing lately,
  - The second one corrects struct sigcontext for ColdFire, as I've
    accidentally merged the wrong version of a patch for the previous
    pull request.

Thanks!

The following changes since commit b72c40949b0f04728f2993a1434598d3bad094ea:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (1):
      m68k: Fix asm constraints for atomic_sub_and_test() and atomic_add_negative()

Maxim Kuvyrkov (1):
      m68k: Fix `struct sigcontext' for ColdFire

 arch/m68k/include/asm/atomic_mm.h  |    8 ++++++--
 arch/m68k/include/asm/sigcontext.h |    4 +---
 2 files changed, 7 insertions(+), 5 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
