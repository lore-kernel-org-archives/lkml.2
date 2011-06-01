Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1FAHdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:33:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59484 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab1FAHdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:33:09 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Jeff Dike <jdike@addtoit.com>,
        Nikolaus Voss <n.voss@weinmann.de>, Kyle McMartin <kyle@mcmartin.ca>,
        Chris Zankel <chris@zankel.net>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/6] clocksource_register_hz/khz cleanups
Date: Wed,  1 Jun 2011 00:32:44 -0700
Message-Id: <1306913570-9445-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the next batch of clocksource_register_hz/khz cleanups.

It would be really great if maintainers could pick these up,
otherwise I'll likely push these through Thomas for 3.1.

thanks
-john

CC: Jeff Dike <jdike@addtoit.com>
CC: Nikolaus Voss <n.voss@weinmann.de>
CC: Kyle McMartin <kyle@mcmartin.ca>
CC: Chris Zankel <chris@zankel.net>
CC: Mikael Starvik <starvik@axis.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Thomas Gleixner <tglx@linutronix.de>

John Stultz (6):
  clocksource: Convert tcb_clksrc to use clocksource_register_hz/khz
  clocksource: parisc: convert to clocksource_register_hz/khz
  clocksource: um: convert to clocksource_register_hz/khz
  clocksource: xtensa: convert to clocksource_register_hz/khz
  clocksource: cris: convert to clocksource_register_khz
  clocksource: tile: convert to use clocksource_register_hz

 arch/cris/arch-v32/kernel/time.c |    4 +---
 arch/parisc/kernel/time.c        |    6 +-----
 arch/tile/kernel/time.c          |    5 +----
 arch/um/kernel/time.c            |    6 ++----
 arch/xtensa/kernel/time.c        |   13 +------------
 drivers/clocksource/tcb_clksrc.c |    4 +---
 6 files changed, 7 insertions(+), 31 deletions(-)

-- 
1.7.3.2.146.gca209

