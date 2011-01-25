Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1AYRRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:17:11 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:35676 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1AYRRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:17:10 -0500
Date: Tue, 25 Jan 2011 18:17:05 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gregungerer@westnet.com.au>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] More m68k updates for 2.6.38
Message-ID: <alpine.DEB.2.00.1101251814410.18530@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:
  Linus Torvalds (1):
        Linux 2.6.38-rc2

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-Linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

These are two fixes for build errors and one fix for a long-standing debug
issue.

Thanks for pulling!

Geert Uytterhoeven (3):
      m68k: Uninline strchr()
      m68k/atari: Rename "scc" to "atari_scc"
      m68k/amiga: Fix "debug=mem"

 arch/m68k/amiga/config.c        |   16 +++++++---------
 arch/m68k/atari/ataints.c       |    4 ++--
 arch/m68k/atari/config.c        |    2 +-
 arch/m68k/atari/debug.c         |   14 +++++++-------
 arch/m68k/include/asm/atarihw.h |    2 +-
 arch/m68k/include/asm/string.h  |   12 ------------
 6 files changed, 18 insertions(+), 32 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
