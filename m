Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab0EZQmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:42:43 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:65442 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab0EZQml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:42:41 -0400
Subject: [GIT PULL] Backlight updates for 2.6.35
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 17:42:20 +0100
Message-ID: <1274892140.24079.47.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for the backlight tree updates for 2.6.35. This includes several new
drivers and various bugfixes/tweaks most of which have been in
linux-next/-mm for a while.

Thanks, Richard

 arch/arm/mach-mx3/mach-mx31moboard.c |   45 +++
 arch/arm/mach-orion5x/dns323-setup.c |   22 +
 drivers/leds/Kconfig                 |   17 +
 drivers/leds/Makefile                |    2 
 drivers/leds/led-class.c             |    2 
 drivers/leds/leds-88pm860x.c         |   11 
 drivers/leds/leds-gpio.c             |   31 ++
 drivers/leds/leds-lp3944.c           |    9 
 drivers/leds/leds-mc13783.c          |  403 +++++++++++++++++++++++++++++++++++
 drivers/leds/leds-net5501.c          |   94 ++++++++
 drivers/leds/leds-ss4200.c           |    2 
 drivers/mfd/mc13783-core.c           |    4 
 include/linux/leds.h                 |   12 -
 include/linux/mfd/mc13783.h          |   66 +++++
 14 files changed, 691 insertions(+), 29 deletions(-)

 arch/arm/mach-s3c2440/mach-gta02.c           |   76 --
 drivers/mfd/pcf50633-core.c                  |    3 
 drivers/video/backlight/88pm860x_bl.c        |    2 
 drivers/video/backlight/Kconfig              |  116 ++-
 drivers/video/backlight/Makefile             |    4 
 drivers/video/backlight/adp8860_bl.c         |  838 ++++++++++++++++++++++++
 drivers/video/backlight/adx_bl.c             |    4 
 drivers/video/backlight/ep93xx_bl.c          |  160 ++++
 drivers/video/backlight/l4f00242t03.c        |   11 
 drivers/video/backlight/max8925_bl.c         |    1 
 drivers/video/backlight/mbp_nvidia_bl.c      |   47 +
 drivers/video/backlight/pcf50633-backlight.c |  190 +++++
 drivers/video/backlight/s6e63m0.c            |  920 +++++++++++++++++++++++++++
 drivers/video/backlight/s6e63m0_gamma.h      |  266 +++++++
 include/linux/i2c/adp8860.h                  |  154 ++++
 include/linux/lcd.h                          |   23 
 include/linux/mfd/pcf50633/backlight.h       |   51 +
 include/linux/mfd/pcf50633/core.h            |    4 
 18 files changed, 2750 insertions(+), 120 deletions(-)

Alberto Panizzo (1):
      backlight: l4f00242t03: Fix regulators handling code in remove function

Axel Lin (3):
      backlight: l4f00242t03: fix error handling in l4f00242t03_probe
      backlight: max8925_bl: Fix error handling path
      backlight: 88pm860x_bl: fix error handling in pm860x_backlight_probe

Dan Carpenter (2):
      backlight: backlight_device_register() return ERR_PTR()
      backlight: 88pm860x_bl - potential memory leak

H Hartley Sweeten (2):
      backlight: Kconfig cleanup
      backlight: Add Cirrus EP93xx backlight driver

InKi Dae (1):
      backlight: add S6E63M0 AMOLED LCD Panel driver

Lars-Peter Clausen (3):
      backlight: Add pcf50633 backlight driver
      backlight: pcf50633: Register a pcf50633-backlight device in pcf50633 core driver.
      gta02: Use pcf50633 backlight driver instead of platform backlight driver.

Mario Schwalbe (1):
      backlight: mbp_nvidia_bl - add support for older MacBookPro and MacBook 6,1.

Michael Hennerich (2):
      backlight: new driver for the ADP8860 backlight parts
      backlight: adp8860: add support for ADP8861 & ADP8863

Randy Dunlap (1):
      backlight: fix adp8860_bl build errors

Steffen Röcker (1):
      backlight: mbp_nvidia_bl - Fix DMI_SYS_VENDOR for MacBook1,1

-- 
Richard Purdie
Intel Open Source Technology Centre


