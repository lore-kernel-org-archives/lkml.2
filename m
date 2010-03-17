Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0CQM4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:56:53 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:63145 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0CQM4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:56:52 -0400
Subject: [GIT PULL updated] led updates for 2.6.34-rc2
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 12:56:34 +0000
Message-ID: <1268830594.3662.17.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[updated request adding a bugfix which was meant to be here originally]

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for various LED updates suitable for 2.6.34-rc2. The patches are
mostly bugfixes that have been testing in -mm/linux-next for a while but
there is one new driver included which is unlikely to be harmful to
anyone.

I can rebase this without the new driver and make it bugfixes only if
you prefer.

Thanks, Richard

 drivers/leds/Kconfig       |   80 ++++++++++--------
 drivers/leds/Makefile      |    1 
 drivers/leds/dell-led.c    |  200 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/leds/led-class.c   |   42 ++-------
 drivers/leds/leds-gpio.c   |    3 
 drivers/leds/leds-ss4200.c |    2 
 6 files changed, 257 insertions(+), 71 deletions(-)

Anton Vorontsov (1):
      leds-gpio: fix default state handling on OF platforms

Bob Rodgers (1):
      leds: Add Dell Business Class Netbook LED driver

Daniel Mack (1):
      leds: ALIX2: Add dependency to !GPIO_CS5335

Florian Fainelli (1):
      leds: Fix race between LED device uevent and actual attributes creation

H Hartley Sweeten (2):
      leds: led-class.c - Quiet boot messages
      leds: Kconfig cleanup

Márton Németh (1):
      leds: make PCI device id constant


