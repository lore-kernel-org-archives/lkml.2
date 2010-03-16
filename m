Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab0CQAXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 20:23:39 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:59762 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab0CQAXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 20:23:37 -0400
Subject: [GIT PULL] led updates for 2.6.34-rc2
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 20:40:38 +0000
Message-ID: <1268772038.1625.207.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/leds/led-class.c   |    2 
 drivers/leds/leds-gpio.c   |    3 
 drivers/leds/leds-ss4200.c |    2 
 6 files changed, 249 insertions(+), 39 deletions(-)

Anton Vorontsov (1):
      leds-gpio: fix default state handling on OF platforms

Bob Rodgers (1):
      leds: Add Dell Business Class Netbook LED driver

Daniel Mack (1):
      leds: ALIX2: Add dependency to !GPIO_CS5335

H Hartley Sweeten (2):
      leds: led-class.c - Quiet boot messages
      leds: Kconfig cleanup

Márton Németh (1):
      leds: make PCI device id constant

