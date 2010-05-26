Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab0EZQlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:41:09 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:65436 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab0EZQlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:41:06 -0400
Subject: [GIT PULL] LED updates for 2.6.35
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 17:40:41 +0100
Message-ID: <1274892041.24079.43.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the LEDs tree updates for 2.6.35. This includes a couple of new
drivers and various bugfixes/tweaks.

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

Axel Lin (3):
      leds: led-class: set permissions on max_brightness file to 0444
      leds: leds-lp3944: properly handle lp3944_configure fail in lp3944_probe
      leds: leds-ss4200: fix led_classdev_unregister twice in error handling

Benjamin Herrenschmidt (1):
      leds: leds-gpio: Change blink_set callback to be able to turn off blinking

Bjarke Istrup Pedersen (1):
      leds: Add LED driver for the Soekris net5501 board

Christoph Fritz (1):
      leds: 88pm860x - fix checking in probe function

Philippe Rétornaz (2):
      leds: Add mc13783 LED support
      leds: Add mx31moboard MC13783 led support

-- 
Richard Purdie
Intel Open Source Technology Centre

