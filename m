Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2D2QPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:15:52 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:56788 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2D2QPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:15:34 -0400
Date: Sun, 29 Apr 2012 09:15:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] staging driver fixes for 3.4-rc5
Message-ID: <20120429161530.GA16514@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.4-rc4

for you to fetch changes up to 89f21cc050d5eed8eeffee5b46297fb7a74ef9dd:

  staging: ozwpan: Fix bug where kfree is called twice. (2012-04-26 12:40:53 -0700)

----------------------------------------------------------------
Staging tree fixes for 3.4-rc4

Here are some tiny drivers/staging/ bugfixes.  Some build fixes that
were recently reported, as well as one kfree bug that is hitting a
number of users.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Imre Kaloz (1):
      staging: octeon-ethernet: fix build errors by including interrupt.h

Omar Ramirez Luna (1):
      staging: tidspbridge: remove usage of OMAP2_L4_IO_ADDRESS

Rupesh Gujare (1):
      staging: ozwpan: Fix bug where kfree is called twice.

Seth Jennings (1):
      staging: zcache: fix Kconfig crypto dependency

 drivers/staging/octeon/ethernet-rx.c          |    1 +
 drivers/staging/octeon/ethernet-tx.c          |    1 +
 drivers/staging/octeon/ethernet.c             |    1 +
 drivers/staging/ozwpan/ozpd.c                 |    2 --
 drivers/staging/tidspbridge/core/tiomap3430.c |   20 ++++++++++++--------
 drivers/staging/tidspbridge/core/wdt.c        |    8 +++++++-
 drivers/staging/zcache/Kconfig                |    2 +-
 7 files changed, 23 insertions(+), 12 deletions(-)
