Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2HQRNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:13:50 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43515 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab2HQRNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:13:42 -0400
Date: Fri, 17 Aug 2012 10:13:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc fixes for 3.6-rc3
Message-ID: <20120817171315.GA13984@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.6-rc3

for you to fetch changes up to f3261dfb5538e2ff0264fde3050dbd4e922fa296:

  1-Wire: Add support for the maxim ds1825 temperature sensor (2012-08-16 12:33:59 -0700)

----------------------------------------------------------------
Char / Misc driver fixes for 3.6-rc3

Here are some small misc and w1 driver fixes for 3.6-rc3.  Nothing major, just
some some bugfixes and a new device id for a w1 driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Matthias Kaehlcke (1):
      ti-st: Fix check for pdata->chip_awake function pointer

Raphael Assenat (1):
      1-Wire: Add support for the maxim ds1825 temperature sensor

Tomas Winkler (2):
      mei: fix device stall after wd is stopped
      mei: add mei_quirk_probe function

 Documentation/w1/slaves/w1_therm |  2 ++
 drivers/misc/mei/interrupt.c     |  2 +-
 drivers/misc/mei/main.c          | 27 +++++++++++++++++++++++++++
 drivers/misc/ti-st/st_ll.c       |  2 +-
 drivers/w1/slaves/w1_therm.c     |  9 +++++++++
 drivers/w1/w1_family.h           |  1 +
 6 files changed, 41 insertions(+), 2 deletions(-)
