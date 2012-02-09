Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab2BIUVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:21:41 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46628 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab2BIUVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:21:40 -0500
Date: Thu, 9 Feb 2012 12:20:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char and misc patches for 3.3-rc3
Message-ID: <20120209202014.GA22109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ char-misc-3.3-rc3

for you to fetch changes up to b5266ea675c5a041e2852c7ccec4cf2d4f5e0cf4:

  mmc: cb710 core: Add missing spin_lock_init for irq_lock of struct cb710_chip (2012-02-02 16:28:14 -0800)

[
  Note, git request-pull is generating the pull request line above line as:
  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ char-misc-linus
  with the branch name, not the signed tag name.
  I'm generating it with:
  git request-pull master git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ char-misc-3.3-rc3 > msg.txt
  with the latest version of git, is that not the correct thing to do?  I edited it by hand for now.
]

----------------------------------------------------------------
Minor char-misc fixes for 3.3-rc3

Nothing big here, some Kconfig fixes for the MISC_DEVICES config option
that was being used incorrectly, and some other minor bug fixes.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Axel Lin (1):
      mmc: cb710 core: Add missing spin_lock_init for irq_lock of struct cb710_chip

Danny Kukawka (2):
      vmw_balloon: fix for a -Wuninitialized warning
      cs5535-mfgpt: don't call __init function from __devinit

Fabio Estevam (1):
      drivers: misc: Remove MISC_DEVICES config option

Paul Gortmaker (1):
      c2port: fix build error for duramar2150 due to missing header.

 drivers/misc/Kconfig                     |   17 +++--------------
 drivers/misc/c2port/c2port-duramar2150.c |    1 +
 drivers/misc/cb710/core.c                |    1 +
 drivers/misc/cs5535-mfgpt.c              |    2 +-
 drivers/misc/vmw_balloon.c               |   14 +++++++-------
 drivers/mmc/host/Kconfig                 |    1 -
 drivers/net/ethernet/micrel/Kconfig      |    1 -
 7 files changed, 13 insertions(+), 24 deletions(-)
