Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2KRJsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 04:48:10 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:35773 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2KRJsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 04:48:07 -0500
Date: Sun, 18 Nov 2012 10:47:59 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.7 (take 3)
Message-ID: <alpine.DEB.2.00.1211181044490.29846@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:
  Linus Torvalds (1):
        Linux 3.7-rc6

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Andreas Schwab (1):
      m68k: fix sigset_t accessor functions

 arch/m68k/include/asm/signal.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

This is a bug fix for asm constraints that affect sending RT signals, also
destined for -stable.

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
