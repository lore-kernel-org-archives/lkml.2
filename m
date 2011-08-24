Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1HXGw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:52:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60944 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1HXGw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:52:57 -0400
Date: Tue, 23 Aug 2011 23:52:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.1-rc3
Message-ID: <20110824065251.GB15604@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Andrew Drake (1):
      Input: bcm5974 - Add support for newer MacBookPro8,2

Axel Lin (5):
      Input: mma8450 - fix module device table type
      Input: mpu3050 - correct call to input_free_device
      Input: tegra-kbc - correct call to input_free_device
      Input: tnetv107x-ts - add missing include of linux/module.h
      Input: ep93xx_keypad - add missing include of linux/module.h

Deepak Saxena (1):
      Input: remove CLOCK_TICK_RATE from analog joystick driver

Dmitry Torokhov (1):
      Input: ad714x - use DMA-safe buffers for spi_write()

Gerard Braad (1):
      Input: wacom - add support for the Wacom Bamboo Pen (CTL-660/K)

Jiejing Zhang (1):
      Input: max11801_ts - correct license statement

Joshua V. Dillon (1):
      Input: bcm5974 - add support for touchpads found in MacBookAir4,2

Michael Hennerich (3):
      Input: ad714xx-spi - force SPI bus into the default 8-bit mode
      Input: ad714x - fix endianness issues
      Input: ad714x - read the interrupt status registers in a row

Ping Cheng (2):
      Input: wacom - add WAC_MSG_RETRIES define
      Input: wacom - report id 3 returns 4 bytes of data

Yufeng Shen (1):
      Input: atmel_mxt_ts - report pressure information from the driver


Diffstat:
--------

 drivers/input/joystick/analog.c          |    2 +-
 drivers/input/keyboard/ep93xx_keypad.c   |    1 +
 drivers/input/keyboard/tegra-kbc.c       |    2 +-
 drivers/input/misc/ad714x-i2c.c          |   81 ++++++++++-----------
 drivers/input/misc/ad714x-spi.c          |   68 ++++++++++++++----
 drivers/input/misc/ad714x.c              |  116 +++++++++++------------------
 drivers/input/misc/ad714x.h              |   35 ++++++++-
 drivers/input/misc/mma8450.c             |    2 +-
 drivers/input/misc/mpu3050.c             |    2 +-
 drivers/input/mouse/bcm5974.c            |   40 ++++++++++
 drivers/input/tablet/wacom_sys.c         |   17 +++--
 drivers/input/tablet/wacom_wac.c         |    4 +
 drivers/input/touchscreen/atmel_mxt_ts.c |   12 +++
 drivers/input/touchscreen/max11801_ts.c  |    3 +-
 drivers/input/touchscreen/tnetv107x-ts.c |    1 +
 15 files changed, 241 insertions(+), 145 deletions(-)

-- 
Dmitry

