Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2FTUxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:53:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62756 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2FTUxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:53:32 -0400
Date: Wed, 20 Jun 2012 13:53:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] misc fixes patches for 3.5-rc4
Message-ID: <20120620205328.GA19170@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.5-rc4

for you to fetch changes up to 49fbd3f1c3a67b99c053600a1cd7e5d0be48bed6:

  misc: mei: set WDIOF_ALARMONLY on mei watchdog (2012-06-13 15:34:31 -0700)

----------------------------------------------------------------
MISC tree updates for 3.5-rc4

Here are some drivers/misc bugfixes (really just drivers/misc/mei/
fixes) for a few problems that have been reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Samuel Ortiz (1):
      misc: mei: Disable MSI when IRQ registration fails

Tomas Winkler (4):
      misc: mei: set IRQF_ONESHOT for msi request_threaded_irq
      misc: mei: unregister misc device in pci_remove function
      misc: mei: fix stalled read
      misc: mei: set WDIOF_ALARMONLY on mei watchdog

 drivers/misc/mei/interrupt.c |    2 +-
 drivers/misc/mei/main.c      |    9 +++++----
 drivers/misc/mei/wd.c        |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)
