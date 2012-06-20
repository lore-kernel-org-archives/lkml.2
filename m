Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2FTUwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:52:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52367 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2FTUw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:52:28 -0400
Date: Wed, 20 Jun 2012 13:52:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/serial patches for 3.5-rc4
Message-ID: <20120620205225.GA19105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:

  Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.5-rc4

for you to fetch changes up to 78d80c5a720ea370defa3e3124c0f7f7179bdfe5:

  serial/amba-pl011: move custom pin control to driver (2012-06-12 15:41:44 -0700)

----------------------------------------------------------------
Serial driver fixes for 3.5-rc4

Here are 3 patches resolving a boot regression (the mop500 fix), a build
warning fix, and a kernel-doc fix.  All tiny, but should go into the
final 3.5 release.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Linus Walleij (1):
      serial/amba-pl011: move custom pin control to driver

Randy Dunlap (2):
      serial: fix kernel-doc warnings in 8250.c
      serial: fix serial_txx9.c build warning/typo

 arch/arm/mach-ux500/board-mop500.c |   54 +-----------------------------------
 drivers/tty/serial/8250/8250.c     |    2 +-
 drivers/tty/serial/amba-pl011.c    |   45 +++++++++++++++++++++++++++---
 drivers/tty/serial/serial_txx9.c   |    2 +-
 4 files changed, 44 insertions(+), 59 deletions(-)
