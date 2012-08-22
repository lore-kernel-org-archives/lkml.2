Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab2HVObG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:31:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60345 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab2HVOaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:30:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jon Medhurst <tixy@yxit.co.uk>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <damm@opensource.se>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 0/4] ARM: patches for randconfig build errors
Date: Wed, 22 Aug 2012 16:29:36 +0200
Message-Id: <1345645780-2749-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
X-Provags-ID: V02:K0:/P/qADVRLiORSaACAum1eT+/IdXXh+kbEf+ctUHbyRQ
 ewQo/4QBGNfps6OS9Xo7msHUL0G3bFbOS3M3ycHci+y/leF2tX
 7UHHe8P8fVpIFMGPcV4tNGIeRR8ve1JX8yIYSB6rgDy3OciX2V
 oWHkjEGRbgo2qPV53IDu7t+CrInGUJ9TcHSVQ8UniM0ZOJjZpC
 wU3cUkmo9V40GKNa+Y6AfEnpi4MSDljUhbMcDOzTEmOxRZ+iAX
 V36R4ccbq3AZptuAElhAnu3mobcazmdpGBUuRMl9B1zqk9jYAa
 Z8hQ3Y8tlVolWzXkwO8zh5VeTxwp7AZ+bCODrH+DgEl9OkiA1+
 vrT03ukLROnZuVZ+OcWrgk3zXfPknl+YdeCJTRTQ61JSEmktIX
 TGQ/wHSHgdTug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

I've done some testing with the experimental multiplatform tree
and that uncovered a few preexisting bugs. Here are the ones
that should go through your tree. Please have a look to
see if the fixes make sense. I can put the patches in the patch
tracker or send you a pull request then.

	Arnd
---
Cc: Jon Medhurst <tixy@yxit.co.uk>
Cc: Leif Lindholm <leif.lindholm@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Magnus Damm <damm@opensource.se>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>

Arnd Bergmann (4):
  ARM: export read_current_timer
  ARM: allow PID_IN_CONTEXTIDR only for ARMv7
  ARM: export set_irq_flags/irq_set_chip_and_handler
  ARM: kprobes: make more tests conditional

 arch/arm/Kconfig.debug             |    1 +
 arch/arm/kernel/arch_timer.c       |    2 ++
 arch/arm/kernel/irq.c              |    2 ++
 arch/arm/kernel/kprobes-test-arm.c |    4 +++-
 kernel/irq/chip.c                  |    2 ++
 5 files changed, 10 insertions(+), 1 deletion(-)

-- 
1.7.10

