Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032779Ab2CSTya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:54:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57110 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030416Ab2CSTy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:54:26 -0400
Date: Mon, 19 Mar 2012 12:54:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char and misc patches for 3.4-rc1
Message-ID: <20120319195422.GA9883@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.3

for you to fetch changes up to b222258ac11cae3e0350fe5992ad164a7b128103:

  misc: bmp085: Use unsigned long to store jiffies (2012-03-02 16:27:54 -0800)

----------------------------------------------------------------
char and misc driver merge for 3.4-rc1

Not much here, just a few minor fixes and some conversions to the
module_*_driver() functions, making the codebase smaller.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Axel Lin (3):
      MISC: convert drivers/misc/* to use module_platform_driver()
      MISC: convert drivers/misc/* to use module_i2c_driver()
      MISC: convert drivers/misc/* to use module_spi_driver()

Bernhard Walle (2):
      misc: bmp085: Handle jiffies overflow correctly
      misc: bmp085: Use unsigned long to store jiffies

Danny Kukawka (2):
      cs5535-mfgpt: don't call __init function from __devinit
      char/ramoops: included linux/err.h twice

Masanari Iida (2):
      char: Fix typo in viotape.c
      char: Fix typo in tlclk.c

Wolfram Sang (1):
      misc: fsa9480: Remove obsolete cleanup for clientdata

 drivers/char/ramoops.c                 |    1 -
 drivers/char/tlclk.c                   |    2 +-
 drivers/char/viotape.c                 |    2 +-
 drivers/misc/ad525x_dpot-i2c.c         |   12 +-----------
 drivers/misc/ad525x_dpot-spi.c         |   12 +-----------
 drivers/misc/apds9802als.c             |   12 +-----------
 drivers/misc/apds990x.c                |   13 +------------
 drivers/misc/bh1770glc.c               |   13 +------------
 drivers/misc/bh1780gli.c               |   15 ++-------------
 drivers/misc/bmp085.c                  |   19 ++++---------------
 drivers/misc/carma/carma-fpga.c        |   17 +----------------
 drivers/misc/cs5535-mfgpt.c            |    2 +-
 drivers/misc/ds1682.c                  |   13 +------------
 drivers/misc/eeprom/at25.c             |   12 +-----------
 drivers/misc/eeprom/eeprom.c           |   14 +-------------
 drivers/misc/eeprom/eeprom_93xx46.c    |   12 +-----------
 drivers/misc/eeprom/max6875.c          |   14 +-------------
 drivers/misc/fsa9480.c                 |   14 +-------------
 drivers/misc/hmc6352.c                 |   13 +------------
 drivers/misc/ics932s401.c              |   13 +------------
 drivers/misc/isl29003.c                |   14 +-------------
 drivers/misc/isl29020.c                |   13 +------------
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |   13 +------------
 drivers/misc/lis3lv02d/lis3lv02d_spi.c |   13 +------------
 drivers/misc/max8997-muic.c            |   12 +-----------
 drivers/misc/spear13xx_pcie_gadget.c   |   12 +-----------
 drivers/misc/ti-st/st_kim.c            |   13 +------------
 drivers/misc/ti_dac7512.c              |   13 +------------
 drivers/misc/tsl2550.c                 |   13 +------------
 29 files changed, 32 insertions(+), 309 deletions(-)
